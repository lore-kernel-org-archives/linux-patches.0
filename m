Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016362;
	b=x8XFLl4VZqx58b7EMWdO2eZ471kDyrqC4akST/EB/qdaJJUKiJstoMrDz8Op+Efw2rdy
	 5uTYFrOwTSdttnSv+tMeKtDgEfW5w36Ysicm8MwS6jONdZRY0SpbSavislnT4wR3n+XUI
	 D3d6mWzcOH793kjcj/UfRkh0ZHIg5XAGNEx8728E7qD4P54AsQYMWkmk9oQogz+WWExGX
	 LHklJryJAawzpgQK6iNP869dY5eiDH7Txt1+HIZ0jWHq1PZqlHnai9XY4lAH1I9tBfx/k
	 jsJZ09XfDj/AIfrr+zSqKppE565+S54J54serw9ovhBY3QWDUx5ex5IspvbiiNbMMnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KeK1GmnfzW4jGhN7gwcrnzawjEMbsURrOyPkNZnVyt0=;
	b=sHWY5fZGM+K6LL7E4bjUKvW9M+DrZpT0NcRkZ4grL11/Z3CiyHZMJnaEj6Hxx4A22EYi
	 lp2DnredlUIJIBN2eyp8Yu+YPwS3PLr7oSRutwcyTlGRJsALL6/KfqBrBwhNUY8HQucuB
	 aky1s4sTrY3AqlKFlvenylwtBqyGM9V/lJpywNDXZPZXvDVeOOv91cwqdBQ3dF8THlPZT
	 p2f2AiFrww/bdlfwfrbWJclnwwHovzd1YGQOZWKN+CPUDCxXI+0FmOuDWg7SyXB2DIQaM
	 EWvX7DE9tSDQirEN14M99zsInDfUQwz4mBMUvKsoRptX+6fl8WlqHciv4+kUgscGwWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pVm7YEB9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB7A606A32A;
	Wed, 18 Nov 2026 15:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pVm7YEB9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6D71F000C4;
	Wed, 18 Nov 2026 15:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016362;
	bh=KeK1GmnfzW4jGhN7gwcrnzawjEMbsURrOyPkNZnVyt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pVm7YEB9QbmPJUTZm4MLMciBtw9iroExBwAS6zNcW+0uA1xVZvstqYxPGStm/1C5U
	 mQtePeAcuf81r07Wqd4zpGopd3pX0QpFgaZnu2UcOcVydoI0NepvD/5/TUa65gh670
	 Plc6XqlQ0Ff8Ezam/c1pEkdBQn4xzdpZsdfaAamY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Richard Cheng <icheng@nvidia.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0501/2651] cxl/hdm: Restore commit_end when decoder enumeration fails
Date: Wed, 18 Nov 2026 15:29:01 +0100
Message-ID: <20261118150305.802621704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 7dae18c39e99813461db6ef3fc13f077452109ce ]

commit_end tracks the highest committed decoder on a port. It gets
advanced before decoder enumeration is complete, so a later failure
leaves it pointing at a decoder that was never added. The next probe
then rejects decoder0 as out of order and enumeration fails.

Reset commit_end to the uncommitted baseline once the decoders are
torn down, so a subsequent probe rebuilds it from scratch. Register
the reset before the decoders are added so that on unwind it runs
after every decoder has been unregistered. This prevents commit_end
from dropping below the highest committed decoder still registered and
exposing an inconsistent value to a concurrent reader.

Protect the commit_end advance in the DVSEC emulation path against
concurrent readers, matching the register-programmed path.

Fixes: 176baefb2eb5 ("cxl/hdm: Commit decoder state to hardware")
Fixes: b777e9bec960 ("cxl/hdm: Emulate HDM decoder from DVSEC range registers")
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/4802c5abc906b858a4754bfc4fa3e4c2c455d0c3.1786143520.git.alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/hdm.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index fc22d515b6389..cb24901dd289d 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -956,7 +956,8 @@ static int cxl_setup_hdm_decoder_from_dvsec(
 	 * change the range registers at run time.
 	 */
 	cxld->flags |= CXL_DECODER_F_ENABLE | CXL_DECODER_F_LOCK;
-	port->commit_end = cxld->id;
+	scoped_guard(rwsem_write, &cxl_rwsem.region)
+		port->commit_end = cxld->id;
 
 	rc = devm_cxl_dpa_reserve(cxled, *dpa_base, len, 0);
 	if (rc) {
@@ -1159,6 +1160,14 @@ static void cxl_settle_decoders(struct cxl_hdm *cxlhdm)
 		msleep(20);
 }
 
+static void cxl_reset_commit_end(void *data)
+{
+	struct cxl_port *port = data;
+
+	guard(rwsem_write)(&cxl_rwsem.region);
+	port->commit_end = -1;
+}
+
 /**
  * devm_cxl_enumerate_decoders - add decoder objects per HDM register set
  * @cxlhdm: Structure to populate with HDM capabilities
@@ -1169,8 +1178,8 @@ static int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 {
 	void __iomem *hdm = cxlhdm->regs.hdm_decoder;
 	struct cxl_port *port = cxlhdm->port;
-	int i;
 	u64 dpa_base = 0;
+	int i, rc;
 
 	/*
 	 * Per CXL 4.0 8.2.4.20.1 Target Count is the number of target ports
@@ -1186,8 +1195,16 @@ static int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 
 	cxl_settle_decoders(cxlhdm);
 
+	/*
+	 * Reset commit_end after all decoders have been torn down so a
+	 * subsequent probe rebuilds it from scratch.
+	 */
+	rc = devm_add_action(&port->dev, cxl_reset_commit_end, port);
+	if (rc)
+		return rc;
+
 	for (i = 0; i < cxlhdm->decoder_count; i++) {
-		int rc, target_count = cxlhdm->target_count;
+		int target_count = cxlhdm->target_count;
 		struct cxl_decoder *cxld;
 
 		if (is_cxl_endpoint(port)) {
-- 
2.53.0



