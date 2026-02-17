Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7957F245029;
	Tue, 17 Feb 2026 12:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771331624; cv=none; b=fqJ1lRCYpv8ynfdAt+lAUFcFbNsqmYw46lXU9IWEjeiYU+JknspjcU2IagvkCnmofClhSsdPPYHRp8INZlnD+lfR85oT2z3xZchZm0XzM/67JLn+GN6SlAfxfdIJXGukR86vyBgz/55N3x66BXWMUfM3HheCOe2YOnkumGd4Nxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771331624; c=relaxed/simple;
	bh=UalrvtjqHt8yUx6RkL+iO3sCWQcaR1m9KEVeDW0Mpqc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=mkamSzIL4M90nBVn8Y7wUa1ufYKvKzDFtcpnsZF7e/wRPnxru9eicPbK6QPqzO5Ft7/cf24FQc0UdBeCcdCa6ebnh2FXzkP5ScwtsKT+98IToJFppFQpuBoWcZvRdaV+BwI8T7xKvjak4N1LVqEzRvTIOiqZpQQZxenbGlOld+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2E3uTyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2E3uTyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A87AC4CEF7;
	Tue, 17 Feb 2026 12:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771331624;
	bh=UalrvtjqHt8yUx6RkL+iO3sCWQcaR1m9KEVeDW0Mpqc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=c2E3uTyhnEQirat9EQC0ieZ76RAM27ZAIPSkRTQtvKd21fleQ4DwDiRrvv4htccAZ
	 eLXAXl4Wec5yuQzNrN/9fVBh9mQZ6OpSFGTbn69sM3+27RgaaoV39hJ7EnayFTLda7
	 cjk06pUmZVkPUbRHtv5fX1ZYkVACqFEIeHzx8Vcw=
Subject: Patch "clk: mediatek: fix of_iomap memory leak" has been added to the 6.1-stable tree
To: 1468888505@139.com,angelogioacchino.delregno@collabora.com,chun-jie.chen@mediatek.com,dzm91@hust.edu.cn,gregkh@linuxfoundation.org,ikjn@chromium.org,linux-arm-kernel@lists.infradead.org,linux-mediatek@lists.infradead.org,matthias.bgg@gmail.com,miles.chen@mediatek.com,mturquette@baylibre.com,patches@lists.linux.dev,sboyd@kernel.org,u201911157@hust.edu.cn,weiyi.lu@mediatek.com,wenst@chromium.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Feb 2026 13:33:37 +0100
In-Reply-To: <20260211012351.2076922-1-1468888505@139.com>
Message-ID: <2026021737-from-steep-235b@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    clk: mediatek: fix of_iomap memory leak

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     clk-mediatek-fix-of_iomap-memory-leak.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-215733-greg=kroah.com@vger.kernel.org Wed Feb 11 02:24:25 2026
From: Li hongliang <1468888505@139.com>
Date: Wed, 11 Feb 2026 09:23:51 +0800
Subject: clk: mediatek: fix of_iomap memory leak
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, u201911157@hust.edu.cn
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, mturquette@baylibre.com, sboyd@kernel.org, matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, miles.chen@mediatek.com, wenst@chromium.org, chun-jie.chen@mediatek.com, ikjn@chromium.org, weiyi.lu@mediatek.com, linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, dzm91@hust.edu.cn
Message-ID: <20260211012351.2076922-1-1468888505@139.com>

From: Bosi Zhang <u201911157@hust.edu.cn>

[ Upstream commit 3db7285e044144fd88a356f5b641b9cd4b231a77 ]

Smatch reports:
drivers/clk/mediatek/clk-mtk.c:583 mtk_clk_simple_probe() warn:
    'base' from of_iomap() not released on lines: 496.

This problem was also found in linux-next. In mtk_clk_simple_probe(),
base is not released when handling errors
if clk_data is not existed, which may cause a leak.
So free_base should be added here to release base.

Fixes: c58cd0e40ffa ("clk: mediatek: Add mtk_clk_simple_probe() to simplify clock providers")
Signed-off-by: Bosi Zhang <u201911157@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/r/20230422084331.47198-1-u201911157@hust.edu.cn
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/mediatek/clk-mtk.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -505,8 +505,10 @@ int mtk_clk_simple_probe(struct platform
 	num_clks += mcd->num_mux_clks;
 
 	clk_data = mtk_alloc_clk_data(num_clks);
-	if (!clk_data)
-		return -ENOMEM;
+	if (!clk_data) {
+		r = -ENOMEM;
+		goto free_base;
+	}
 
 	if (mcd->fixed_clks) {
 		r = mtk_clk_register_fixed_clks(mcd->fixed_clks,
@@ -594,6 +596,7 @@ unregister_fixed_clks:
 					      mcd->num_fixed_clks, clk_data);
 free_data:
 	mtk_free_clk_data(clk_data);
+free_base:
 	if (mcd->shared_io && base)
 		iounmap(base);
 


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.1/devlink-rate-unset-parent-pointer-in-devl_rate_nodes_destroy.patch
queue-6.1/ksmbd-set-attr_ctime-flags-when-setting-mtime.patch
queue-6.1/clk-mediatek-fix-of_iomap-memory-leak.patch
