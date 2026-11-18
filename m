Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016365;
	b=beeWWkLPgXjlfXa/KgLRvWCiHTDwiYw5Nl5PCs9yneoqgHuGjxhx9W7H9rr4R6lbcghZ
	 rZUHfvl85C0RD+yRjdjwPyMZCxV7q4scUvjg38WD4dWxdRug4qtzUgdz7C/QG2GUpDEqH
	 TLIKUco2aXiEpwIoUno6UuHfSvjWdfK3lhPFiGiYiHcFkqm0YhXAxCFJNvunYHcg6wOD+
	 EDx3J5+FCpNlk41wr6Bz/iSeiqVtAMnAZ8b6ntuF7eP7lpWlorPkoVSSUoubx3zWt+p1M
	 CHcD1eaC4J+EhfyJYiXZk0Sof2dlrL+H1s05O3fAwfloqxJ7Q66Hz+lsCHptAKz/a3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=edH7oF3N9F72WrQRSIrG2/CO2T+T05x5/TZQFbHny2g=;
	b=QCsfH5nBJCAYugNqykITZll++qS90jCGJPID2fkpxvr+WenxXh3JEze6cYaeYHiNfjXf
	 2vLMQtsJoeYzO6L4FsVa+74x47BOOIt9LwjeTb84ElR8Bbd5xzSt3Q2CbEY6W5Pai5CKt
	 QLqUVjU6veOchi0JCRyVytWOOyv1RCN55ZIfX4+H4V/ciXkbIC8CjYEBEFKp24z2DmYJy
	 XFQ9Abaad5/LVTGaDNCtUcrsgzgxZnl3HDLU/KhZgXEV5LGsh/W0xKkuHmqj1UKidLp4X
	 UDQs5vu0iev2TvwaFxmYC7l432aCtj1iDgfB+OpTrsFwdv8TwJzUnBmyG9blkNc0Vtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhJNnafw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F84C60A2602;
	Wed, 18 Nov 2026 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhJNnafw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A425B1F000C4;
	Wed, 18 Nov 2026 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016365;
	bh=edH7oF3N9F72WrQRSIrG2/CO2T+T05x5/TZQFbHny2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhJNnafw27CwEiHfKmWLnpxZGxHZX4yEJ+R31WXpnGw2dK1DDV1hqRNf3gMZTY/k7
	 HQkITNQ/fJwh3lxZUH1SD4YS67LbrppZGMzSiIaq6J9C/jEam/ZAfR6qdS9L14iXqx
	 wOrP+vXEAt02ZNAEKxNC/+ottNmiw5YJe84i2DzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0502/2651] cxl/port: Bound switch decoder target array access by nr_targets
Date: Wed, 18 Nov 2026 15:29:02 +0100
Message-ID: <20261118150305.837844816@linuxfoundation.org>
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

[ Upstream commit 4e42c398af136d62fac8c19c9f410ec83a8dd34a ]

Switch decoder target lookups walk the target array using interleave
ways as the bound. The array is allocated with nr_targets entries, so a
decoder whose interleave ways exceeds nr_targets reads and writes past
the end of it. That happens during dport activation, during decoder
target population, and when userspace reads the target_list attribute.

Bounding by nr_targets alone is not correct either. Commit d6488fee6647
("cxl/port: Fix decoder initialization when nr_targets > interleave_ways")
moved target population to interleave ways precisely so that targets a
decoder does not use are left unpopulated. Neither field alone is a safe
bound, so add a helper that returns the minimum of the two and use it at
every walk of the target array.

Valid configurations keep interleave ways within nr_targets, so this is
not a behavior change for them.

Fixes: 40ba17afdfab ("cxl/acpi: Introduce cxl_decoder objects")
Fixes: d6488fee6647 ("cxl/port: Fix decoder initialization when nr_targets > interleave_ways")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Link: https://patch.msgid.link/d7577652cc6d414e1de0ee4045d4d6b2808172ce.1786143520.git.alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 25ef2c3e9f5d4..fa1a290a8c1d0 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -148,20 +148,29 @@ static ssize_t target_type_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(target_type);
 
+/*
+ * Interleave ways selects how many targets a decoder uses, but the target
+ * array is only nr_targets long. Bound array access by both.
+ */
+static int cxlsd_nr_used_targets(struct cxl_switch_decoder *cxlsd)
+{
+	return min(cxlsd->cxld.interleave_ways, cxlsd->nr_targets);
+}
+
 static ssize_t emit_target_list(struct cxl_switch_decoder *cxlsd, char *buf)
 {
-	struct cxl_decoder *cxld = &cxlsd->cxld;
+	int nr_used = cxlsd_nr_used_targets(cxlsd);
 	ssize_t offset = 0;
 	int i, rc = 0;
 
-	for (i = 0; i < cxld->interleave_ways; i++) {
+	for (i = 0; i < nr_used; i++) {
 		struct cxl_dport *dport = cxlsd->target[i];
 		struct cxl_dport *next = NULL;
 
 		if (!dport)
 			break;
 
-		if (i + 1 < cxld->interleave_ways)
+		if (i + 1 < nr_used)
 			next = cxlsd->target[i + 1];
 		rc = sysfs_emit_at(buf, offset, "%d%s", dport->port_id,
 				   next ? "," : "");
@@ -1640,7 +1649,7 @@ static int update_decoder_targets(struct device *dev, void *data)
 	struct cxl_dport *dport = data;
 	struct cxl_switch_decoder *cxlsd;
 	struct cxl_decoder *cxld;
-	int i;
+	int i, nr_used;
 
 	if (!is_switch_decoder(dev))
 		return 0;
@@ -1648,8 +1657,9 @@ static int update_decoder_targets(struct device *dev, void *data)
 	cxlsd = to_cxl_switch_decoder(dev);
 	cxld = &cxlsd->cxld;
 	guard(rwsem_write)(&cxl_rwsem.region);
+	nr_used = cxlsd_nr_used_targets(cxlsd);
 
-	for (i = 0; i < cxld->interleave_ways; i++) {
+	for (i = 0; i < nr_used; i++) {
 		if (cxld->target_map[i] == dport->port_id) {
 			cxlsd->target[i] = dport;
 			dev_dbg(dev, "dport%d found in target list, index %d\n",
@@ -1947,7 +1957,7 @@ static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
 				    struct cxl_port *port)
 {
 	struct cxl_decoder *cxld = &cxlsd->cxld;
-	int i;
+	int i, nr_used;
 
 	device_lock_assert(&port->dev);
 
@@ -1955,7 +1965,8 @@ static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
 		return 0;
 
 	guard(rwsem_write)(&cxl_rwsem.region);
-	for (i = 0; i < cxlsd->cxld.interleave_ways; i++) {
+	nr_used = cxlsd_nr_used_targets(cxlsd);
+	for (i = 0; i < nr_used; i++) {
 		struct cxl_dport *dport = find_dport(port, cxld->target_map[i]);
 
 		if (!dport) {
-- 
2.53.0



