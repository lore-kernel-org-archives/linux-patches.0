Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052555;
	b=LCfkoux2NK0j0Y3wnwjt2Pfh319SSOgE94TqwWPGxjWu8yIzBvtm0+sRwJqUaJ9MjwyL
	 M3iShrQ4lFl6Yz4osDX5xD7rNrdnj6v2uaFBLHwFtPCFfOXnHENNqoev4YDu35O0dYKEs
	 6d53evbbX7cBI7nZJfO1/AFePzBZ2ZYlGn50ysIDOiQtlSNDPCgQe+6eFWe+A4clSX418
	 I4Pfz46OHO90VjXeHENoViGKc2x5Uz89ZjvxQoeXMmZoUMqp7m2EjcR0J1jv7Y47alteN
	 a1vCL9dnmga8EoZiQSD2SbsaPMmtb60g4ZEygGYA0zVhiyCYW6oQ6w9yhHdF8RNPR/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1jXY3oNlAoAFv0p8OH5jqjPKcpo/yLb2kKlOg5II+cI=;
	b=xLIal47/jiCqdn1/T+3CAFFHRs8B0BcthzMN+5jhRGb5SwkyTGM5HSGFrIQew0Isg/V+
	 UdMux+2RIYHAtsHycMYcyw312/9M8X+8K6gUTsbuhtbFrtKMF/lLw/i/jBnohLFv3oH2n
	 L/yKFQNnZZiM4kfneBkDkApOhjol7LmHirFDPY/Bo/DzTgs/7G/Tbxh1iGuJ/XwNjrMsM
	 GIEJ5RbYPYZyjXLauCC0cgtq8Z/GKFyv5WzuolHY2yCykOOtCEhFAgbiM0SDP3Er3wkdT
	 boziPdGj4KS7C6FljAfby24WXrnANgWmAw+vFoGbfpPM8udQ5cK9dXEopG6ZdXEuQ7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMgMP6SA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B577606A31C;
	Thu, 19 Nov 2026 01:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMgMP6SA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4462D1F000C4;
	Thu, 19 Nov 2026 01:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052554;
	bh=1jXY3oNlAoAFv0p8OH5jqjPKcpo/yLb2kKlOg5II+cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMgMP6SANmuuXHcZshqXopDdSLgNAqThy8tGeQL3o9Z5s/E/6Tsn0c3v9PZzok9t4
	 G/bdVOhnIQVqklatFCkjDOKpVuW+4SV228eDjtg2ajEG3sDJwz17KHcl4FJpWD4Ym3
	 Frml92jVXmY/GaclrP/KQdGYc/T6QrAS65soQv8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0604/2214] clk: imx: Fix clock reference leak in imx_obtain_fixed_clock_hw()
Date: Wed, 18 Nov 2026 15:38:00 +0100
Message-ID: <20261118150035.208942536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 52d4d1b26a5bc64de95099d0a3dd8b90dba1f3a3 ]

imx_obtain_fixed_clock_hw() obtains the clock through
imx_obtain_fixed_clock_from_dt(), which creates a consumer reference
via of_clk_get_from_provider(). The reference is discarded right after
__clk_get_hw() returns the hardware pointer, leaking it.

Keep the imx_clk_fixed() fallback unchanged and drop the DT-obtained
consumer reference with clk_put() once the hardware pointer has been
extracted.

Fixes: a4a4069f4523 ("clk: imx: Add imx_obtain_fixed_clock clk_hw based variant")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260915055631.1730231-1-vulab@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk.c b/drivers/clk/imx/clk.c
index 0a375fbca9e51..990c949685d76 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -100,11 +100,16 @@ struct clk_hw *imx_obtain_fixed_clock_hw(
 			const char *name, unsigned long rate)
 {
 	struct clk *clk;
+	struct clk_hw *hw;
 
 	clk = imx_obtain_fixed_clock_from_dt(name);
 	if (IS_ERR(clk))
-		clk = imx_clk_fixed(name, rate);
-	return __clk_get_hw(clk);
+		return __clk_get_hw(imx_clk_fixed(name, rate));
+
+	hw = __clk_get_hw(clk);
+	clk_put(clk);
+
+	return hw;
 }
 
 struct clk_hw * imx_obtain_fixed_clk_hw(struct device_node *np,
-- 
2.53.0



