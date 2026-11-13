Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590595;
	b=B+SSupEZh3Bm8b9q9zIu9nWpT69YAPWWS2dIyhXD9LICe5Pv67bmUhS2zSyyP0AF4+Z8
	 nore3IMzIq3gVw8odTcN0kqGWQPsyRmFpMO7q2MNyYIphITn0Yw/o/kdtVEAv47hfNA9L
	 RPvtAebVeOMoJwZoN13A1OMinIN8l7wcQfsOJeOGpcQcfktB7qpuhp9QLAf7jd+nNJK5v
	 wZD0EylYd1noUQXTMu6t821IfdtpEZ6gFYX76jTZyy9qsoxVRWW2/RhiBQtE+xXkKE9JX
	 fLj4Aw1XItj6o5F/jLsiw8bVyNla76Y+9cRjUAntFu0b+KhYdwPSfIhdG8w/wEhgfkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xBcklJGkpjqBEaVv02ncKAei7vFH+2Lr1hGO1tsEXXk=;
	b=CcHYuXcHkEUEnuNMglSojeAsTWvemLqJp5Sg729LJkhtAD+JRb6l+Ysa2SP9q5wF35tm
	 T/jfFPQWqZam4qd6gl24u5lXDK8mmvJah8kuiOea4zMWHzfvMwrppLQPG4AC9t18qnV68
	 KtXiuJFGQlOireITo7kgUYd9uad0reXIk+aMNzw9mcK0phGxY9tmXc2wlNn15+pSzIcX9
	 wFZG91goS7tgQdiGfcfnF59L0EPL74yBSEztCJmzQcqZ0HNdC6kRtlJTFKX1jfxw5SxBR
	 Be+L7/i8qoxEwKIc/ZqR919Z2uhDr1OaAxV8g7RPOjP2zrHVV+GuTB4A2a8GyMCUXWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hokHx0n4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F392606A887;
	Fri, 13 Nov 2026 17:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hokHx0n4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CADE1F000C8;
	Fri, 13 Nov 2026 17:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590595;
	bh=xBcklJGkpjqBEaVv02ncKAei7vFH+2Lr1hGO1tsEXXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hokHx0n4cP7dzzyDxK6P6yzn9v9nnPY576LvYIAMwMYBlZV0Kfs5cWl8MDJ3HN1PT
	 zyxT1n73iW/GSGJur/Vr2XVZMinawFP+sOlkHgTyxFja8jxh/gMfhWOkrqhLRLPdsq
	 f0/Z78xY6mATPbAiTe4FKuRxNZdLyAOijSvyxR5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Terry Bowman <terry.bowman@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 526/686] cxl/port: Cleanup handling of the nr_dports 0 -> 1 transition
Date: Fri, 13 Nov 2026 10:50:59 -0500
Message-ID: <20261113153838.954520948@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 47fec713d97fb6b823026f723435b58af541bd8d ]

There are multiple setup actions that can occur for a switch port after it
is known that it has at least one active downstream link. That work is
currently split between __devm_cxl_add_dport(), the add_dport() helper, and
cxl_port_add_dport() where decoder setup occurs.

Clean this up by moving all @dport object setup responsibilities into
add_dport() and all port effects into cxl_port_add_dport().

add_dport() handles taking a reference on @dport->dport_dev, and
cxl_port_add_dport() grows the awareness to setup the port component
registers. This removes an awkward open-coded xa_erase() from the middle of
__devm_cxl_add_dport() and instead tasks cxl_port_add_dport() with calling
the common @dport destruction path if anything goes wrong.

After this @port->nr_dports is always the count of @dports in the
@port->dports xarray, and cxl_dport_remove() is symmetric with add_dport().
With ->nr_dports now reliably tracking the number of dports the use of
ida_is_empty() can be dropped. Recall that the ida is only cleared on
"release" of decoder objects, and release can be arbitrarily delayed past
unregistration.

Lastly port->component_reg_phys is no longer reset to CXL_RESOURCE_NONE
post setup, no reason is seen to carry that forward.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Tested-by: Terry Bowman <terry.bowman@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20260131000403.2135324-2-dan.j.williams@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 019560d23450 ("cxl/port: Clear cached dport pointers when a dport is removed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 599aa9d9eddca..a7d3497f82c05 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1073,11 +1073,15 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *dport)
 		return -EBUSY;
 	}
 
+	/* Arrange for dport_dev to be valid through remove_dport() */
+	struct device *dev __free(put_device) = get_device(dport->dport_dev);
+
 	rc = xa_insert(&port->dports, (unsigned long)dport->dport_dev, dport,
 		       GFP_KERNEL);
 	if (rc)
 		return rc;
 
+	retain_and_null_ptr(dev);
 	port->nr_dports++;
 	return 0;
 }
@@ -1106,6 +1110,7 @@ static void cxl_dport_remove(void *data)
 	struct cxl_dport *dport = data;
 	struct cxl_port *port = dport->port;
 
+	port->nr_dports--;
 	xa_erase(&port->dports, (unsigned long) dport->dport_dev);
 	put_device(dport->dport_dev);
 }
@@ -1188,21 +1193,6 @@ __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
 	if (rc)
 		return ERR_PTR(rc);
 
-	/*
-	 * Setup port register if this is the first dport showed up. Having
-	 * a dport also means that there is at least 1 active link.
-	 */
-	if (port->nr_dports == 1 &&
-	    port->component_reg_phys != CXL_RESOURCE_NONE) {
-		rc = cxl_port_setup_regs(port, port->component_reg_phys);
-		if (rc) {
-			xa_erase(&port->dports, (unsigned long)dport->dport_dev);
-			return ERR_PTR(rc);
-		}
-		port->component_reg_phys = CXL_RESOURCE_NONE;
-	}
-
-	get_device(dport_dev);
 	rc = devm_add_action_or_reset(host, cxl_dport_remove, dport);
 	if (rc)
 		return ERR_PTR(rc);
@@ -1629,7 +1619,16 @@ static struct cxl_dport *cxl_port_add_dport(struct cxl_port *port,
 
 	cxl_switch_parse_cdat(new_dport);
 
-	if (ida_is_empty(&port->decoder_ida)) {
+	if (port->nr_dports == 1) {
+		/*
+		 * Some host bridges are known to not have component regsisters
+		 * available until a root port has trained CXL. Perform that
+		 * setup now.
+		 */
+		rc = cxl_port_setup_regs(port, port->component_reg_phys);
+		if (rc)
+			return ERR_PTR(rc);
+
 		rc = devm_cxl_switch_port_decoders_setup(port);
 		if (rc)
 			return ERR_PTR(rc);
-- 
2.53.0



