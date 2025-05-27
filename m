Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9061EA91;
	Tue, 27 May 2025 17:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365346; cv=none; b=rzB2NPhCrzofAdlrAPMckDnPgo0TDQjxZfJoI6zKvtcceJg6E6rBqvtTdKn34Serg4Pd46N1UXYQt/NXZfLonrMvvdrqnxTBqqbPp0kzmxxaXcxBjOP4l6xnmxsw+V2c2Cgy1x2mAlHK38+vVyxyR4Eq0WmCdaVcUFdBsnsNsLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365346; c=relaxed/simple;
	bh=qb1NfWE66F8rNsULRbdIzQRH2IIT4lxBequHfl1jIOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rk9FBOayqC2CVuHdqymeZPIKwshSexcyJBVDoiv/6jQQiElQHKbYLxlB27RSjZwzhPABgS7hTCbROF7dKQqKh7H8gOHj8BKIjOn6btW3RBvUy0HWtbkCUc/k/3sMg8LOfr72DVWadag7Gyj32Fzj2JIzssYaIHv5SfrOkjkqCfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZK5xLG6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZK5xLG6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87628C4CEE9;
	Tue, 27 May 2025 17:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365345;
	bh=qb1NfWE66F8rNsULRbdIzQRH2IIT4lxBequHfl1jIOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZK5xLG6ZOY+28AhlKT8QognP/ogr83YNhScIiPw6wA+Xlt8HhD2fU+MdJLmwnroDq
	 EXTFJAr4hVGtkeQYzoW+5Ax7sWBPOjeyU/m3PZrsc2K3b+q99Me5VMHU/wlx6F74ML
	 uKRZ8C3Q+LwpVR75jpybAa7t7C5tZDlZczOwzggA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mrinmay Sarkar <quic_msarkar@quicinc.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 316/626] PCI: epf-mhi: Update device ID for SA8775P
Date: Tue, 27 May 2025 18:23:29 +0200
Message-ID: <20250527162457.870446390@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mrinmay Sarkar <quic_msarkar@quicinc.com>

[ Upstream commit 4f13dd9e2b1d2b317bb36704f8a7bd1d3017f7a2 ]

Update device ID for the Qcom SA8775P SoC.

Signed-off-by: Mrinmay Sarkar <quic_msarkar@quicinc.com>
Link: https://lore.kernel.org/r/20241205065422.2515086-3-quic_msarkar@quicinc.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-mhi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-mhi.c b/drivers/pci/endpoint/functions/pci-epf-mhi.c
index 54286a40bdfbf..6643a88c7a0ce 100644
--- a/drivers/pci/endpoint/functions/pci-epf-mhi.c
+++ b/drivers/pci/endpoint/functions/pci-epf-mhi.c
@@ -125,7 +125,7 @@ static const struct pci_epf_mhi_ep_info sm8450_info = {
 
 static struct pci_epf_header sa8775p_header = {
 	.vendorid = PCI_VENDOR_ID_QCOM,
-	.deviceid = 0x0306,               /* FIXME: Update deviceid for sa8775p EP */
+	.deviceid = 0x0116,
 	.baseclass_code = PCI_CLASS_OTHERS,
 	.interrupt_pin = PCI_INTERRUPT_INTA,
 };
-- 
2.39.5



