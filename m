Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4C83A1E86;
	Thu, 15 Jan 2026 17:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497281; cv=none; b=UiMgn1vUS06XFQDMvbZl1t8WAmZ8mTTV2RGvln05036Z6sBOiGLUnSGRED9GJO0W75zUZCTt6E6rBQVwgX/8YgF2IUi26yWzsdQtC1PW6HXjQ+WerGtqN82SyFgsz1y2+BlAc/UsXNo9NqIoibMSkRFJTpJINZ8tmMvNUVoNlkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497281; c=relaxed/simple;
	bh=HtX4xG1jnov9nTKo2GxmR17RbhGrHTG6rm2Pw0+mh94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngKxfoW9gt83q6psSEKzZ0J8raGmyn6p5rBOXkHNR9i4mP2CDG6M33AREfl12/sXN1gZ0y0X6J3upVqsD1e87Rr8qoVSVT2jLrCCsLpHWvU8ahaE9x8PfOaqYA8DfDVAPng625wvZda7dilrKbpE6I7W3wjo8UbmO7ZrvdmDkqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcIedWXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcIedWXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7120C116D0;
	Thu, 15 Jan 2026 17:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497281;
	bh=HtX4xG1jnov9nTKo2GxmR17RbhGrHTG6rm2Pw0+mh94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcIedWXsJelCYCJvNClhlq4t7oZ256raOESpshRahU0NPV5wzUbundN0ZpI/vQd7r
	 TuVKWDL0do+cK+UzvEw9b7DBy4bu3lY/jj1mxyMvA2fmrlN3Qy2JxzNzQwULdpxyEb
	 oc/zPIURK1wofyvQ3fq/miokVEiExui+ekvz1nOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/554] dpaa2-mac: bail if the dpmacs fwnode is not found
Date: Thu, 15 Jan 2026 17:41:11 +0100
Message-ID: <20260115164246.431611513@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

[ Upstream commit 5b1e38c0792cc7a44997328de37d393f81b2501a ]

The parent pointer node handler must be declared with a NULL
initializer. Before using it, a check must be performed to make
sure that a valid address has been assigned to it.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index ae6d382d87352..4ace67bfa07c1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -40,7 +40,7 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
 						u16 dpmac_id)
 {
-	struct fwnode_handle *fwnode, *parent, *child  = NULL;
+	struct fwnode_handle *fwnode, *parent = NULL, *child  = NULL;
 	struct device_node *dpmacs = NULL;
 	int err;
 	u32 id;
@@ -55,6 +55,9 @@ static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
 		parent = fwnode;
 	}
 
+	if (!parent)
+		return NULL;
+
 	fwnode_for_each_child_node(parent, child) {
 		err = -EINVAL;
 		if (is_acpi_device_node(child))
-- 
2.51.0



