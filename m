Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E15387562;
	Tue, 10 Mar 2026 11:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141910; cv=none; b=ElTof6W3iiGsrEwFMlNfkLqc0cX+AZ8t/I3MtYqOUdBwyb3cx+ndktgvHtt8w/kYYw+ilJbfPEqK+lOcgVvLzVlzzUinzpVSmyW3em+hT3DKeg1xuC2N3g6AhtIQbRQ1iBwu5j17T3DZY1HFkDvE4IcPuhrTmRZJd+ORuRVzrDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141910; c=relaxed/simple;
	bh=Od99ggh6f+36bLixdSqp8+rPZwCVPfc6Abl9bGT092U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpZrnltEbhtABQVFReLdLkiCKiBCWHDftqYvDvJU4nyij56SEYd2FaIp0/cl3V0kyFqXkqQRzutEfPGSX4+A5Fs58jAkLfCRluzWPWFCFGWaKVy0uniFx7zFGHFW0zFNUUKUVnPgXY3qPcDfh7+cA5529BWjjFitfDTMtkRJWn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHNm40RZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHNm40RZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24952C19423;
	Tue, 10 Mar 2026 11:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141909;
	bh=Od99ggh6f+36bLixdSqp8+rPZwCVPfc6Abl9bGT092U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHNm40RZkX31mj4QprGUfbIwgM98Wu22XaYPbLt2dJcfPinhxJiLa8ruUjOPNEvzJ
	 /BO9OEhfrbqduyv728Fi9GvjYNoc9fd+ZulGfhiiJwv8N93lV35tyQrY8/xHHv+JCp
	 qEzPDW9fHufnr/EyJI5xOo6ZDw5eosyZv9V/Bu+nhe+NLM7H3HkKjvUR88uwp6BGSN
	 htHcDCdk4HggPEhrlqYYmhKuHlRVpaAaYLbl2X7aKIfcR025Lrv2x92yJZBgDB+TT/
	 w6MmGVmzUou7Qnr9WaEvQMfDq95Q3T6WIuD3+uyUVVzaDqm96FgKPGLBT6ZUpMxovi
	 WentgWuPBRzKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/314] cxl: Move devm_cxl_add_nvdimm_bridge() to cxl_pmem.ko
Date: Tue, 10 Mar 2026 07:14:52 -0400
Message-ID: <8cce5a3eed02199f48fd80e4a17867f8e26a4eab.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit e7e222ad73d93fe54d6e6e3a15253a0ecf081a1b ]

Moving the symbol devm_cxl_add_nvdimm_bridge() to
drivers/cxl/cxl_pmem.c, so that cxl_pmem can export a symbol that gives
cxl_acpi a depedency on cxl_pmem kernel module. This is a prepatory patch
to resolve the issue of a race for nvdimm_bus object that is created
during cxl_acpi_probe().

No functional changes besides moving code.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Ira Weiny <ira.weiny@intel.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com?>
Link: https://patch.msgid.link/20260205001633.1813643-2-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 96a1fd0d84b1 ("cxl: Fix race of nvdimm_bus object when creating nvdimm objects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pmem.c | 13 +++----------
 drivers/cxl/cxl.h       |  2 ++
 drivers/cxl/pmem.c      | 14 ++++++++++++++
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index 8853415c106a9..e1325936183a6 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -115,15 +115,8 @@ static void unregister_nvb(void *_cxl_nvb)
 	device_unregister(&cxl_nvb->dev);
 }
 
-/**
- * devm_cxl_add_nvdimm_bridge() - add the root of a LIBNVDIMM topology
- * @host: platform firmware root device
- * @port: CXL port at the root of a CXL topology
- *
- * Return: bridge device that can host cxl_nvdimm objects
- */
-struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
-						     struct cxl_port *port)
+struct cxl_nvdimm_bridge *__devm_cxl_add_nvdimm_bridge(struct device *host,
+						       struct cxl_port *port)
 {
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct device *dev;
@@ -155,7 +148,7 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
 	put_device(dev);
 	return ERR_PTR(rc);
 }
-EXPORT_SYMBOL_NS_GPL(devm_cxl_add_nvdimm_bridge, "CXL");
+EXPORT_SYMBOL_FOR_MODULES(__devm_cxl_add_nvdimm_bridge, "cxl_pmem");
 
 static void cxl_nvdimm_release(struct device *dev)
 {
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 231ddccf89773..443296da74db1 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -866,6 +866,8 @@ void cxl_driver_unregister(struct cxl_driver *cxl_drv);
 struct cxl_nvdimm_bridge *to_cxl_nvdimm_bridge(struct device *dev);
 struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
 						     struct cxl_port *port);
+struct cxl_nvdimm_bridge *__devm_cxl_add_nvdimm_bridge(struct device *host,
+						       struct cxl_port *port);
 struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm(struct device *dev);
 int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index e197883690efc..714beaf1704be 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -13,6 +13,20 @@
 
 static __read_mostly DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
 
+/**
+ * __devm_cxl_add_nvdimm_bridge() - add the root of a LIBNVDIMM topology
+ * @host: platform firmware root device
+ * @port: CXL port at the root of a CXL topology
+ *
+ * Return: bridge device that can host cxl_nvdimm objects
+ */
+struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
+						     struct cxl_port *port)
+{
+	return __devm_cxl_add_nvdimm_bridge(host, port);
+}
+EXPORT_SYMBOL_NS_GPL(devm_cxl_add_nvdimm_bridge, "CXL");
+
 static void clear_exclusive(void *mds)
 {
 	clear_exclusive_cxl_commands(mds, exclusive_cmds);
-- 
2.51.0

