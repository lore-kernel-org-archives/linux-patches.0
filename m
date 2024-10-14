Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD8D1ABEBA;
	Mon, 14 Oct 2024 14:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916914; cv=none; b=Zu5RRMvppm8AonMwSWky4v8G4Zkq8aU/OcWidMdGrbgddTzBvXSpEQ94f8x5JFPHNrVsoyDWHWJepLp+Uhk4dY5FBQOhdd4TEZp0DM+y517PLsnt9HslTbqLLML+ovA7SLgvIeb1PpMX76mkDfat0Jjh11cKDCpJtLv4c8USiwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916914; c=relaxed/simple;
	bh=3ksP918lUtu8ckSBuhRLmUldy3uArrflFaAz16u7tDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HGs6vpdyN9Lk9VMJb32cpF/b1KGPMnHIs4qV1+E0n0aMLpcpsOYR5N+OsKBjmwpi4mOufO1SsPNGBgj8WMLepNXWTgb6HGK3YrInMmACAIHsyl2Ds4g5HOlpI5emnimNCgkYGdnQ4Vivx8VnIzQYOBJVSiM+N2iCArkoUIr5le4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvbwhnNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvbwhnNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2C2C4CEC3;
	Mon, 14 Oct 2024 14:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916913;
	bh=3ksP918lUtu8ckSBuhRLmUldy3uArrflFaAz16u7tDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvbwhnNVaHMuXdnz3cSG9sIFtLSoTG34w/HlLc2voUlwvsABrrwzGGLFbXx2j433k
	 K5s9FzF/7ha3WfkjuJhJctqpBcILECRhU80zNtFHJW/bezR+z88DM06Ss4K8NJFzuV
	 C7O3FKX7y2MWpeJ2G/lJkYQ7G84V8S2L9J3Bzlak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subramanian Ananthanarayanan <quic_skananth@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/213] PCI: Add ACS quirk for Qualcomm SA8775P
Date: Mon, 14 Oct 2024 16:19:39 +0200
Message-ID: <20241014141045.832942670@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a35f72b443cef..486efe7b7cae1 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5080,6 +5080,8 @@ static const struct pci_dev_acs_enabled {
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



