Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B825466B01;
	Fri,  7 Aug 2026 14:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114720; cv=none; b=gvpT0dnHtEKJomucASA8fMrTiSLOJZczfBWy0oIEe4I3IelZp0yAM1Uqp1DvPIKTWHz4LiQNdFKkVF1dVRMRFTn5sUh2hqJ0lHK9mjCllT8AeaD2f5hGeBjLtrhRksn4C/7ZU2z+ABQfr6nh+9crvQ0v/6n7JyddEdG0q2o58/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114720; c=relaxed/simple;
	bh=ymD1SzkNdOuZmCq7Td+lWSFTzLfmuIeIN9/7g8f0XjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=um/GtgwmERqIdQ9rcG85e5AdsWKU7lVE+9fd0z26w3eKPFzi//hi+5sR7puxsOCDMrmInFBwAII27a8XcyVelaFRYiYbQKWC6GZxnLcuzwl2mIZVKxnIYzfZgUE8c5fMD1aoMgYMG73+Nw56VkghV9N1ckQk72LGiDJA2lkmTTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Im9CR2IO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Im9CR2IO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554381F000E9;
	Fri,  7 Aug 2026 14:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114718;
	bh=cWKGY9f+CyZwJ7jz+LTbb0OrgTrnf34tDeb3830bWbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Im9CR2IOQgc6UEZ1yuxNP/G8a3huq7FjDuTQrd+CKfdN3IrC9rRRE196xIE/rLY/C
	 cdpXr0izYfZbFaGenh5M50XyDZ3XgPstmp1nDPokmrVnYsi5+idq6DP1kpoNQ8n/5h
	 QflH+cFLy5QiJ1l7uB9Qn3crZIYRwbZd1anI9zgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/396] phy: qcom: m31-eusb2: Fix return value of init call
Date: Fri,  7 Aug 2026 16:33:04 +0200
Message-ID: <20260807143424.796530110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

[ Upstream commit 361f533a2dce2c2841fe4dc0c9d85a67117edf95 ]

The init call currently returns success irrespective of any failures
during repeater init or clock enablement. Return appropriate error value
in the init call failure path.

Fixes: 9c8504861cc4 ("phy: qcom: Add M31 based eUSB2 PHY driver")
Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Link: https://patch.msgid.link/20260718-m31-eusb2-fix-v1-1-8588a1b94d76@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-m31-eusb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c b/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
index 68f1ba8fec4ad..9434bd22ef32d 100644
--- a/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
@@ -221,7 +221,7 @@ static int m31eusb2_phy_init(struct phy *uphy)
 disable_vreg:
 	regulator_bulk_disable(M31_EUSB_NUM_VREGS, phy->vregs);
 
-	return 0;
+	return ret;
 }
 
 static int m31eusb2_phy_exit(struct phy *uphy)
-- 
2.53.0



