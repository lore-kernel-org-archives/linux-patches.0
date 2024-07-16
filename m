Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C960EF9E8;
	Tue, 16 Jul 2024 15:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144514; cv=none; b=dMnhn4PEqopON3Ktc6bmid856Gri2+lT+wse78AfiPTji8Xerj+JDZScC38SBqL3ivzcnOCu2fCor0ZUFtq6eQ+GlXLBXyHfKrixwA0FWPxZ2CbiqSyLAVMvCftxtsdmWbeTvRxWfzQPFLvvbyihp6VvPDBQvaWRkvy5iXwMLYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144514; c=relaxed/simple;
	bh=G29gRp0zivNKzhYROAEZq9M+17dlc6bTfUu5qXYX7+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNedVJADQ06EVrhxgJ7JRq0zNyxyrtt7/7R5elKjq2M+4PywdgejGCQg4Th4dMgV0NdWeD4nAuqcfil/fi1oj6olGUIiPP/+9aZFMEVRQgu9dpGJKt3dH1bPVmJFNGAzbKdPFiYbCABu2sPos1VGHSEK9qp0exc3XzhFf4oc15U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEBJSm6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEBJSm6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA74C116B1;
	Tue, 16 Jul 2024 15:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144514;
	bh=G29gRp0zivNKzhYROAEZq9M+17dlc6bTfUu5qXYX7+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEBJSm6Edfb/TP0UB6oNOD+F6L1oKY6I2o6ubC/sTQRvvo+GHbIzEScnivnb0azcI
	 hTD/pjBWX5Q30MILQ4xHeevVGSof3F9cj6V4DsYx3EIdDlrionGcpz9opkW/jwLeKv
	 vDjE26G87C+EEM7BwjhiDoG/sIaBCACv7mNsvCKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/108] i2c: i801: Annotate apanel_addr as __ro_after_init
Date: Tue, 16 Jul 2024 17:30:34 +0200
Message-ID: <20240716152746.738610562@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 355b1513b1e97b6cef84b786c6480325dfd3753d ]

Annotate this variable as __ro_after_init to protect it from being
overwritten later.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index d6b945f5b8872..4baa9bce02b67 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1078,7 +1078,7 @@ static const struct pci_device_id i801_ids[] = {
 MODULE_DEVICE_TABLE(pci, i801_ids);
 
 #if defined CONFIG_X86 && defined CONFIG_DMI
-static unsigned char apanel_addr;
+static unsigned char apanel_addr __ro_after_init;
 
 /* Scan the system ROM for the signature "FJKEYINF" */
 static __init const void __iomem *bios_signature(const void __iomem *bios)
-- 
2.43.0



