Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C8235FC0D;
	Wed, 17 Sep 2025 12:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113439; cv=none; b=jeHtbqilQw2DxjIRNgbnZdyyy23T4SuxmhakGb8jsCM5L3lx66VgoqE4hNm6qI9Oe9sLL8blXcJL4u2sF6/QLNXphHieqIpyQRi72e+utOmy4RmvOq079ZR/Zj8Bw/I22Xe9LZzjwHQ6vvngfdWpuQ4o+erogWDTvc989sPOFEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113439; c=relaxed/simple;
	bh=Y/XMMPljclJDdN8O32AUbn9x3yDoVo6SHu/srELY+BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDQa630VUyy8F3JaT2jPA8pyyJ3HSSit44TOVXeQxFph1eA6Kn7wve14G2B4dqwA32zvV6pAtp9zAnNmaURJp+i9rmus6WBzJ5EE5dKo4I9F5kvFrX6CxrZ4vzQ1vkORrp8JvDbgk0BhtxraeQDKFHu3ApMLHnAjiYm9XPCoa8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1CZTcgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1CZTcgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16786C4CEFA;
	Wed, 17 Sep 2025 12:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113439;
	bh=Y/XMMPljclJDdN8O32AUbn9x3yDoVo6SHu/srELY+BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1CZTcgw4KewNrga8KB6A/89I/n751iI1AxEvdauypYE8qx0/3JCaYeWvF/g8xdXj
	 3r5qBrDCXEKIBW/+v+4c7Ux2+FaLWdgtjnB9vie7hnrjGSKC1Kpg6uF999Swb4876h
	 q3hu1wLW5+GY6KyiWvtGDUgCleL3qoKYeqR0AmjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 087/140] Input: i8042 - add TUXEDO InfinityBook Pro Gen10 AMD to i8042 quirk table
Date: Wed, 17 Sep 2025 14:34:19 +0200
Message-ID: <20250917123346.435167281@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Christoffer Sandberg <cs@tuxedo.de>

commit 1939a9fcb80353dd8b111aa1e79c691afbde08b4 upstream.

Occasionally wakes up from suspend with missing input on the internal
keyboard. Setting the quirks appears to fix the issue for this device as
well.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250826142646.13516-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1155,6 +1155,20 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "XxHP4NAx"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "XxKK4NAx_XxSP4NAx"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with the forcenorestore quirk.


