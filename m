Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039932;
	b=GfIwts7YjHBU7+xh8l3QwPF4u5ij8NOHjeTdPsqupefyEQs9q6TIZOOFYihhMccJX2he
	 +p5WEIf5+3UYUMYhAbEsbCEPcHtn0hAl3OvGKKkymtZHjZ5lpXK58Q+7Z65grzd1xTej8
	 1MIosJMXXvK9HLTgcV4VcDVPLPDC5lYGimuTvZ5W7ITp1ww7+zTkcViW8r1MfUvPIQmxM
	 M+TbZ9DST2yfmFJ+u9l7dn1mF+vQjpYxWY0ReAghmCs2sX9RcxkByliAZj+2vxjzV9d1F
	 D18eyCz4zO/raSWQjmOpBRDzDXKCEVB9pLnS+B8bo/qKLf5xxQZdIFMQG/heJz5BeRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oTu+9TKfwYNMHvgXMBvUs7pErTguz21bb8odPFP1dtY=;
	b=ijw4tsb0RgwdYcL9g5d/EG5w9ySkIfy5vCAq2Ir37tl2hDrN5l7UU68hR7cND+CD6L0C
	 LhWmWhhYUyJklGDVfJQ74zQq0Lzz/1No+rPqyRRb6Qs0Wdm3uaVsfx0JXWvIdHeIYl+z7
	 G5WQEZXysQ0ND3O7dkyG6bVnOkRE91kPnmI8jIC71g5LtOvcf3y6D7aaAbE1jP7ujzNm8
	 z291j63WUXe4/h8wlgCZznUw1TWwTut/qFFH5YyddzrUBfaF7HQ6TVYQWY+SirZZaSmKH
	 394eUKm/6ynDA0YKHO7fGC+EGt9cYqeOEfLLNcbfoVq6gY60u2G6Vu6jEtumelQ7hDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TA4fSw9+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526D2606A31C;
	Wed, 18 Nov 2026 22:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TA4fSw9+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAB91F000C4;
	Wed, 18 Nov 2026 22:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039932;
	bh=oTu+9TKfwYNMHvgXMBvUs7pErTguz21bb8odPFP1dtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TA4fSw9+8sS69kW+PcssfMAfJxwz3zevVPNfTuOtvnLkWJZFsubpt+qacdS+vXkuo
	 OXnihNrjJ0yNnl7Bee9J1Wo+VZiNbmx5//ZZO0wraOHKZA+5XmqI9LQAdEY5Z6GuZt
	 Jsp5iej5vUUpAOTau3Tr9e/wufsSR0xSepIimOm0=
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
Subject: [PATCH 6.6 2235/3318] cxl/hdm: Reject switch decoder interleave ways that overflow targets
Date: Wed, 18 Nov 2026 15:47:37 +0100
Message-ID: <20261118150428.915121469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dc4dff7a2d38d..493c024eafc1a 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -81,6 +81,8 @@ static void parse_hdm_decoder_caps(struct cxl_hdm *cxlhdm)
 
 	hdm_cap = readl(cxlhdm->regs.hdm_decoder + CXL_HDM_DECODER_CAP_OFFSET);
 	cxlhdm->decoder_count = cxl_hdm_decoder_count(hdm_cap);
+
+	/* target_count is a direct count (1h..8h), not 0-based like decoder_count */
 	cxlhdm->target_count =
 		FIELD_GET(CXL_HDM_DECODER_TARGET_COUNT_MASK, hdm_cap);
 	if (FIELD_GET(CXL_HDM_DECODER_INTERLEAVE_11_8, hdm_cap))
@@ -945,6 +947,16 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
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
@@ -1022,6 +1034,18 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
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
index 2589354b0ca44..6bc3dd4dcd8a8 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1666,7 +1666,7 @@ static int cxl_switch_decoder_init(struct cxl_port *port,
 				   struct cxl_switch_decoder *cxlsd,
 				   int nr_targets)
 {
-	if (nr_targets > CXL_DECODER_MAX_INTERLEAVE)
+	if (nr_targets < 1 || nr_targets > CXL_DECODER_MAX_INTERLEAVE)
 		return -EINVAL;
 
 	cxlsd->nr_targets = nr_targets;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 7a1b1721860d7..f67a2e0346804 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -61,6 +61,8 @@
 #define   CXL_HDM_DECODER0_CTRL_HOSTONLY BIT(12)
 #define CXL_HDM_DECODER0_TL_LOW(i) (0x20 * (i) + 0x24)
 #define CXL_HDM_DECODER0_TL_HIGH(i) (0x20 * (i) + 0x28)
+/* Target list capacity, i.e. max interleave ways for a non-endpoint decoder */
+#define CXL_HDM_DECODER0_TL_TARGETS 8
 #define CXL_HDM_DECODER0_SKIP_LOW(i) CXL_HDM_DECODER0_TL_LOW(i)
 #define CXL_HDM_DECODER0_SKIP_HIGH(i) CXL_HDM_DECODER0_TL_HIGH(i)
 
-- 
2.53.0



