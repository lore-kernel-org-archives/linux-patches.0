Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030051;
	b=bTdkDVEAwRs0cch58rK84Nytp8bGAXAApd6G1bG6ECAeVImrqdKhjGTTd5OkQTEzIwCW
	 nekYY9GcO9kW1yFTkapKZDMXAMRwaGcV1E/ks+tpEdX6f7hzxUv+JKI/axAMFFuNoJs5i
	 nHGHLhsB78kt0S4KAIlhx1rcKCb2KQES7ePXuqGXEzKrbETnzRMq0iB3XIlCV4nZI5AFs
	 GEP+yjmhR/iU3GaGIhHEGHEFAKKRBm0wHl1nyD3mCwfqEGA6rB3/w2L80DFGERzU/Wi4g
	 QIq6OqdPPBOj86+rYudIQYrYvhIT13w1T4P42ZUU4iVQeeWL1XeF3+tnHhllAxGTZKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VhSk4YJZi4mHGlKj1bBxr7uoRbK0XgAFDBC8o9xn82s=;
	b=XzJp6HZolK3FGcSqTnOrbrfvEa2aP0dM4aimC9ZopJRV3V9pvJoaTr7NUL2ha7pHid1Z
	 F8q+U5FQJgw/m5pzCscmQY7feVf7jciNuVssFfgtQFx1g6yEd1uLZPONulKreGw7Cgxow
	 u6XPaybO8O5sbKYu0dj/8DvjslMuILK920TdXhC5s4AJ3fXhwbwAwujzDhMdvGktpBJj/
	 q65Run7kUOIkewCkCc4E8qNCjwC+sqXqnrhDNMxdwtpLGmUN8FMFd/q5TUD8Y6LN4uwFW
	 nElSK9yJHaoLm2vxsFXdwGsukvU2Jwoer7mlCEcyp521+TZaa0DNUCak/56MNs7Lpaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tGddykDS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A5760A2628;
	Wed, 18 Nov 2026 19:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tGddykDS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274591F000CB;
	Wed, 18 Nov 2026 19:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030050;
	bh=VhSk4YJZi4mHGlKj1bBxr7uoRbK0XgAFDBC8o9xn82s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tGddykDSod4bBG3J+J07/VclXx6kT1waufiEsg0mGsbbZnARoibbyDmFyNeqqIXWu
	 I+CQPIxDBscKBB8Z60Nmcxn1Xz9FnlENN2PYQM9raf6MipvkfmqV24BTELyKy50qwO
	 b8ZezDQlHBtz5AqHr+Wsehz2Ya83EBrf9FD/bk1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0568/1756] ASoC: rt1011: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:44:55 +0100
Message-ID: <20261118150031.679972698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 432734a00bfae17baeff1a83b61bfc9c2ab20c12 ]

rt1011_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: d6e65bb7ff0d ("ASoC: rt1011: Add RT1011 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-7-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1011.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1011.c b/sound/soc/codecs/rt1011.c
index a0e75b03e9dc9..24aee0eaff810 100644
--- a/sound/soc/codecs/rt1011.c
+++ b/sound/soc/codecs/rt1011.c
@@ -2099,9 +2099,7 @@ static int rt1011_resume(struct snd_soc_component *component)
 	struct rt1011_priv *rt1011 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1011->regmap, false);
-	regcache_sync(rt1011->regmap);
-
-	return 0;
+	return regcache_sync(rt1011->regmap);
 }
 #else
 #define rt1011_suspend NULL
-- 
2.53.0



