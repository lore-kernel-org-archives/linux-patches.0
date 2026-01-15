Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AE125228D;
	Thu, 15 Jan 2026 16:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495915; cv=none; b=P4wWfPd3PpCTu9Xnr84M/Phk5nvrY5NXzl+NAeVQFPwejEosxdxwglo/Mh9KCJ05KMjABUl6+jmz2eLwK3cvgWjFunX4mctIELZjbVd6Sd0Yh1AqJIc2K/YVOQVe6hwyZQJUuJya8h0tn5lOaXuwtkBspF21Ni/BipmC9GJEyBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495915; c=relaxed/simple;
	bh=TIkoO/UlLxg57g+QeLeocBF25vYUPp41rPTZ7HzfMlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8byrXUvXP6j+XD8PpgeSpY1BHYbuszkYUNDkFyjzaho+Wvr3k7RZByYaf8A9Oogvil+zOjJV1bEbErKpJNC1TSsyI+c+8FRVeccRoP0ducSmBSh/6X8TOCyb71bdLqL/6YXoAOeP6w86DQc3Uk7d/jlHLdoOWF8KLtO7T17Eng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuD7gNAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuD7gNAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F813C116D0;
	Thu, 15 Jan 2026 16:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495914;
	bh=TIkoO/UlLxg57g+QeLeocBF25vYUPp41rPTZ7HzfMlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuD7gNAiz0rAY/BcNN0X+AzvSSLV3hj/9zw4dyCwsrDGeuK2XCuhTV8UbuinP1g/K
	 Uw5q4nMpFKrtQ0ffCE96zc6CAapcuFgcpUAnI2Zkc5ATX8bn7PKW6k4wvi3lsVdQLB
	 Adnj+Xjq4emRfTb9p6EkNt3ubbA8yyhAmIkhgBSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.18 013/181] mei: me: add nova lake point S DID
Date: Thu, 15 Jan 2026 17:45:50 +0100
Message-ID: <20260115164202.799257338@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 420f423defcf6d0af2263d38da870ca4a20c0990 upstream.

Add Nova Lake S device id.

Cc: stable <stable@kernel.org>
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20251215105915.1672659-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -122,6 +122,8 @@
 
 #define MEI_DEV_ID_WCL_P      0x4D70  /* Wildcat Lake P */
 
+#define MEI_DEV_ID_NVL_S      0x6E68  /* Nova Lake Point S */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -129,6 +129,8 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_WCL_P, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_NVL_S, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


