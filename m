Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFB52AF07;
	Mon, 28 Oct 2024 06:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098464; cv=none; b=pYN9SG7KagemxG06IubkDMr0mEY1x0NSdhUceNyK7BaI5ovtHYqkB+l5gKgENoXXeSm58bRsuGx4OkVTe1iVMrwtFywC/Go6/mUJ8rhZrxx5UrBpmd1heWEo1gaGU7jASTEQAvvzK47LwMkZPXk4EL0IDtdXyLuglH/BGPXIG+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098464; c=relaxed/simple;
	bh=6o6iD3dv3q6Ao3ShSWT5u/H3GFSqRB3mF8vPZh1Ywlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAEoIuu7pEu0ifPlShC14zNOjnvDthRIfuIruoV5jrOo/zb0PepOx5X1FVIwKo17Ctvf54jqC9tWpCSTjTyA7L39x6/g0ChV3DTn55ISwocJm3ibou+/9l1lZ0YM2qVtkgxqfxSjMsS3evAFp9gaUn4miNO2HCRM7FFaYw2WTa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUL+Vy0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUL+Vy0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA87C4CEC3;
	Mon, 28 Oct 2024 06:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098464;
	bh=6o6iD3dv3q6Ao3ShSWT5u/H3GFSqRB3mF8vPZh1Ywlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUL+Vy0nnV+N+n1AV/4PKIfJvtG4Y4puUKA6TdelL62m9av1B48gwraJC1PYG3rRU
	 T1zlouS5yNW6SgP/6cL+IJYkGO9A3tdTTY+lcDw/SIDg6/sfTfnucUOheRF/0xr/AV
	 jya9F1MuyxW+XmX5/oY6gaeTu80hDkEuYuVeWWbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Michel <alex.michel@wiedemann-group.com>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 6.11 238/261] net: phy: dp83822: Fix reset pin definitions
Date: Mon, 28 Oct 2024 07:26:20 +0100
Message-ID: <20241028062318.084539189@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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
@@ -45,8 +45,8 @@
 /* Control Register 2 bits */
 #define DP83822_FX_ENABLE	BIT(14)
 
-#define DP83822_HW_RESET	BIT(15)
-#define DP83822_SW_RESET	BIT(14)
+#define DP83822_SW_RESET	BIT(15)
+#define DP83822_DIG_RESTART	BIT(14)
 
 /* PHY STS bits */
 #define DP83822_PHYSTS_DUPLEX			BIT(2)


