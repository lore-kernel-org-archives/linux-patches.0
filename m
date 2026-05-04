Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5BD2E2F0E;
	Mon,  4 May 2026 14:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903588; cv=none; b=I1SSXHq1aYnoq6YF+UNeDWuQ/cy6zMDG0tOR6ZJFrM7M9B/JgDFTm9YES6s81/ly2aDR+CErnqbO6xVfLUFHqFxhsEJl6BbBVzpDYNd01X9BdDMkqjh4sUKIfVPoCpITpXZu8WWPlB4zFZFgbWcADQi4dlVju8kqM8Ur2NRAG8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903588; c=relaxed/simple;
	bh=ZyUIr5twpwaTtP5exLyjpSKzxEcmNyZCSfOYlC+d4Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WY0RlTGsnhshdTloz5Vs79FtKMClrDpyObznL9/vVIysc07VSch0GuzDXqmdTmvVM4WZRI1A8I5y4wC6SBG+SJ+2lfjZpMI7I868ISR73iFHTDU6MbMUcA3uglvEL5+EE/ia/a2CU8RtHIQBSVL9ZPNTTatpjWsZTnHZvcWdQ1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Xuveu8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Xuveu8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FBCC2BCF6;
	Mon,  4 May 2026 14:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903588;
	bh=ZyUIr5twpwaTtP5exLyjpSKzxEcmNyZCSfOYlC+d4Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Xuveu8Bek+oBx0syDHD7e1EZXjyi/vPyf8C/xk8IdkibEOjkzxfFBnEiu9957F9E
	 ZR2VI3VeZwkPW9CATEwNPbigEJg1pAQ7x8Ka0aWgc7r9uj0eyJjo4OzLesTNrmKFdB
	 IgbE9u2yko/NyJZGyhT+YpAHMQrcjX/ZpCXFtVQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 293/307] mei: me: add nova lake point H DID
Date: Mon,  4 May 2026 15:52:58 +0200
Message-ID: <20260504135153.815081007@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit a5a1804332afc7035d5c5b880548262e81d796bc ]

Add Nova Lake H device id.

Cc: stable <stable@kernel.org>
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20260405141758.1634556-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -123,6 +123,7 @@
 #define PCI_DEVICE_ID_INTEL_MEI_WCL_P      0x4D70  /* Wildcat Lake P */
 
 #define PCI_DEVICE_ID_INTEL_MEI_NVL_S      0x6E68  /* Nova Lake Point S */
+#define PCI_DEVICE_ID_INTEL_MEI_NVL_H      0xD370  /* Nova Lake Point H */
 
 /*
  * MEI HW Section
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -130,6 +130,7 @@ static const struct pci_device_id mei_me
 	{PCI_DEVICE_DATA(INTEL, MEI_WCL_P, MEI_ME_PCH15_CFG)},
 
 	{PCI_DEVICE_DATA(INTEL, MEI_NVL_S, MEI_ME_PCH15_CFG)},
+	{PCI_DEVICE_DATA(INTEL, MEI_NVL_H, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


