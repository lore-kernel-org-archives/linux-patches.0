Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063853;
	b=Nexgb4ESfMgQJ5XL2HXV/vvoF1q5XgGDz5tRB5W1fXZArUrMhMlHS99PSS00egqSv/hk
	 U3lNyuNtKSTfGeyvKnwDppvc6kc/9dR1MEUB2R/Q5oa9nvSau6qUNvN0MofqjEsk6Lolh
	 7iS1wXCsOGytKKbHrV00s3Jn5Ijq1u7sliIh2zSf54S9elW2WC7MoW2BreXMdR1H1tZOe
	 DzJXsBKY0ldgDzIKPVyFMC82T0Uquoduz3b8sMeEVbT3mq5tJo2QSPqhJ1054hy5KAW8f
	 35+cWAUW/093Rw8gneZdozJDXfH70bUIEZUD6iAPvRlU1jiFnl9F5+f50AKxFz4f4Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQ92FIBNVW1GN0eCuttiE/xf+CTX/AzTej7RQTIv0iY=;
	b=scQUZDOKtOPLqB/JECbZDFaQHL/jNk6BeLMJRFp91VwsCIQPFpnAGBIqhmLVlUy0ILBS
	 qJTTsrUo6OoiL3q6pyPqj6mJWnSg9fzqjwLmfuh0r+a0MiSM4yGZKzgzNZfZMNKSEdhMN
	 b0Ad7VxKyyTgdfL1PXAK/B3TLsp9pueeXMYx7MqEFb06DKQOAF3EBjwH0y8LYddzT3n5d
	 Pc7qL92eytRXCVmqKL+v/LHDXKhA+DMRjpxN3bbScgOdLXsxhTpBoGSoAnitsvDUhnySN
	 wNPQ1yjHbnlTwbAS0A9mGyV2vpYpZsM7VshWnm0zP5NM2xliwD+fsP0x4u2Fq4A/aBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gR/b98Ti";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2541606A9CC;
	Sat,  7 Nov 2026 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gR/b98Ti
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7B61F0089F;
	Sat,  7 Nov 2026 15:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063853;
	bh=ZQ92FIBNVW1GN0eCuttiE/xf+CTX/AzTej7RQTIv0iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gR/b98TiDkstG0UxYDhkPRNsA3Hvp1bRSbJOQlxPcPevsTIYKBCXO6G0pR1rx2q6f
	 aZNq24ugmMJj58kGE8t4aW8YC9oDqOGpWSc1hD+GALc+6IBCCiKzj38wxrBkcIwRq/
	 5NM3GVGbTrHrh8Ue1Z5ITf/20FBaQKmaWD08rYyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hanzhijian <hanzhijian1991@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0062/1257] clk: mstar: msc313-mpll: fix off-by-one in clock array allocation
Date: Sat,  7 Nov 2026 08:39:18 -0500
Message-ID: <20261107134941.110827360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hanzhijian <hanzhijian1991@gmail.com>

[ Upstream commit 712b75152c00a8ab0c56dbfe34caf88e3870ddde ]

The hws array of mpll->clk_data is allocated with struct_size() using
ARRAY_SIZE(output_dividers) as the element count, giving it 7 elements.
But the probe function stores the MPLL clock at hws[0] and one
fixed-factor clock for each output divider at hws[i + 1] for i in
[0, ARRAY_SIZE(output_dividers)), writing 8 elements in total.  The
final write to hws[7] is past the end of the allocation.

clk_data->num is also set to NUMOUTPUTS (8), so the clock framework
reads hws[0..7], again accessing hws[7] out of bounds.

Use NUMOUTPUTS as the element count so the allocation matches the
number of clocks actually stored and exposed.

Found by smatch:
  drivers/clk/mstar/clk-msc313-mpll.c:134 msc313_mpll_probe()
  error: buffer overflow 'mpll->clk_data->hws' 7 <= 7

Fixes: bef7a78da716 ("clk: mstar: MStar/SigmaStar MPLL driver")
Cc: stable@vger.kernel.org
Signed-off-by: hanzhijian <hanzhijian1991@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mstar/clk-msc313-mpll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mstar/clk-msc313-mpll.c b/drivers/clk/mstar/clk-msc313-mpll.c
index 61beb4e875250..bd45aa0aec011 100644
--- a/drivers/clk/mstar/clk-msc313-mpll.c
+++ b/drivers/clk/mstar/clk-msc313-mpll.c
@@ -105,7 +105,7 @@ static int msc313_mpll_probe(struct platform_device *pdev)
 		return PTR_ERR(mpll->loop_div_second);
 
 	mpll->clk_data = devm_kzalloc(dev, struct_size(mpll->clk_data, hws,
-			ARRAY_SIZE(output_dividers)), GFP_KERNEL);
+				NUMOUTPUTS), GFP_KERNEL);
 	if (!mpll->clk_data)
 		return -ENOMEM;
 
-- 
2.53.0



