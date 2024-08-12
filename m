Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9C71422A8;
	Mon, 12 Aug 2024 16:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478832; cv=none; b=jm1zjVyxEu9ESS5SeW8efouN+pIuu26CSa7Mzv9nmW4F4Iv+Wy3okkJi2T3zt47basqysTSPoFAxmKYZ5W/+wiggDHTDa79eGMyJPXycxo1dPGPsEZRcTAmWlUrazSw94JNk8LazfJAoNBb0CSy/vHmiLdDMIvcMwpyZu8CGKuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478832; c=relaxed/simple;
	bh=8bFSf51dlJs3T5WU1N/ChkYOU+xJK3o58yyfCstYB6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvcehhV2rwcTqaRQ3lx1y2QpMR/Okr3gtTDE/7tbwsS/DjG75wKo8FMLzEm7dD4ZizT0epzfnC7I61+7DkpHiEOVS2z6KE4tBH3EbMFwtGqjUUdwwrKNrqXHO+kk2F3piPpIULpFMk5gDRpaL2WRtY7AUNaSo4jl5yST//Fg9qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXvtCEkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXvtCEkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126BEC32782;
	Mon, 12 Aug 2024 16:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478832;
	bh=8bFSf51dlJs3T5WU1N/ChkYOU+xJK3o58yyfCstYB6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXvtCEkQ6pVH8r98eBCX5e0537gttgxGGgNT6SFa59Y3Cl1JVpc9/jHL5YD1jqbZM
	 PehVukQjccioaEX6kllkKE78Q1Yhij8Gkbhgs4mFNYmz9346rl1X5Pl8cBP4Iy/Ccj
	 hvOnNwkAvTZpmGFPzdH6FcLyvC6doYywivo0VSWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH 6.1 050/150] bus: mhi: host: pci_generic: add support for Telit FE990 modem
Date: Mon, 12 Aug 2024 18:02:11 +0200
Message-ID: <20240812160127.096560330@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Daniele Palmas <dnlplm@gmail.com>

commit 0724869ede9c169429bb622e2d28f97995a95656 upstream.

Add support for Telit FE990 that has the same configuration as FN990:

$ lspci -vv
04:00.0 Unassigned class [ff00]: Qualcomm Device 0308
    Subsystem: Device 1c5d:2015

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20230804094039.365102-1-dnlplm@gmail.com
[mani: minor update to commit subject and adjusted comment]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pci_generic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -553,6 +553,9 @@ static const struct pci_device_id mhi_pc
 	/* Telit FN990 */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, 0x1c5d, 0x2010),
 		.driver_data = (kernel_ulong_t) &mhi_telit_fn990_info },
+	/* Telit FE990 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, 0x1c5d, 0x2015),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fn990_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0308),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx65_info },
 	{ PCI_DEVICE(0x1eac, 0x1001), /* EM120R-GL (sdx24) */


