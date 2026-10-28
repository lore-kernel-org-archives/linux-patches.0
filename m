Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211519;
	b=I42w5LUqJl5FAVDYDPJSp+LCwlT9h34fFZynwpQTk5j5frTOuZFykGzaOe9HUFE9Ew/k
	 J2udlopXUm7fUKpZCwDWcZmU/4bumkuWOpquxjEYyHRd+7HlXFwjBoeMAFL9GVHk1OvtB
	 KyEQwckHuLf+If5HaTbdBgwav+ZKTUMMoHk8RPgwTtJQGDMotZ2TBDs7g/RwGJxrsW0cy
	 OdhYdcJJKX6R29elPsqe4h6Z0lAn7NcL0X5NYoPFDulAIukWL1L0LTZ8Ex6nRqLJffN/d
	 3f7jyOJX8N5/PoSzcOJ1jtljQTOs4VceN8f330xV8GzhUqI4ome1gPGc24pQsKQyzYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vtyb+Q/siPV1DUTutUyUkyA2nrZ0cPwjHEyORHLynl4=;
	b=bt0FX0FVqJ8QS74h95qm6atAI4+PU6JXbOwC6aiThr2ODM6pozkCyJL0oTJfdp591JjT
	 xSPX+P/CKoaBct78nSJ0R5kb50Nc2znVvLQE/gDwi3TajUStm7RHt50uN71MtOSRkDofJ
	 gjF3wqPVhhhSZ6Uz2Cie2IomK+nuZJj05kk5/5cQxtWgFfQpTJQpJHQ4BzgEoJwnGoL9v
	 z7aMuriGBgPVeSrC54GOCEGg/Ndpk70E/oZpwqqZhDDEd7vqwDN028sUOiY1L4FYlsm8u
	 3eTMldgvZaZXIsJLs9aqQYFq3d4Do/bG6PzfvSGyMYIstSj7rKyO49S4ZZaVEGI4jLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8I9oGwD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183F8606A31C;
	Wed, 28 Oct 2026 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8I9oGwD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C071F01825;
	Wed, 28 Oct 2026 18:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211518;
	bh=Vtyb+Q/siPV1DUTutUyUkyA2nrZ0cPwjHEyORHLynl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8I9oGwDsXsQjGKG5wY/LsnO24nL6nZc2VaLzIuPALGJrmJ+UbrsF6wjKP7JdaaJl
	 3YVOp/6hr8sCVprW2HqvJINhZi18XJlc1o1aLj1EnVgKsnUcX4l4uzuMR4G8i960wS
	 pmNDxtIRzHUhq1XIc+LgRA0UqOFu6aFafhfHmbio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 369/571] mmc: mtk-sd: Cancel request timeout work on remove
Date: Wed, 28 Oct 2026 17:58:36 +0100
Message-ID: <20261028170016.769653782@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2702,6 +2702,7 @@ static int msdc_drv_remove(struct platfo
 
 	platform_set_drvdata(pdev, NULL);
 	mmc_remove_host(mmc);
+	cancel_delayed_work_sync(&host->req_timeout);
 	msdc_deinit_hw(host);
 	msdc_gate_clock(host);
 


