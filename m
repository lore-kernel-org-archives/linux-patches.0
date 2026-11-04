Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831386;
	b=iCIK6OUiRSg5bkGAlg083W5vwCbLUTvAWuckB9RsNvXs7dj3usEYbGHRmOXEoiuyfqKa
	 hZedLiDIbXWlsVnKClpyDh1sO+1tG3LejZs9PBEctfQMxgdT8kpa7oKNs0zZpaAJZFJRu
	 rnTYN3dDuiMmx6HgOyJKwFu8s6swQIpR2FOj6sRs54Bc0h15FqrnMXzemKsD0ncqPSetj
	 2XNc7FBMgH3Avi4uVH/QHbLGqfIPNY2TUOmxeVoCoiLHkumI+esCFQdyrDbb4647mJRgs
	 BudK99KBQ1rZurUbLba9U94CkQNj1lg5pFydWOX2xNA8HpP93NU0wlxrFCGajID3Xjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3y+p0FiQ3wu0GYW7GBdZmn6jkfyGk+FlIim1hLleuZQ=;
	b=4qYWtOjbNzqQxszPJ2qnsYTpapca6BFvXLYa3rl3CeFJTj4V07Lbsm9Euo8zluN7H2qa
	 g+5xx+DjRjzO+zioWEDDn4Okxfh7FqUN5GJrT8T3J66m8ACfWVjxSAG7GfbUaoWLYl+kB
	 t7w7dWO2S8lF51nFgqb2AK78IVBsAs6P1UTaxk8H+mmjR8GQZP++CfNdmimx5OadqyepQ
	 z7oBMmnZszZ8J+zlZfrdOm8jT4Xl/TYp5KSGFNVJmX1HersXbcod4BNtkMgpLxAmw0ATu
	 5i4NbjA2XBZfRLFvNDWoISYdao6q1TyU851JsCSzIhgjuiG7OCO46xQQc1hVTpU3Ffw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vRwOIKPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879EF606A337;
	Wed,  4 Nov 2026 22:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vRwOIKPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C851F000C1;
	Wed,  4 Nov 2026 22:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831386;
	bh=3y+p0FiQ3wu0GYW7GBdZmn6jkfyGk+FlIim1hLleuZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vRwOIKPEz1ScBelR/5gwBkvfCmaDQwsSBYTddBE667GvlfpdLMUwjJeAO5pgg2RUV
	 hjky2iPqPE6V5aVKt+X9zAq6s/fxjqB5NlGczXftTkW8xKcd85E1QnE+MunWanMuc2
	 bHiHrF2cJZ/H8oYPSTLTFYGqCK3KSN87uBlveHxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 0636/1005] backlight: lm3630a: Cancel delayed work before destroying workqueue
Date: Wed,  4 Nov 2026 16:06:09 -0500
Message-ID: <20261104211101.586318603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 2cf184caab8b406fdd9db126ee40d62418237456 upstream.

The interrupt handler queues delayed work to read the interrupt status.
After free_irq() stops the producer, this work can still be waiting on its
timer. destroy_workqueue() cannot drain delayed work that has not yet been
queued by its timer, so the timer can outlive both the workqueue and the
devm-allocated chip containing the work.

Cancel the delayed work synchronously after freeing the IRQ and before
destroying the workqueue. This also waits for any running status read to
finish before the chip's resources are released.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 0c2a665a648e ("backlight: add Backlight driver for lm3630 chip")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Link: https://patch.msgid.link/20261003030439.599330-1-mhun512@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/lm3630a_bl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -591,6 +591,7 @@ static void lm3630a_remove(struct i2c_cl
 
 	if (pchip->irq) {
 		free_irq(pchip->irq, pchip);
+		cancel_delayed_work_sync(&pchip->work);
 		destroy_workqueue(pchip->irqthread);
 	}
 }


