Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343E311725;
	Sat,  3 Feb 2024 04:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933562; cv=none; b=AONZBc0GJQKO6wQkk5TSKOEhFdo4B7BdH51YaXTQvpxud6yJnun9XOJZaZm6Vl3Up4zD7/9A85njJlMz5LejuS2Ym5pPT2PIhp0XgphLLZrMUEmGm2gJ16Llhpg0Fd9yEhEFL9wKz1RAr8N0mX+b7H0x2kD0sjjezCms3FIsL8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933562; c=relaxed/simple;
	bh=3F3pM9Js0+XiFP5LXQWw4rfKzTgFNvaE+sLJ2emO46Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Udqdg7+FL35Gt9hyPBwtCVeHCXXUZ+rULqz+OZ89b7q9GwblXbYOLi9QQWoU/ebpjtw821GtDFMl57ASmYuBpTTgn2TpRPBX8mhA2i+qqJlmari9EpKR4Z39Gm+eF0GA8Uds0QNQNja7ukqZMOdha6cG171/43Dekuq/ygEGP7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKrI3pUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKrI3pUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2DAC433C7;
	Sat,  3 Feb 2024 04:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933562;
	bh=3F3pM9Js0+XiFP5LXQWw4rfKzTgFNvaE+sLJ2emO46Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKrI3pUgQ904PPI8yRuJjUw9DHkwGMhp4q5DrK0XeGUXWUFeTfCrQHTzmZAAkfQVh
	 0sD4wUN2hIbPqGWc4N8e+5eSSak5bRWVEBcj9l24/1ac6GerRbCj5hLBy8X6XzL2vL
	 lvM0/VVuZRdbgHi7ZTU9mDo43czSht0tdn4UU55Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/322] net: phy: at803x: fix passing the wrong reference for config_intr
Date: Fri,  2 Feb 2024 20:03:32 -0800
Message-ID: <20240203035402.867782858@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit f8fdbf3389f44c7026f16e36cb1f2ff017f7f5b2 ]

Fix passing the wrong reference for config_initr on passing the function
pointer, drop the wrong & from at803x_config_intr in the PHY struct.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/at803x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 37fb033e1c29..ef203b0807e5 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -2104,7 +2104,7 @@ static struct phy_driver at803x_driver[] = {
 	.write_page		= at803x_write_page,
 	.get_features		= at803x_get_features,
 	.read_status		= at803x_read_status,
-	.config_intr		= &at803x_config_intr,
+	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
@@ -2134,7 +2134,7 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= at803x_resume,
 	.flags			= PHY_POLL_CABLE_TEST,
 	/* PHY_BASIC_FEATURES */
-	.config_intr		= &at803x_config_intr,
+	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
@@ -2150,7 +2150,7 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= at803x_resume,
 	.flags			= PHY_POLL_CABLE_TEST,
 	/* PHY_BASIC_FEATURES */
-	.config_intr		= &at803x_config_intr,
+	.config_intr		= at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
-- 
2.43.0



