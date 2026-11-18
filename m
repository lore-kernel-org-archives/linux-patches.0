Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058571;
	b=cLZ7vI0/vNAX3V6iIxEHmO/62NtKkIgalCv9bnN3FwH2fXhXeaal2jZBp24KZ2pgcCHP
	 F6oiDLrMhOj5GGb0W79SsvRZPKmLuFnGwAEzf8X/tnyPKW9b45CtzmkOqQSFOw83Wvmxd
	 qd6MCO/fBUAm1Ws9oovvzUJ3u2rUXn06b5+2NL+X9MkEB/1Yo1teAiOy57hLV1O1UwaDj
	 JUJ3AakoagX8+MywUbF8NQejZ3An5rUom69auOCu0/i5hmmj5WLaJ84mG7dogXbfjPmMn
	 zyAoAyD4JzN8lsuNSeRmURA9tlbY6bLztOPkG/Kxh1ij/tlZGEtwBoH5O1O0xPho68A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AZH+pABiNTRwszNvZJZdDHUTpiRCcYpPjx9ZULkOPbk=;
	b=RaZJwPBambRfwZuuoqH0HltcNie7R2Znd+c9GxWqEOQJFm4xs34gg7u0nk8yAoY14dlO
	 Krq7AF8CN93VFEAo3qX7+WcG3Ubm6YH4ctG6UMdhD4CzI3DchzNHdZGjZlB6TxJYofO/3
	 +p8abKzQP/8G1YLBV9ki0/ebIe5ZcDq9GtSK0DxMfRJ15OPk+tTAJqPKe2HNun3xNrDA3
	 d6hZ5S2W69DxptVkg0cPvgeSFyud4MiUPZ9MiUOYIIWRJf4d+edSdZdo5H2EsQo0f5qYR
	 MiVSyLrbntC5jTejX25t+go/ymPERMbGfsAFSDq2kddrW5yPHeBolOpx4DFLCulodqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dq4smt0w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65CD606A32F;
	Thu, 19 Nov 2026 03:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dq4smt0w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046A51F000C4;
	Thu, 19 Nov 2026 03:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058571;
	bh=AZH+pABiNTRwszNvZJZdDHUTpiRCcYpPjx9ZULkOPbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dq4smt0wnzwAdqzuFVj0YKIIONSram5aqYiE0woGgxJ7ALwEElR8xoz7mg6AzHldQ
	 omEfJy7B+eJeK+SFp9KKVzR2WHd3980BOUriOczTebnZ/Dr/MRvVIYWnRApJE85lbc
	 BD+VfbEYj+kEl4ILmXEi5lFNt4i5yoiHpq3CL7Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0493/1848] clk: imx: Fix clock reference leak in imx_obtain_fixed_clock_hw()
Date: Wed, 18 Nov 2026 15:42:11 +0100
Message-ID: <20261118145935.040332152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



