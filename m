Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213597;
	b=SljHCRwFjZPdlCanRo0KJZHlFBYyU7maF+39o7JCJHDHkZhSNM9VUi41PrgsWFiT7uG1
	 HDyKoMZO/VDLieGpRTCEqtHWnHBh5zhqn6TEO0laYVw/p8J+OQnE4l8BvleVg0lLO79JF
	 3w8oqohEZCipp1hxxs/wdYDaZ0oAk1jEc3hpYUSTj0N/UqdlsxJtsdPnhfqk9F3Xqz+35
	 X/Zf9jZBEwFDyU6cIehmP7mFBCW+/Qw1SZhqO4njpAf5wMpvKW52eKJT0Zps+f1KnoDov
	 LYuNXF3hZl0GCV7YIygMQHCDL6w2kNp2tSvZfR7byQohq+azTrOPOt4K5c7OnhXxNmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QMuO+dWTOncqJuOZCK1B0oCK7Hx+O9V4+ulWJzSC4zQ=;
	b=Q01XsJkDw2wGU5CQufYIi6zZtlMY7I5Okgec+Cq94vHjaH0yxv1OtnXA6vwahMR3ck9J
	 97UbSdoBnfvqsVGmyaHC3QptO/R2d89YBfvvWMRGK7/FHu5UwyjgMZ2NGKZgn0r/2l61P
	 OwLvTdSXo+0YF3dc1B211BUI/Z5JyBGYwCv8mprzgjpk52yUwzXKbdJO3xCW+1QV+S7er
	 Dbf//2BUC3Wm4ohKlSVMUSUIoJYegmp4ms0Ef0RiqEfOC+Rofq0Evu4f8hQqZKgeX1tAD
	 Q+3XDBp9YlGGSIaEEMM06W5+NTmK3q2g1pLsU+Z5F0koD62njC0QBpiTxRcZXcQNchQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F43h0FMB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A491606A31F;
	Wed, 28 Oct 2026 18:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F43h0FMB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB42B1F01825;
	Wed, 28 Oct 2026 18:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213597;
	bh=QMuO+dWTOncqJuOZCK1B0oCK7Hx+O9V4+ulWJzSC4zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F43h0FMBYa2edcblZAXZ5iRW4qbAPebpEyZt2GGWv7TNvpHG1NsQo6m4WCGQE1Fl2
	 fvLA+AKBF4iOLOWPdTcsdtRBqBjn8IrS+4Vmx91IkJ4Ivxm9ILqw6l2OE8w7lIFxtc
	 1EA1IHcIr/GVIr1rP26t3fC3oqMtGb4REzFC5vUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Richter <rrichter@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0561/1887] cxl/port: Fix delete_endpoint() vs parent unregistration race
Date: Wed, 28 Oct 2026 17:44:17 +0100
Message-ID: <20261028170512.153626310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 8d2ad999ca3c64cb08cf6a58d227b9d9e746d708 ]

The CXL subsystem, at cxl_mem ->probe() time, establishes a lineage of
ports (struct cxl_port objects) between an endpoint and the root of a
CXL topology. Each port including the endpoint port is attached to the
cxl_port driver.

Given that setup, it follows that when either any port in that lineage
goes through a cxl_port ->remove() event, or the memdev goes through a
cxl_mem ->remove() event. The hierarchy below the removed port, or the
entire hierarchy if the memdev is removed needs to come down.

The delete_endpoint() callback is careful to check whether it is being
called to tear down the hierarchy, or if it is only being called to
teardown the memdev because an ancestor port is going through
->remove().

That care needs to take the device_lock() of the endpoint's parent.
Which requires 2 bugs to be fixed:

1/ A reference on the parent is needed to prevent use-after-free
   scenarios like this signature:

    BUG: spinlock bad magic on CPU#0, kworker/u56:0/11
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS edk2-20230524-3.fc38 05/24/2023
    Workqueue: cxl_port detach_memdev [cxl_core]
    RIP: 0010:spin_bug+0x65/0xa0
    Call Trace:
      do_raw_spin_lock+0x69/0xa0
     __mutex_lock+0x695/0xb80
     delete_endpoint+0xad/0x150 [cxl_core]
     devres_release_all+0xb8/0x110
     device_unbind_cleanup+0xe/0x70
     device_release_driver_internal+0x1d2/0x210
     detach_memdev+0x15/0x20 [cxl_core]
     process_one_work+0x1e3/0x4c0
     worker_thread+0x1dd/0x3d0

2/ In the case of RCH topologies, the parent device that needs to be
   locked is not always @port->dev as returned by cxl_mem_find_port(), use
   endpoint->dev.parent instead.

Fixes: 8dd2bc0f8e02 ("cxl/mem: Add the cxl_mem driver")
Cc: <stable@vger.kernel.org>
Reported-by: Robert Richter <rrichter@amd.com>
Closes: http://lore.kernel.org/r/20231018171713.1883517-2-rrichter@amd.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 20f052d3759e0..15b468b6aec38 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1094,29 +1094,24 @@ static void delete_endpoint(void *data)
 {
 	struct cxl_memdev *cxlmd = data;
 	struct cxl_port *endpoint = dev_get_drvdata(&cxlmd->dev);
-	struct cxl_port *parent_port;
-	struct device *parent;
+	struct device *host = endpoint->dev.parent;
 
-	parent_port = cxl_mem_find_port(cxlmd, NULL);
-	if (!parent_port)
-		goto out;
-	parent = &parent_port->dev;
-
-	device_lock(parent);
-	if (parent->driver && !endpoint->dead) {
-		devm_release_action(parent, cxl_unlink_uport, endpoint);
-		devm_release_action(parent, unregister_port, endpoint);
+	device_lock(host);
+	if (host->driver && !endpoint->dead) {
+		devm_release_action(host, cxl_unlink_uport, endpoint);
+		devm_release_action(host, unregister_port, endpoint);
 	}
-	device_unlock(parent);
-	put_device(parent);
-out:
+	device_unlock(host);
 	put_device(&endpoint->dev);
+	put_device(host);
 }
 
 int cxl_endpoint_autoremove(struct cxl_memdev *cxlmd, struct cxl_port *endpoint)
 {
+	struct device *host = endpoint->dev.parent;
 	struct device *dev = &cxlmd->dev;
 
+	get_device(host);
 	get_device(&endpoint->dev);
 	dev_set_drvdata(dev, endpoint);
 	return devm_add_action_or_reset(dev, delete_endpoint, cxlmd);
-- 
2.53.0



