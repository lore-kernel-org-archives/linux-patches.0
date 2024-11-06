Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C9D1FBCB0;
	Wed,  6 Nov 2024 12:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896730; cv=none; b=APIK1ZOriK5J882/n5GoOnjK6kFzw3Ny/7Yd/Q9pfxtCQKDClKSEaYxs/o1IDYKz6LvxeAgF1Ximh9TCxd2DX5RBQKVqAjQMY5+lyfJ8irIabUcYZWG0GyN+xwLe3Nr2+ml4+x4tlcCxHOjSZ5CfGn3jE927bk55p8BvbU+/lB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896730; c=relaxed/simple;
	bh=KC5wGcfmMcEfqP31vGEX2VkZb6f9OZ48c+dJSQUwfAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBYeODKEPRVDMPqArQgW58RahW2wccaCGMAImNTv4TDGBP4MXIX9z8MwhtCV4G+20M8wmVh426PBHLxdchIUFY3irANrRTc0i3eKIiMm3kBHDEo8zFTyqfjq86L/P2YUiGDb0/t9JTUJJvmkkYAGmlsXIGvnMBV8g+nV7LU9MhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAsFIeNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAsFIeNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C940C4CEE1;
	Wed,  6 Nov 2024 12:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896730;
	bh=KC5wGcfmMcEfqP31vGEX2VkZb6f9OZ48c+dJSQUwfAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAsFIeNQ2J7ebrBm3dB5cpjx1Af9/7CLd9krEtUhdXwxsRMedtpWd5A97d8FuG6/V
	 PaMn69OfgFchzpg09lXKUw66oclDt9tB0dW0E/vOjOoVghG2pg+OAiupIEfHEEBtc+
	 PJGzlpyfbA/99U57DzONn+/UcG0NrLsSHRu5rOBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Michel <alex.michel@wiedemann-group.com>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 5.10 053/110] net: phy: dp83822: Fix reset pin definitions
Date: Wed,  6 Nov 2024 13:04:19 +0100
Message-ID: <20241106120304.668593855@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


