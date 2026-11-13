Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590714;
	b=1epTPnTbkBSTwkLtBpbxAUqMG2I6rUk2Hv49J0ev/bdHRSYhBQFFcPKRf9GkIVSfFb7Z
	 w9c4hIpINyT5VW4DF0DiR9UHMVEN5Wwx2mH7kw7m78zdYKUR2SmPs0u+jzekfKmLP9xpU
	 HW00PZCivjSV++vp6RZP9Icd7/CvQFr9feHuybmme6HivUY66Ro4VA3xVdGIsS+4J6U92
	 62usE46943ySp53DKXbokJJ45cKLJjCWiU1OdAi1rY0sbJX60rNab9yyaQAKVm5pIc9Ah
	 YL0ovr4cmP02Cpsd7N/0pzQOjSEgTV3a19y1tw+ivgGNMnXS3hLr+5pkGFVrS4n1VQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nZwYdcFdn9QU3N9HQkf9eWljWHWLY2qaUz/tNCxAVJQ=;
	b=PaMcZfaWaTr5K2DlmfS7BrLqmWJsw4ooqftzpD18RmZjh4yHrdnoNEms/kVS6J0O85Sh
	 ftvq0BmFpoeF+P4JpfyicnWxMLqSp64XmRrziJiTVpOtLo1jYLEeMHo3+Dr14Gi0LOH1g
	 zP4c3/WzLdcdjDB6PtEV1LtI+z1ZPeT0OsDxRA9Vj41C+ebz+o2HX76ory0g0nWf7N6kc
	 WMniIXykkG0PSQau15rfvo5AzhKcigWTWeUNeNJ2bZCug/f2NS01SXrmP67DjJzz4PWUZ
	 6Fuo2o6u6Yn6aqdfoOCYOt2ykD4rMCLissv8+AchY3TQbls6toQ1E9LW2ewem4VNIDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O/PMKGsX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16B8606A338;
	Fri, 13 Nov 2026 17:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O/PMKGsX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3861F000C6;
	Fri, 13 Nov 2026 17:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590714;
	bh=nZwYdcFdn9QU3N9HQkf9eWljWHWLY2qaUz/tNCxAVJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/PMKGsXOS3s/fCLJ8Q42aEZnCh17ccDPHyLLCBnchd99GKUUOH6t8bOHhnv8dtzW
	 YTJeRpG74mCQMj5uX/xyyhLoCLbrCNrxMqOxxM3MUBn4CKO+58nL9eWvo9ZCW0jrBR
	 0Y322babQdk15B+HCwQ8W8MjpZeIYGiu2yCHfqxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 622/686] nvmem: rockchip-otp: alloc clks with main struct
Date: Fri, 13 Nov 2026 10:52:35 -0500
Message-ID: <20261113153842.937289129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 9f99bb979f930e52e6861114fe03535d4bc2f374 ]

Use a flexible array member to simplify allocation slightly. No need for
a separate calloc.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530205333.117458-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 9fc6a1592d84 ("nvmem: rockchip-otp: Serialize reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/rockchip-otp.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/nvmem/rockchip-otp.c b/drivers/nvmem/rockchip-otp.c
index d88f12c532426..00921b9fe9aae 100644
--- a/drivers/nvmem/rockchip-otp.c
+++ b/drivers/nvmem/rockchip-otp.c
@@ -77,9 +77,9 @@ struct rockchip_data {
 struct rockchip_otp {
 	struct device *dev;
 	void __iomem *base;
-	struct clk_bulk_data *clks;
 	struct reset_control *rst;
 	const struct rockchip_data *data;
+	struct clk_bulk_data clks[];
 };
 
 static int rockchip_otp_reset(struct rockchip_otp *otp)
@@ -327,7 +327,7 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 	if (!data)
 		return dev_err_probe(dev, -EINVAL, "failed to get match data\n");
 
-	otp = devm_kzalloc(&pdev->dev, sizeof(struct rockchip_otp),
+	otp = devm_kzalloc(&pdev->dev, struct_size(otp, clks, data->num_clks),
 			   GFP_KERNEL);
 	if (!otp)
 		return -ENOMEM;
@@ -339,11 +339,6 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(otp->base),
 				     "failed to ioremap resource\n");
 
-	otp->clks = devm_kcalloc(dev, data->num_clks, sizeof(*otp->clks),
-				 GFP_KERNEL);
-	if (!otp->clks)
-		return -ENOMEM;
-
 	for (i = 0; i < data->num_clks; ++i)
 		otp->clks[i].id = data->clks[i];
 
-- 
2.53.0



