Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023724;
	b=YQlIEY5qHYY2M2RI4pAK8y5LHFJKfDHl9VQ7i++D+kGy8Xt2qp6s7Sa63qLEESZK76Hb
	 5P8d2glLDueRMZSoveEqXa4BoLLzROtRzY896SKQr1lThvPdzUVP4n+P3vT+/1mZQC70l
	 E3hvPgJqD8rf8SkVVixD5hGs9nKwfokhTr4J7uXg059Qgu9aX1LyLP40lbYu97Br7iP0U
	 zAQNO5KCAcAgAxzLkwkBsBl+d+I1xgGmSbrEvBA4QkBfPrDfI9dgYCcFihezRVmO7ePQe
	 CSxVGwbYNGIXOL9pZCzVQJ5OG4uq4Z8ELgJFp/mP4JqBhrNthra8S32qvJ3rI5J33lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=owWfpOHQBEW0KAzuqDSCYN42FINU8fqafMJlbN3ftwE=;
	b=XaNd7SDQPYHILPDP7t4Yl8Mu2lpu/a+01cdSz9FSHi+gQO2h9nJFGgFDpkfTvwQbHesi
	 8XrpFhT0TS4GBqAf9+Jkj0xdhOHapFrpJnH7UzOE9pVEMmYY/RBK76B7Ua6kY9P65vRy5
	 EXiZDPJlrIAdrLGgub1ILRIiphrv25/9gejnaoHsK7xXflGivo0Shp5XQs3qpPm5tpwlU
	 KqexDDyCsTi09cVxKa6yi0omlBorflKSRPtJV+WQ4+rbgIxWnhlwxS52AxuTOIE9L1cSK
	 sUi125PQcsbY3LuCEBv4LG1+Kaj85132T48rYvnLqX7zd8CdI7bs0FBmfJl7Ex9NE3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=km1IKuGm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3EA606A31C;
	Wed, 18 Nov 2026 17:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=km1IKuGm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DED1F000C4;
	Wed, 18 Nov 2026 17:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023723;
	bh=owWfpOHQBEW0KAzuqDSCYN42FINU8fqafMJlbN3ftwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=km1IKuGmfuCKDDd84Jm6nprhHkV7YAzGhubgQzH5bBXJBn4Eas2LAkvx6rBWIZj6o
	 ZUgAGg8+DIOdhwN11IuD/1qAcqeFOt7aGD2+qd0erKKNFN/NVZyRsgNtI6TM66ahsd
	 3+9HpgGmYQQi3nvpsxgchBbZJenBRfQJWpgi1XY0=
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
Subject: [PATCH 6.18 0469/2151] cxl/hdm: Restore commit_end when decoder enumeration fails
Date: Wed, 18 Nov 2026 15:36:44 +0100
Message-ID: <20261118150139.096179972@linuxfoundation.org>
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
index 16cf4f116a97b..c43b14533ffe0 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -953,7 +953,8 @@ static int cxl_setup_hdm_decoder_from_dvsec(
 	 * change the range registers at run time.
 	 */
 	cxld->flags |= CXL_DECODER_F_ENABLE | CXL_DECODER_F_LOCK;
-	port->commit_end = cxld->id;
+	scoped_guard(rwsem_write, &cxl_rwsem.region)
+		port->commit_end = cxld->id;
 
 	rc = devm_cxl_dpa_reserve(cxled, *dpa_base, len, 0);
 	if (rc) {
@@ -1156,6 +1157,14 @@ static void cxl_settle_decoders(struct cxl_hdm *cxlhdm)
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
@@ -1166,8 +1175,8 @@ static int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 {
 	void __iomem *hdm = cxlhdm->regs.hdm_decoder;
 	struct cxl_port *port = cxlhdm->port;
-	int i;
 	u64 dpa_base = 0;
+	int i, rc;
 
 	/*
 	 * Per CXL 4.0 8.2.4.20.1 Target Count is the number of target ports
@@ -1183,8 +1192,16 @@ static int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 
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



