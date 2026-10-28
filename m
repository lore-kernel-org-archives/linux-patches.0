Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213272;
	b=KjnjuMFNvKbKzlQgYFwMxVqD3hyTOc/AKhK3vCt8PYlw6mxXQsuSxQEcTXllqqqT4eS8
	 vftgT4TA/m9D7bexdTCgcRMcIgWTCT1n+dC52ueNVCvSK0INE7gaATpJoQm6MfYRTvG2L
	 t9x7EIaTgRLQqGGYO2iQD9AoE6erpstOP7TZVcOxzIqK9kms3fuGB6Up1+BXRfb2/Y30C
	 LSnLarER79SQOMQRKhheJQT4ekTzYX6nxe8biIABtBQ1RbOFynwYPnvtX0k5IAVg+NjkC
	 lyC8zbtRlihKDSnrwv/52aH7F8BLM/SDxG19MZH7E1xDSVot+5JBEq/UhQbe328vQrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WhqDJPY+ZJqaXIVnwJIW2Wzn8jhkun0iJqSSrSM4WcQ=;
	b=YrOZF1w9k9h2RaPDpmHJyMwMbHyXA+QnpBI1HjoDWKDiUqGba5OTQecXcmf7BpV+9/z+
	 Efoc98+ZqaQYd7BFbWNJYoxC0+pnQgBhyM+MWQXwBqleVe8w+VzZ3hPpRt2/MFkuhrLKt
	 54HHKl0FtE4RkGIcgrIUSRpi54UpqPHGvRfmxPJJxVmeNe784+eFZOX78PxLHRyfiV2N2
	 E532Z9N0+ciOmE7jLz1iAx/zp0cpLGrvXTWx6OckHcxEfowqCxrcNoL/7kj2me9cdjKX6
	 6asQs1APh0vkW8o/c86HC7+Q0WEKrn5qRh6KvyCM9vz9O4Wqpx6KvCZhyOW3FeWL1OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t+gROrGE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECEC606A31C;
	Wed, 28 Oct 2026 18:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t+gROrGE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0781F01825;
	Wed, 28 Oct 2026 18:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213271;
	bh=WhqDJPY+ZJqaXIVnwJIW2Wzn8jhkun0iJqSSrSM4WcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+gROrGExpObkvIl1i3OKT1zGjIqQKeCSWdH2pYndUcZCYPdJkCWXd2B8cMCCYawp
	 0p8U6NR31/wOeg4nAMDk3uRvUmjG2xS8HuU51mIUuHZPAlx26V5EovfU0jwEvob0Ur
	 P8ioPWHyjiJftkDCOs+8VGKnXivzxbVWgqWb66ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridham Khurana <khurana.ridham222@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.1 0448/1887] gpio: xilinx: fix runtime PM leak on request error path
Date: Wed, 28 Oct 2026 17:42:24 +0100
Message-ID: <20261028170509.424731676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ridham Khurana <khurana.ridham222@gmail.com>

commit ff82fc3a4a1d417dee1229681cc5285986edb1fa upstream.

pm_runtime_get_sync() leaves the usage counter incremented even when it
fails, and xgpio_request() returns the error without dropping it.

gpiolib does not call ->free() when ->request() fails, so xgpio_free(),
which holds the only matching pm_runtime_put(), never runs. The reference
is leaked and the controller can no longer runtime-suspend, so its clock
stays enabled.

Switch to pm_runtime_resume_and_get(), which only increments the usage
counter on success.

Fixes: 26b04774621e ("gpio: gpio-xilinx: Add support for suspend and resume")
Cc: stable@vger.kernel.org
Signed-off-by: Ridham Khurana <khurana.ridham222@gmail.com>
Link: https://patch.msgid.link/20260923113905.1409290-1-khurana.ridham222@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-xilinx.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -292,14 +292,7 @@ static void xgpio_save_regs(struct xgpio
 
 static int xgpio_request(struct gpio_chip *chip, unsigned int offset)
 {
-	int ret;
-
-	ret = pm_runtime_get_sync(chip->parent);
-	/*
-	 * If the device is already active pm_runtime_get() will return 1 on
-	 * success, but gpio_request still needs to return 0.
-	 */
-	return ret < 0 ? ret : 0;
+	return pm_runtime_resume_and_get(chip->parent);
 }
 
 static void xgpio_free(struct gpio_chip *chip, unsigned int offset)


