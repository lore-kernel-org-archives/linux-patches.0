Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2578919DF99;
	Wed, 19 Mar 2025 14:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394881; cv=none; b=tYLiGxOLnwg7OwBDDOS9EKuLCfyqfqiH1eQzuOHuunUtydnje3AUS+3D7jwndgEeWkAsmoyRca9t2jhpXa36Yf+gSn4wBN4x6Gjpfrqfw+P3pHLqYwqB1tHceguLmyg4zEEZfIE9gTAtadnpLTGImbOuEUN3tBAhGM3rNUzL39Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394881; c=relaxed/simple;
	bh=+9mOKGNaHBJxwL6b/FGGDQ+dRPQyiwj1tNtDhA+qEac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUJmyD8pxaLq+3zwDFPlORqUZKyZRxCGuIbhsihR0Fnxlh+QoTqbpTxq7uTktQ20rJ6N0OllGnyga4DrV2kvJlm9AAo4+VO6SRLqV0r2uGjYx9mlCKK3GdfunSvRvev+fKHn/UFIxVLK/qizQ2pQqdfkeaqx01Z0M7nCaVE2ix4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7I6BA5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7I6BA5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5230C4CEE8;
	Wed, 19 Mar 2025 14:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394881;
	bh=+9mOKGNaHBJxwL6b/FGGDQ+dRPQyiwj1tNtDhA+qEac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7I6BA5geFMpHRpFA95jFbFPoJ1FEosnB/oEuX4dhrQJhub0O3kA4uzx1qso0u9gW
	 rUPy0e++2Vv6+9jmMYwBqrcXUblQe6OnnP/AMYfjP89JiQvDyf+uedPcJLL0QaH/n+
	 I7TQMZD2CHBu8+JNVZIescwtagJBTgz/nVg+CfeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 081/241] usb: phy: generic: Use proper helper for property detection
Date: Wed, 19 Mar 2025 07:29:11 -0700
Message-ID: <20250319143029.735306053@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 6c3ececf91375..8423be59ec0ff 100644
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



