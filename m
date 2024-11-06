Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9AA1E0DA1;
	Wed,  6 Nov 2024 13:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898760; cv=none; b=A/lovrL7JeprjiI9YaftwAnC4XOSjXmIvsQh/3oVIAcca4ywcPqfCAu4dJ6n5yunYcMTSWOZ84ffzunP/nMixmQYMCADiDKvCM0D8Pqo0h2PhPkb5YBGeW9NPi8VJBDzLhojsFvoFY6VIoLnQ1BttfXvpYh1tdSKBYlaIilGPMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898760; c=relaxed/simple;
	bh=hXC8nRbukWbMMOTEA75JLCUQ7B/iAIIF7hsyBfNRbeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XxwnwM0Z+/JE1eCwweWAXKbEkZeAMwnGKuxiyAUWo5D1IMZPYr7lHJzble8p7ateYBWIkkHLJeYUmDYqFq1l1ndgG6g+VoOCjHLC1pQuBwnLdKpumxIubd05HKwJsS9ndOr6rlM7ThKP+1tQ+LjzeobkATtPoRiASrOMtQtovkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hco6qW+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hco6qW+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A800C4CECD;
	Wed,  6 Nov 2024 13:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898760;
	bh=hXC8nRbukWbMMOTEA75JLCUQ7B/iAIIF7hsyBfNRbeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hco6qW+XMw+4Wurjr381PFGf+DrMzEuz9RHgh/uh+6a4ju/+7hxIBgzn9PXecxUkS
	 bKQY3JGzcKUpmHS1N9ze4rtkxXwWqk9A+bFjsMxD6VjeXc/DbvfjneE4EM+9sC+ZOO
	 Wov6uaZrCc6QJzfwi5Y6z/072fIPIKmbOVaESVpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subramanian Ananthanarayanan <quic_skananth@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 310/462] PCI: Add ACS quirk for Qualcomm SA8775P
Date: Wed,  6 Nov 2024 13:03:23 +0100
Message-ID: <20241106120339.182105304@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3bc7058404156..1e846b62feba5 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4957,6 +4957,8 @@ static const struct pci_dev_acs_enabled {
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



