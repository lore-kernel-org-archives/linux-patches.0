Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023844;
	b=kybv2HoS6saCynsZoJlS2uUGJHIAFfJ95DkRQdS9Pu+ddK91yHxxwV/Wfox/4j5cUryV
	 QJzC1BLF+6D0bfVQeQCspHmCDAwVP4n9FAjfy1Mv/jVXYfwc5ktiCeQ1S7ocxFVqosD9l
	 yidjtqaEDYA676uRLUGv4kKsNu+uGTFMTnB0fCYRDbL+oPcHymT+86zBCjURlMKSGFO8R
	 tFlBMHel5+6l7fGmsNrlk0MQQ9Uo9j2+DdpVKXARIxRiktfseGS+S0YSu0jVon/5eBBql
	 6HhPEE2ksd0FUXopO8jLVp/JMrQLQGHCa1IOeIkPFw2WNJyvyZRj+sjqXPpjMp9zX6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WDQt6MgTm8HMQ1ocmUe/XhujXqrKDa6hzz56fERncjQ=;
	b=Ta6Py/nKJ+Ob9Kyq0UmZ95KA5CfyhmzhYmpTFAJrUYBfjhqfaPYN6QuaweZoK5fogPT4
	 M9eStzMM1E/znNPJKjpOXFvvHNv0iZ0PsNS8vuNuCIHnJRVwgQyoVCCoOZ/eLcgofserk
	 ZYAqLd6/xJTaxwGMWvRiEPlOe5vOwk9DfERfHQrpTlPR2/Mtd7vAjRk1VVF3MvQe+Nfrf
	 A1rSd1eqNtL0XtXTV4N+P/tA7/vawGzYqGGjq46X9VVmxaSLc6cazfk+9q0HvXcktXFdn
	 t+99DEeFdC3dWb6vp4vwKpJ48SIEQ/F2Aqw3f8Qx724sl0Tdm1HBH8b3htYHgeCDMow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=chqqzOIV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36108606A31C;
	Wed, 18 Nov 2026 17:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=chqqzOIV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2A11F000C5;
	Wed, 18 Nov 2026 17:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023843;
	bh=WDQt6MgTm8HMQ1ocmUe/XhujXqrKDa6hzz56fERncjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chqqzOIVWgFfFxYU2kKOibPuANgfoccGB52sPsxKuDIGGtjgNFPw/wubzaCHPDOJA
	 ShNGFEf2S/kMd84aqMcrppJqRRod/mtST+/RELbq5MCxMG/tqFIP0RBh9KiSsIox3X
	 2UxVaQbGa+n/rAOPatVmEABED1/rCh0bX3rEqfNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Alison Schofield <alison.schofield@intel.com>,
	"Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0512/2151] cxl/test: Add support for acpi extended linear cache
Date: Wed, 18 Nov 2026 15:37:27 +0100
Message-ID: <20261118150140.712769324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 68f4a852e18329e84bb5d36168a45b0a52cdf236 ]

Add the mock wrappers for hmat_get_extended_linear_cache_size() in order
to emulate the ACPI helper function for the regions that are mock'd by
cxl_test.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
Link: https://patch.msgid.link/20251117144611.903692-4-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 0de71a1ab211 ("cxl/core: Fix dport use-after-free via the einj_inject debugfs file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/Kbuild      |  1 +
 tools/testing/cxl/test/cxl.c  | 21 +++++++++++++++++++++
 tools/testing/cxl/test/mock.c | 20 ++++++++++++++++++++
 tools/testing/cxl/test/mock.h |  3 +++
 4 files changed, 45 insertions(+)

diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 950335b3c128f..f1ed9c46acd2d 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -11,6 +11,7 @@ ldflags-y += --wrap=cxl_rcd_component_reg_phys
 ldflags-y += --wrap=cxl_endpoint_parse_cdat
 ldflags-y += --wrap=cxl_dport_init_ras_reporting
 ldflags-y += --wrap=devm_cxl_endpoint_decoders_setup
