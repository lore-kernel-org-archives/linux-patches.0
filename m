Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209173;
	b=p8h1UU+hn/N/ayhVOpPE33qxkxOasJnkwRu2P0gdbO0Oaoy0sTpvWzOSILRPm8AQB7e9
	 sBEgUyCJUyRfMsv1Ld1zwmBErJwL+/9e7qE7cD27NH2M0KlE9wLlYLreG4RIAs0LtaH/m
	 7cURTWqxiTPM9vlCpLBqRkjhHX8nS3SxKK4KkqhH80bhCAadE5xUFvp7h+2ZjgxTcwEc+
	 Oz0yQrv5hmDyHrk7tyHY9+7oIS9GIGUS62IqC36waQJioYmcGJRa2WJo8CGPUK1IZ9JZy
	 Ji8mOxdq7QJfq2vSvvEtsXzksl4XM8FpC5wlDIJ6xE85fDMOkUJ6YfzYRx/P2DVkThw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IEnDMNsFHSatGyIXjF4Mx50UXz6dOXNlqOzvrmTZm8o=;
	b=W94/mAhaGCB38iB6Ay59r/w5IZAxlyaRvWL0j9p63bRwIfKIAijUf17L7tkAMpqD6fHD
	 aYi/+ySxHgDz0z35uhrtf1dXs/rVeeE/GrHYm8TXwaUspJhfWYoiNl76mhqrIU+sIgKMd
	 Vztb5HWbGmSLnQzsUwLkzoiJwFrPtsGp42/AGXbkLeFdTo5BKN6JAc+6d5UgOFJ8ci4LW
	 3MI35ktRvnt8RE3wv3AF4zcAOaQymBy0xdmhNAoVTRK2GXlkhXQXGAvuoeVjCNgwpKI/9
	 /VRHALhMXRt7uH1M2GSPTyUquYSZ5YL3i0XsXXNh6hUTebBZK/v769LH5wHf5hS/swQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gwbp7l9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BCA606A31A;
	Wed, 28 Oct 2026 17:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gwbp7l9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D9A1F01825;
	Wed, 28 Oct 2026 17:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209173;
	bh=IEnDMNsFHSatGyIXjF4Mx50UXz6dOXNlqOzvrmTZm8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gwbp7l9EPWH3sjTe+VqEyqGhydYJRCq8TAFbK2boKM5C/vH61nzXY7kQ+eMYKX7uG
	 QUdj3P3Yih+On8eLdruF1zN/Cu4UXWdXAxhaY0YMAyzhhGaaj21DiH8sk9GpuBZfLf
	 1DaNUdob/Evx0/EowXM3vicp4M/KgHe8FNgx9Dnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 335/516] mmc: mtk-sd: Cancel request timeout work on remove
Date: Wed, 28 Oct 2026 17:58:07 +0100
Message-ID: <20261028170011.423863576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Yibo Tan <lhfff@tju.edu.cn>

commit b38af5386a74416e898955443f2e26547b358cb2 upstream.

The driver queues req_timeout while a request is active.
msdc_request_done() uses cancel_delayed_work(), which does not wait for
a timeout callback that has already started.

The timeout callback calls mmc_request_done(), which wakes the request
waiter, and then continues to use host->dev_comp and check the SDIO IRQ.
During unbind, msdc_drv_remove() can return and the managed mmc_host can
be freed before the callback finishes.

KASAN reported use-after-free accesses in msdc_request_done() and
msdc_recheck_sdio_irq() in each of three unbind tests.  The same tests
completed without a kernel diagnostic after this change.

Call cancel_delayed_work_sync() after mmc_remove_host() has stopped new
requests and before the driver releases the host resources.

Fixes: 208489032bdd ("mmc: mediatek: Add Mediatek MMC driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2611,6 +2611,7 @@ static int msdc_drv_remove(struct platfo
 
 	platform_set_drvdata(pdev, NULL);
 	mmc_remove_host(mmc);
+	cancel_delayed_work_sync(&host->req_timeout);
 	msdc_deinit_hw(host);
 	msdc_gate_clock(host);
 


