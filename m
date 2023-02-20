Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0B663B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439A5C433EF;
	Mon, 20 Feb 2023 13:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900626;
	bh=ldYvoza5HYOreGZTjGHATCRxnoA7BiprTCOwwB5U3Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4kdlIyiPKNDRqfUr1phOAFM58vALyIF4zNdyiE+DThYwIu/Au30pse1bWFcIqS3M
	 TDuf/fNy7IVTjYyD2y2gTOVTfEq5AyjHkFXYZVHLfJJZYO0MpRQQ5adYPONbNJnsZ+
	 un+KLAu04dWLxc26QTor3f0SFfjM6+n59Mesx+gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Chris Healy <healych@amazon.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 89/89] net: phy: meson-gxl: Add generic dummy stubs for MMD register access
Date: Mon, 20 Feb 2023 14:36:28 +0100
Message-Id: <20230220133556.305833578@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Healy <healych@amazon.com>

commit afc2336f89dc0fc0ef25b92366814524b0fd90fb upstream.

The Meson G12A Internal PHY does not support standard IEEE MMD extended
register access, therefore add generic dummy stubs to fail the read and
write MMD calls. This is necessary to prevent the core PHY code from
erroneously believing that EEE is supported by this PHY even though this
PHY does not support EEE, as MMD register access returns all FFFFs.

Fixes: 5c3407abb338 ("net: phy: meson-gxl: add g12a support")
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Chris Healy <healych@amazon.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20230130231402.471493-1-cphealy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/meson-gxl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -258,6 +258,8 @@ static struct phy_driver meson_gxl_phy[]
 		.config_intr	= meson_gxl_config_intr,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
+		.read_mmd	= genphy_read_mmd_unsupported,
+		.write_mmd	= genphy_write_mmd_unsupported,
 	},
 };
 


