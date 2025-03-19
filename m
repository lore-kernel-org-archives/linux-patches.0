Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61721E1C3F;
	Wed, 19 Mar 2025 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395051; cv=none; b=kDca5wt5JAN5fd6uJ3bwQWduQiEzYoSc3P6/pEeFHflXW5pS0f/sWgAwncFpivNf14MHoWGal8yDgsgiJcgN/rc3xE2Ge/w6z+lQ0CUeCXXCf8Ty2ZwLXENPEIiIH0+Y/M2yzjLgRE2ilHcdbuCB/MErHDhAjHuEOfx9AH/8iIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395051; c=relaxed/simple;
	bh=CvjKvnhF8TU4lHL8ajh5a27cfeEuG07XecZADkgLbVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4R9W+JlLtxLWYIkgGJp+x3/P7DU3szN7VDLVsWqmB+Q78LbMOI8WTZtQHoLw7drrTLP/ZTjE1Ak48iu0NzQ+a+Q8poZlIXDgR7mQ3DAdglgeNDn6dFZb6BqVrtv/5bM/Qe0VbPFCxlBM1a6zQxlc9AFYOBcxMDlKonqjfUz6wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JIdOcoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JIdOcoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB12C4CEE4;
	Wed, 19 Mar 2025 14:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395051;
	bh=CvjKvnhF8TU4lHL8ajh5a27cfeEuG07XecZADkgLbVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JIdOcoTEQSGkVIuO8w3A70CTpvo8vOWZXg5hqMEEZO+0GctS61dHswgBNbWMC4Lr
	 mFCpp89WHHZ6x+dRBfXFYc8J0b0EU0YfZahYWqXdS4qtH85QE/4cGoXFcEnlj6A1Wh
	 gRR/POiDTNT0TCYhRp7/YEe89E6VdUZZwTdceSmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/231] usb: phy: generic: Use proper helper for property detection
Date: Wed, 19 Mar 2025 07:29:32 -0700
Message-ID: <20250319143028.785945465@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 309005e448c1f3e4b81e4416406991b7c3339c1d ]

Since commit c141ecc3cecd7 ("of: Warn when of_property_read_bool() is
used on non-boolean properties") a warning is raised if this function
is used for property detection. of_property_present() is the correct
helper for this.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250120144251.580981-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index e7d50e0a16123..aadf98f65c608 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -212,7 +212,7 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_generic *nop)
 		if (of_property_read_u32(node, "clock-frequency", &clk_rate))
 			clk_rate = 0;
 
-		needs_clk = of_property_read_bool(node, "clocks");
+		needs_clk = of_property_present(node, "clocks");
 	}
 	nop->gpiod_reset = devm_gpiod_get_optional(dev, "reset",
 						   GPIOD_ASIS);
-- 
2.39.5



