Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052124;
	b=vy0JCaCVIT9KUou45wlqYwdmIh9SarwJYtnStO7FuAqThdy02NG1z/uwE1eQFtX7pgcR
	 2gDGbPhioItQ3GzdiWPAPXlHetwYY7ndLh8v5vGNjjjQ1kNKHHSihlRNLzDSQQkaJfrsl
	 1Q2tLx98bTTqvLiRDX8J2+029hFxzAaLT5X4ZYQR88w9OujVKSxBFV3rmsYFD2SgK01LV
	 XM4OJ2vjDgCIrlL45IhLrXqftSF4hVpf30qAR24Vte8auDoq7wQhgnsC2///SpOYjdXEn
	 xtj41xtAHIZb5OPjYPmrkDSA4atu+4HaH5ZggW+UqhjukxkIoGwSgGNw4s8+l7jweFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yr17g8jONA2W0w9uCGWQS522YVKDBL48vw4y6hjgx0o=;
	b=jdTxy5tEu0H+rkSYp/jHJERrXq74z/CkcbrzFgzO67/AQGcAPrK4SUC8FUIfmly+QKkN
	 x3vQYpyd3/vvrgGFv9g7TZMck/Sf6LqPOVzPZ3hbi5H2M2QhmvOxQtgsr9JX3q142x5cb
	 JVuAkUqNTzyAIvNaCMXHQKYXLLq7+2FcCu0zbcNVRtFABa3LBfoGKL/Q+kgXqwvOiBcK8
	 xpvNanKm/eM41IBMGSLXHt77FDGY53GC0X9TA0uto2A4QJtxjKklHC8dMMhpOxK9IvKXY
	 b+UuZ8n3CxPGIMhBeak/g1ODFvkvtb8P2jRGd/ylD+2IoTb2MaM/TMUkO0ZxRmtMofg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mf8rzHnu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0026C606A320;
	Thu, 19 Nov 2026 01:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mf8rzHnu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EBB1F000C4;
	Thu, 19 Nov 2026 01:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052123;
	bh=yr17g8jONA2W0w9uCGWQS522YVKDBL48vw4y6hjgx0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mf8rzHnuCVwghdgrx5pn89642HSoaclpte6l8QLYOzmkhJoXekzrFloatk7HiT74X
	 I/5wksVNWXZ/o8ilCD90fNDlWPJQbbwzoDGhtBek5CN/NZPwq96LDC8Eb3JbApTU4A
	 CuQl/y99MDkqKjiZ8qPoOaz/Ee9xMuFyGXm0mBLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hanzhijian <hanzhijian1991@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0451/2214] clk: mstar: msc313-mpll: fix off-by-one in clock array allocation
Date: Wed, 18 Nov 2026 15:35:27 +0100
Message-ID: <20261118150029.117899913@linuxfoundation.org>
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



