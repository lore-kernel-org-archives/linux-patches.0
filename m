Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8341B15E8B;
	Mon, 30 Dec 2024 15:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574096; cv=none; b=HEnIfgUfIhsebUnHI/5bGuJV9R2DAifO1nHvTiQWIk2pIpgPNqvsKg592TIBdbfSOzo05HJGdDN7vE9kKZrZIwZycT1ETDIS6AmA24Z9d51SIFUN0nW8V0J2byYmy8Jx0KP7joR/Kd5ba1jvH8ETrBcxIJxPApxASoHHGgih28Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574096; c=relaxed/simple;
	bh=mkCl7h5KwHqNay2kp9snkjQbUQsETbgAbpBG5nCbvK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SM6r3UVLR9MqEYVx2vCW9juLRb5mOugyI9lmaORABaD02aaFMv/UVRMFjIWD0LpKJcK5QJTTizS94hU2vCaJKadzQQJJRQyBidZq82IbzzZmGkJHJJMx2Fm1dAU9/VFrXsRQGUBFhbHHCZENVOMxlJOSfkdDl90vGGdFKHWfEug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzkaNmAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzkaNmAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF09C4CED0;
	Mon, 30 Dec 2024 15:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574096;
	bh=mkCl7h5KwHqNay2kp9snkjQbUQsETbgAbpBG5nCbvK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GzkaNmAJxFkAhiGWXWeRn8ZrpQY1ypLo2i6QeY2b504nyfiKtrI40wAgUWCSf0rhL
	 alI9uoFZJ68Et999xKtW51ubBHktk4IfmCBqOKh/rtf6HuNCeC/jsLtfb4+ojWDx3f
	 Set97mKrSL9zCN6Bi/LMqtqhisXBqLu2m8DaiG14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.12 036/114] platform/chrome: cros_ec_lpc: fix product identity for early Framework Laptops
Date: Mon, 30 Dec 2024 16:42:33 +0100
Message-ID: <20241230154219.450124336@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Dustin L. Howett <dustin@howett.net>

commit dcd59d0d7d51b2a4b768fc132b0d74a97dfd6d6a upstream.

The product names for the Framework Laptop (12th and 13th Generation
Intel Core) are incorrect as of 62be134abf42.

Fixes: 62be134abf42 ("platform/chrome: cros_ec_lpc: switch primary DMI data for Framework Laptop")
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Dustin L. Howett <dustin@howett.net>
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20241224-platform-chrome-cros_ec_lpc-fix-product-identity-for-early-framework-laptops-v1-1-0d31d6e1d22c@howett.net
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_lpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_lpc.c b/drivers/platform/chrome/cros_ec_lpc.c
index 924bf4d3cc77..8470b7f2b135 100644
--- a/drivers/platform/chrome/cros_ec_lpc.c
+++ b/drivers/platform/chrome/cros_ec_lpc.c
@@ -707,7 +707,7 @@ static const struct dmi_system_id cros_ec_lpc_dmi_table[] __initconst = {
 		/* Framework Laptop (12th Gen Intel Core) */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Framework"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "12th Gen Intel Core"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Laptop (12th Gen Intel Core)"),
 		},
 		.driver_data = (void *)&framework_laptop_mec_lpc_driver_data,
 	},
@@ -715,7 +715,7 @@ static const struct dmi_system_id cros_ec_lpc_dmi_table[] __initconst = {
 		/* Framework Laptop (13th Gen Intel Core) */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Framework"),
-			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "13th Gen Intel Core"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Laptop (13th Gen Intel Core)"),
 		},
 		.driver_data = (void *)&framework_laptop_mec_lpc_driver_data,
 	},
-- 
2.47.1



