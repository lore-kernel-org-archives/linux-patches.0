Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E199D528;
	Sun,  7 Sep 2025 20:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276661; cv=none; b=AmzWx/9t8Q8zLEYKpU1iQurMM2tYlEmGP/Fn5iL1OX37/nELuthmCpE/4pwRUx4hKQki8jIN0ISgo5QU9UDo/eAbxqBpzXw5Z8Jue40wdFzk6O13zoST2oSKYfz2KPpyTDSeQ/Gi4y5pxl8cM5fOBNAFf6d1Jd+xvTYQQ4P5eTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276661; c=relaxed/simple;
	bh=fOpYYoSEiS2VzZROy0nEMafWGQAd4rY7edpFL92jd3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbSob8CJ0CWeM51wmbpuqSEMd4UJdbnul16lYdsAZNEG2U+R26OSFEPWPE1ctay+YaGAS1irriIEbf080Ndwv5VkQrT6CGGcX9kGhiGNPW/4Yil3Tu/KvpPEx0s9MZAUrOG2w3d40W9jj8nmZN5XZUg2FVO1ooR44pr0wGfwp8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/A9Gg6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/A9Gg6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8965C4CEF0;
	Sun,  7 Sep 2025 20:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276661;
	bh=fOpYYoSEiS2VzZROy0nEMafWGQAd4rY7edpFL92jd3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/A9Gg6kZ1HK7ehl4KsXVA/KdJJ3ThakAayO7sEdLxEWK/ezv8AbcK3dXAVH+EWB9
	 O4hGM3kTZd4bIEq7NP1BcKYXVi0njq0To3rbnI1TN8XDB9iZsdsQqer4dTUFQ8dliH
	 PWYFTiBakTOIOIWGLV1XUg09EkVrEAIL1x7/Cthc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinfeng Wang <jinfeng.wang.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 070/121] Revert "spi: cadence-quadspi: fix cleanup of rx_chan on failure paths"
Date: Sun,  7 Sep 2025 21:58:26 +0200
Message-ID: <20250907195611.633723750@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinfeng Wang <jinfeng.wang.cn@windriver.com>

This reverts commit 1af6d1696ca40b2d22889b4b8bbea616f94aaa84 which is
commit 04a8ff1bc3514808481ddebd454342ad902a3f60 upstream.

There is cadence-qspi ff8d2000.spi: Unbalanced pm_runtime_enable! error
without this revert.

After reverting commit cdfb20e4b34a ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
and commit 1af6d1696ca4 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths"),
Unbalanced pm_runtime_enable! error does not appear.

These two commits are backported from upstream commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
and commit 04a8ff1bc351 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths").

The commit 04a8ff1bc351 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths")
fix commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance").

The commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance") fix
commit 86401132d7bb ("spi: spi-cadence-quadspi: Fix missing unwind goto warnings").

The commit 86401132d7bb ("spi: spi-cadence-quadspi: Fix missing unwind goto warnings") fix
commit 0578a6dbfe75 ("spi: spi-cadence-quadspi: add runtime pm support").

6.6.y only backport commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
and commit 04a8ff1bc351 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths"),
but does not backport commit 0578a6dbfe75 ("spi: spi-cadence-quadspi: add runtime pm support")
and commit 86401132d7bb ("spi: spi-cadence-quadspi: Fix missing unwind goto warnings").
And the backport of commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
differs with the original patch. So there is Unbalanced pm_runtime_enable error.

If revert the backport for commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
and commit 04a8ff1bc351 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths"), there is no error.
If backport commit 0578a6dbfe75 ("spi: spi-cadence-quadspi: add runtime pm support") and
commit 86401132d7bb ("spi: spi-cadence-quadspi: Fix missing unwind goto warnings"), there
is hang during booting. I didn't find the cause of the hang.

Since commit 0578a6dbfe75 ("spi: spi-cadence-quadspi: add runtime pm support") and
commit 86401132d7bb ("spi: spi-cadence-quadspi: Fix missing unwind goto warnings") are
not backported, commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
and commit 04a8ff1bc351 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths") are not needed.
So revert commits commit cdfb20e4b34a ("spi: spi-cadence-quadspi: Fix pm runtime unbalance") and
commit 1af6d1696ca4 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths").

Signed-off-by: Jinfeng Wang <jinfeng.wang.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1870,6 +1870,11 @@ static int cqspi_probe(struct platform_d
 
 	pm_runtime_enable(dev);
 
+	if (cqspi->rx_chan) {
+		dma_release_channel(cqspi->rx_chan);
+		goto probe_setup_failed;
+	}
+
 	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register SPI ctlr %d\n", ret);


