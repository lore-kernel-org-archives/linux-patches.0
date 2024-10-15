Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388E91EF936;
	Tue, 15 Oct 2024 12:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994106; cv=none; b=GbtzCRqi9w46ixeD8VYJRC6A5tSxYZZuwXa9xXYIPAOeaY+n1Rh22TTyWOOnzK1HE4lWeBxBLPwx8wolfXdvnc4zDNqZESGr0WreAdujSYv3OI6oHID6yofMqYqIUNoFQ5Ja3RXuMhfSWN1xwsW5LhgW3UBg4hahA2lb2OjQxNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994106; c=relaxed/simple;
	bh=SoAwMoZcSZWS9QQHgyuSIndj8xTse7ji3Uny7MU3D6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NNgg8k+EoMzY+PnazZSpHFy4rlJL4rHtSiaUcrRmCY/jbyX0UQbOORcTCM9E5Jtvv+Q1AE1CbSzAfpuNLXZvYPtb6Ne8+63omwqriFfOwyt+tzJWQ2VMl8hBxPJH4dy3IHDvS6TQirfkUEjaMn+wrcWYcJavy2fSHRdBKQ+hWD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9TF87Gn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9TF87Gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998A8C4CEC6;
	Tue, 15 Oct 2024 12:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994106;
	bh=SoAwMoZcSZWS9QQHgyuSIndj8xTse7ji3Uny7MU3D6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9TF87GnONzIkPiGAsR/lsWGak0YXKOGPBBN38PyX8azQwzXfgl6hB6iRXc3/8yQV
	 FNauRzU6FbrgpzP+/E0r1MsKf10Czfy666esQbqD8Lk6kGjgl0y4TqbJS9rO6wHnov
	 d7xBn8WcEnhOkqSaKoUZBX4Hf9EgvSskkvqzlVgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subramanian Ananthanarayanan <quic_skananth@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 608/691] PCI: Add ACS quirk for Qualcomm SA8775P
Date: Tue, 15 Oct 2024 13:29:16 +0200
Message-ID: <20241015112504.471165907@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2d648967aa85f..965e2c9406dbd 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4946,6 +4946,8 @@ static const struct pci_dev_acs_enabled {
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



