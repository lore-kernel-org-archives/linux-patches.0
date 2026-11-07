Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061905;
	b=qXGnRrQKFZnwoBOpvlKz7AmMysBaHAlNwwdgP4XsoPW7ZvCCwAkt4xyvQHt9R95nfh8f
	 5ZUtV6Pj6i9a3FcWK9jKOBpP1rS+Mdwf2LGgFv4hHivKtX8geSjKhtYWr+Ez6sEtM1jke
	 tQ2zY8fzxf7SSuvwAImgXFkuWdKAPVaDbuUBskWbtqyMDl2A+k2iLE+F6yA8Tp/hjW0W2
	 wnLv42a5jXLMh1fJgB4QSWiQ7+iXB21jRxa2e3ODq5RmZJu4sPO0OsGLvxFNSzbDDtdDJ
	 ysOT4Ae7w5hEbWeEwtVF9PC3g9VOsHQuxUWqF+RFscieLSdQJZwSodbozzWeDqRy4+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rQPJwmQODfkIY9YTCIQrpxpzSoa7QfYbWhP43dA0olU=;
	b=RK4GtfPr3R5mcTS5RA2J093OchK2IuWKad8I1Zse7rp76BuewZy9VpFYI8swSNhtZMWI
	 //1PBOZcBCTwlji2hqNd0NcuoqGhAdDQtJRyEOuWNczk/A3t+Rp16bAaAHXVLmqsPGcEm
	 tHRW4KgrM1KhP0kLSmHsNiuXnpwmC4HYO/eBw2wBemvawb7OIhp/ue+n045F+f2P4RoJr
	 RJ2xFyBpylZZJnGVi+THQ0M62UYkffhhYddSZo8xKO806SyyYZAqmn6p+ZW1QWtgMXq9b
	 eKZOTVmXkFGwaBZGDGB5Oo7cVq7AZibNR3Cngj2tgJMbcEXy8wwdlvHoyUKfRu6Oi3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+tShNUH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B09E606A32C;
	Sat,  7 Nov 2026 14:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+tShNUH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099E71F0089F;
	Sat,  7 Nov 2026 14:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061905;
	bh=rQPJwmQODfkIY9YTCIQrpxpzSoa7QfYbWhP43dA0olU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+tShNUHPMLZlqxq3SgXSKb8kfe3P/1iWM6GOSfFIkVaDtk5Ij9zYwyr0cvNUJczW
	 qEUZarqiKxYkwm9h41BWIOA/C4YmWY/dOpBDraSrOu5mRIRqXAy77FWgsgUvC6ucc+
	 OFwQxOGJbqoNu2psAkkjEMrikKJ2kZle7gYjY8zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hanzhijian <hanzhijian1991@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0915/1536] clk: mstar: msc313-mpll: fix off-by-one in clock array allocation
Date: Sat,  7 Nov 2026 08:48:51 -0500
Message-ID: <20261107135023.335401503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



