Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4558B155389;
	Tue,  9 Jul 2024 11:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523643; cv=none; b=jK75I1XnHvav9OQMJ7y5cJwrCrVrvnxn1fuZ4vBfvCsDwZv/X5cSeOxAtl7CRZDQT+mF2XalDgK+95y0pVNleCFokEU9nmJ5zte8s1fg6b6w2CPP84WybZRwWl+5V0V6wnp5idvcS7ZlfTa7bsRNnp7YGNNbSZv5LfUhv+2Qq28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523643; c=relaxed/simple;
	bh=RpnUPNKQzRW6npbyWhtGKLW4h/2DxLWwsJQoe4LxLrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzS40fOEoeoHcrfUTJGhpQdkywUJIdkssA5i/R1n45TIRCzJk2t3E+QAmOkvHsQEH6CTUPdkmf9taAplXKt8WP1pY7Lj1eTDO3RYredF2fHDvfRaP6NQ8S0wqrPB6Ob3w2bXJ8l4XnrGuToGm/AP7AbO9DxPio4xfxbyR892La4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJlc8Fsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJlc8Fsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE503C3277B;
	Tue,  9 Jul 2024 11:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523643;
	bh=RpnUPNKQzRW6npbyWhtGKLW4h/2DxLWwsJQoe4LxLrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJlc8FspQEwR9lBcEacJ6WCMNHPAPaVkNsop/omOy0GZexSu9VDUfu2eupV5jAYJI
	 lnXuQSE+rHnAximvhM7Ls05TySMJ6BqQVp9ArWHEMaTVNPcWSJdbu9EItFactHTjMR
	 n1595vaTq2lWeVFk86W1RlIl4LM798yA1I3DXCtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/139] net: phy: phy_device: Fix PHY LED blinking code comment
Date: Tue,  9 Jul 2024 13:09:22 +0200
Message-ID: <20240709110700.567216960@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit d3dcb084c70727be4a2f61bd94796e66147cfa35 ]

Fix copy-paste error in the code comment. The code refers to
LED blinking configuration, not brightness configuration. It
was likely copied from comment above this one which does
refer to brightness configuration.

Fixes: 4e901018432e ("net: phy: phy_device: Call into the PHY driver to set LED blinking")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20240626030638.512069-1-marex@denx.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/phy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1351b802ffcff..5aa30ee998104 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1099,7 +1099,7 @@ struct phy_driver {
 				  u8 index, enum led_brightness value);
 
 	/**
-	 * @led_blink_set: Set a PHY LED brightness.  Index indicates
+	 * @led_blink_set: Set a PHY LED blinking.  Index indicates
 	 * which of the PHYs led should be configured to blink. Delays
 	 * are in milliseconds and if both are zero then a sensible
 	 * default should be chosen.  The call should adjust the
-- 
2.43.0



