Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8BE21E087;
	Mon, 10 Mar 2025 17:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627078; cv=none; b=Z2Ok4Yz6U8ibaXCrTPeireRRRlFVpE+g/p6znQ2LPUd/RaKzacqeMI/n2JnByynoo62QYIn0ZrzOHMx/IhD8uF5FQM3LnZAs+NOpJmfdj6kxDXCRye0JrCZM4h8IWDqBcQFzJRJfhPrynpTroNBbKuMQD5Ecjnd03Zmko8OH0TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627078; c=relaxed/simple;
	bh=TC37pz90bmuSeR0zMVVd7H7h1N3M4gXRR4KerhxSHbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X99PssV+09sGNS2TgS+Pml7An2APSva2mGgPJhUJ9TyDoa0cWo0/6A09YFmimUDZy2G3hMIvrnPpfxuxO+yiSGE1g1s9PXjxTMkgwAPuqtZKnSFvdzlLc4vM+LjQ10SNiT41PaGo/ifd87IBYkYn5qGJ2zjPvA09HuE/GyKSgFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aP87s0/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aP87s0/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087D3C4CEE5;
	Mon, 10 Mar 2025 17:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627078;
	bh=TC37pz90bmuSeR0zMVVd7H7h1N3M4gXRR4KerhxSHbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aP87s0/srwU6Vbu5JF+Enu+okiwzaLZTVeng54Oscg5vbA0tOjOvL2bKLoHOxVv8H
	 UfMuARfOVbdTSOeneQsr9nkNg7SeX0LqEIDfrw0RIu4/QXcEpu6uYLC6BOYyAnv26+
	 optguKpEG7CgKrhR1XxC8gtb/0R1y9vf9aSwAe+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.13 181/207] mei: me: add panther lake P DID
Date: Mon, 10 Mar 2025 18:06:14 +0100
Message-ID: <20250310170454.983157769@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


