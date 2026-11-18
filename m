Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023868;
	b=bJFVmo9lWwp5HKEFKhVKJ3xkZHOrALOAuN9H3zhDnRyFH6xXaUtqMmWs948F5O4ph/1W
	 l42Dn2XYSfTP/cbKC4TPEYnqBp18kOvvWHdq5dEcS3WCt3aHaHJYMzH4oQqe50A8myYLx
	 ylHpJ3T+wT8wZWzQGDy80AT7bhbtIx7CBpVkXHW+VAiCnaL3HnOxNyvI7oEfhN2jS6uMI
	 ZmjjYc8ZYXgcUae9hYdmtBhyI4FowWk3gJviuXEYSuQ3vot45Q3mDgJbXTguuTt2jWBse
	 YF0KF6YG91pFf0WGV2uj6AGaK42xZ9EhbS9OArDkuza0Boosa3ShpLxkCVq4ZesNu9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LjJtyh9LA5kkdJI2Eo0/ihz4LtwyqF9im3Es3p5zTsE=;
	b=SBhw/88h/YPXj6XlQbkb2yyGAAlS68xg6hMNpJyJjY65FPv1ly4V+sf0AiuE034zu1li
	 1pFf1Nt46Hk+ILPTsVh8WNkdOsWOLST/1ScsTd7EbRGjKomuguUTnb0RmtvHreLVf9PGk
	 c5pjdhd/ugvYRxQA89uMWOADz8H5FJf+2DqKp7ED0NhSw32Si53cpJyLQgl/2x7LdqZ24
	 npaH9dt4xxs8vewzydQs1wGLhs3uFp4RrogoZqwP7olKIh5wRFO2MtEYFN2jxfgUuHCZw
	 3rhXEVyUuwC9FMEP5G7vEmTj0s/E50x8yqV4ktaVHN7hNkEMKlxziM2Lvo0QnAaykoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vERyj2VY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CAA606A332;
	Wed, 18 Nov 2026 17:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vERyj2VY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894E51F000C6;
	Wed, 18 Nov 2026 17:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023868;
	bh=LjJtyh9LA5kkdJI2Eo0/ihz4LtwyqF9im3Es3p5zTsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vERyj2VYSIGpGvDPl91mYRzr5xSzmGjj2SSMlIh9tj6cogGpiWy63aE5bZQcpqnJ5
	 YsoF3ij5IZGbxxZbkg5p5b8Smy6OWNkHTdLPKljKHVJkMhU1reJT2kArFj7fKyQqw/
	 a49VrfpC+9+eYNXs0FhZKK3BcIqykOMSY+wUVCvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Terry Bowman <terry.bowman@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0515/2151] cxl/port: Move decoder setup before dport creation
Date: Wed, 18 Nov 2026 15:37:30 +0100
Message-ID: <20261118150140.813180010@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 86e756715db22cd79a9726c22644415c46b6b149 ]

There are port setup actions that run on first dport arrival, and there are
setup actions that run per dport.

RAS register setup is a future additional setup action to run per-port
(once the first dport arrives), and each dport also has RAS registers to
map.

Before adding that, flip the order of "first dport" and "per-dport"
actions. This makes allocation symmetric with teardown, "first dport"
actions unwind after last dport removed. It also allows for using a devres
group to collect the unrelated decoder, RAS, and dport setup actions into
one group release action.

The new cxl_port_open_group() collects "first dport" and "per-dport" into
one group that can be released on any failure. This group's lifetime only
needs to span the short duration of cxl_port_add_dport() to cleanup all
potential damage from failing to add a dport. Contrast that to the "dport"
devres group that is called upon to destruct fully formed dport objects.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Tested-by: Terry Bowman <terry.bowman@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20260131000403.2135324-5-dan.j.williams@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 0de71a1ab211 ("cxl/core: Fix dport use-after-free via the einj_inject debugfs file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index c7b46eeedb093..441c49bb8e595 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1697,10 +1697,14 @@ static bool dport_exists(struct cxl_port *port, struct device *dport_dev)
 	return false;
 }
 
-DEFINE_FREE(del_cxl_dport, struct cxl_dport *, if (!IS_ERR_OR_NULL(_T)) del_dport(_T))
+/* note this implicitly casts the group back to its @port */
+DEFINE_FREE(cxl_port_release_dr_group, struct cxl_port *,
+	    if (_T) devres_release_group(&_T->dev, _T))
+
 static struct cxl_dport *cxl_port_add_dport(struct cxl_port *port,
 					    struct device *dport_dev)
 {
+	struct cxl_dport *dport;
 	int rc;
 
 	device_lock_assert(&port->dev);
@@ -1710,14 +1714,13 @@ static struct cxl_dport *cxl_port_add_dport(struct cxl_port *port,
 	if (dport_exists(port, dport_dev))
 		return ERR_PTR(-EBUSY);
 
-	struct cxl_dport *dport __free(del_cxl_dport) =
-		devm_cxl_add_dport_by_dev(port, dport_dev);
-	if (IS_ERR(dport))
-		return dport;
-
-	cxl_switch_parse_cdat(dport);
+	/* Temp group for all "first dport" and "per dport" setup actions */
+	void *port_dr_group __free(cxl_port_release_dr_group) =
+		devres_open_group(&port->dev, port, GFP_KERNEL);
+	if (!port_dr_group)
+		return ERR_PTR(-ENOMEM);
 
-	if (port->nr_dports == 1) {
+	if (port->nr_dports == 0) {
 		/*
 		 * Some host bridges are known to not have component regsisters
 		 * available until a root port has trained CXL. Perform that
@@ -1730,18 +1733,24 @@ static struct cxl_dport *cxl_port_add_dport(struct cxl_port *port,
 		rc = devm_cxl_switch_port_decoders_setup(port);
 		if (rc)
 			return ERR_PTR(rc);
-		dev_dbg(&port->dev, "first dport%d:%s added with decoders\n",
-			dport->port_id, dev_name(dport_dev));
-		return no_free_ptr(dport);
 	}
 
+	dport = devm_cxl_add_dport_by_dev(port, dport_dev);
+	if (IS_ERR(dport))
+		return dport;
+
+	/* This group was only needed for early exit above */
+	devres_remove_group(&port->dev, no_free_ptr(port_dr_group));
+
+	cxl_switch_parse_cdat(dport);
+
 	/* New dport added, update the decoder targets */
 	device_for_each_child(&port->dev, dport, update_decoder_targets);
 
 	dev_dbg(&port->dev, "dport%d:%s added\n", dport->port_id,
 		dev_name(dport_dev));
 
-	return no_free_ptr(dport);
+	return dport;
 }
 
 static struct cxl_dport *devm_cxl_create_port(struct device *ep_dev,
-- 
2.53.0



