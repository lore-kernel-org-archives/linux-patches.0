Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F0B303C9B;
	Tue, 30 Sep 2025 14:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244094; cv=none; b=rI1PdVIsxFmM6lVN0iuof+zEyXWPA2Qz/RzasMgdWBv8OaWJaL/i0XsqCC0Ct6mJgEUUCmx2VoTP4HqqgSfU7UBhkojjrkle8TkPG+753gS9sBhsa4rbfQSMoJsW0DjrUu0m8zuvY3jjv3xs5jmiWOeq+lxhiONF4TmSm0Bm6uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244094; c=relaxed/simple;
	bh=XsNXMEjKoi511JPvaHu3JLF8w+TxE3iHQgflQA2+mN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7o6+I7GjhKVWrlKyeM8t2FsYS6Gdcn1C7MYdGcealPAXo4cng5+hDTqWW0DKRe4EJ3q7je+Sswlvk5S/loob+QPlvb/yLZK03SiF6+axGOmwp4w2J13xCM0SUmKRBAxhCbBhv4ypd8BL9r8Uf9j0ANMIYopViLP2CPlPCXJ6h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuFeL3Wq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuFeL3Wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D652C4CEF0;
	Tue, 30 Sep 2025 14:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244093;
	bh=XsNXMEjKoi511JPvaHu3JLF8w+TxE3iHQgflQA2+mN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuFeL3WqPLK5uS3CX3z0nFIRVSZ8LiCByquQOlWMtyE1LCdVXQmEWHSJgYJKIHxJ7
	 36Uf1rJtX1NZ7BK+6+2spRTo3VgGk6DqJ8NhubUbaNSC9hZrgKhW9FILdtFE7GKz+W
	 ialdXbvw+QrV/sIqNckQOVnzOI1umW1LvQruHiLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 026/122] Input: i8042 - add TUXEDO InfinityBook Pro Gen10 AMD to i8042 quirk table
Date: Tue, 30 Sep 2025 16:45:57 +0200
Message-ID: <20250930143824.073785732@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
User-Agent: quilt/0.69
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
 	 * after suspend fixable with nomux + reset + noloop + nopnp. Luckily,


