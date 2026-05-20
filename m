Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559D22F363F;
	Wed, 20 May 2026 18:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300870; cv=none; b=H6sWgw3KaNsQ+FcD7eDJ6Ke3xwFz4f79SQPhkdyRlBPUyuSA26VhiF6RRgexRO7q6QO7gv4C1MVvMTiOz1pmhSRUZrbITwmAz8K2EsEABDkKsLT9kJ60WwYEYsNwoK001C3e37QZ5WNqScskCJ0LomgBFpHpL1eRz1Wm3J/EOSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300870; c=relaxed/simple;
	bh=1JYhdrsA3uw52Uiy/YU8A90pVGpSc1yHSRGZrDkD9ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsbGxMjCROSPUR+VUFmraLylLghRX/47Tc9zLrh9DGE38qAhwanVGL+aVoCjQsaFOawRIbAEVwOPovwjvvbabr+F//l2Eisd3oArNkAqjjuX2S6vwqU4MRYHdIfMwrm4veQaOKpXWD9PM0lYJDyHMOOF4N9KLDS8gsE3vtlNs8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCp2bpZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCp2bpZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7061F000E9;
	Wed, 20 May 2026 18:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300869;
	bh=S7n5I76gIM7i8AES2XcDPIjVIRVmwVphWCtNSxw6JdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCp2bpZjJ8cFUAGAJbQIe6A/1ubpcF6CjK9KguApv0f/qYuS9PNbDQEwJ86BXjjq0
	 gM5OQd5lVrzdv3I0Ky7aX2TwgyBwmdrlOF0JcpbA7ojJxbR05uGp71T0hSqId2oaeo
	 CzdlwqHsmnGdbjh63IelT/LBR8h4u/GjQ12zwBR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 337/666] mtd: spi-nor: update spi_nor_fixups::post_sfdp() documentation
Date: Wed, 20 May 2026 18:19:08 +0200
Message-ID: <20260520162118.537152597@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 3620d67b48493c6252bbc873dc88dde81641d56b ]

After commit 5273cc6df984 ("mtd: spi-nor: core: Call
spi_nor_post_sfdp_fixups() only when SFDP is defined")
spi_nor_post_sfdp_fixups() isn't called anymore if no SFDP is detected.

Update the documentation accordingly.

Fixes: 5273cc6df984 ("mtd: spi-nor: core: Call spi_nor_post_sfdp_fixups() only when SFDP is defined")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index 3aeca2299ddb1..df07ded382605 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -412,7 +412,7 @@ struct spi_nor_flash_parameter {
  *                   number of dummy cycles in read register ops.
  * @smpt_map_id: called after map ID in SMPT table has been determined for the
  *               case the map ID is wrong and needs to be fixed.
- * @post_sfdp: called after SFDP has been parsed (is also called for SPI NORs
+ * @post_sfdp: called after SFDP has been parsed (is not called for SPI NORs
  *             that do not support RDSFDP). Typically used to tweak various
  *             parameters that could not be extracted by other means (i.e.
  *             when information provided by the SFDP/flash_info tables are
-- 
2.53.0



