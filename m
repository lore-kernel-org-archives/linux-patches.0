Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB46B1798C;
	Mon, 14 Oct 2024 15:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918325; cv=none; b=c/sJVqN7f+vfHoXAGijbnHuILs/flYTUMgBBr7YOj66V/CCwFkp/HFNC3b7ZyWvxKge7WFkOI5xVUX1kgcUUDdtY4xswZPzp2WJnROMY1bhfH7g0SoYQC9LlZ8YWK/U3wReG8X5D1ebP6qjrPsbD6OZ7EiUAMTRBa4hj1bi2wr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918325; c=relaxed/simple;
	bh=MT66r8b+ngG/y3yWIOvOqnUMPeHh/ziOMpKB7bqod8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/m6Xi4G1IW1eY692Je7VVsqWbg368RgBfzUOQS0X6OgGMNy6LyQGbcQ7G7pCRUluEuie1+6kOS9bCfzDNCqaxBc0Y/wfoL1KpE1P2dY0Rkac/46vm0HymQXXPYa1Gy4Xz74f4cxFJL2E0iD1is5j6fQ6KuIP6vYXEJ0sKxDsXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2cQDuCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2cQDuCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABACC4CEC3;
	Mon, 14 Oct 2024 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918325;
	bh=MT66r8b+ngG/y3yWIOvOqnUMPeHh/ziOMpKB7bqod8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2cQDuCe4PIjue6vSNkz2M6iGP3wMGoXz2SRWLbvlxu/j5bfeONNqkh0uHWc1Upz9
	 82sGJpB3Z8o36RCSXzsf9H7+LY5xzgPrIdan5Q7oyykds1yXSIrORnYyXCJOTrcgqj
	 23cnoHhYBgTMK0vKHsU13PtDpNczbROYoTj9lMl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 288/798] Input: i8042 - add TUXEDO Stellaris 16 Gen5 AMD to i8042 quirk table
Date: Mon, 14 Oct 2024 16:14:02 +0200
Message-ID: <20241014141229.258613730@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Werner Sembach <wse@tuxedocomputers.com>

commit e06edf96dea065dd1d9df695bf8b92784992333e upstream.

Some TongFang barebones have touchpad and/or keyboard issues after
suspend, fixable with nomux + reset + noloop + nopnp. Luckily, none of
them have an external PS/2 port so this can safely be set for all of
them.

I'm not entirely sure if every device listed really needs all four quirks,
but after testing and production use, no negative effects could be
observed when setting all four.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240905164851.771578-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1121,6 +1121,29 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	/*
+	 * Some TongFang barebones have touchpad and/or keyboard issues after
+	 * suspend fixable with nomux + reset + noloop + nopnp. Luckily, none of
+	 * them have an external PS/2 port so this can safely be set for all of
+	 * them.
+	 * TongFang barebones come with board_vendor and/or system_vendor set to
+	 * a different value for each individual reseller. The only somewhat
+	 * universal way to identify them is by board_name.
+	 */
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GM6XGxX"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxX"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with nomux + reset + noloop + nopnp. Luckily,
 	 * none of them have an external PS/2 port so this can safely be set for


