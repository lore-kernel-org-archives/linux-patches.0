Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023846;
	b=T4XtCnEwwE5133qErsqQIcdj+Io2aR++wZj0W6iIqCxh1olu5vB6nZ4IYUx0EDZ0REaG
	 MLGdWVRVh1VCuz6NY2/oUEO4k8Iin6w1lH53GfnTKDVGHRDyT505605fk1DvCQ/iKzVhH
	 WoWrEtxIv2Kdh7LyEkatUjqrFEZJXkiMDV8CyaeEvXxcFZT9A+fwJ+LQcS/f4lFRCO1KW
	 rjaA9SJRioXcv11BKVgJlDnauwnvBCvZClYHC+KRhssKOmyUJ2Bl9nc/pEY4i00Av14mn
	 /zZSOzQP0xehOFkxzhEo9hebUfpoZ0p29AkLGmPngn4N5eZc2zbaxMbeEux87N0FHWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fl6Y1OF5Ku3Yj/IwzNUhTQEVHqhy3TuuiIvyH7FiEok=;
	b=l0mgJ673YiwAbNwisgNVefBxKu/76W2P1Qm2Nn23WPDKDZ5hiqyIEik4b7K/rsFgHEnL
	 snay/8q3FUjJQWKKGY/0K+VKMD2RkM4UuXC0sTo4hgvQHnhixkFW5AJJHqE30gjTrEu3V
	 ZiE1/p+Ex0sqyGW+5a2ZgaozBpaWwoUCpbvitYDEaiAeCYAXKd+5Kp7afEK83pBjn191C
	 68mrbrkgIGAMM9JByT3i4U9r22xXXpYqtItD72vAJUOH5Rre1w8ypgauMk2NTHAn5mNGF
	 8JqEVYGiLqVm6dP9s4uiDub0CR+JhIU3+U7Z3T8QTZkUBPz2LGPBL4HISv4D+4NBPPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L7H9Qowi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7A1606A330;
	Wed, 18 Nov 2026 17:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L7H9Qowi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5711F000C6;
	Wed, 18 Nov 2026 17:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023846;
	bh=Fl6Y1OF5Ku3Yj/IwzNUhTQEVHqhy3TuuiIvyH7FiEok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7H9Qowipu0XmX52AJRAzKsFlyVt5W+VCkrNxcbkJVU1dwRlqNNIGOw6mJQMDEwtF
	 fReKYq1PoB9/rRtsq3fwekseDua31Zii6/ScAkd2js4fdtsiz6Ig3wjqCUS6wGasQY
	 loGy4Ka/h3VGGsUoOgSE6QhuDVdHgKjYzgHwdAdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Terry Bowman <terry.bowman@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0513/2151] cxl/port: Reduce number of @dport variables in cxl_port_add_dport()
Date: Wed, 18 Nov 2026 15:37:28 +0100
Message-ID: <20261118150140.747157977@linuxfoundation.org>
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

[ Upstream commit 83ccbaf1a1075ded82329d27de01d3b2681986ec ]

In preparation for refactoring cxl_port_add_dport() to add RAS register
setup, cleanup the number of dport variables with a dport_exists() helper.

Kill the @dport needed to check for duplicates, rename @new_dport to
@dport.

Reported-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Closes: http://lore.kernel.org/20260116150119.00003bbd@huawei.com
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Tested-by: Terry Bowman <terry.bowman@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20260131000403.2135324-3-dan.j.williams@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 0de71a1ab211 ("cxl/core: Fix dport use-after-free via the einj_inject debugfs file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 62c1ca6680881..9990a038d2360 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1633,30 +1633,38 @@ static int update_decoder_targets(struct device *dev, void *data)
 	return 0;
 }
 
+static bool dport_exists(struct cxl_port *port, struct device *dport_dev)
+{
+	struct cxl_dport *dport = cxl_find_dport_by_dev(port, dport_dev);
+
+	if (dport) {
+		dev_dbg(&port->dev, "dport%d:%s already exists\n",
+			dport->port_id, dev_name(dport_dev));
+		return true;
+	}
+
+	return false;
+}
+
 DEFINE_FREE(del_cxl_dport, struct cxl_dport *, if (!IS_ERR_OR_NULL(_T)) del_dport(_T))
 static struct cxl_dport *cxl_port_add_dport(struct cxl_port *port,
 					    struct device *dport_dev)
 {
-	struct cxl_dport *dport;
 	int rc;
 
 	device_lock_assert(&port->dev);
 	if (!port->dev.driver)
 		return ERR_PTR(-ENXIO);
 
-	dport = cxl_find_dport_by_dev(port, dport_dev);
-	if (dport) {
-		dev_dbg(&port->dev, "dport%d:%s already exists\n",
-			dport->port_id, dev_name(dport_dev));
+	if (dport_exists(port, dport_dev))
 		return ERR_PTR(-EBUSY);
-	}
 
-	struct cxl_dport *new_dport __free(del_cxl_dport) =
+	struct cxl_dport *dport __free(del_cxl_dport) =
 		devm_cxl_add_dport_by_dev(port, dport_dev);
-	if (IS_ERR(new_dport))
-		return new_dport;
+	if (IS_ERR(dport))
+		return dport;
 
-	cxl_switch_parse_cdat(new_dport);
+	cxl_switch_parse_cdat(dport);
 
 	if (port->nr_dports == 1) {
 		/*
@@ -1672,17 +1680,17 @@ static struct cxl_dport *cxl_port_add_dport(struct cxl_port *port,
 		if (rc)
 			return ERR_PTR(rc);
 		dev_dbg(&port->dev, "first dport%d:%s added with decoders\n",
-			new_dport->port_id, dev_name(dport_dev));
-		return no_free_ptr(new_dport);
+			dport->port_id, dev_name(dport_dev));
+		return no_free_ptr(dport);
 	}
 
 	/* New dport added, update the decoder targets */
-	device_for_each_child(&port->dev, new_dport, update_decoder_targets);
+	device_for_each_child(&port->dev, dport, update_decoder_targets);
 
-	dev_dbg(&port->dev, "dport%d:%s added\n", new_dport->port_id,
+	dev_dbg(&port->dev, "dport%d:%s added\n", dport->port_id,
 		dev_name(dport_dev));
 
-	return no_free_ptr(new_dport);
+	return no_free_ptr(dport);
 }
 
 static struct cxl_dport *devm_cxl_create_port(struct device *ep_dev,
-- 
2.53.0



