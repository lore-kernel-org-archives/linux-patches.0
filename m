Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749D2466B0C;
	Sat, 12 Sep 2026 10:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210131; cv=none; b=BNmrAKGua8GRkrCHQeaH1aTW9nMTUTP0Za/p5f5n+5dYJAxqkGR5OcKDI4ylnFxZJ4SfaP1wATsRatm+nzgtitjsU9QiAqRWWI5kZ27CXsOiIUea/hItDpCJw6/w9UusFPRjRH5zXqd7zhYU68I1+T/WnbQo89EYGz4xzmsoS0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210131; c=relaxed/simple;
	bh=RdqAhbmOKMHAWeJAMKYddZiGya8EdE/pUlVA5B1E5u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9JMny5Ipi8RDBxbJ9Zug1gOjqqZk07asWotHZiQMeDiWDPzG106A/b9Kw7XXQw1AgbWwKz+kPKdFbLjmfqkXC/QGvTcvdQbY7R9bb8IBptxu9SUCbYu9ye8g+yRpvtloc+/By1AhkpWgDheGz4CRbLVr8iWcOPkY2uir7+MOvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrtIPdqh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrtIPdqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB8A1F0089C;
	Sat, 12 Sep 2026 10:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210128;
	bh=kbP9OgAezlhrbNkU2obb0Sa3e1rV39U/6DHm3ZF1hCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xrtIPdqh6/TjDpatBpRwvL0xyLhsDD5Hr42OWtETtXhVYiy0Z949fZkwnrUpTDrBM
	 bALUpTrvPtysGmBbeesjvNPlwvE/NhBZc4nhN9SO4Ck2d0OqIpGnqQ7Wc7LGPHbOab
	 MZ9L2+WjB+kdk24PYuR5UMpJcx6fwRDEMWiQksdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esteban Urrutia <esteuwu@proton.me>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0961/1518] phy: qcom: qmp-pcie: Add pcs_lane1 offset to V5 offsets
Date: Sat, 12 Sep 2026 08:52:10 +0200
Message-ID: <20260912065645.199685608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Esteban Urrutia <esteuwu@proton.me>

[ Upstream commit f8b4493d5e7e19682abcf538a9faad012b5ef69e ]

Some SoCs such as SM8475 write data to registers using this offset,
specifically SW_CTRL2 and MX_CTRL2.
Add pcs_lane1 offset to V5 offsets to support this.

Signed-off-by: Esteban Urrutia <esteuwu@proton.me>
Fixes: 0fd0b31965b0 ("phy: qualcomm: qmp-pcie: add support for SAR2130P")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260715-sm8475-bup-pcie-v2-2-48bd91a19abf@proton.me
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 62b1c845b6275..456cdb6e7213c 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -3288,6 +3288,7 @@ static const struct qmp_pcie_offsets qmp_pcie_offsets_v5 = {
 	.pcs_misc	= 0x0600,
 	.tx		= 0x0e00,
 	.rx		= 0x1000,
+	.pcs_lane1	= 0x1400,
 	.tx2		= 0x1600,
 	.rx2		= 0x1800,
 };
-- 
2.53.0



