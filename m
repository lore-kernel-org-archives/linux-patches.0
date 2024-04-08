Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010BE85620;
	Mon,  8 Apr 2024 13:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582317; cv=none; b=Td5Gbj3oEG8JnMfbx9duBTmDQelRSlcBJI8F9F7SZ/L6agGjF2zt8IpQ6LiicokhvVDTksl0EoLxue37LvgV6wJnFHJq6J+qnImsDO4ktu7qE3xOXmvyIPnb9QtyCW5VDeGY9W+Bk9GjRH/MN1s52wboLT/ZNU7SpI5/eINtgAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582317; c=relaxed/simple;
	bh=Uu35xLT7yqpjX0G2X8S/fX42+rrqYvOQfQmJNzOd0VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m79Iv1cHMD0a+gtcDidXTvjDFSEEK3Akq4nQW93E8lVgv7Rh8hMBud6H11wtCZFzyhUbJt9IlLwqmkdPRm80fF7nz2OrwgswFpO8p7fVouSK0KZ7uxX3snnxDpZS4SJXiQEDDoIQ3hBTeQTamWlpDDcoLY6UAOhcMW/M3YS2sAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuVwg1sJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuVwg1sJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79275C433C7;
	Mon,  8 Apr 2024 13:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582316;
	bh=Uu35xLT7yqpjX0G2X8S/fX42+rrqYvOQfQmJNzOd0VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuVwg1sJXApmq3RzIEEL0wWsI0FQSlFxFAT62L+bNfFyvOJAQLfEHgKOl3Os24MmG
	 4VNTyqxBFSSXpjS4WOqZ31YtLNmXYQ+JBmC08hk2YGMpn5XybszU8JPy+XV9m/oejW
	 GVzBmx75IZX+ZoxjDx63/CiNRRPjETxbiQq2jJE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.15 132/690] mei: me: add arrow lake point H DID
Date: Mon,  8 Apr 2024 14:49:58 +0200
Message-ID: <20240408125404.317533626@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 8436f25802ec028ac7254990893f3e01926d9b79 upstream.

Add Arrow Lake H device id.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240211103912.117105-2-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -113,6 +113,7 @@
 
 #define MEI_DEV_ID_MTL_M      0x7E70  /* Meteor Lake Point M */
 #define MEI_DEV_ID_ARL_S      0x7F68  /* Arrow Lake Point S */
+#define MEI_DEV_ID_ARL_H      0x7770  /* Arrow Lake Point H */
 
 /*
  * MEI HW Section
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -119,6 +119,7 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_S, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_H, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


