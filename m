Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8755B1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F92C433C9;
	Fri, 21 Jul 2023 16:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956342;
	bh=Azn/iyG04MtMTv3oTqSeSfAQiDTge9ISj8jyKXCYGQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHy6wWufwRb06gjIctNEEhaxvNWko9L5vfG3hj/EsAfftnuMgJQ3zncV8uHTzpEWT
	 doyE3wI+kIwbZSt55sG7PK7yRXK67MRHPPs7r9uD8HeCWJFWSPWJNlRPQCf+qycJDc
	 Z0SqWFifp3y8qvDNSbxv0wbzRsMJVf6N5YUV6ISo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 6.4 173/292] PCI: qcom: Disable write access to read only registers for IP v2.3.3
Date: Fri, 21 Jul 2023 18:04:42 +0200
Message-ID: <20230721160536.334785645@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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
@@ -834,6 +834,8 @@ static int qcom_pcie_post_init_2_3_3(str
 	writel(PCI_EXP_DEVCTL2_COMP_TMOUT_DIS, pci->dbi_base + offset +
 		PCI_EXP_DEVCTL2);
 
+	dw_pcie_dbi_ro_wr_dis(pci);
+
 	return 0;
 }
 


