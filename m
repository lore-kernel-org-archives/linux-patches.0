Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C9C230BC5;
	Mon, 10 Mar 2025 17:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628506; cv=none; b=Gj80vpUeaA2px6DhxUnl6haBsegy3QVkgO0GipDq7bU1eRtJ0TgID5qCHxIx7elaYbMiwtymY8sK6gI0hnikGpMKJ+S0ntcOdKhmkU2PlWCEtnfTf+gc/QK2g00lltsuhO6lBEiI4t/afkjiuHRNRS3KtvKaUARtYFqpPOQfbQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628506; c=relaxed/simple;
	bh=/vXNJF1k6bgN77WLxqvzttKGVCAqs0o2UyVyo6pn0cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TO6QQqz6WQMbJCpVr08FEYyhP1AumJLRxzXU6a+ieXlQzEexb1QUmcdheycscIPSUPH5BGdOhpUq1PTs4dGeakdpzKR+woDtAlA5DYSxDbD7yr3iz5WVZpqgwjbA7TxWAk7mZUMJSytGLLOuN7iWpNBQY4WDqcaIODYV5MVWgZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVFAdT1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVFAdT1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805AFC4CEE5;
	Mon, 10 Mar 2025 17:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628505;
	bh=/vXNJF1k6bgN77WLxqvzttKGVCAqs0o2UyVyo6pn0cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVFAdT1fhP/Rv4oq94pmokNCpHeml6JZQjYJ91lYvpcIHPKoo/JP3GVLYGjMEyB8L
	 V1e8+4y7JAd6XHqPA7KpCXPMa8oot3rI+hP3w4pfPuxdDUx00dtmjCGLC9/3twpvnH
	 SqjDcEUkMf+YlONVaTRn/NzGOoPZsVtolWegdtLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.1 080/109] mei: me: add panther lake P DID
Date: Mon, 10 Mar 2025 18:07:04 +0100
Message-ID: <20250310170430.746997601@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -124,6 +124,8 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LNL_M, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_P, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


