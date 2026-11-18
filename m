Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052372;
	b=m1U8VR3gze9kiBDBf3WKe7EwCXyeXS1Lbf7jq64x/fjpyxK9Fq02f9mr1CDIGQqrkJsy
	 EXbi3+e9M20i1fQRIK3+p6Z2Hvx4DSKfswPmkkPFyQ6qsjUyf/6ZeoBWid19+l9U7JDnx
	 m3r5LinveVYyRgbAMMukCKXg3AX/F+RGEYOj+7CvoPHsnnGbu6VGcucQBU61IvGS4N28q
	 2y/432hT0h0vcvs44fRLdtlkgE0mUX5Eq8OqHLLKOAOha/J18TfL7xiNoXZVIzBfRaJxR
	 cZyaetFjj8ejM9xKES62DD2vT2wnuubjQ1M0puv146vol95RoPCut1z9bUqrXP+H6KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NkP02IQD3m3BjJc4Hujalz10fNPeWzsgH6RRbqNlT7U=;
	b=lAOb1ZwpH795YOAnU8uDzbCPNtF8+8oiYhGqOPAjIPbxhK+Wbxg2gLhWuyzEcnm0jBSw
	 mOHhpTSwhvCaytVf/raBLpts4G4b7BGRjogiepOVU/zZd52fOIjsuwwzrLgOyhye4htif
	 DXuT3hhsm1G7tLt2WVh5KxJ0l10n/ezDju+AHGZYjVeILMSOHOaGj0JHmASD44NqI5cDR
	 hx35cKPvdwYvfUR1oZsiILRDAfmPDvTfENWP5oRU/+V55KtltEFai/eMccY6DsgS//PTH
	 5fIKs0SiSye2oNUpcgojOIQQzrSYc1j0A2LLS6SSIucAfTZH2xpBl5vY3JdjZVfKwjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fihMHhV+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4F8606A325;
	Thu, 19 Nov 2026 01:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fihMHhV+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E120E1F000C4;
	Thu, 19 Nov 2026 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052372;
	bh=NkP02IQD3m3BjJc4Hujalz10fNPeWzsgH6RRbqNlT7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fihMHhV+fq73TfKUrQ25fUeQCQGCkaI/RHaZVhnOvA5qhIjt8AGhgh3fZ2gE3WH0R
	 8wwXP+NEKqZOoV0rvZXmbCN5s4HPAEGZwAsXm82VohpJISPkBSwKty8z5CqmX70Sei
	 WoNbzXC/H0W6QTBWn28630LjKdD/oa3bULdb2eJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0523/2214] media: marvell: manage the MMP camera clock provider
Date: Wed, 18 Nov 2026 15:36:39 +0100
Message-ID: <20261118150032.000906276@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 9887716132d6c3c58cc67841dfb441c5a4a0d209 ]

mmpcam_probe() registers an OF clock provider before requesting the IRQ.
Neither a later probe failure nor driver removal unregisters that provider,
although the underlying clock is registered with devm_clk_register().
This leaves the provider referring to a clock whose lifetime has ended.

Use devm_of_clk_add_hw_provider() with the existing mclk_hw so the provider
is unregistered before the managed clock and camera storage are released.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 81a409bfd551 ("media: marvell-ccic: provide a clock for the sensor")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell-ccic/mmp-driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index f2f09cea751d8..0de293e606fe7 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include <linux/pm.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 
 #include "mcam-core.h"
 
@@ -259,8 +260,8 @@ static int mmpcam_probe(struct platform_device *pdev)
 	/*
 	 * Add OF clock provider.
 	 */
-	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_simple_get,
-								mcam->mclk);
+	ret = devm_of_clk_add_hw_provider(&pdev->dev, of_clk_hw_simple_get,
+					  &mcam->mclk_hw);
 	if (ret) {
 		dev_err(&pdev->dev, "can't add DT clock provider\n");
 		goto out;
-- 
2.53.0



