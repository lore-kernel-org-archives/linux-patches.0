Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6789B1AA7A5;
	Mon, 14 Oct 2024 14:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915908; cv=none; b=hZbfS1rFuZ4v8RXJ2+GEjWBKDuKMNlwGq/S0RRjWFciSZ20p/sDzgsCaF8E7NBL6ycOjaDFnNSjh7fUKiNN0BqvCZEu+1ZejvNdkfa9b3mRKeuuPLlpv056lZ/mVw2FSzQER0tXWH1IkDUVPo0uTcQAaAhMETuH+KXMb1LILwas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915908; c=relaxed/simple;
	bh=Nwgu/jLKF42JQwW3Py2qsLkUiZpKzGkYmKHBx+a+gME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a8JzLFLwsSz3ZFnKylw/Nxn3k+19K4xc4K0f6Np+ja4z7smC0jgKUwxGQ5Sc3LVK1A9zPgr/1ay1r0L6rnZvpBbHHsozdRXUlSMZZM1JY2J22dWSRgDB714a8k0BEkI2BjMjuIkupft9IcacR+D88Tjzdct4y+nP+B6KNYSggL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ix9g3d3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ix9g3d3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EE1C4CEC3;
	Mon, 14 Oct 2024 14:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915908;
	bh=Nwgu/jLKF42JQwW3Py2qsLkUiZpKzGkYmKHBx+a+gME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ix9g3d3Qap2JfDHVpBihjatHtnqN1LHJ6Pod++wPW9U2njkR8zR1Ije7SCK1RcVrp
	 lNvyah3U/Ba1HD2NnlicRvIr8Vmo+5dTaw/GmiYqlIYpXxrT12tKBcm1cemVYaCn4E
	 +WSJ+KcDFwq4dmKs/uIEU/XlNfcEWxxkmtY2a1Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subramanian Ananthanarayanan <quic_skananth@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 034/214] PCI: Add ACS quirk for Qualcomm SA8775P
Date: Mon, 14 Oct 2024 16:18:17 +0200
Message-ID: <20241014141046.319589978@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 979901a0e1f97..85666ee2d8691 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5087,6 +5087,8 @@ static const struct pci_dev_acs_enabled {
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



