Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6029D78F32;
	Tue, 27 May 2025 17:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365253; cv=none; b=luEaO7BazMEgFIBQhOMIXfSb0sNku/ldtIVpg8CWr7SKb9LX0I03xKes2D1C3mY0u+U3EOcMQ9JBJ+Vr3fQffeOoWI9FdPEZuNuVw4Jej2k4CnsVy7YnLNBGq/E0rMd/MwmrBbIq/PSZEuUTPutleB/Cbyrg+7GD+i8Uei2L3k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365253; c=relaxed/simple;
	bh=OtlaIbHN3CV4W2FgecxI3lcgappqzJPysZE8xzHd9o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umNK4jkixCpMqXcMqt6PN8XjfWNAebfcWxcJN8vr/RQroFOMfltFYOzq8zwUeLLr9a9XQHoh7raEM0hTffxCmJRKCV4KwDu9wEaaqEjoHRqHdInA9/jPjbxpUcBmHnN1JPraD5lVnprM2ioBEdsPBJLDatf6ugxI4ON6z1AKjDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvRmbxAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvRmbxAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4633C4CEE9;
	Tue, 27 May 2025 17:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365253;
	bh=OtlaIbHN3CV4W2FgecxI3lcgappqzJPysZE8xzHd9o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvRmbxACWzIQ5cnO5PEx+VUWm6oWmMg3KmHY079eId44jnfSLbvvyzf44TkJA8HVt
	 hCrpns+3PUB0AjST3/xEbzn73+OLWD5uNTjRrDzpQFceJR14guhQOeK3X65qN8elPy
	 Ba2Z5J4SFgFIaw79Xg6iBMwIs60vPwGHeWqvtKBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 285/626] Octeontx2-af: RPM: Register driver with PCI subsys IDs
Date: Tue, 27 May 2025 18:22:58 +0200
Message-ID: <20250527162456.610959704@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit fc9167192f29485be5621e2e9c8208b717b65753 ]

Although the PCI device ID and Vendor ID for the RPM (MAC) block
have remained the same across Octeon CN10K and the next-generation
CN20K silicon, Hardware architecture has changed (NIX mapped RPMs
and RFOE Mapped RPMs).

Add PCI Subsystem IDs to the device table to ensure that this driver
can be probed from NIX mapped RPM devices only.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20250224035603.1220913-1-hkelam@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 14 ++++++++++++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h |  2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index e43c4608d3ba3..971993586fb49 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -66,8 +66,18 @@ static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool en);
 /* Supported devices */
 static const struct pci_device_id cgx_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_OCTEONTX2_CGX) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10K_RPM) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10KB_RPM) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10K_RPM,
+	  PCI_ANY_ID, PCI_SUBSYS_DEVID_CN10K_A) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10K_RPM,
+	  PCI_ANY_ID, PCI_SUBSYS_DEVID_CNF10K_A) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10K_RPM,
+	  PCI_ANY_ID, PCI_SUBSYS_DEVID_CNF10K_B) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10KB_RPM,
+	  PCI_ANY_ID, PCI_SUBSYS_DEVID_CN10K_B) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10KB_RPM,
+	  PCI_ANY_ID, PCI_SUBSYS_DEVID_CN20KA) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10KB_RPM,
+	  PCI_ANY_ID, PCI_SUBSYS_DEVID_CNF20KA) },
 	{ 0, }  /* end of table */
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 8555edbb1c8f9..f94bf04788e98 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -30,6 +30,8 @@
 #define PCI_SUBSYS_DEVID_CNF10K_A	       0xBA00
 #define PCI_SUBSYS_DEVID_CNF10K_B              0xBC00
 #define PCI_SUBSYS_DEVID_CN10K_B               0xBD00
+#define PCI_SUBSYS_DEVID_CN20KA                0xC220
+#define PCI_SUBSYS_DEVID_CNF20KA               0xC320
 
 /* PCI BAR nos */
 #define	PCI_AF_REG_BAR_NUM			0
-- 
2.39.5



