Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0712E498B;
	Tue, 15 Jul 2025 13:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586814; cv=none; b=s8qVM5tWmdrflId9mK+pos1S3Lil05usooQtdiNZ0GOniyYziks2Z0q1RSY+L5IOgI+ffXTbhft9e0KRXb7rXHTokFcQsD4f3wboGw0YeiSEqPFuvzxiTjU7PmCh32klogwzCu2wxPT1dd9EUTLBH8foQNP2ZMGBfafVvqAGMhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586814; c=relaxed/simple;
	bh=5Y0inInMKQ/vgcxB+EWKsc0MBW2qARQA3TzIhe12lIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXnk4JOXkHuSrGslFNq/jydpjYXooKzk/eG7QSTVJDromT7YCd2goJchWDdErVWRuYysCNCxAn9aChwN9cUMPdzn3CIqh4FYjnmaSYlUf88cbozDSv4q6kFARNTOW6DCsAGsUqs6EpnlBRMu22zNqjjI/2W2Q0EGrF84tKAuPAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2VGomMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2VGomMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F31AC4CEE3;
	Tue, 15 Jul 2025 13:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586814;
	bh=5Y0inInMKQ/vgcxB+EWKsc0MBW2qARQA3TzIhe12lIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2VGomMswKmAwuK9KKRtd44vVEcJWUcHmEYZ0KdzFu64aNJEVp/nEk8ZSvpDneVBh
	 AkrQjDFKnLhMlbtMtQzCCMzQW865n7fRyGvCKveIxjbOj81o7cs8FJb+aG33QvcufU
	 NtBJD9dPYJmRLMnwaR9l/w/WD+uVz1i2bD8OL51g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Jie <quic_luoj@quicinc.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 027/192] net: phy: qcom: qca808x: Fix WoL issue by utilizing at8031_set_wol()
Date: Tue, 15 Jul 2025 15:12:02 +0200
Message-ID: <20250715130815.953045439@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 71498c518f0fe..6de16c0eaa089 100644
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



