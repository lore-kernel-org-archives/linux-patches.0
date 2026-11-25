Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625098;
	b=Z91RpRlLoW0UKwcg33akHmhvp75MVrIhhaeGS+uzcRb20bb0yrJIPR5InC2bsqBnBDLD
	 SK3PvRJPb2C8OQr12l+zkfKuzInBrb61gXwB81tdVidktnstBjENzVVdcoHwLChQP89H0
	 xCNtmvt+hyBWTBYS7+5foHE4G4WHj3kdT1YLBZUbNoXMjRqSgHzYlc8+1FVZ7P0NAHAr7
	 CFh7pmm7+ClA7W+hJNrWtUBgWIB+cLkfdVvhtNN1VNDsYltIMT9di5VSCmaL+zUT56+X+
	 KpfGwmg9CWdtqrIZU/dNVWdpMhN1B9vlX1EmL/4dI4y6SpO6oeOmn86Uh2OxEsqAIvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2UWlazo5d4QJtaVRALEnwpPTQXPhnWSgJ+oOWaVwFzo=;
	b=SEkEH4dGXy/mCYflCL6ldNPMDyMGQ7XpzligPgSmGdCG7FZiHqRB8k8YJWxP0/l/1PBM
	 cx45eCFgbRjulD2fojWGWNVJGL+1SdySpz2U5+kiO5xgL2vR14S3OXbf7uIQzIg8uD5Z6
	 6lHw5yRgrNW0T7SyqTZTTswFhgUoNXXFO0D3Fbot+q+/iVnoQ9QAHNAgpbkl7oYpA/tyF
	 /JyEM59uhnZDAt3c1mMyWTooS2bgbyvSWPH4dmv74ey2AhmMb5RN01gn517SG+ya2PqFG
	 wjGQlSilh+aczmUWGBwqw4p+KalqARXBWDXcnpL7JXI1wRYWd5OCDigwgakCUL6X+Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDd12+dd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D05606A327;
	Wed, 25 Nov 2026 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDd12+dd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A3D1F000C6;
	Wed, 25 Nov 2026 16:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625098;
	bh=2UWlazo5d4QJtaVRALEnwpPTQXPhnWSgJ+oOWaVwFzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDd12+ddXvBKYolaVWacHS3bibmYYzyDJ1IK1KUSN6CVWQNTy8wdOY3egWEWluqkV
	 U7H85kLZ/Eb6oQ2q1KgjsHfR9P3s7i+zOvQak5yH1ziIql3JIv3dLu2lst6HSILvVr
	 fF3AQhLlktsppQquHlrhdcekUDkydv+3rQ3R/hSs=
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
Subject: [PATCH 6.12 405/816] cxl/hdm: Restore commit_end when decoder enumeration fails
Date: Wed, 25 Nov 2026 15:32:33 +0100
Message-ID: <20261125143858.570375660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced cxl_rwsem.region with the standalone cxl_region_rwsem lock in the two new write-guard sites, since the newer lock struct doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/hdm.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 24873dbb900c0..6fc4068d2566f 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -808,7 +808,8 @@ static int cxl_setup_hdm_decoder_from_dvsec(
 	 * change the range registers at run time.
 	 */
 	cxld->flags |= CXL_DECODER_F_ENABLE | CXL_DECODER_F_LOCK;
-	port->commit_end = cxld->id;
+	scoped_guard(rwsem_write, &cxl_region_rwsem)
+		port->commit_end = cxld->id;
 
 	rc = devm_cxl_dpa_reserve(cxled, *dpa_base, len, 0);
 	if (rc) {
@@ -1011,6 +1012,14 @@ static void cxl_settle_decoders(struct cxl_hdm *cxlhdm)
 		msleep(20);
 }
 
+static void cxl_reset_commit_end(void *data)
+{
+	struct cxl_port *port = data;
+
+	guard(rwsem_write)(&cxl_region_rwsem);
+	port->commit_end = -1;
+}
+
 /**
  * devm_cxl_enumerate_decoders - add decoder objects per HDM register set
  * @cxlhdm: Structure to populate with HDM capabilities
@@ -1021,8 +1030,8 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 {
 	void __iomem *hdm = cxlhdm->regs.hdm_decoder;
 	struct cxl_port *port = cxlhdm->port;
-	int i;
 	u64 dpa_base = 0;
+	int i, rc;
 
 	/*
 	 * Per CXL 4.0 8.2.4.20.1 Target Count is the number of target ports
@@ -1038,8 +1047,16 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 
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



