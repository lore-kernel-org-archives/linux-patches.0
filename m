Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB702E3385;
	Tue,  8 Jul 2025 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993082; cv=none; b=pGcbsxAy9yif26PFqjXPxx171p99V6bly1UGEnSwuGcKkxXC71VLAywZ34Y+H6cUU0qy5E4YkEd4ZjUr42zB5pIbAZLSYsx7GdoYFr3MnD5P0gJ/i0Bp6drKPWjtbLwgrhGdyZIET6hMPshHUsushT8KA70fZSujEXL0gIGb9j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993082; c=relaxed/simple;
	bh=cu1ErXtXdiZjP3oUPuKtG9ROH86DL9C2SzbxsqvsKPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7CaXtw7MjwkmGpdfs8BoZcayza7/ABp6ceBOrzPIOiOuvCS+zPWaZKzLzUGcnvqKAqfRx3WP4zw2BRKMf7j/sLSpYdLc0Ekf6AbhjbdYiK55Iq28xOWfC16BvLdvFxRmKQt2W5FpzTgssGmNZM0jfrmKDUkxG9C8AGtVOxoPcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTaQmd4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTaQmd4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270F5C4CEED;
	Tue,  8 Jul 2025 16:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993082;
	bh=cu1ErXtXdiZjP3oUPuKtG9ROH86DL9C2SzbxsqvsKPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTaQmd4+lSgrK3YQq5hnHLjAxXqxbtvtNEnNYgf5ffRZi1RMvBEX8MVdU8GD66NHF
	 kK2LIfSqtoLpTRziC6nsE9rxrlrO9nserKA+VMCRz0TE7FnNmN62igMnX7qxeE8IgQ
	 N92Vp5FbsFRACKf8h5E2Aqzs6p6sqWUttNqzZErE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raven Black <ravenblack@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/232] ASoC: amd: yc: update quirk data for HP Victus
Date: Tue,  8 Jul 2025 18:22:57 +0200
Message-ID: <20250708162246.170594672@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Raven Black <ravenblack@gmail.com>

[ Upstream commit 13b86ea92ebf0fa587fbadfb8a60ca2e9993203f ]

Make the internal microphone work on HP Victus laptops.

Signed-off-by: Raven Black <ravenblack@gmail.com>
Link: https://patch.msgid.link/20250613-support-hp-victus-microphone-v1-1-bebc4c3a2041@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 4f8481c6802b1..723cb7bc12851 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -521,6 +521,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Gaming Laptop 15-fb2xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



