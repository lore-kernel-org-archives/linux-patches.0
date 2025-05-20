Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207B122097;
	Tue, 20 May 2025 13:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749510; cv=none; b=I2nmEegJVUMQeXOleuRoAGishUlpmFqio/ErwjonNUSrl5L7SmLXKHYP3W4v7W6Ymsh7jJcQB2+SVDzAyxujeJDruiPuarwNxtnvXUoshX/qqoJXtwlTJMO+oBu1YJ1YXT5q5B0S9CDZ1MOdWZeQCOUH+ApNphg68UFCHpU/V9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749510; c=relaxed/simple;
	bh=mz7kRJ7/WRSAjwriYvABx0S/cfTq1nBbjD3ToXNudzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prnjVUawL+DlrK5QcxODVmKrPN1UgKcgFHrjWw2K52fBIw60cLKYHFfca1CZzLvmU4uQKefrPa4ydVmVfek8QONNo+b7qFMAeKIc1vbs6G0jnRuFhpxNiTawRTcWTROtt9f3q15j2PfxJCjj4cHDb7jr6awXXvxaakcQvb7YoCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJEBms9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJEBms9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0156AC4CEE9;
	Tue, 20 May 2025 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749509;
	bh=mz7kRJ7/WRSAjwriYvABx0S/cfTq1nBbjD3ToXNudzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJEBms9pFNTfAZwDbn1yJWTZHj5V/KmdTlLYLey/6+RgV4JnfTts7MU7iYhFTy2dh
	 j71U+DJcqjdApqq80tTFELyn0DNEeWwxeHvHCUahSsK1LjHgtyujgg7PmcNrLLXt6B
	 xRinRB9TyI8vZEbWkCxnA5m25v3FjUfjSL7HiUQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 60/97] phy: renesas: rcar-gen3-usb2: Set timing registers only once
Date: Tue, 20 May 2025 15:50:25 +0200
Message-ID: <20250520125803.005069830@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 86e70849f4b2b4597ac9f7c7931f2a363774be25 upstream.

phy-rcar-gen3-usb2 driver exports 4 PHYs. The timing registers are common
to all PHYs. There is no need to set them every time a PHY is initialized.
Set timing register only when the 1st PHY is initialized.

Fixes: f3b5a8d9b50d ("phy: rcar-gen3-usb2: Add R-Car Gen3 USB2 PHY driver")
Cc: stable@vger.kernel.org
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250507125032.565017-6-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -454,8 +454,11 @@ static int rcar_gen3_phy_usb2_init(struc
 	val = readl(usb2_base + USB2_INT_ENABLE);
 	val |= USB2_INT_ENABLE_UCOM_INTEN | rphy->int_enable_bits;
 	writel(val, usb2_base + USB2_INT_ENABLE);
-	writel(USB2_SPD_RSM_TIMSET_INIT, usb2_base + USB2_SPD_RSM_TIMSET);
-	writel(USB2_OC_TIMSET_INIT, usb2_base + USB2_OC_TIMSET);
+
+	if (!rcar_gen3_is_any_rphy_initialized(channel)) {
+		writel(USB2_SPD_RSM_TIMSET_INIT, usb2_base + USB2_SPD_RSM_TIMSET);
+		writel(USB2_OC_TIMSET_INIT, usb2_base + USB2_OC_TIMSET);
+	}
 
 	/* Initialize otg part (only if we initialize a PHY with IRQs). */
 	if (rphy->int_enable_bits)


