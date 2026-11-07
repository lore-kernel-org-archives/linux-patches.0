Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063915;
	b=W1TIvRNprx/PtJhcoXlPpWdfxHOPecRTCzRiGDuvqrfpcJGvEpnb3nbhmMKBMrW+0GRp
	 18vATMmU3t9mj8h9PCOUHbKj9KRBXUx0lG20ujEm1KkKae6tRSeNnnrkavU4aTfwY4GcO
	 sfrwHPAAkDRuJaQtdgG9oNRJoQu9O3pzn9GE9i3q3KQRJwhtE29NoQzdOeLBuNvS72O3J
	 PWLBHTWttolLJ9OJZHeOeKs69WfGgqpasJ36PUq3VbXbmSF/NiARaJfLXvOsDj0AielAV
	 oV9kqWfAoVIzE9ZjurprqLRgl8q1CgIXAoJKzMZP4g0Kydf886mDIhPdJjktUewQZJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1vTcCAhd3z8VelL0qH2jWUXHW9wFGB9izRPRiH26qkw=;
	b=fFkuYdhumStnIEUdxZOmrdeQbkEOQFv654aGUAAk55/ktXTiaXSF6SCO2yLY/8z5oQA8
	 cjPqc1+OxV5rjUN3Sho+IExiTvAgHCPu2NrPSV7FsYHeM0WRWQFKuL8Q++7wIgiVKzW2R
	 3WiNyEKC21MUmG6TZm8SB9eoSHydshua/HtWVlKPw6GhxaB8rRbXb+h8QO5s6YEgeDvyG
	 uax5etom53QJCc5TIZSNvv9kqAXaAf7sQywrgsaETPr+CV9SLS9Xi00p2XWQfLmBR8wmf
	 E+ADeBOH/gRnY/A4Ob6KyyqBoCGWKZ6QANYjw0G8iW9xPDBp/fyJtgg93fewiQ/e/1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OsxNpgqE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68C8606E8E9;
	Sat,  7 Nov 2026 15:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OsxNpgqE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8357B1F0089F;
	Sat,  7 Nov 2026 15:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063914;
	bh=1vTcCAhd3z8VelL0qH2jWUXHW9wFGB9izRPRiH26qkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsxNpgqEftz9b0E/tdpFiyU/Q0aX7QlltQo5M2CWPxOyg8WQ+6gWgOB4sk6dOxLBJ
	 5sbWxVJqkUph3mVXZQroonPQ1sNRINd5VQP65m/XlDTkBwL+ngvjYtlK3vb6yECTTN
	 e96SYQHQwkEp731BhI8/0BJHsYBXR4V3GIXj1kng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0112/1257] media: microchip-isc: fix PM runtime leak in AWB work handler
Date: Sat,  7 Nov 2026 08:40:08 -0500
Message-ID: <20261107134942.443246380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 21ad8225822a892c4c273bf1368d477a83a19dbb ]

Early return when streaming stops skips pm_runtime_put_sync(),
leaking the reference and preventing runtime suspend.

Fixes: 314c96e5203d ("media: atmel: atmel-isc-base: use mutex to lock awb workq from streaming")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/microchip/microchip-isc-base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-base.c b/drivers/media/platform/microchip/microchip-isc-base.c
index cf4611443fd13..21d108eb93c7b 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -1432,7 +1432,7 @@ static void isc_awb_work(struct work_struct *w)
 	/* streaming is not active anymore */
 	if (isc->stop) {
 		mutex_unlock(&isc->awb_mutex);
-		return;
+		goto out_pm_put;
 	}
 
 	isc_update_profile(isc);
@@ -1443,6 +1443,7 @@ static void isc_awb_work(struct work_struct *w)
 	if (ctrls->awb)
 		regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_HISREQ);
 
+out_pm_put:
 	pm_runtime_put_sync(isc->dev);
 }
 
-- 
2.53.0



