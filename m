Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E957261B;
	Tue, 15 Jul 2025 13:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585404; cv=none; b=n86xb7o7pvsfKpYRdrh9q6UmP6gHW//pPjw0w1KStUfYGjr8r+oJ+jSZmdVEb+mdldP4Q5wWuIEhLQGSaDRBQ7FUMBcLDyMaUfvXwgk03nPAwOau0kbG2eW1dIsH4aueU2N0QqWSLUVnzFHF57HXjmVeAWUiKV//n2RDAH+sdsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585404; c=relaxed/simple;
	bh=VTqa2kDPbCEyeF2Rm+nDA/drygvTTknTub0b28XBn5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPruM8zlchnfmiU0S3q/79JzXtcFgs4VgdZWLVlhAzO+cPZxV7XMMXGn1lxouWSeZYTQ9aWujpDQrTZae20LUxDLlOTAT5630u/nYtUm+THZkYC0c65HVom+RUegMD327WV5qelmKxAqczMVBUejtKt0tw5zos04ZIKpVww19K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjL0Wk/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjL0Wk/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0493C4CEE3;
	Tue, 15 Jul 2025 13:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585404;
	bh=VTqa2kDPbCEyeF2Rm+nDA/drygvTTknTub0b28XBn5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjL0Wk/t1aU+aRKfENY83E34T5ev6gaax4q76JqCB2aFIw3m097UVEM2umjdKyxHH
	 3wxOZO1mzYoEKRYZQ3cZ7yWEz1RqFS3OgSOBd0bWQPHgWplc1NCXeAE6LBz7Z4xvyH
	 cnMrwfo3oNC2U7XNRwhmubocgKUvKJCY83AWfhJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Jie <quic_luoj@quicinc.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/163] net: phy: qcom: qca808x: Fix WoL issue by utilizing at8031_set_wol()
Date: Tue, 15 Jul 2025 15:11:36 +0200
Message-ID: <20250715130809.886776381@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Jie <quic_luoj@quicinc.com>

[ Upstream commit 4ab9ada765b7acb5cd02fe27632ec2586b7868ee ]

The previous commit unintentionally removed the code responsible for
enabling WoL via MMD3 register 0x8012 BIT5. As a result, Wake-on-LAN
(WoL) support for the QCA808X PHY is no longer functional.

The WoL (Wake-on-LAN) feature for the QCA808X PHY is enabled via MMD3
register 0x8012, BIT5. This implementation is aligned with the approach
used in at8031_set_wol().

Fixes: e58f30246c35 ("net: phy: at803x: fix the wol setting functions")
Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250704-qcom_phy_wol_support-v1-2-053342b1538d@quicinc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/qcom/qca808x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/qcom/qca808x.c b/drivers/net/phy/qcom/qca808x.c
index 5048304ccc9e8..c3aad0e6b700a 100644
--- a/drivers/net/phy/qcom/qca808x.c
+++ b/drivers/net/phy/qcom/qca808x.c
@@ -633,7 +633,7 @@ static struct phy_driver qca808x_driver[] = {
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
-	.set_wol		= at803x_set_wol,
+	.set_wol		= at8031_set_wol,
 	.get_wol		= at803x_get_wol,
 	.get_features		= qca808x_get_features,
 	.config_aneg		= qca808x_config_aneg,
-- 
2.39.5



