Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057994;
	b=W/fSRwabzGixLyJUIS8yoNNIYijGc0nu+7WT8zBzqkF87o2oKB8JgyiLHjrHQbM/rivR
	 P+88Zti+cFp/j8TlWtHsOLMpPZxDv1eJ8TP3t4KHbwjs/ShiYCPoTzszXlb9/GB+3BHLb
	 ubskpoYxq824MTd8zhM+dWTDLwBkRoeLHFeWmfZxC0seRpjNEGQXeta7f5A+f9UzD+Nn0
	 8AGFFNPqtNAJyIBVDDCothpaYuYBFh3fiCE1dA1s+GLdRDxs/8Qn9q9x82Yrq7k78th4T
	 k36OY1R4+OuCcPQFxN0f2J5Ps4FbYK73tBK5Hr55Tfi5SzWl/lOeClmJWiPitpJyl6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wNXniLtLVxyU9nRsLSwSYCj4SDMCiiI+oD9YyuSYFug=;
	b=gRys1suWf32w+ZvLljGKdhVf6OlwIAn37DWFHtoVDBWzdR2Bd1gkZHjdO4wjEwdWCN1D
	 4B0fk9q28JIrZ/T8WEykZZUNaenl+ZYpM2inQ8KreTVqFnOanCgFeAcu7agA9cjxrYkZa
	 q8NT85nAP6aG+hrlfwoGd+p3L4incSMyHJsvRUagwpq4H8aJEQ1I6TtusD2SICiJodNnf
	 bR/GKrT9FB5WFgHO8OGJ7yYSajskn9cCeLBdYjC0qxVb5DaOhgde4gZ/83blUme2soc6/
	 Qw5aMGp2156W1vXvAUaS1+1cXMQAHXbe+TvovErtzkTESHsNUETy92aI61wupSixLuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0RwsJve;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0E9606A31C;
	Thu, 19 Nov 2026 03:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s0RwsJve
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC3F1F000C4;
	Thu, 19 Nov 2026 03:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057994;
	bh=wNXniLtLVxyU9nRsLSwSYCj4SDMCiiI+oD9YyuSYFug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0RwsJvec0HVjwYuPoiyO47X/ASPwXNNYctw50iO3ZOBF37b9ulxisocmCCePFMvX
	 Z9zQeQgW85pELfIy1WrBgarACYBdzcf3DMFUas1CCPO/pl7weH9fQv1Ep1n0eUxh6H
	 GnUVqNBUbqoxivqomgoznn6FrUb7iHKEo7Qrz5pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Wang <vulab@iscas.ac.cn>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0328/1848] backlight: lm3630a_bl: Remove redundant flush_workqueue() calls
Date: Wed, 18 Nov 2026 15:39:26 +0100
Message-ID: <20261118145925.828685103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Wang <vulab@iscas.ac.cn>

[ Upstream commit adc122011125682932ef279d717153670feedde4 ]

'destroy_workqueue()' already drains the queue before destroying it, so
there is no need to flush it explicitly.

Remove the redundant 'flush_workqueue()' calls.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 2cf184caab8b ("backlight: lm3630a: Cancel delayed work before destroying workqueue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/lm3630a_bl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
index 2134342c2c97d..1de26785c3032 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -593,7 +593,6 @@ static int lm3630a_remove(struct i2c_client *client)
 
 	if (pchip->irq) {
 		free_irq(pchip->irq, pchip);
-		flush_workqueue(pchip->irqthread);
 		destroy_workqueue(pchip->irqthread);
 	}
 	return 0;
-- 
2.53.0



