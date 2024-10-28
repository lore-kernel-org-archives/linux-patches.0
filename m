Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2115815B10D;
	Mon, 28 Oct 2024 06:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097154; cv=none; b=dotRMk/fhTpQUsivfveojmu/eAZy5+K9vgZJ9mdKg/f+zUVaKCFY0g03yT4tbdY+jPFcucgAPCZyUFQzYBUSmoMORXBri14Bw3Q0zDSwjdec9ID0MFkCP3zd1t+9Q7ArOSA7kyZPgTPs1+ysNS17K5R9MTYowlrGkbhGXgoaP9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097154; c=relaxed/simple;
	bh=JbxUPpF0xxmAT6ReJ2ouS/6Je1PWCrzdpgjpjy8c4eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSysK4QFz2p2xDxEQRQsHwi4LDm7HQEAKnaMAu5EtsGdCLuGc1xebq1T8TGY+tn9zVgcdt8vNhvHf78bNjOPfy4UgOQVOCsyEjq0TbJbdG0pV9b00ksXkvrcoJsZaf2P9G7CM7qz9Rf+sRmzND54H2LyWseg6kXjDWwmYqpZiic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07CRYfwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07CRYfwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F27C4CEC7;
	Mon, 28 Oct 2024 06:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097154;
	bh=JbxUPpF0xxmAT6ReJ2ouS/6Je1PWCrzdpgjpjy8c4eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07CRYfwZEAq9AxdGO6gIOTO+OD6moLwXUNxX/cdDJIgWiGrZJCZ0ZCBQSEGQXL5lz
	 /IQuOJ4/GjafyNbOxsTl1sqttw+DyXtFV+bwCZf3FweTJ3yLVaLu7RM9qEFZbwA9oz
	 mmNXJG0AHgGUjQRybmpUFV76uvNuDt6U6dRtErTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Michel <alex.michel@wiedemann-group.com>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 5.15 79/80] net: phy: dp83822: Fix reset pin definitions
Date: Mon, 28 Oct 2024 07:25:59 +0100
Message-ID: <20241028062254.805814568@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


