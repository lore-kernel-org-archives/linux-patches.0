Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023718;
	b=Kr8K/4H2GnAwA4Ist7+ei0/1nm5lA9zlYhRCZcJXq03z9BuK2Wvrwf9GFQ1WKI3f+ecC
	 RvL1AdlIFEGc6uirZ87+MmfCH5pHXDMVo4VAlGIiiJf36XBWmeP3BFLYQaQL9xuZS9jpz
	 Euj5PvnN5XU9hAZ28uoceOTZBb0HVFeqqOBU46gU98OBMzC3lWgmB2ekoWL2CtMgolDXq
	 2I36BPC1tIpQ5xUrIrL6mzdWwb6DTq5Ww79funYXl1Q9NLosyK4rEdvOoDS19ksoCLv5y
	 mMmUaVDCi7G/TKiUeBtI1g92vZexieOB4rJgZYR+JOpc3QnWZ5M4xojtTzob1nZMskw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j3qy9VTssUV57qCldIYbHoG5FoaasTe3Mv8DFsxHZ4w=;
	b=MKEzsntkjeS31aPBnEMvoZlr1vA3IggSlCEx0PdeVdxaqEXyp4pmNnWivGCEdiXm+RQ0
	 qogLYXF46oiAE4GoowwlhHG3uj67zqL7xRDITFJ/Ebc2pThP6BFHShGGorbtq5Rc378dl
	 Y3BLjhvQ5L9JzizI7Qh0ia9kNwSs/CQomZqofCzDFJQzNML1MW+lr5EEE3KXIb0KxZJ40
	 0GqNZ94Og2S6zAkYl3cUV3wIg76vW+Np3vm9/MasGDjICiaJ11ync3s7d/VvDtvm7eUbZ
	 5QClgI/TWOI5QaR+cU0zFA6qe1tuDtziYPcI0T7VJ4xpxQ3RFk6k2BzX5rKItNChh0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIokReFz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1B0606A32C;
	Wed, 18 Nov 2026 17:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIokReFz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF24E1F000C4;
	Wed, 18 Nov 2026 17:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023718;
	bh=j3qy9VTssUV57qCldIYbHoG5FoaasTe3Mv8DFsxHZ4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIokReFzTozsImRjt2EdlukRBdfRBuCsaLEl+nGdnBYdgdGyHlFQDRxMZJWKa8FW/
	 h2ofrE/ejLTD82tQCBG2D3J73O16qT8yaAuY6UYKIfP+67437qe813+HXIeYPeUylb
	 yR7jxz0/w/h2vRgVKarwqao/+4eVp0TBoHvMcbe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Richard Cheng <icheng@nvidia.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0467/2151] cxl/hdm: Reject switch decoder interleave ways that overflow targets
Date: Wed, 18 Nov 2026 15:36:42 +0100
Message-ID: <20261118150139.025168835@linuxfoundation.org>
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

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 3696326ca14cf018788d64232a068fdf26b1ff31 ]

Switch decoder enumeration validates that the interleave ways encoding
is legal, but not that the resulting number of ways fits the available
targets. This can overrun the target array (target_list.target_id[])
during enumeration of 12 or 16 way interleaves.

Bound the target count where it is established rather than at each use.
Reject an HDM capability whose reported target count is zero or exceeds
the target list register capacity, and reject a zero target switch
decoder allocation in cxl_switch_decoder_init(). Enumeration is then
left with a single check: reject a decoder whose interleave ways exceed
the targets it has.

Add a clarifying comment that target_count is a direct count, not
0-based like decoder_count.

