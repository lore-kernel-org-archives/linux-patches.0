Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787ED194A67;
	Tue, 27 May 2025 16:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364354; cv=none; b=KtnXYtgy8zpv4BuAkKDruS0mwRVG02P7mtQJbbtfzCechup6l0pJ9dEgn+mBQeCLmia5OMLrXVesCmkv7AGG/AsYebFY0GQMQpMAQ0Y/wDGODfHF06iN6KuVAPdYl31sgFRZY9LtqzLPCatL5YR4A6OAtxhi2LXfaThwJasQS6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364354; c=relaxed/simple;
	bh=VmdcuOF7irSXzxLdzQSdoKtEWbbLrRHMa34IXF0VUN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMmOc11Z04O1pk8JEPsApw/8EXbaMXABvFWGh885butjkbMrZWb9Owdx9IAdovEkvy4IcY0FtDg5du3L6XzoooGezyBGjD/eGK+UQlW77S/0fZlThW8zlioftdLUwxyEw9HnCm8Ezs53JC13vz9/iryLg878t5OVHKwS/Sfks2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRbxKi85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRbxKi85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B406C4CEE9;
	Tue, 27 May 2025 16:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364352;
	bh=VmdcuOF7irSXzxLdzQSdoKtEWbbLrRHMa34IXF0VUN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRbxKi85yu4eWbnW5V7DJzA3VZ7Gh7beRZZZYZwTLkS5gksY6e230+wOqtu4pvIN4
	 bx4kyk5CzpU8gRz4mDl12Iqi3qPDLo6bycwW+M/63r5VmLsi4xVS3jCBcmO+gT1V+a
	 /0HycIFaeWNZjgKHe8BiNFPEADge//vTBzWy3Rcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	kernel test robot <lkp@intel.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/626] dma-mapping: Fix warning reported for missing prototype
Date: Tue, 27 May 2025 18:18:42 +0200
Message-ID: <20250527162446.249705239@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balbir Singh <balbirs@nvidia.com>

[ Upstream commit cae5572ec9261f752af834cdaaf5a0ba0afcf256 ]

lkp reported a warning about missing prototype for a recent patch.

The kernel-doc style comments are out of sync, move them to the right
function.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504190615.g9fANxHw-lkp@intel.com/

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
[mszyprow: reformatted subject]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250422114034.3535515-1-balbirs@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/mapping.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index f7366083b4d00..74d453ec750a1 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -897,14 +897,6 @@ int dma_set_coherent_mask(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_set_coherent_mask);
 
-/**
- * dma_addressing_limited - return if the device is addressing limited
- * @dev:	device to check
- *
- * Return %true if the devices DMA mask is too small to address all memory in
- * the system, else %false.  Lack of addressing bits is the prime reason for
- * bounce buffering, but might not be the only one.
- */
 static bool __dma_addressing_limited(struct device *dev)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
@@ -918,6 +910,14 @@ static bool __dma_addressing_limited(struct device *dev)
 	return !dma_direct_all_ram_mapped(dev);
 }
 
+/**
+ * dma_addressing_limited - return if the device is addressing limited
+ * @dev:	device to check
+ *
+ * Return %true if the devices DMA mask is too small to address all memory in
+ * the system, else %false.  Lack of addressing bits is the prime reason for
+ * bounce buffering, but might not be the only one.
+ */
 bool dma_addressing_limited(struct device *dev)
 {
 	if (!__dma_addressing_limited(dev))
-- 
2.39.5



