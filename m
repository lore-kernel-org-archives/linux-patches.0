Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B029257849;
	Tue, 11 Nov 2025 01:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822803; cv=none; b=R/M0Bngr+pwIHnECRWQasIsBAW71unujRetVxKGFWHiLr7X4f9pPzR+J0eAqvl0sjuWNvzGZUUaoS4qaXdgUyoQX3bZieBk+P2qrSdADypvVLGwnSqqAJRX70LIqaYt5kGuKgW5RNRs/IZikqOr6VYqSUOwP7ZmhCh0wi9L4tmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822803; c=relaxed/simple;
	bh=LKKQRVyDc13Rz6BsYCfxU6+nmOtQaz+P8MVG/5OdCVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjIeAvsqHnbqCPqnwk4+5bfylwgn+eKkC5rAJSI7ordNzzcCNY9vboiPmPEGkSz4wIRsehT7UY9LlIRGEIrxVlGG8dQ/8FjNEtA6QzVM44Ar6uaKozA1muznVm0vkMUQAQX3NU1hvYRy2Qt7ZBXyrzqqKZGiVvzEVyjvCxatH4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNCAL+G8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNCAL+G8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30376C16AAE;
	Tue, 11 Nov 2025 01:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822803;
	bh=LKKQRVyDc13Rz6BsYCfxU6+nmOtQaz+P8MVG/5OdCVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNCAL+G8P7wUIdIWbImDVkmwwKjkKVOAg+FwgZI3b7f+8qM+EG13Q8L2UtAOKhaxL
	 7N/Ea4SoNHqaD0889PRVUWSPjrdkuID4i6iLzAMiiTGpsRdG3YKRo6ktBcTeIoKdH8
	 bH4uB7wyDO+KNlx3s2jOK8xrVKRl0IAHeE7LtpcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Brattlof <bb@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 174/849] soc: ti: k3-socinfo: Add information for AM62L SR1.1
Date: Tue, 11 Nov 2025 09:35:44 +0900
Message-ID: <20251111004540.641932457@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Brattlof <bb@ti.com>

[ Upstream commit 037e496038f6e4cfb3642a0ffc2db19838d564dd ]

The second silicon revision for the AM62L was mainly a ROM revision
and therefore this silicon revision is labeled SR1.1

Add a new decode array to properly identify this revision as SR1.1

Signed-off-by: Bryan Brattlof <bb@ti.com>
Link: https://patch.msgid.link/20250908-62l-chipid-v1-1-9c7194148140@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/k3-socinfo.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/soc/ti/k3-socinfo.c b/drivers/soc/ti/k3-socinfo.c
index d716be113c84f..50c170a995f90 100644
--- a/drivers/soc/ti/k3-socinfo.c
+++ b/drivers/soc/ti/k3-socinfo.c
@@ -66,6 +66,10 @@ static const char * const j721e_rev_string_map[] = {
 	"1.0", "1.1", "2.0",
 };
 
+static const char * const am62lx_rev_string_map[] = {
+	"1.0", "1.1",
+};
+
 static int
 k3_chipinfo_partno_to_names(unsigned int partno,
 			    struct soc_device_attribute *soc_dev_attr)
@@ -92,6 +96,12 @@ k3_chipinfo_variant_to_sr(unsigned int partno, unsigned int variant,
 		soc_dev_attr->revision = kasprintf(GFP_KERNEL, "SR%s",
 						   j721e_rev_string_map[variant]);
 		break;
+	case JTAG_ID_PARTNO_AM62LX:
+		if (variant >= ARRAY_SIZE(am62lx_rev_string_map))
+			goto err_unknown_variant;
+		soc_dev_attr->revision = kasprintf(GFP_KERNEL, "SR%s",
+						   am62lx_rev_string_map[variant]);
+		break;
 	default:
 		variant++;
 		soc_dev_attr->revision = kasprintf(GFP_KERNEL, "SR%x.0",
-- 
2.51.0



