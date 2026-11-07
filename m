Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062718;
	b=3qcJp+K5M2AOUH5F+K5wDj2UIDvTmQuGYs8Im96BZ5rAXE7FCHGBaFSqw6eX02jfpZ8R
	 MNsPXLv8G/ynMSi9b3Bjd0YI/qm1I5cFGR2qgJHT0iF/erBvfSspnlXL3xHOguWN5Kras
	 YkWMZZb/sdO9exI+jmWgg29ELNbvY2NtUHiI5rpaS40mDxmxL89BS+cxoOB6+vnJKf1ds
	 eILiLRS4++I7plAXkJdVV+6iIPR6GtakWDgAmh5n9M1QZBy82PK0aejXY9OnT6ODL17i5
	 00jx3GNYMdn40lT/CAm5Jy7bLczsfJFgej+v7dNsgcHE8jl/Wsokg8R9WayQuAAnPEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TN4FoPE8Uh+X9twiBE/AbpCjx2M26uyzHingDMFClz8=;
	b=o9VNYHhC6VZM9jTiacnFVisHWJHu6t6YHxY78nxdbB+qE5PrKbnlA65UJAlqK61OK2BI
	 3kM+zRFl5awhi/oSNN6EMbsWy8ngBi31zgBX/d8BdBLGa4Ski5QdShzJNEx3+QhUhjJ6/
	 2JKQXlJBdgazDsBzvdKK5PUnrP55v3+80A4O9EEhk2ZbK8I305whvpjdSsty5pnN++Nfd
	 MsuZ/QhNPb1RjsOCGr5X4XdH6ZKcWFzCmH0ceGF4mwRRkfHYiC/5+YEh49xtcE2rA7BfX
	 NX2tUPrs34iYmkVORwmiSPpbA5zqfwLTTVwdw7BryrYAuPIrvEyesd4GbI9BD4c/ACg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U6w2cDGB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEEF606A330;
	Sat,  7 Nov 2026 14:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U6w2cDGB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589761F0089F;
	Sat,  7 Nov 2026 14:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062717;
	bh=TN4FoPE8Uh+X9twiBE/AbpCjx2M26uyzHingDMFClz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6w2cDGBRiYPOYG51H3wDi4q8A8ITnF+3DdilEMH7wDvsPNTSxd3okNWlzH9vJTxr
	 /DDz6z+iNF7m9YMQ3AIOzEXDeiMZPaliA1Ty0kNzrwDmx/oZ1D/XJdEvRMZbtk8b9n
	 rJhlZGZsTzTtbHiU1WM/Qo8t3rbxmKCDtqWITZ6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/869] media: meson-ir-tx: Ensure probe error is propagated
Date: Sat,  7 Nov 2026 08:45:19 -0500
Message-ID: <20261107134853.431626535@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 2eb8a4cba70f521a8217021e227cfa28ba17724b ]

devm_clk_get_enabled() may return -EPROBE_DEFER which needs to be
propagated else the probe will not be deferred, it will fail instead.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index e8e3c1a303279..1ab898069e67f 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -292,7 +292,7 @@ static int meson_irtx_mod_clock_probe(struct meson_irtx *ir,
 
 	clock = devm_clk_get_enabled(ir->dev, "xtal");
 	if (IS_ERR(clock))
-		return -ENODEV;
+		return PTR_ERR(clock);
 
 	ir->clk_rate = clk_get_rate(clock) / 3;
 
@@ -325,7 +325,7 @@ static int meson_irtx_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		return -ENODEV;
+		return irq;
 
 	ir->dev = dev;
 	ir->carrier = MIRTX_DEFAULT_CARRIER;
-- 
2.53.0



