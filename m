Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA6E442FA6;
	Thu, 30 Jul 2026 15:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425119; cv=none; b=cdnIFBNeHSEt35Mwf06koEKSN4BZWyiFdHegz51QXRgttJOP6tG/cn2IHy32qoOKbN/h/Mtsd+HCpCnIQmQZ164GvOcdNc3OQDh9leEdVAk5ThFY5C67Z3TC09jBb3fWwLVxUaej03uJFrrfEdNjvqHZDkEhvGRlHGnsJr3zasI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425119; c=relaxed/simple;
	bh=c+tpuKNyYKn4njKWH8wGPZFysfF5JmF0GeZ1gQ5nmUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnDqPG9VIQRA0APYRVd90hLPgCM0DCTs+U5xwAGmIBbAnJTUM8rDaaqxZPo4o9vkXsszk7qEmnFwn3bBTfSfBJZvxbuzMSOoGopaHAwJfSfEzbv9S3eujk2ayR68Dmrcs1tLKPG7tyChHEDV9AmwxoZ2G4lt/PJIGUvGWDd2PiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y66BWM6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y66BWM6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930581F00A3A;
	Thu, 30 Jul 2026 15:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425118;
	bh=GMCXCu2rg94c7h8fYDh5PMnpbROrrEIaiW3T7LJ/kT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y66BWM6uje6fCC3LO2SqCTjm2+44ebSxkpfuVQ8nmvbuTGSpqobtRGcKouMoKXOBS
	 aqH33JJ8B/OglwH8JfnKU4XagSEMuHfYwIchdG3YDKsCPJPvES4IlsRGLAqEVV0WKj
	 WT4mVZ9RwljSu7CZsnEDXp/9OWzL2tpr4lqCSZE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Bowman <terry.bowman@amd.com>,
	Alejandro Lucero <alucerop@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 630/675] cxl/pci: Remove unnecessary CXL RCH handling helper functions
Date: Thu, 30 Jul 2026 16:16:00 +0200
Message-ID: <20260730141458.515787547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Terry Bowman <terry.bowman@amd.com>

[ Upstream commit eb78ef4d6f0e51243c1ee117f801dbc503e886ab ]

cxl_handle_rdport_cor_ras() and cxl_handle_rdport_ras() are specific
to Restricted CXL Host (RCH) handling. Improve readability and
maintainability by replacing these and instead using the common
cxl_handle_cor_ras() and cxl_handle_ras() functions.

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Alejandro Lucero <alucerop@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20260114182055.46029-6-terry.bowman@amd.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: c268f949e219 ("cxl: Fix CXL_HEADERLOG_SIZE to match RAS Capability size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/pci.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -858,18 +858,6 @@ void cxl_dport_init_ras_reporting(struct
 }
 EXPORT_SYMBOL_NS_GPL(cxl_dport_init_ras_reporting, "CXL");
 
-static void cxl_handle_rdport_cor_ras(struct cxl_dev_state *cxlds,
-					  struct cxl_dport *dport)
-{
-	return cxl_handle_cor_ras(cxlds, dport->regs.ras);
-}
-
-static bool cxl_handle_rdport_ras(struct cxl_dev_state *cxlds,
-				       struct cxl_dport *dport)
-{
-	return cxl_handle_ras(cxlds, dport->regs.ras);
-}
-
 /*
  * Copy the AER capability registers using 32 bit read accesses.
  * This is necessary because RCRB AER capability is MMIO mapped. Clear the
@@ -939,9 +927,9 @@ static void cxl_handle_rdport_errors(str
 	pci_print_aer(pdev, severity, &aer_regs);
 
 	if (severity == AER_CORRECTABLE)
-		cxl_handle_rdport_cor_ras(cxlds, dport);
+		cxl_handle_cor_ras(cxlds, dport->regs.ras);
 	else
-		cxl_handle_rdport_ras(cxlds, dport);
+		cxl_handle_ras(cxlds, dport->regs.ras);
 }
 
 #else


