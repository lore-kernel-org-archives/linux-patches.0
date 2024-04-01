Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551A51DFF4;
	Mon,  1 Apr 2024 17:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991099; cv=none; b=sRi8L5SDqnpjmnKkOLNkAFFN7OSNcXusEYvhqUEraRSSCVB1XxfB383wXSG29VvigpPI4zq1wTmKLHDRh8LVvdn7A2VOe4C926n8jfGu7Rv/io4xyXZWnFPxmfLxaqGaahRIPx/OpTxOBJqemvA59Zb++x19uTpv4/Se4+0ReSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991099; c=relaxed/simple;
	bh=evBYGhR0AhtBGx+leHY3lkf5awXl2UDfbWmdOhqEfOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0laHr9BaxFUpz4v2qIdoKux8P6bHWEE4XAgZ0Br+m95F7ahM6TzEzYeHR53XNpJxBB8JgqZfbyHtjiY9dELjvHD1PUJeHxIuW0iCGr3I3pZLWSZGI2LR8/vyJg8/rQN7vLGXm9EZXCE54KAz+yB9GUjOBHz8s2NxBQ9IKHo2ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Um5vyvsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Um5vyvsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF607C433C7;
	Mon,  1 Apr 2024 17:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991099;
	bh=evBYGhR0AhtBGx+leHY3lkf5awXl2UDfbWmdOhqEfOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Um5vyvscgaQDC199e291QyhfuzXhs9ZKpadMw0J4SWFA8U0W2zOSwTX6V97uLrzlY
	 awWsMrLeb4l9o2y92AZAE0VdoRlXVtRVFT+2aHQNJklS94/U25z44bhPv6h/d7YpXY
	 AVsX02sZcsf2OruEpd14pNPLmqEqJrii55+ubR5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.1 163/272] mei: me: add arrow lake point S DID
Date: Mon,  1 Apr 2024 17:45:53 +0200
Message-ID: <20240401152535.831587852@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 7a9b9012043e126f6d6f4683e67409312d1b707b upstream.

Add Arrow Lake S device id.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240211103912.117105-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -112,6 +112,7 @@
 #define MEI_DEV_ID_RPL_S      0x7A68  /* Raptor Lake Point S */
 
 #define MEI_DEV_ID_MTL_M      0x7E70  /* Meteor Lake Point M */
+#define MEI_DEV_ID_ARL_S      0x7F68  /* Arrow Lake Point S */
 
 /*
  * MEI HW Section
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -119,6 +119,7 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_S, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


