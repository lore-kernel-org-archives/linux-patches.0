Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064294;
	b=wV+T0vnqgpLPjhNMBPdqvNEYyfdmYjh0i1eDwRr46EshW+RBctq5Z/mncBecE+9J4miq
	 SYS1DriBU3kdCqhFs8QPuLBMGX0FEyofc2XjQMvD7ds4XE1zPOp+nPK1UwSzUx/Zsk6Vu
	 QtqCYOAQhE+oJeyj2yz/44rsQ3hxxUBkYODrTkyEJs6bf532d6tIsh55Ksbh1GmluvtEE
	 giVBhOMM9FIKDUCsDhPuBLodBueaJpMpNJBlDsauzgInrI4hUDZ7MR6uZY1LcG6RvmLVS
	 jm/Bpkok+bxRrb+OZFaYdsSlXrbjp9ZPtHPDuGi6ySwpFb5zd4MGjIPlBlc78cBB+xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J5yYK5QqUazPRfye5O43cD8we24h2HKJUhVNdG+zu0k=;
	b=0cksvauVruA22HNSEpmN6HQWpwe72JL31wzOxX3qg20QbBCbYSJKS37j0nFFUukz5XW7
	 wHVwx5ao3Tll5lYegav+qJ4j+YzClnwG+P9T89FYuxLqNwQMw05MaHUsC3HahdBFulG+w
	 Lbn/s+lclLfi/avvSa7OuunW9giGWF0WIdWGLt1ZMdpuBSoVVhDvKhX3OA4yjBUQoD4Mx
	 ZGzHfb6+BGXhDfhAapnR9c6KwrYjHOCZJL9VdwT24kOP1+JesWcGuWCtiZwLelFHvE/6s
	 5X24r+Yk7dbXpyeM8K2PuWIK/pQipmeuHprNhN1pN5WDFUykkvhFCC5aVLkkAYq8wXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQrsFlYj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B38606A9D4;
	Sat,  7 Nov 2026 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQrsFlYj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB331F008A1;
	Sat,  7 Nov 2026 15:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064293;
	bh=J5yYK5QqUazPRfye5O43cD8we24h2HKJUhVNdG+zu0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQrsFlYjHSUQjpgictN4BOYK3W2iKNPUaMYrURgJeRcLlBma5OxZQCVN3UQ9JvbBW
	 oKE0Fgxi9UkecadfOuI/0uyOdX5l3uoyENb6uKM4FqnkW08B9rOIkRIMM7HlLKFQAN
	 iMQfJ6fwKR7nJzXnqAuhHKCayDeKCetEFQGuL/p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	"Drew Fustini (Tenstorrent)" <fustini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0388/1257] clk: tenstorrent: Assign .num before accessing .hws
Date: Sat,  7 Nov 2026 08:44:44 -0500
Message-ID: <20261107134950.265102609@linuxfoundation.org>
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

[ Upstream commit da9f1312b06e4c03d43d21494fb5beea7f9e096d ]

Commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
__counted_by") annotated the hws member of 'struct clk_hw_onecell_data'
with __counted_by, which informs the bounds sanitizer (UBSAN_BOUNDS)
about the number of elements in .hws[], so that it can warn when .hws[]
is accessed out of bounds. As noted in that change, the __counted_by
member must be initialized with the number of elements before the first
array access happens, otherwise there will be a warning from each access
prior to the initialization because the number of elements is zero.
This occurs in atlantis_prcm_clocks_register() due to .num being
assigned only after every clock has been stored in .hws[]. With
CONFIG_UBSAN_BOUNDS and a compiler that implements __counted_by (GCC
15.1+ or Clang 20.1+), this triggers an array-index-out-of-bounds report
during probe, and with CONFIG_UBSAN_TRAP the first store traps so the
clock provider never registers.

Move the .num initialization to right after the allocation.

Fixes: 23c8ebc95284 ("clk: tenstorrent: Add Atlantis clock controller driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Reviewed-by: Drew Fustini (Tenstorrent) <fustini@kernel.org>
Link: https://patch.msgid.link/AS8P251MB00013BD9A093C06D2D60E10EC8B42@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
[fustini: drop num_clks, use data->num per Gustavo]
Signed-off-by: Drew Fustini (Tenstorrent) <fustini@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tenstorrent/atlantis-prcm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/tenstorrent/atlantis-prcm.c b/drivers/clk/tenstorrent/atlantis-prcm.c
index 6d4386eeb7dae..6772035ec8726 100644
--- a/drivers/clk/tenstorrent/atlantis-prcm.c
+++ b/drivers/clk/tenstorrent/atlantis-prcm.c
@@ -789,13 +789,14 @@ static int atlantis_prcm_clocks_register(struct device *dev,
 {
 	struct clk_hw_onecell_data *clk_data;
 	int i, ret;
-	size_t num_clks = data->num;
 
 	clk_data = devm_kzalloc(dev, struct_size(clk_data, hws, data->num),
 				GFP_KERNEL);
 	if (!clk_data)
 		return -ENOMEM;
 
+	clk_data->num = data->num;
+
 	for (i = 0; i < data->num; i++) {
 		struct clk_hw *hw = data->hws[i];
 		struct atlantis_clk_common *common =
@@ -809,8 +810,6 @@ static int atlantis_prcm_clocks_register(struct device *dev,
 		clk_data->hws[common->clkid] = hw;
 	}
 
-	clk_data->num = num_clks;
-
 	return devm_of_clk_add_hw_provider(dev, of_clk_hw_onecell_get, clk_data);
 }
 
-- 
2.53.0



