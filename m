Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F72D15B10D;
	Mon, 28 Oct 2024 06:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097445; cv=none; b=E0Csj6wETkLrC1KUreifGor3Vq93zsA9DXn91eMPgYwzIYC/Adfnh5AIyF12OtCqQ99ZKYI4g5X9UlwWktrOpRyoSN9hlVXYht7QArdwjPfars+Iftf72KbDsyhMESGpCg2HU9vRGcCKFlSvwO1iInyWzZlBckPq7F5YqlIUUoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097445; c=relaxed/simple;
	bh=9xPJHNpDSfI4Rib/SdRIGyNGBuOUXL1H4Tg7QyiLAFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/q6lvWCq3mp30JuozuX6ZidqwPSqJHbS6fT+2aqGU4mErl+atP7eXlXBhvGTNKUDKOtBIsG0OxYhPiEErLVPARFC1ar1FGCqUGh6Cm9Ki+TK6LU1mOrnWI/sd/naGl4lftZysdrQqo8g+T6F9b2uTgdHSGI7UYozEP8msgbwrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvExk9Vv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvExk9Vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33EAC4CEC3;
	Mon, 28 Oct 2024 06:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097444;
	bh=9xPJHNpDSfI4Rib/SdRIGyNGBuOUXL1H4Tg7QyiLAFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvExk9VvlNlGHDllcZdMuTILP9OcPO5eN2t2KmZy7qWv4lLQt61/hfyQn4Xk9teAN
	 Z9CnottYWbD2uT9oeydM3ZOtpaMYoQlbNU9xNa3MwBEIyI9NXe3xwEZgOMofx1vMpP
	 mXgoThUyN90piIn1hUFgcz/um5i2XJqHR71OlN2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Michel <alex.michel@wiedemann-group.com>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 6.1 132/137] net: phy: dp83822: Fix reset pin definitions
Date: Mon, 28 Oct 2024 07:26:09 +0100
Message-ID: <20241028062302.390732194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Alex <Alex.Michel@wiedemann-group.com>

commit de96f6a3003513c796bbe4e23210a446913f5c00 upstream.

This change fixes a rare issue where the PHY fails to detect a link
due to incorrect reset behavior.

The SW_RESET definition was incorrectly assigned to bit 14, which is the
Digital Restart bit according to the datasheet. This commit corrects
SW_RESET to bit 15 and assigns DIG_RESTART to bit 14 as per the
datasheet specifications.

The SW_RESET define is only used in the phy_reset function, which fully
re-initializes the PHY after the reset is performed. The change in the
bit definitions should not have any negative impact on the functionality
of the PHY.

v2:
- added Fixes tag
- improved commit message

Cc: stable@vger.kernel.org
Fixes: 5dc39fd5ef35 ("net: phy: DP83822: Add ability to advertise Fiber connection")
Signed-off-by: Alex Michel <alex.michel@wiedemann-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Message-ID: <AS1P250MB0608A798661549BF83C4B43EA9462@AS1P250MB0608.EURP250.PROD.OUTLOOK.COM>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/dp83822.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -40,8 +40,8 @@
 /* Control Register 2 bits */
 #define DP83822_FX_ENABLE	BIT(14)
 
-#define DP83822_HW_RESET	BIT(15)
-#define DP83822_SW_RESET	BIT(14)
+#define DP83822_SW_RESET	BIT(15)
+#define DP83822_DIG_RESTART	BIT(14)
 
 /* PHY STS bits */
 #define DP83822_PHYSTS_DUPLEX			BIT(2)


