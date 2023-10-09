Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8AE34183
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jmaUGa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B95C433CB;
	Mon,  9 Oct 2023 13:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859152;
	bh=rqylnQsHVvAbJ2PoeeEMQqaLShmCTKz5nsygdZa8BJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jmaUGa8mPFSeqCmpoLSdAPBF/yDO18JMSr4yAOrhjucTDqIw9Wdx5p18A4rifm/4
	 X6EZGquCOvtGqlvo1gPLJkBpRqc+87VMNXVgOPo1uKDArS2IsNmjZj1KyYXZ7i98rC
	 AADUz5A6C6CG2+zFiPxp1FvmvQBflLTFYmhkEKj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 178/226] Revert "PCI: qcom: Disable write access to read only registers for IP v2.3.3"
Date: Mon,  9 Oct 2023 15:02:19 +0200
Message-ID: <20231009130131.286567507@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 48e11e7c81b91002a120a513312a4de9f5ba7f08 which is
commit a33d700e8eea76c62120cb3dbf5e01328f18319a upstream.

It was applied to the incorrect function as the original function the
commit changed is not in this kernel branch.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Link: https://lore.kernel.org/r/f23affddab4d8b3cc07508f2d8735d88d823821d.camel@decadent.org.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -771,8 +771,6 @@ static int qcom_pcie_get_resources_2_4_0
 			return PTR_ERR(res->phy_ahb_reset);
 	}
 
-	dw_pcie_dbi_ro_wr_dis(pci);
-
 	return 0;
 }
 


