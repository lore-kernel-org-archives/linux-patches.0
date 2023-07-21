Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5058E20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC4BC433C8;
	Fri, 21 Jul 2023 19:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966887;
	bh=1p7n331KiUYPbTmEB4zBJQTSpxFqwCB1H6h/eV6QxWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fr1iNgoWAhKtqQyXMCWEzRqBLyOEtoscoA/6zTskGXJ+pvt0omrI1nPg0oo5ugass
	 uXjEezPwWWtrCrMg/Z5XgSfGqmwWkoDTCNjMXXtf8CruinWqbvSOkZFmm01zgzW+DT
	 aV70hL8iug5vR5369D8aFFT5QTDDh1GeAN3FSXdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 5.15 474/532] PCI: qcom: Disable write access to read only registers for IP v2.3.3
Date: Fri, 21 Jul 2023 18:06:18 +0200
Message-ID: <20230721160640.224289645@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit a33d700e8eea76c62120cb3dbf5e01328f18319a upstream.

In the post init sequence of v2.9.0, write access to read only registers
are not disabled after updating the registers. Fix it by disabling the
access after register update.

Link: https://lore.kernel.org/r/20230619150408.8468-2-manivannan.sadhasivam@linaro.org
Fixes: 5d76117f070d ("PCI: qcom: Add support for IPQ8074 PCIe controller")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1134,6 +1134,8 @@ static int qcom_pcie_post_init_2_3_3(str
 	writel(PCI_EXP_DEVCTL2_COMP_TMOUT_DIS, pci->dbi_base + offset +
 		PCI_EXP_DEVCTL2);
 
+	dw_pcie_dbi_ro_wr_dis(pci);
+
 	return 0;
 }
 


