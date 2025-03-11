Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1704625B68E;
	Tue, 11 Mar 2025 15:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707584; cv=none; b=nIlv9RjmCvW4dghXOYd6n776L/69s5mdKog9tQqoShyHudpwvkg787t0O1hXM8BzDxEfyG8OpjZwMHGoP8yTxn95Wz8PO/hXAWbvFNfaL7K3AXMLcHl8kiUC5eNYd4y3kfP/cDP4+ug68Bu6CP0j8sW4bQtZQvK2n+Xn+m2bTXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707584; c=relaxed/simple;
	bh=rY3qzGnlFXVvnq6o1LkfE5deCyj7TyjvjaSP0tjkckY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=li0sFp1857tV/0omnQtCjuVrdFGNP5slWau9cUmmWr2CXZY1F0qn3dzH+KKR3D2sj1SDu3AjpNuAcQFwYlqRzk0mo6sY55/NTM+qBXruY7hmJyDsOypr0rhlrQdMkOmJull3ZlkpUzRtF/6LpL+2m65X54AcclHY0amTDj3k3VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ikmw0/Mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ikmw0/Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E41AC4CEE9;
	Tue, 11 Mar 2025 15:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707584;
	bh=rY3qzGnlFXVvnq6o1LkfE5deCyj7TyjvjaSP0tjkckY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ikmw0/Mbql9ZYnR7wILlUNdIOdPjvGd32DH0RAkThETJWNTKnJL1QMXpgXq0RSyFx
	 w57f9CLwYi3btwfgBVWfoUtESnQcYRox4mElEZwRYN6mLwn7BhZp4T9ek5esBd5pE6
	 TMRoGn6YjCPa/qG96C1LhoI4lDwWv0NBuxA/bXQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 5.10 438/462] mei: me: add panther lake P DID
Date: Tue, 11 Mar 2025 16:01:44 +0100
Message-ID: <20250311145815.635575283@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit a8e8ffcc3afce2ee5fb70162aeaef3f03573ee1e upstream.

Add Panther Lake P device id.

Cc: stable <stable@kernel.org>
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://lore.kernel.org/r/20250209110550.1582982-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -117,6 +117,8 @@
 
 #define MEI_DEV_ID_LNL_M      0xA870  /* Lunar Lake Point M */
 
+#define MEI_DEV_ID_PTL_P      0xE470  /* Panther Lake P */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -123,6 +123,8 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LNL_M, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_P, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


