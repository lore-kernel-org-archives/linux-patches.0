Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45D53218C2;
	Mon, 18 Aug 2025 13:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522612; cv=none; b=YnZlOXW5dT2ePD3E9Cj+zclVx/0sSKpOjJDAR8gVnTZKfNEFUUfqrcqRhZqP1fNOc1JpVoevnvQ2YZ/xZz0wBgi0ELEhlSr5YPLQDD3I0AdDPm/PmrNoVh52BZBXdKqhUoFfd+UMpX4KhZwKptX7KcomGBumu3ziRBqgEA6PMFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522612; c=relaxed/simple;
	bh=dE4sytdHcp7yQnPreS6mmG5UQrLts0e2Mm4W6thv+KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nIuV5SQeufMGEMxmjsDN52A3T0rN2/gBjttJ33w7+XT26G9rvnWCsBNGNITo0QaPNPqCLyPNOqmNrS4DvHgPXVZ611PpPOncDcSSOhXEQZRrl6j+iqZHkYroswCi0RS2JTcVdTqxHArjvy3OuQO1F+DlfRhDw+SKVl0Iwl9IWAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDdEcD33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDdEcD33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF4FC4CEF1;
	Mon, 18 Aug 2025 13:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522612;
	bh=dE4sytdHcp7yQnPreS6mmG5UQrLts0e2Mm4W6thv+KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDdEcD33v/b3oBRhNfG3OJLx/FycpQzDBAQBm1UwBQkRii0rLszdKatrWEeWTqm0S
	 DPOIh+L8GcI3qcMhK537g79AcAKkt1P0IHq+1i+kleJCJ3ov1KiYw9VzAoLt2dj2Fb
	 bBlAVzq60FVYq3sSe7VHxLB+8ZiEjIh7cJgvDXDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Buday Csaba <buday.csaba@prolan.hu>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 360/444] net: phy: smsc: add proper reset flags for LAN8710A
Date: Mon, 18 Aug 2025 14:46:26 +0200
Message-ID: <20250818124502.407349883@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Buday Csaba <buday.csaba@prolan.hu>

[ Upstream commit 57ec5a8735dc5dccd1ee68afdb1114956a3fce0d ]

According to the LAN8710A datasheet (Rev. B, section 3.8.5.1), a hardware
reset is required after power-on, and the reference clock (REF_CLK) must be
established before asserting reset.

Signed-off-by: Buday Csaba <buday.csaba@prolan.hu>
Cc: Csókás Bence <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250728152916.46249-2-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 6a43f6d6e85c..de66b621eb99 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -784,6 +784,7 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	/* PHY_BASIC_FEATURES */
 
+	.flags		= PHY_RST_AFTER_CLK_EN,
 	.probe		= smsc_phy_probe,
 
 	/* basic functions */
-- 
2.39.5



