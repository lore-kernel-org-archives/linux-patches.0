Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4A01C1ADB;
	Mon, 14 Oct 2024 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919872; cv=none; b=jutTPE7zPfdAjSzQW6rV/PuLRReTeQbCB1MoDQkTiBCNcNy9fSCpjcb1H6xCs03GOWGfCCZWgUXZSCphmP7CMu9jFRnDi0FqQkntWsecUP07Qkfa7qAku4L8kBVum/5yKOtDoS5q/EsqI6PfIq12qgHzZQe1/wLcs7hqSUUZjLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919872; c=relaxed/simple;
	bh=Mv/OwGGjI28OBvr6LjYLTKQRE8S5NYCnm0pz6okIEZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VdI9Z1JsPPKSnJHl8cfrgOflExVQv7dl/64fftCYHH2PkzH/diMaum+fr3ETzechr4MZ1QmecuCyPfV+s4no45DFfUy12FtpNdNnVJf3+lJKFUqS8FolIw4/vQSzNtdRwbqxIYg2dzZ26mVvqaTmDjAumAyQG8r0crq6ZM6VgmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkzsvAd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkzsvAd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36994C4CEC3;
	Mon, 14 Oct 2024 15:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919872;
	bh=Mv/OwGGjI28OBvr6LjYLTKQRE8S5NYCnm0pz6okIEZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkzsvAd1gt/4LY5U3PJ9RGYA+mHM5dhs2XwxbDEaq0xitK0K0gxKO2C0JEQXDFwGl
	 TbAak4zIN5ubXrWSx1CtS36WEwsMSBzuKlpqliTeoLDzhCv4YNqBthgsIyEFFtwq1j
	 LazxKubLeJLEBqUUfQRI89LZqCTWXRmP8Arx9G2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subramanian Ananthanarayanan <quic_skananth@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 700/798] PCI: Add ACS quirk for Qualcomm SA8775P
Date: Mon, 14 Oct 2024 16:20:54 +0200
Message-ID: <20241014141245.570896110@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subramanian Ananthanarayanan <quic_skananth@quicinc.com>

[ Upstream commit 026f84d3fa62d215b11cbeb5a5d97df941e93b5c ]

The Qualcomm SA8775P root ports don't advertise an ACS capability, but they
do provide ACS-like features to disable peer transactions and validate bus
numbers in requests.

Thus, add an ACS quirk for the SA8775P.

Link: https://lore.kernel.org/linux-pci/20240906052228.1829485-1-quic_skananth@quicinc.com
Signed-off-by: Subramanian Ananthanarayanan <quic_skananth@quicinc.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7ebce76778f71..131c75769b993 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4972,6 +4972,8 @@ static const struct pci_dev_acs_enabled {
 	/* QCOM QDF2xxx root ports */
 	{ PCI_VENDOR_ID_QCOM, 0x0400, pci_quirk_qcom_rp_acs },
 	{ PCI_VENDOR_ID_QCOM, 0x0401, pci_quirk_qcom_rp_acs },
+	/* QCOM SA8775P root port */
+	{ PCI_VENDOR_ID_QCOM, 0x0115, pci_quirk_qcom_rp_acs },
 	/* HXT SD4800 root ports. The ACS design is same as QCOM QDF2xxx */
 	{ PCI_VENDOR_ID_HXT, 0x0401, pci_quirk_qcom_rp_acs },
 	/* Intel PCH root ports */
-- 
2.43.0



