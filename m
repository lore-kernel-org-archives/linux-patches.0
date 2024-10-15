Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF56E1DD0FE;
	Tue, 15 Oct 2024 13:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998373; cv=none; b=hmqLmzUOKl/ved9U2UOHlxgXF2M+O/OoGcMlVVuvH0dsS5regGWqNjLYQ6nVU3TM/6gUB6DeLY/ya+8Cw6zJAKMKMUHbKT7aF+zrfEE7OsnyYu/X2mQARlKWOlPxNpkGqXk78+B4ABxQu1gleGwj1DOJXg7uDvTbBU/dIkSYCYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998373; c=relaxed/simple;
	bh=ekATTEkqvqbF0SHjP911IS2FJ1VrIcZ46TbbFIs3Ny8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n26WOCsjVVCIut9HUz/+hlZWYSUwMChMIGT88Mwzym5FH459JbK/aaRVlQe5POy2WfLLHk05trQuMNi95VQr2YEqGghEma1cxRupb8ybtkDc0uVrh+QL0/d8cErzHa5Yuk3mfTV6Na5Lq08ZQKElDUiRWhXbBYf6wmt23UEWSs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aociSkBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aociSkBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D983C4CEC6;
	Tue, 15 Oct 2024 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998372;
	bh=ekATTEkqvqbF0SHjP911IS2FJ1VrIcZ46TbbFIs3Ny8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aociSkBkVyK8+OU09FdlA93ZShRNiF01gXmbsC9RCUZwl/0nrGs6RBSmcWyZKKnx/
	 3jP638ltazoJOvTiwLdsUfADylht3eyCLB1sA5ShXEsbHXVA5Wr1t6x0cQzrNUnbI8
	 PAt6/KuRtTQ20cGI5Ho8WqylT0AFKFdEA+Hw79zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subramanian Ananthanarayanan <quic_skananth@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 458/518] PCI: Add ACS quirk for Qualcomm SA8775P
Date: Tue, 15 Oct 2024 14:46:02 +0200
Message-ID: <20241015123934.683573955@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6f782734bb6e6..f0bbdc72255ed 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4920,6 +4920,8 @@ static const struct pci_dev_acs_enabled {
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



