Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543AA1E1336;
	Wed,  6 Nov 2024 13:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898316; cv=none; b=fhj9e9kWK9V7LceOHPpSMaU91DF09R/je8xfjgjC4uMxnrepr7EBRXFIGiqym1cr1jjtjAZsWG+0nqXqd13DbfNPEcLJ/qekf0JKjD2FVY2KDQT/i794s5MkMOtZ2rfWQy6eY2lToPDfTFliwRgS5NtAfkf/dQVEiqzRBl5Gfg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898316; c=relaxed/simple;
	bh=Fv2Uq4J5ZLMMKikllU4UC6Dy5GvctJfnc32umAAbyNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhKtE56QYyDNEhk5mxFi8ASt8tTf0wBAiY2YY/Roc+RCO/Bi2ylrxUBCbq4iPyvPXnE4yarPRo5r3ZFcGxsRDlzG6cHt4IJbrhYepjrGgdXVP3yMtOq9fo0WxA+81ddMk9LtwOl3Dk02JNKz9wGlyewX2UyHqQsJ88g2fFbB2B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqLaz7gN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqLaz7gN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D0AC4CECD;
	Wed,  6 Nov 2024 13:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898316;
	bh=Fv2Uq4J5ZLMMKikllU4UC6Dy5GvctJfnc32umAAbyNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqLaz7gNU5lCYI2uVRXUXAhPBWEC5aIJXpZQiDq5ClP0+xi7hAWDo2fafIlSF2mIC
	 YU5bR67kHWJMjmDF2z9RICOA7B33OTGT6OkTRlLYbSVyo9f7Nk2oTs/DR+d60maIAT
	 pHG2agg19JJcJGFAhAlardaiXusTS7VO3OHTf/uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 198/462] net: hisilicon: hns_dsaf_mac: fix OF node leak in hns_mac_get_info()
Date: Wed,  6 Nov 2024 13:01:31 +0100
Message-ID: <20241106120336.407491284@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 5680cf8d34e1552df987e2f4bb1bff0b2a8c8b11 ]

Driver is leaking OF node reference from
of_parse_phandle_with_fixed_args() in hns_mac_get_info().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240827144421.52852-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index e34245649057e..b3733d7a7d81c 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -933,6 +933,7 @@ static int hns_mac_get_info(struct hns_mac_cb *mac_cb)
 			mac_cb->cpld_ctrl = NULL;
 		} else {
 			syscon = syscon_node_to_regmap(cpld_args.np);
+			of_node_put(cpld_args.np);
 			if (IS_ERR_OR_NULL(syscon)) {
 				dev_dbg(mac_cb->dev, "no cpld-syscon found!\n");
 				mac_cb->cpld_ctrl = NULL;
-- 
2.43.0



