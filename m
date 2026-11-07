Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062746;
	b=wXdah+1BKbDiRzhYzi9oPfAP/dQZqy66eIEsFT+nY5DecT0kLejFaz/doXeCzZZ8Upnx
	 Z7C6OTGvMoWcUiNkJqSOCDMdFT0Re6eXroNW8jt8gMOKbLE1LLQhO5q1Q74KT4zIX2yYe
	 ww9u/FSRdzTYUhEZMiPecS4X184xrqvnolucjnUSNekBrMXJCff5zqAgx08ObD31V7A9A
	 XuTyCQdRTJNz+tryc41p9opHcdlh0i1eQi6Mv6gLEYZ9jCj7uFEOJIUdFnujRdS147a6N
	 Pq1pCXpxlAwqyAzHL44IqSn9Hr7Ltvq6GCi8wcyn6+b5UYq0IQLWim3ZxhgDsO4388g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HGDrV7gLyx/JxjAcsnT5wUHB+uNAqsF4gZB0CP3fWl4=;
	b=4lENLIpysc+ShiJPlgx8XBDC/yt2sYbhHE+tbhF0tj8+ebYxFRSMoTnwUdV0UfwFBWC3
	 adaBFB88YIoN6eaXYzR9ou9vnQCfNkDnMNV8/G9BEoDL4M0EiYvXie95nzJo2LO+aqS8Z
	 saRzObIaOBYxK8L6XBCydhpX+z3eNH12KQKGvEvFbXO2FHhkWGdI2bqVlZ3igrNn771kD
	 fVVRuVeQXmmUfrQG/tE7oO/0HgV7wnQ705pFLhB41uNg7r5walGklESGyTLF6BJBgGVaK
	 on8v2TiHljjLa2HO1RJ3qLjqP0Cald+SBunvH1JP9s+awjdqZnViMDVw4D7UpdgBwNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RrqiHD74;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9163606A32C;
	Sat,  7 Nov 2026 14:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RrqiHD74
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4461F0089F;
	Sat,  7 Nov 2026 14:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062745;
	bh=HGDrV7gLyx/JxjAcsnT5wUHB+uNAqsF4gZB0CP3fWl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrqiHD749Rvarp6sJGxgMxSL9QZkCXnCuIsyNATvMAzCS2zew8vpdy/djcY6SFTs7
	 oPZTYZct2RsUt2vzbwrb5o1Q1DnrNysvXhzUZCGDip5RCqd0JqstO3ywcL7d7iVGRh
	 SM7D54ahZRH+nerwNNq4wIiMT+XNvy5dYQiUcuxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hanzhijian <hanzhijian1991@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 060/869] clk: mstar: msc313-mpll: fix off-by-one in clock array allocation
Date: Sat,  7 Nov 2026 08:45:42 -0500
Message-ID: <20261107134854.202260736@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



