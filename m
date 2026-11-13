Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590598;
	b=wE/E58fuDQp7Ol/puiVOvP6dwIQ2KyQQi7RajaEvaLz63SrxA2a5ozAfVuspLIklF/el
	 4OiSSpb72UC04PinLaWhEFSbUx5NJF3sUlX3v+Kc+ZImkq6Ukh9Cy+xP67rl1R9FsyQjI
	 EhdDyJ6jwH8J0di7lA4fjCM4lAQv1HsCrfiE/K1UmVaMEjZ5Gz+e3LkO9xuL7fM/WJahc
	 lW3pe1gGalx15EkcpZStDwjl5TecT8i4C7hHZV4CNyCKDsxz7Rq5vdzepcbXX/4kB7UIS
	 01wTarwA2svLWQ36c1Do9j2DP8sg4Nt3J9EJdmiCcmVivfE0gCTrLqqv4OEoggS3/KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DDNl/h/1zqXpMXX8wEeTAz3UU3x3Ki1ydUhDwBi2quY=;
	b=oO3dw8YWX8WboizfK3O25w5ptqCCS+YNsnghH3nwjii/oI77dSm+wbJeGcZQoqSZB3hb
	 yB/XN8HmJu242cpC01M4jBKO6MJ9fK8oaHW09vqmNCo9BUq+xN6BtBb5lmei7ouVWo2q3
	 E+ug0udXRYotJiRAJw4uGMYBeJEh4uqLS4e9HH1XBbVcjk9Kclc/q0Iyvl9l4H5jGNQ+V
	 DoD3INa2vfk5c0YoBxHAIi6fNQpKjGU09exOji5OuK3582uaMQ9yznFq2i55VlgCocuvA
	 XtyFHoV+282GTc5PkTaKkbKy2plZPpPs8JiQWNzr8KA9OGaDZ+9KqUkF5jZ/xp9i2cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EoYplgzU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F396C606A330;
	Fri, 13 Nov 2026 17:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EoYplgzU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D1D1F000C7;
	Fri, 13 Nov 2026 17:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590597;
	bh=DDNl/h/1zqXpMXX8wEeTAz3UU3x3Ki1ydUhDwBi2quY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EoYplgzUQ1/Cmk/7HCfkWKFQeoqyS1EuYsNyC7bWKBzixOod41ycrgDWe6ttuoNBJ
	 BQaBuHy7D+jQZh6tavSRALirbwifD1iFGBf+MLwDyKZ2XTTtlhRlHotWpMUC+6KVfX
	 t/uyl2ABhfl5lCZShdrF6P9bYd78LM8QIQb4g6pU=
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
Subject: [PATCH 6.18 527/686] cxl/port: Clear cached dport pointers when a dport is removed
Date: Fri, 13 Nov 2026 10:51:00 -0500
Message-ID: <20261113153838.985725605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index a7d3497f82c05..01655eeb43a8f 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1105,11 +1105,40 @@ static void cond_cxl_root_unlock(struct cxl_port *port)
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



