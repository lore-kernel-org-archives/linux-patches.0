Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033271EA7EB;
	Wed, 19 Feb 2025 08:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954282; cv=none; b=K1Su7TdNaOvNgOK72dTry6LNExPK5iEBCn2XfswxA5fDyk632uqnHqNIPXUWtDSgAlfivtyEn1xljXrbWLDx3P0qCFV3iuwtIvY/Wb7DUhfOe5/fb+TxEw/9NHaRHYnTP3EREUQgeBlHJauBvXO/nW7SBK0gIloIzeK2ET0sfIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954282; c=relaxed/simple;
	bh=YpiD9hcjQ2uwA5i5i6LnM/mm2MdexXX0/RpyZC2LVb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gT1egO3TXY0oVVkBOdw1GG2W7nFT9YljbdR+tMdeBf2XihRPFJLtFvto6Xbh8HH2UVjPSCvoPgsVMvGjYZfVLlAnhOpOfw6EeYFlclyfY5hXw0+9coaO66g0Y7l76qO8IAUEev9XMtLU4ohCUo8YsMqGv9vEpafl9u9AnfW5XxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufj2XNwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufj2XNwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17ADEC4CED1;
	Wed, 19 Feb 2025 08:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954281;
	bh=YpiD9hcjQ2uwA5i5i6LnM/mm2MdexXX0/RpyZC2LVb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufj2XNwDqTCKpCTpHoCZ5Zpsx1cBGFBg5BQQB1mhqqHnPYIds5aIC76Pr5YmMbvh2
	 uWck9WX17W+egHbfWM8bXH/6OnMuRycJzoiBMthiNU0dBDQU2gBT5AY2UAhGfhha8b
	 jbCzn9tR7CzMWTmUGKSRuHJZXG81Y2w32gxNZEnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya08@live.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.13 155/274] wifi: brcmfmac: use random seed flag for BCM4355 and BCM4364 firmware
Date: Wed, 19 Feb 2025 09:26:49 +0100
Message-ID: <20250219082615.662912171@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Aditya Garg <gargaditya08@live.com>

commit 0e9724d0f89e8d77fa683e3129cadaed7c6e609d upstream.

Before 6.13, random seed to the firmware was given based on the logic
whether the device had valid OTP or not, and such devices were found
mainly on the T2 and Apple Silicon Macs. In 6.13, the logic was changed,
and the device table was used for this purpose, so as to cover the special
case of BCM43752 chip.

During the transition, the device table for BCM4364 and BCM4355 Wi-Fi chips
which had valid OTP was not modified, thus breaking Wi-Fi on these devices.
This patch adds does the necessary changes, similar to the ones done for
other chips.

Fixes: ea11a89c3ac6 ("wifi: brcmfmac: add flag for random seed during firmware download")
Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Acked-by: Arend van Spriel  <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/47E43F07-E11D-478C-86D4-23627154AC7C@live.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2712,7 +2712,7 @@ static const struct pci_device_id brcmf_
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4350_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE_SUB(0x4355, BRCM_PCIE_VENDOR_ID_BROADCOM, 0x4355, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4354_RAW_DEVICE_ID, WCC),
-	BRCMF_PCIE_DEVICE(BRCM_PCIE_4355_DEVICE_ID, WCC),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4355_DEVICE_ID, WCC_SEED),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4356_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43567_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43570_DEVICE_ID, WCC),
@@ -2723,7 +2723,7 @@ static const struct pci_device_id brcmf_
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_2G_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_5G_DEVICE_ID, WCC),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_RAW_DEVICE_ID, WCC),
-	BRCMF_PCIE_DEVICE(BRCM_PCIE_4364_DEVICE_ID, WCC),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4364_DEVICE_ID, WCC_SEED),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_DEVICE_ID, BCA),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_2G_DEVICE_ID, BCA),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_5G_DEVICE_ID, BCA),