Link: https://sashiko.dev/#/patchset/20260711180755.1779002-1-alison.schofield@intel.com?part=1
Fixes: d17d0540a0db ("cxl/core/hdm: Add CXL standard decoder enumeration to the core")
Tested-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Link: https://patch.msgid.link/af094094813d7f51d86cbf608936270b7d85526e.1786143520.git.alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/hdm.c  | 24 ++++++++++++++++++++++++
 drivers/cxl/core/port.c |  2 +-
 drivers/cxl/cxl.h       |  2 ++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 4d5113b5e6316..f49e3139c8281 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -76,6 +76,8 @@ static void parse_hdm_decoder_caps(struct cxl_hdm *cxlhdm)
 
 	hdm_cap = readl(cxlhdm->regs.hdm_decoder + CXL_HDM_DECODER_CAP_OFFSET);
 	cxlhdm->decoder_count = cxl_hdm_decoder_count(hdm_cap);
+
+	/* target_count is a direct count (1h..8h), not 0-based like decoder_count */
 	cxlhdm->target_count =
 		FIELD_GET(CXL_HDM_DECODER_TARGET_COUNT_MASK, hdm_cap);
 	if (FIELD_GET(CXL_HDM_DECODER_INTERLEAVE_11_8, hdm_cap))
@@ -1081,6 +1083,16 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 		cxld->interleave_ways, cxld->interleave_granularity);
 
 	if (!cxled) {
+		struct cxl_switch_decoder *cxlsd = to_cxl_switch_decoder(&cxld->dev);
+
+		if (cxld->interleave_ways > cxlsd->nr_targets) {
+			dev_err(&port->dev,
+				"decoder%d.%d: interleave ways: %d exceeds targets: %d\n",
+				port->id, cxld->id, cxld->interleave_ways,
+				cxlsd->nr_targets);
+			return -ENXIO;
+		}
+
 		lo = readl(hdm + CXL_HDM_DECODER0_TL_LOW(which));
 		hi = readl(hdm + CXL_HDM_DECODER0_TL_HIGH(which));
 		target_list.value = (hi << 32) + lo;
@@ -1158,6 +1170,18 @@ static int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 	int i;
 	u64 dpa_base = 0;
 
+	/*
+	 * Per CXL 4.0 8.2.4.20.1 Target Count is the number of target ports
+	 * per decoder, max 8. Endpoint decoders have no targets.
+	 */
+	if (!is_cxl_endpoint(port) &&
+	    (cxlhdm->target_count < 1 ||
+	     cxlhdm->target_count > CXL_HDM_DECODER0_TL_TARGETS)) {
+		dev_err(&port->dev, "Invalid decoder target count: %u\n",
+			cxlhdm->target_count);
+		return -ENXIO;
+	}
+
 	cxl_settle_decoders(cxlhdm);
 
 	for (i = 0; i < cxlhdm->decoder_count; i++) {
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 01655eeb43a8f..67dfebe123ca4 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1983,7 +1983,7 @@ static int cxl_switch_decoder_init(struct cxl_port *port,
 				   struct cxl_switch_decoder *cxlsd,
 				   int nr_targets)
 {
-	if (nr_targets > CXL_DECODER_MAX_INTERLEAVE)
+	if (nr_targets < 1 || nr_targets > CXL_DECODER_MAX_INTERLEAVE)
 		return -EINVAL;
 
 	cxlsd->nr_targets = nr_targets;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index b7933a892af72..561359c2d7dc0 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -66,6 +66,8 @@ extern const struct nvdimm_security_ops *cxl_security_ops;
 #define   CXL_HDM_DECODER0_CTRL_HOSTONLY BIT(12)
 #define CXL_HDM_DECODER0_TL_LOW(i) (0x20 * (i) + 0x24)
 #define CXL_HDM_DECODER0_TL_HIGH(i) (0x20 * (i) + 0x28)
+/* Target list capacity, i.e. max interleave ways for a non-endpoint decoder */
+#define CXL_HDM_DECODER0_TL_TARGETS 8
 #define CXL_HDM_DECODER0_SKIP_LOW(i) CXL_HDM_DECODER0_TL_LOW(i)
 #define CXL_HDM_DECODER0_SKIP_HIGH(i) CXL_HDM_DECODER0_TL_HIGH(i)
 
-- 
2.53.0



