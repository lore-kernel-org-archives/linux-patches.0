Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625101;
	b=QryCwSGLh5/cmklQjIoZCVbzl2yF4Axm9APs7mpLFXQ7MEhfZZ/3wHJu7o+qB2k5K3Z1
	 WU2F3cQzDdYrL0EwHx8tdE2f4u8SBb2aesIcfrFa/PG+Lbk67iZhxkrEnJlJz50zMn4+m
	 2hLoSkulaK7TDPeexGkn5unbEOcgrg7COI4pQjyXMpKc+d+DDU0ON9VZNTAKR/kkYdlHC
	 1awu+oeZx3g43iWFYjUTioGTttGFpuz1G39ZKrSvzJlv6BvKsMoBqFEfhtZOykLxOwAZ4
	 2kYDaFYaftyLYEulpycY++BGjy9FGHPkKjWiBW26ngbciGqnfuxwJbLNMpf3073hF3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zJJGdThX63ug4ahn6PrMLurqmmDtOgSbCmeY0MYcT1Q=;
	b=FpwWOKmRVosFmUG3jTufxZrMkH63GVlc6YARXHJ9lFMlabtPhYyvHJgCwXShNePxKPdj
	 Idl13bXI4IPOMwGwRAjPRG00nMIMFp55FuMoBW18l6i/bzTQyogTKmjtuNIDm7/6yQdJo
	 +I0Et47MYdOATesfvv3SPeY6QEttvBLG6xp2gyZnlb2vRGc9P2fmD2OXNDS5M5drwo8oK
	 jlm3scDwvxj94RhIYon2cgaJDXna5tvVlkYEeM5YbD3ujpS/5Xf/k+kQotK9Kj6eNbl4q
	 E1nAYUthgLORAmF4gdfdMyYi/7UOL6qCwOPONSsvrZFy2Ou28pHvEDGmebS6KTrdJHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CotLl1i2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D128D606A330;
	Wed, 25 Nov 2026 16:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CotLl1i2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B7D1F000C6;
	Wed, 25 Nov 2026 16:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625101;
	bh=zJJGdThX63ug4ahn6PrMLurqmmDtOgSbCmeY0MYcT1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CotLl1i28H2UozbqZs8Q7drw3UZJFyF/YLmqV5da8rknzlUew+ymsmeKtDQN4VS0G
	 FaenXOj+bbvUNZy9PeldFArCMWFNhmVe9PqXitRj4NKZCXHxCQShpCC9QE/UGdCuhi
	 sLzHwGBNvBbZMvmb/mffyRUM8GCw/SJcgiowkSrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Li Ming <ming.li@zohomail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 406/816] cxl/port: Bound switch decoder target array access by nr_targets
Date: Wed, 25 Nov 2026 15:32:34 +0100
Message-ID: <20261125143858.593675229@linuxfoundation.org>
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
[ sashal: Dropped the update_decoder_targets() hunk since that function doesn't exist here, and used cxl_region_rwsem in place of cxl_rwsem.region for the locking context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index e78f8ebe50e81..56a4f0e14b33f 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -144,20 +144,29 @@ static ssize_t target_type_show(struct device *dev,
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
@@ -1718,7 +1727,7 @@ static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
 				    struct cxl_port *port)
 {
 	struct cxl_decoder *cxld = &cxlsd->cxld;
-	int i;
+	int i, nr_used;
 
 	device_lock_assert(&port->dev);
 
@@ -1726,7 +1735,8 @@ static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
 		return -EINVAL;
 
 	guard(rwsem_write)(&cxl_region_rwsem);
-	for (i = 0; i < cxlsd->cxld.interleave_ways; i++) {
+	nr_used = cxlsd_nr_used_targets(cxlsd);
+	for (i = 0; i < nr_used; i++) {
 		struct cxl_dport *dport = find_dport(port, cxld->target_map[i]);
 
 		if (!dport)
-- 
2.53.0



