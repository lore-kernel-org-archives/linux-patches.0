Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061887;
	b=jTkgwfnADm/F9ibIRHh3n0XVlDwTkWTRJmJQJP5ZweEE02ld7CsHol44GspXqGFJLI7j
	 Rdh4vq0k+GhegQqcVxear6muzmYlV8IixU7GpoAK8A+XHLm3yMlSq48oytEVPhBOeDUve
	 t/plA0h9qY5XwuSTzDz8IgZUKLK08g7hsUkn0ruUjXiJjMFXNJvRBMBM2kQ9lWPEf85fH
	 BFOvvuSxA9EstriJK/Grt7Re68tyCxXo55XPGEAKjkByOPraBDJ8DV+m9S1trkcoQ7M+D
	 Oj26YGNSLTaHcE0Oy+TBBiXrCjsnVuhJqN8KmFjGZ8scrl/XxeWGqQOFYqOwIPcht2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=esFY2AAxNV+h+V95awa3HMv9/+9avlD5fFayTU6EOE4=;
	b=EOTG1QW8mmA/iDfUfM7gvCUdmr+wg25ByGMkzMecZ+o8I9ptGpgQtljk6MoPxEC8be+S
	 v0dCP/bEp+IDA3r9bNzXW72ebCpDm86a/hPImfWaYoT3AQCQnwmRmQWWU1NEJakZC2mpK
	 iNRvyCqDYsJXATKzEl7gTbvzZQ3Q4o3irU7V6lpEAllnCwY0Dx6x6g+DIlpfJAAFAgMcl
	 CeTHIZABFLLtPovpAsZleMQqf7Nze+tvNn317P65lOh8hsfA3mto0JOzwUPNt1qMizXRX
	 /juQPum2syN6DIJqL8pdPyvnk5RZCOi+jrb4eaBII5tOXcGLMVM4+/NKdp8QiiNLCRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TzEHEQOq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E64606A326;
	Sat,  7 Nov 2026 14:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TzEHEQOq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D709B1F0089F;
	Sat,  7 Nov 2026 14:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061887;
	bh=esFY2AAxNV+h+V95awa3HMv9/+9avlD5fFayTU6EOE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TzEHEQOqRAXBzV6FvbskfdLIZ3ysTSbqVBOKnEjqWROzbF3PFWMQ0cL5CJGeyTkVT
	 7HiKNUVM/9lNYlJp+WA3iUNRCGUGzaCTPDe3C4jfn7R/r/BU0n/DfGXuZ8fEJmqcj1
	 hEvXMSvzl0bMTblyVfJphcPeXpRb88M35+shqNOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0898/1536] media: meson-ir-tx: Ensure rc_free_device() is called on unbind
Date: Sat,  7 Nov 2026 08:48:34 -0500
Message-ID: <20261107135022.856151492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 32999b8a9d5c4f497c9739e70ac4ee390cd650a7 ]

Make rc_dev devm managed.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index 6beb9e97453dd..e8e3c1a303279 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -346,7 +346,7 @@ static int meson_irtx_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "irq request failed\n");
 
-	rc = rc_allocate_device(RC_DRIVER_IR_RAW_TX);
+	rc = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW_TX);
 	if (!rc)
 		return -ENOMEM;
 
@@ -359,10 +359,8 @@ static int meson_irtx_probe(struct platform_device *pdev)
 	rc->s_tx_duty_cycle = meson_irtx_set_duty_cycle;
 
 	ret = devm_rc_register_device(dev, rc);
-	if (ret < 0) {
-		rc_free_device(rc);
+	if (ret < 0)
 		return dev_err_probe(dev, ret, "rc_dev registration failed\n");
-	}
 
 	return 0;
 }
-- 
2.53.0



