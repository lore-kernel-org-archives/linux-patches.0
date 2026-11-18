Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030076;
	b=gUVffYT8BexxXSCMXVdyf3qehC2TINfWMpuXsNjr2j0xkCjs0TXOMj3LBE8/5Y+eZS7a
	 6xPdNhZdEM27yVSH11sYr3BEopcXhBkTpQVsoOGztb5zTgWCKW2KW27BJaYWhdIfSMoJX
	 laHOFetKhfWhz/A5Zga7B5ftpwyMsNcoL5ttRg8oXjrxNpzQgMZtyt/ppPzsXdYZVFVT0
	 tYvxIO/ttKBRvuL7tTZXXb3+F94KVZo2iPNU2BreVp4xNpsqkCeO8fUhl98YniV50xRaf
	 GSDENMOSboSzOZZ1S5xkK8eAoqsH2STELyYuyofi0QthoAk8T4Pa9l4xo+v7HzBc5KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ggB2wbtfc50h9jr+qxh8p8Ud+PHajt0QmnOsJkD6g4E=;
	b=j4hA4N4b54ejekXGifrm6Og6ipJelQmROJjQ37QyTgfPqCOMbxZPtv/XPwT4Ots8c0D6
	 dstkKyYNuivSem6Pd5E16j217Abof+ayWLC0kQD0WWV9rNjqqX2yvuxB0rZNll+Qd67uT
	 sF0phYblAwlzIduXg4y1dhTLdMsNlRpCRP5GFRco0zpgkmQd9Hoz56xctR6Tzkg9MlemV
	 ZpsTdW7htkMz6HlHSIy0jouUIIZakL1gVocRGYC3ccPyhdIoz5/0Rm24jUEI3yyXP4Pub
	 DLYLaF0HYLxtM5/W10r8C9fPb4cXtDdsf1f3iIXssDBLCbQ+Mq9T8A2v59i+zPZ2xvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfHZIXG4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F1A606BB63;
	Wed, 18 Nov 2026 19:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfHZIXG4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CB41F000C5;
	Wed, 18 Nov 2026 19:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030076;
	bh=ggB2wbtfc50h9jr+qxh8p8Ud+PHajt0QmnOsJkD6g4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfHZIXG4zomLBCj6Egq+9OuvkNskq/AeHZeAxifQWoAXDnH9XFFFrm+/XBCU5Ohcc
	 u3493xrIPmKaguRRUjfUwwPqSDeoRDiBLDZBD3F6WpTA1hHVbQYGpNp3OTUvflApvR
	 49y3znpor5QN6kin3YdLwxSOpeFEyJnT6kQacnN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0576/1756] ASoC: rt5665: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:45:03 +0100
Message-ID: <20261118150031.977776867@linuxfoundation.org>
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

[ Upstream commit 9f2933d9a437302d5ae32eb9022efef049d8ab22 ]

rt5665_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 33ada14a26c8 ("ASoC: add rt5665 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-15-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5665.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5665.c b/sound/soc/codecs/rt5665.c
index 4f0236b34a2d9..2f9b1c305cf0a 100644
--- a/sound/soc/codecs/rt5665.c
+++ b/sound/soc/codecs/rt5665.c
@@ -4485,9 +4485,7 @@ static int rt5665_resume(struct snd_soc_component *component)
 	struct rt5665_priv *rt5665 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5665->regmap, false);
-	regcache_sync(rt5665->regmap);
-
-	return 0;
+	return regcache_sync(rt5665->regmap);
 }
 #else
 #define rt5665_suspend NULL
-- 
2.53.0



