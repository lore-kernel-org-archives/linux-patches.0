Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90C31A71F
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IADgf4tq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26EEC433C8;
	Mon,  9 Oct 2023 13:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858334;
	bh=AgldSrLe5ULYV04+GjlSJQWk0g3iD2iNG2MREOnGFrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IADgf4tq7vesqnF2SoyhbjKWDD4vRZB7fnJYgZ0aqljqBDOQQe8q0cDUjy7s9rKvl
	 0WmHy1MHK424fgN1dSRgfTD/HeO6RlyceZtbDDdZZXkb27rfeW8kXLLsZpppwfufXE
	 oLOm66uEkbEwaT8xx9Rx4CohOMlaf+Kd7zL6rQeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.4 090/131] Revert "PCI: qcom: Disable write access to read only registers for IP v2.3.3"
Date: Mon,  9 Oct 2023 15:02:10 +0200
Message-ID: <20231009130119.127189930@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 35c95eda7b6d9883d1cc9bb1f89d454baa140ebc which is
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
@@ -807,8 +807,6 @@ static int qcom_pcie_get_resources_2_4_0
 			return PTR_ERR(res->phy_ahb_reset);
 	}
 
-	dw_pcie_dbi_ro_wr_dis(pci);
-
 	return 0;
 }
 


