Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD1982C60;
	Tue, 29 Apr 2025 17:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947846; cv=none; b=Q1/lRWyYj1kfD/iOrhpSR/bF+XR8fJBS9F3HalFTXyGvZShofx34mdwy20vXExurFkFJTD1jvGaEVLS8JANkjqv4R3RULRHirxwnagGNmNutQEdQlAJemWYiV4azhKhNtg1f7wRfyJbRLlVyXnayTasxXBF1ndwDRFrayhxbDgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947846; c=relaxed/simple;
	bh=kp8RwjHHfzCBccdxbGuqtA70Xa6IQppwFi+4BKTY4Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQxF7RCmXWTGXY4WY8AX/g3NL6X4ZTxf7r2mvwCErm2rDup1nWePROtgvSEOyjcKnO29l0HRI+jAtv5pU9rQBjB5dNXlsfpji7UoRs7Grso9+duKJSDKnw/cbJpwOxbgLSx+8DmYe7QlEhU3osPedTExHQ0iLqiPI+wBnGHYLUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zL71p3+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zL71p3+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0249DC4CEE9;
	Tue, 29 Apr 2025 17:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947846;
	bh=kp8RwjHHfzCBccdxbGuqtA70Xa6IQppwFi+4BKTY4Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zL71p3+BmyhSpeIdB+c+JWGFPelnPsrhzK7jPk7kjyA4S5rAJ4pqzBpyoVEkvh43O
	 9dHgGI02WHGN3h52UoyLWu0oMzH/igZPJmkLZg/fBrFoba5yYfoa4K6IWQzAIOU9TE
	 j1D36Xfg9O5WyqGOYQ2eEBa6dZgT58W2mXOIuO8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.12 121/280] mei: me: add panther lake H DID
Date: Tue, 29 Apr 2025 18:41:02 +0200
Message-ID: <20250429161120.061690660@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 86ce5c0a1dec02e21b4c864b2bc0cc5880a2c13c upstream.

Add Panther Lake H device id.

Cc: stable <stable@kernel.org>
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://lore.kernel.org/r/20250408130005.1358140-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -117,6 +117,7 @@
 
 #define MEI_DEV_ID_LNL_M      0xA870  /* Lunar Lake Point M */
 
+#define MEI_DEV_ID_PTL_H      0xE370  /* Panther Lake H */
 #define MEI_DEV_ID_PTL_P      0xE470  /* Panther Lake P */
 
 /*
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -124,6 +124,7 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LNL_M, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_H, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_P, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */


