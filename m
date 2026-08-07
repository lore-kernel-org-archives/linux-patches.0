Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC497412C05;
	Fri,  7 Aug 2026 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116666; cv=none; b=t20dyS28U2KBhLXvK/YE8zpC4rCyLZP+0Lck87ibw8ZZ1zH+uzzK54bYj9aKC6YrgFnyTVgNusrUN5FmxA10ykXGjev78eeUhal/4dJIndEFxzJ3Zla1M10yk/H4hrYxU9Q0fZ6rDropuMT/ohs+A83wZmZNMIcmaOaI4fptwKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116666; c=relaxed/simple;
	bh=irGKIJ+C+n4gdtXzar7wprf1vzjNRYk5KtQGp5QYj2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxByjtqlw06P4px+8KQTsF3yCjbpaCrtZnEEMJmFpC2Rlw8Rpyi7pB0K9KnB+CqnYwgbfOupusGqy//D0iQLtPQtUC4DCnogLWDYKUCwdgbclqxPdyd6tPIi7azY511BjYhZs2t3mHCeho94jsI4MIjDSWIZsi+g27eLHszVb90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0eCbxMF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0eCbxMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CF51F000E9;
	Fri,  7 Aug 2026 15:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116665;
	bh=qaiHfhzuNpZTBTc69Fo1QlJoJpK2+YK2/2JTySNWNT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0eCbxMFN+rICLPm1PFwlDCc2ZkDsk4Rt6V3FBEWa66/lGTwl0rYlbql4OQ/NxGRA
	 2kSfu7nGHsD+vMAvJXUftQ+KLI6IqlD2bnYavgnYrSLCFJ/auqbQXHCuP2v9eW+xdd
	 KVT7qnmgKwFMScEYEof1dHjVMxyuHP4xxihDkfVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 021/438] phy: qcom: m31-eusb2: Fix return value of init call
Date: Fri,  7 Aug 2026 16:33:37 +0200
Message-ID: <20260807143428.461916055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



