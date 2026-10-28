Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213306;
	b=i/Nv4/dCDVpJWGgJBBiIGXN1Y+rQGJnkKwgWlEZ/pahFyNzhZ2EB7N+3T+5rRmH6X82N
	 qlQspQc24nQPRH2lL4Jp8JDBc0veA7qr848hEOhK7nd38ciWyRV70RNMy7dZ/cwfL2+Hv
	 gMvgV09r82yal10Bj74ZKObtr4Zd8fAPTPR6mBTZLq8sHZKabTuZ/Pu2d4HLhA+GM0EQ9
	 zy6CSyBsDN/SQpntuqOCda3Ki61BuWIV8Y71QprpGUH9VN+CwDBIS2UXGj+LCSiH12VsF
	 HRmB/Kx1xfc/cNk8r/m+F83qGNIwgVp4stIoS2SVeqcj4J2keAjEyTNf9TZoa/Hl2wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uFjOLExKwsiX++eWz8WqlWlhrkhBrMcCOnuhdZraPRA=;
	b=qaoxU6UfrBU7jzq9LMXytpwGcUwMjC6A8r7Nc9ezJfqbeFwBebFMW/AKwzCPzxWSEJxp
	 FxGq9B+FArFPzna/Kz5UqD+TEPcKvmf4bCY/DMcfNa1GTEldSGFriabSnyOE9UmWrqVlp
	 XE1VZfZ69Nmk2PIDEFdPucR0SXYhV997q3iMpG2pp72dNJf+xdEFH/MDMi03U5i2HUv4D
	 UKJP33bDr6h5LxakfJ+8jvlIHdxD1H3NCTKUH2NK+O6MQfQuDAF1zkEN6XUzXWAA2BZmH
	 rDSN0dbALzAbu1urAvGnsn6kekphlHVUeHlYdShbSDHuTfsjq2ARC/3U60JJwD6DhKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMYaQAoE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1BE606A31C;
	Wed, 28 Oct 2026 18:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMYaQAoE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B58E1F01825;
	Wed, 28 Oct 2026 18:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213305;
	bh=uFjOLExKwsiX++eWz8WqlWlhrkhBrMcCOnuhdZraPRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMYaQAoERPv6g7aBkyY/UDxFPTVqxk8IqRkkK3s4GchqBneg5rFlrmayuBH+047yz
	 8FqLwbVR+J+aW5jCHXj+dPhOxMkOt+aA2Qdoj2J4iWjXQGRYfO/EyCrfBDI9vs17AS
	 JhwtU1n90LaOdbbrGq/fV9qHACHSkK7Z5PgmKjyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 0459/1887] mmc: mtk-sd: Cancel request timeout work on remove
Date: Wed, 28 Oct 2026 17:42:35 +0100
Message-ID: <20261028170509.678390351@linuxfoundation.org>
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
@@ -2854,6 +2854,7 @@ static int msdc_drv_remove(struct platfo
 
 	platform_set_drvdata(pdev, NULL);
 	mmc_remove_host(mmc);
+	cancel_delayed_work_sync(&host->req_timeout);
 	msdc_deinit_hw(host);
 	msdc_gate_clock(host);
 


