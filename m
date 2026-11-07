Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064722;
	b=zPNgX6EBZIU/uOBC5B8beq8tyo1TnAQ4GezFNVULlVz1l0uF/2hD3ceZ27Y7EkMKylXi
	 KWQGtwb2zWwGfKxzOoE6HOfxF4F3YncUIVS3TxbGvhyz0taS4BhsqmELyOmlArO0aVSw3
	 c8BIkbhmdXMdjSV7mp/yWy84r0hvbn5C+vR4dVztrxI9R7TmNBt/6BKk3us+gKij7eVOl
	 EiqqY78TowxppZyN2XFNIR09UXDYifUy34HkLykCpqnrovJ9pZaimQcxsTpYMbfcd8e5W
	 j46P4Tux8pN8X/lbBubHrdPdC8n/kaf1G/D651MZVbtuIlm0PhGQsQWYDM83YbbRqvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X2iqdLWXs1QX66KV8jg87v682n8ct5pToPh/22quKpc=;
	b=0XtV546zaUM2ZaRySE86N9N3OXIdlV/ziseb1WdKFM4aK1C9Yjpa3gckZxxmZhHZWh79
	 b9i6rJF3NsE6zAxIJ8aaRUmbOUOaIOKx09RBVSMfMzLD3uYQpkMZeeYghrPzoB2DN0W0Z
	 908aD6/LkQpjA9B83yQZ+E8l8uFIunIOu289+xSDuPSzlAgjNAJyqMCF+bseRlo6x2GDg
	 oE+3WJbMKnPuiql6mcxi62efKzhSC+0uU9s11xpoZxZVXYmljr7WOBIV+IeaO3wqLURQw
	 /pEt1JRJTkVDoxY8+an/jtGhfHq5FD/lIrC76oXop7+ZlhAbAlV1EYzM9kA0Axov6hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lVSG/AjN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24F1606A333;
	Sat,  7 Nov 2026 15:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lVSG/AjN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC511F008AB;
	Sat,  7 Nov 2026 15:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064721;
	bh=X2iqdLWXs1QX66KV8jg87v682n8ct5pToPh/22quKpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lVSG/AjN1oZ0k9w8ajMGUkXDnCrDvbyUvyqRxPVM+2AwevLtOfuLu27Z9VCAi55Zq
	 bYVFQpRWCQ59TLXyQTffKxZL63KDL3zTFUziTDgpAYoOmnI4Jmck3rJYUhsDq7TDmp
	 v9hJkqpMJ/FlaC3o6hkWrx8cJgiiB51ccOPQApe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Luo Jie <jie.luo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0701/1257] clk: qcom: ipq-cmn-pll: Assign .num before accessing .hws
Date: Sat,  7 Nov 2026 08:49:57 -0500
Message-ID: <20261107134958.614170044@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit 231bbd135772390522be3656b34b49ea3039eccf ]

hw_data->hws[] is annotated with __counted_by(num), so hw_data->num
must hold the element count before the array is accessed.
ipq_cmn_pll_register_clks() assigns it only after storing the fixed
rate output clocks and the CMN PLL, and the unwind loop under
unregister_fixed_clk reads .hws[] with .num still zero. Both are
out-of-bounds accesses under CONFIG_UBSAN_BOUNDS.

Move the assignment to right after the allocation.

Fixes: f81715a4c87c ("clk: qcom: Add CMN PLL clock controller driver for IPQ SoC")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Reviewed-by: Luo Jie <jie.luo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/AS8P251MB000187BDFAD98A21F4C356E9C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/ipq-cmn-pll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/ipq-cmn-pll.c b/drivers/clk/qcom/ipq-cmn-pll.c
index dafe8c1738df8..a9abad9ff4e57 100644
--- a/drivers/clk/qcom/ipq-cmn-pll.c
+++ b/drivers/clk/qcom/ipq-cmn-pll.c
@@ -380,6 +380,8 @@ static int ipq_cmn_pll_register_clks(struct platform_device *pdev)
 	if (!hw_data)
 		return -ENOMEM;
 
+	hw_data->num = num_clks + 1;
+
 	/*
 	 * Register the CMN PLL clock, which is the parent clock of
 	 * the fixed rate output clocks.
@@ -406,7 +408,6 @@ static int ipq_cmn_pll_register_clks(struct platform_device *pdev)
 	 * is configured to 12 GHZ by DT property assigned-clock-rates-u64.
 	 */
 	hw_data->hws[CMN_PLL_CLK] = cmn_pll_hw;
-	hw_data->num = num_clks + 1;
 
 	ret = devm_of_clk_add_hw_provider(dev, of_clk_hw_onecell_get, hw_data);
 	if (ret)
-- 
2.53.0



