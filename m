Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0BC1F473A;
	Tue,  3 Dec 2024 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239585; cv=none; b=HImlDvwhWNgTu7twXqacgum3yxz2P74BEyFfOg3rfPFpktk7+de3LBiQtK7H15c/cRxMnJUwNa/nNRFRJy0hr5NGfcZyxMVTJk5M9sKU/0uDafY3VoTIqDm9SaZoSN4xtGCVddNFYhzuJejNhhC66qnlyDIjpKsh1HynFBicio0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239585; c=relaxed/simple;
	bh=BcVr/HrpGq7WS0ToFatRR3kb1L1RiTwJZAtyiyQ7JyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKsgWA2BfBTthvAhL0vc2j3UWM27iSy/jIZUI9Kl7iRGX8zuTSTE1cohIdZJp2+obPkKdRMnvh3Om9WM9jCFkjkimuR6yLDfTqr49upwSXA+8GG8OXxeK+hptMhHnDAzPzcaflWKNj9+o/TIF4LLWCI29EDouxT8VIp3I+oD+s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/dgz/MS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/dgz/MS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9759C4CECF;
	Tue,  3 Dec 2024 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239585;
	bh=BcVr/HrpGq7WS0ToFatRR3kb1L1RiTwJZAtyiyQ7JyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/dgz/MSuyMTbMwyK6TcsH2ekR7Npx5ml4e0T27m9/sq/BCQN888fN6UQ9nhWWtgu
	 dElui3nYJ3SME3REIPjkgzfOb3sPFQInrwBTgOg2OBpSVaRsyvqTWcXOoD6gpYE8pz
	 9eUNaNln0pQnHJ2lksDgj1cXtqRRBLnOrgSeZ5PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 664/817] iio: dac: adi-axi-dac: fix wrong register bitfield
Date: Tue,  3 Dec 2024 15:43:56 +0100
Message-ID: <20241203144021.877105030@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angelo Dureghello <adureghello@baylibre.com>

commit 70602f529e4d76798c95aeed5ce2a8d36263abe5 upstream.

Fix ADI_DAC_R1_MODE of AXI_DAC_REG_CNTRL_2.

Both generic DAC and ad3552r DAC IPs docs are reporting
bit 5 for it.

Link: https://wiki.analog.com/resources/fpga/docs/axi_dac_ip
Fixes: 4e3949a192e4 ("iio: dac: add support for AXI DAC IP core")
Cc: stable@vger.kernel.org
Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20241008-wip-bl-ad3552r-axi-v0-iio-testing-v5-1-3d410944a63d@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/adi-axi-dac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/adi-axi-dac.c b/drivers/iio/dac/adi-axi-dac.c
index 0cb00f3bec04..b8b4171b8043 100644
--- a/drivers/iio/dac/adi-axi-dac.c
+++ b/drivers/iio/dac/adi-axi-dac.c
@@ -46,7 +46,7 @@
 #define AXI_DAC_REG_CNTRL_1		0x0044
 #define   AXI_DAC_SYNC			BIT(0)
 #define AXI_DAC_REG_CNTRL_2		0x0048
-#define	  ADI_DAC_R1_MODE		BIT(4)
+#define	  ADI_DAC_R1_MODE		BIT(5)
 #define AXI_DAC_DRP_STATUS		0x0074
 #define   AXI_DAC_DRP_LOCKED		BIT(17)
 /* DAC Channel controls */
-- 
2.47.1



