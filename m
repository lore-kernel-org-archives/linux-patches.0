Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F250E1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71072C433C9;
	Tue,  1 Aug 2023 09:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883115;
	bh=WllhNuc1gDmBtDiE2Gcqukbw4COGXIC2Z1Z9agtAi8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUSCULs+8QTSBzuPqjSNpgerm955S4/6Npu2SBFp67+rDlrqsw/vjf6Zj3/3xAOKh
	 k6eNWBBGOV/HiLsWSzpjD6h/zSPEJ/ccMw8y7oJ/lpFRhPm4RPkXxpeY1zUUmADThQ
	 awnbEG/F5UyIgA/GBtqCHHl+slcZEZFlNnWvb9uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 120/239] cxl/acpi: Return rc instead of 0 in cxl_parse_cfmws()
Date: Tue,  1 Aug 2023 11:19:44 +0200
Message-ID: <20230801091930.042448907@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 91019b5bc7c2c5e6f676cce80ee6d12b2753d018 ]

Driver initialization returned success (return 0) even if the
initialization (cxl_decoder_add() or acpi_table_parse_cedt()) failed.

Return the error instead of swallowing it.

Fixes: f4ce1f766f1e ("cxl/acpi: Convert CFMWS parsing to ACPI sub-table helpers")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20230714093146.2253438-2-leitao@debian.org
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 973d6747078c9..8757bf886207b 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -297,7 +297,7 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
 		rc = cxl_decoder_autoremove(dev, cxld);
 	if (rc) {
 		dev_err(dev, "Failed to add decode range: %pr", res);
-		return 0;
+		return rc;
 	}
 	dev_dbg(dev, "add: %s node: %d range [%#llx - %#llx]\n",
 		dev_name(&cxld->dev),
-- 
2.40.1



