Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028448;
	b=y5ZgQDzhwDNg10q4eaOJbP1XZwEHo2tv4IW3PEtUlyNAFC2WRUFAqNG+Q7DRWR/ufi9U
	 5dgO1XE87WmcOgy12lHCe2UvD3oAG9fbyKiLXgiieNJ7vqt9AEXi+XArNoL3jx9gu/AV1
	 xgRxqtttQT4eoGeYI0t/YDVYGN/eKi/i7KTdDJ7eDR/dO4W6qboPOIQPA9GeiTcFNhpGJ
	 9Ga156jYHNZj8PogD5jEoh25RG/1gi64To5Uarx3D2KZj/ilWLPnQT/F3VwRI42S6nomx
	 pJfkAnlYDnEF+pwrjnsOs3+pXmvYQFx24jlth7etKwWo9JSvVdwTT0NKLJenq/ZNOpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gj5PxAxr3793kaK0nfrAE0FIjnKZ/NR0uIaK2XQQ0sU=;
	b=L2ilGCnwkwf+UqpIIHvVSPQOiHAmBq47ZlIz1Ex6PbJGY2QxzJIpsI6vqnits9sniAd8
	 uf9vsGQhRpwXB/43VsnFt4iQw54Nw6IZHL565eT7OlUmKun5NqJw/dA6SRVRmXxMMuPHj
	 19DP8JKnPP6bsuCKeGlBGJtziYGsHkEDCbD6zihpNR+WZ4q/0Ph1VkHQF3d63QAag/d/T
	 d0eoupEg+NFlPd6GL37jYQbh/hNWPXb/nowaSJOrRUO8xQP4e5gRUhKYe8/vdBJ79Jk7k
	 rgWsD9XygfV1FyIgyCzMxuAPjCGioxH5c1SS8+cssg1Yy7l+MeZnKEIaUmKsJ3ZsAEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bl2zcNM0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81663606A330;
	Wed, 18 Nov 2026 19:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bl2zcNM0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2BD1F000C4;
	Wed, 18 Nov 2026 19:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028448;
	bh=gj5PxAxr3793kaK0nfrAE0FIjnKZ/NR0uIaK2XQQ0sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bl2zcNM01E3ghRa7/atG3WcFumQaccI9gMCf3E5MlCvJvceR0y1cJHKBlAJ27izbG
	 Q6t/2Ie2Qr4aVa99nSBJv+Xl3gc5W5LDSes8G+9znG+0ANMIgpAtPdW3AKXuUxTvWv
	 GZ00qL73ZAd+bvpncohz2rzmnfPQorFc0UV8GGd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 2149/2151] ACPI: extlog: Validate PCIe error section length before payload access
Date: Wed, 18 Nov 2026 16:04:44 +0100
Message-ID: <20261118150239.954095208@linuxfoundation.org>
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

commit 5eefd849e26506170552e614496d094230650e78 upstream.

extlog_print_pcie() reads pcie_err->validation_bits and device_id and
copies the 96-byte aer_info buffer without checking that
gdata->error_data_length is big enough for a struct cper_sec_pcie. The
cper_estatus_check() call added earlier keeps the read inside the estatus
block, but a short section still gets stale adjacent bytes treated as PCIe
error data.

Reject a section too small to hold the record before touching any field,
and warn: a truncated section means firmware is emitting malformed records.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-cxl/20260709165457.8BA181F000E9@smtp.kernel.org/
Fixes: e778ffefa34d ("ACPI: extlog: Trace CPER PCI Express Error Section")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-7-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_extlog.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -134,7 +134,7 @@ static int print_extlog_rcd(const char *
 }
 
 static void extlog_print_pcie(struct cper_sec_pcie *pcie_err,
-			      int severity)
+			      int severity, u32 len)
 {
 #ifdef ACPI_APEI_PCIEAER
 	struct aer_capability_regs aer_regs = {};
@@ -144,6 +144,12 @@ static void extlog_print_pcie(struct cpe
 	int aer_severity;
 	int domain;
 
+	if (len < sizeof(*pcie_err)) {
+		pr_warn_ratelimited(FW_WARN
+				    "PCIe error section too small (%u)\n", len);
+		return;
+	}
+
 	if (!(pcie_err->validation_bits & CPER_PCIE_VALID_DEVICE_ID &&
 	      pcie_err->validation_bits & CPER_PCIE_VALID_AER_INFO))
 		return;
@@ -247,7 +253,8 @@ static int extlog_print(struct notifier_
 		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err = acpi_hest_get_payload(gdata);
 
-			extlog_print_pcie(pcie_err, gdata->error_severity);
+			extlog_print_pcie(pcie_err, gdata->error_severity,
+					  gdata->error_data_length);
 		} else {
 			void *err = acpi_hest_get_payload(gdata);
 


