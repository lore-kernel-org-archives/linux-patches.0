Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026252;
	b=fIUx8aOEyfm10iBJGJxS0OfIOm98LLGG73RisjJJU2PBu7kfWUvRhfNYU9bqQpJviyFZ
	 ihnrw5ZqZT7r+8tF/o/G0ECYtBhidLIAzt1vI56E8G4wR32T/hajRgTWVtVJwNAHgJlhp
	 0JuP6YB/NpikiaJbySBoYJnSOeEqAwY3Zqztb8V/Rh9s/mWj9Blet/Wy6Oq/1dLQhbR4x
	 9kTwZAtor9KK/E7tl35HkUxHULREMKR0kQZcFfRvsDZbMuYPUROZJjU2cgB9JenIR/PtL
	 V1vWKXDP0ENxeSjCRhpBiWuLzdAVOJ8xiJcVrzuSKzfFRB9KcXYKCELum+KhLnH34lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zqehlvgeYb02flTF7magq2S5i4mRQm94ZObJdTR7Dak=;
	b=S6/XEykTQiBHeOkW7fKOQiaGQ4VpjatoGA/xDu0uHjoqxjkNH8ViGaavnEeQhtQ1aCLO
	 oQg738ln+78kQWOK3Xgp6lcjsS9iAqxyVrNhrX9AwLLHfEv7fHz8iQ3lrDmi59rifLKrK
	 yzHz429HVILtIkLw4LRLaSPDJ4FuxQ1Hvk/jBeDHAfh857RREYdR1GE/masSas5bCAneD
	 9svYoOQb9yPXK64SMgaI3CsoTyv5uAemMxcbBqlWpacuvZD4A/dHXBxTRhf7MK4XPGR+O
	 xjlUvQXFE9C3RSY8Ec/TmMyileKOYceFYTd98TnQ9QHEbdhNPRa79QuSb6K0wVrGYlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D7jYb4QL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40399606A320;
	Wed, 18 Nov 2026 18:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D7jYb4QL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B261F000C4;
	Wed, 18 Nov 2026 18:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026252;
	bh=zqehlvgeYb02flTF7magq2S5i4mRQm94ZObJdTR7Dak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D7jYb4QLbJIIsL3a0BBWHiIPAhc9dMRPkf9/rWYCmUckVKQ3ltkkSeJpZDKKvFXJP
	 qHJuRN6/MgtDKUMvAYT9e2LZif/UyhnbzI45dFdzjVPeOrzAK3hCX7ys/z5bL1eUey
	 wWcA22lWncrWXW4tfslZ0i5D5GsXYzObs4JmTQIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sidong Yang <sidong.yang@furiosa.ai>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1368/2151] accel/rocket: Dont tear down the scheduler when drm_sched_init() fails
Date: Wed, 18 Nov 2026 15:51:43 +0100
Message-ID: <20261118150211.855597705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sidong Yang <sidong.yang@furiosa.ai>

[ Upstream commit a6709a58a01c8fc357e316bee31f369c2ea56235 ]

drm_sched_init() cleans up after itself when it fails, but
rocket_job_init() then calls drm_sched_fini() on the same scheduler.
That wakes a wait queue that was never initialised, dereferencing a
NULL pointer, and can destroy the submit workqueue a second time.

Only destroy the reset workqueue on this path.

Fixes: 0810d5ad88a1 ("accel/rocket: Add job submission IOCTL")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260912114524.7A6131F00893@smtp.kernel.org/
Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20261004164727.466164-2-sidong.yang@furiosa.ai
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/rocket/rocket_job.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/accel/rocket/rocket_job.c b/drivers/accel/rocket/rocket_job.c
index 729b7d6d77d46..269c8a00410be 100644
--- a/drivers/accel/rocket/rocket_job.c
+++ b/drivers/accel/rocket/rocket_job.c
@@ -494,8 +494,6 @@ int rocket_job_init(struct rocket_core *core)
 	return 0;
 
 err_sched:
-	drm_sched_fini(&core->sched);
-
 	destroy_workqueue(core->reset.wq);
 	return ret;
 }
-- 
2.53.0



