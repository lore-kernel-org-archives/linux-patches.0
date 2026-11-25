Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619376;
	b=xLqVC9vrG01GwHM4VxspjzRhoXdxWC6oLYbXMSuA5NKyX0k3bjEYEKvLPmiz3CMiJo+G
	 VnVHmxN5i0QpXKDHsI5Y2EzyAlTumHuUtWcxvtn13T2PR8Bo12Jy99hFM7YHzIKlCk08D
	 aAh5URe969H6dZVH5KTObNoTrGw9f72KflTJD/Bykl1Q5g4SvTCs0FyRWmaEGbVLnvXVs
	 1OBU88KuFcg2bg0l1TRVnIvmPULyefvy/RZpp07GQta20B2nAn0/TDZdFE1tlOIJOxcNp
	 Z122YgIBtz66StUxMTjdMij4WAzxCtsY8b9ERJjKREvcFZsf6suj2kZKCU1e2BymKIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DNuwflf6zkLdz0vlFKrQ+4DfdOlFAt9zQ3q8OcgytJI=;
	b=yVNGE9k1HOvIIKnyCRaVgiq/eR6pe0KDqekOhSlVQdeTCMg4Jr8x/1hpoC7xkMmVk0LA
	 6ouW7bx2ZT3tQ42actmi6xtlLmsTqhbDl1QaYURa/xoOH9o1izz4k5OMUmnyHhsGTlwVY
	 dCpZK9Dw2lFLHg/Q/8whYbeWf0VPs6R3boeEg1fVVePBuYi56v5eKGf4gjUDomY2fEX8M
	 E/FeEKbEvv5zBw3k+3BAthte+C2F79gifCgqMVKWr5IluXw6XXx70hp5Wp9uVzMYt0fvd
	 Ogwai+yszSfq/m7B6177WEgXLCaykQZJqRwNPglYWWFHp7HGuEfdpbcJ+jhD2aRXsRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzFcygow;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4BE606A31E;
	Wed, 25 Nov 2026 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzFcygow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9991F000C0;
	Wed, 25 Nov 2026 15:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619375;
	bh=DNuwflf6zkLdz0vlFKrQ+4DfdOlFAt9zQ3q8OcgytJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzFcygowwwehynI3tPDKMKu9tRBhDD5qnjfDiDvqbeItENBveFHJ8ludpsq5CQDuR
	 AF1wKbZFdP3WHr+242aMQ6fbbWVb92PRwkUcvXb3LtmpoX2r7CJJEm3SeilBtKX6XT
	 bcP4+RXvQCUV2WUxRipJjjfTRjb6Qf6btR/IPDpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Louvignes <olivier@mgcrea.io>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.3 0576/1005] mmc: jz4740: Remove the host before resetting the controller
Date: Wed, 25 Nov 2026 15:31:54 +0100
Message-ID: <20261125143835.241451159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Olivier Louvignes <olivier@mgcrea.io>

commit 6b8b1e8827837bf4cf1f87219038fddae9e81b0b upstream.

jz4740_mmc_remove() masks every interrupt and resets the controller
before mmc_remove_host(), which removes the card and lets the card's
driver send its last commands. Those commands then run on a controller
that was just reset, and can wait out the driver's 5 s request timeout.

With an SDIO card that cost 5 s on every unbind: on a HiBy R1 (Ingenic
X1600, a BCM43430A1 driven by brcmfmac), the CMD52 that
sdio_release_irq() sends from brcmfmac's remove waited 5.1 s. The
command had finished (END_CMD_RES set in MSC_STAT), but MSC_IMASK read
0xffffffff although the request had unmasked END_CMD_RES. MSC_STAT can
still show IS_RESETTING after jz4740_mmc_reset() returns, so the reset
most likely completed after that write and undid it.

Remove the host first, then quiesce the controller, as other host
drivers do. On the R1, unbinding the Wi-Fi's MSC now takes 0.65 s.

Fixes: 61bfbdb85687 ("MMC: Add support for the controller on JZ4740 SoCs.")
Cc: stable@vger.kernel.org
Signed-off-by: Olivier Louvignes <olivier@mgcrea.io>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/jz4740_mmc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -1151,12 +1151,13 @@ static void jz4740_mmc_remove(struct pla
 {
 	struct jz4740_mmc_host *host = platform_get_drvdata(pdev);
 
+	/* The card's driver may still send commands as it goes */
+	mmc_remove_host(host->mmc);
+
 	timer_delete_sync(&host->timeout_timer);
 	jz4740_mmc_set_irq_enabled(host, 0xff, false);
 	jz4740_mmc_reset(host);
 
-	mmc_remove_host(host->mmc);
-
 	free_irq(host->irq, host);
 
 	if (host->use_dma)