+ldflags-y += --wrap=hmat_get_extended_linear_cache_size
 
 DRIVERS := ../../../drivers
 CXL_SRC := $(DRIVERS)/cxl
diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 3e5ae5caae94d..aadb90ec516e5 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -595,6 +595,25 @@ mock_acpi_evaluate_integer(acpi_handle handle, acpi_string pathname,
 	return AE_OK;
 }
 
+static int
+mock_hmat_get_extended_linear_cache_size(struct resource *backing_res,
+					 int nid, resource_size_t *cache_size)
+{
+	struct acpi_cedt_cfmws *window = mock_cfmws[0];
+	struct resource cfmws0_res =
+		DEFINE_RES_MEM(window->base_hpa, window->window_size);
+
+	if (!extended_linear_cache ||
+	    !resource_contains(&cfmws0_res, backing_res)) {
+		return hmat_get_extended_linear_cache_size(backing_res,
+							   nid, cache_size);
+	}
+
+	*cache_size = mock_auto_region_size;
+
+	return 0;
+}
+
 static struct pci_bus mock_pci_bus[NR_BRIDGES];
 static struct acpi_pci_root mock_pci_root[ARRAY_SIZE(mock_pci_bus)] = {
 	[0] = {
@@ -1121,6 +1140,8 @@ static struct cxl_mock_ops cxl_mock_ops = {
 	.devm_cxl_port_enumerate_dports = mock_cxl_port_enumerate_dports,
 	.cxl_endpoint_parse_cdat = mock_cxl_endpoint_parse_cdat,
 	.devm_cxl_add_dport_by_dev = mock_cxl_add_dport_by_dev,
+	.hmat_get_extended_linear_cache_size =
+		mock_hmat_get_extended_linear_cache_size,
 	.list = LIST_HEAD_INIT(cxl_mock_ops.list),
 };
 
diff --git a/tools/testing/cxl/test/mock.c b/tools/testing/cxl/test/mock.c
index 995269a75cbd1..bff5853717f02 100644
--- a/tools/testing/cxl/test/mock.c
+++ b/tools/testing/cxl/test/mock.c
@@ -111,6 +111,26 @@ acpi_status __wrap_acpi_evaluate_integer(acpi_handle handle,
 }
 EXPORT_SYMBOL(__wrap_acpi_evaluate_integer);
 
+int __wrap_hmat_get_extended_linear_cache_size(struct resource *backing_res,
+					       int nid,
+					       resource_size_t *cache_size)
+{
+	int index, rc;
+	struct cxl_mock_ops *ops = get_cxl_mock_ops(&index);
+
+	if (ops)
+		rc = ops->hmat_get_extended_linear_cache_size(backing_res, nid,
+							      cache_size);
+	else
+		rc = hmat_get_extended_linear_cache_size(backing_res, nid,
+							 cache_size);
+
+	put_cxl_mock_ops(index);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(__wrap_hmat_get_extended_linear_cache_size);
+
 struct acpi_pci_root *__wrap_acpi_pci_find_root(acpi_handle handle)
 {
 	int index;
diff --git a/tools/testing/cxl/test/mock.h b/tools/testing/cxl/test/mock.h
index 4ed932e76aae8..bfd36cbdbae27 100644
--- a/tools/testing/cxl/test/mock.h
+++ b/tools/testing/cxl/test/mock.h
@@ -25,6 +25,9 @@ struct cxl_mock_ops {
 	void (*cxl_endpoint_parse_cdat)(struct cxl_port *port);
 	struct cxl_dport *(*devm_cxl_add_dport_by_dev)(struct cxl_port *port,
 						       struct device *dport_dev);
+	int (*hmat_get_extended_linear_cache_size)(struct resource *backing_res,
+						   int nid,
+						   resource_size_t *cache_size);
 };
 
 void register_cxl_mock_ops(struct cxl_mock_ops *ops);
-- 
2.53.0



