Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064598;
	b=I3arlbOoUGe4Xp7lVSfx137OrA4e1M4IjzB93OGjtaAwz87wATQnWv9/6jIGyxKKU95Z
	 G2LnqZrNzcs4q85T+ITlbMJgWYz+mWxJQgB/2nNXWN+3CJoLoPWzFFSSh9dthNeWPkyRW
	 jDNjI3m1i+OjlnXi/oDvk4Fb24afmrAjPNjaAs3c9yLa7pUAmhOgF6FOhTH1RqWghqRUv
	 zS7Ng2Ue8sTs1GqQUzK4WaRWDg1gOT7KnsjNMSOxFZHrPLyilDB6tg1k9bwAvnbBeE5Ed
	 RK9EmsXUwRcDu5NakkoPKOArGVGKfumwt9Kq/oJjSrAEiTWL035EtnQWdxJoFdugr7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zhs9JjDSpmB1rNfi5onROCZMoRpfy9Je8A1WpAzFOgY=;
	b=la5KxzQp3xQ7BglEAMlX6BrlYNicURMHW2Vp1uBHFHJGOQiB/5xO9WQenEPtc2N/0WHm
	 R6VElN9/U7fxWX5qMlvZonSkbUGikfMgRQXAuFatBMkh1EGaZ0ML4UsLZzKfaDAxJYnT5
	 GNwdAlqZbHMrI4mbTZAWptxEkTYKBUvW5y5481OWduUOdVu2N+agNqS1lFeUdoThkw03j
	 /eW/E90ACnFynl0k2OEiUVgqFwypn8FWWJnUeOpp4aWb6LsCruzVDrjDQ9eIKNhYFtfS9
	 gnbeYA5UXhpcc+jf9e53FiTYhmdZvjo2JRMKj51FHo+ZRSp6DM6cTw2e8oJOdMQ946A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjJ+rLAF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E71606A9E2;
	Sat,  7 Nov 2026 15:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjJ+rLAF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB23A1F0089F;
	Sat,  7 Nov 2026 15:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064598;
	bh=zhs9JjDSpmB1rNfi5onROCZMoRpfy9Je8A1WpAzFOgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjJ+rLAFnP2VjpTt8a2TcBMba89y6LTeJtzed71Z+6mr6N1hVAD19PogSjogCu/MG
	 3RMNAXRrg8AbfLCSc73I47MCSSVIKQ4cztmwqg8k/hasq2omBshRyIrdQwLpGuXeOc
	 ySRdEq4z6RNZDlbL+OXULfCmcRqL0Gpc0H4DsoiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Li Ming <ming.li@zohomail.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0612/1257] cxl/port: Clear cached dport pointers when a dport is removed
Date: Sat,  7 Nov 2026 08:48:28 -0500
Message-ID: <20261107134956.210924428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 019560d23450a320f4060ff235563a5277ea8033 ]

Switch decoders cache dport pointers in cxlsd->target[], and nothing
clears them when a dport is freed. Readers then dereference freed memory.

KASAN caught it under a cxl_test load/unload loop with concurrent sysfs
reads (abbreviated).

Clear the matching slots from cxl_dport_remove(), walking the port's
decoders the way cxl_port_update_decoder_targets() does on the add side.
Scan all nr_targets slots, the target[] allocation size, and clear every
hit.

Fixes: 8330671c57c7 ("cxl: Add helper to delete dport")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20261001154744.1095902-2-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 625e4aa427db0..6ff3353865e39 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1089,11 +1089,40 @@ static void cond_cxl_root_unlock(struct cxl_port *port)
 		device_unlock(&port->dev);
 }
 
+static int clear_decoder_target(struct device *dev, void *data)
+{
+	struct cxl_dport *dport = data;
+	struct cxl_switch_decoder *cxlsd;
+
+	if (!is_switch_decoder(dev))
+		return 0;
+
+	cxlsd = to_cxl_switch_decoder(dev);
+	guard(rwsem_write)(&cxl_rwsem.region);
+
+	/*
+	 * A dport can occupy more than one position of an interleave, so
+	 * scan the whole target list rather than stopping at the first hit.
+	 */
+	for (int i = 0; i < cxlsd->nr_targets; i++) {
+		if (cxlsd->target[i] != dport)
+			continue;
+		cxlsd->target[i] = NULL;
+		dev_dbg(dev, "dport%d removed from target list, index %d\n",
+			dport->port_id, i);
+	}
+
+	return 0;
+}
+
 static void cxl_dport_remove(void *data)
 {
 	struct cxl_dport *dport = data;
 	struct cxl_port *port = dport->port;
 
+	/* counterpart of cxl_port_update_decoder_targets() */
+	device_for_each_child(&port->dev, dport, clear_decoder_target);
+
 	port->nr_dports--;
 	xa_erase(&port->dports, (unsigned long) dport->dport_dev);
 	put_device(dport->dport_dev);
-- 
2.53.0



