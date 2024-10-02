Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D5E19752C;
	Wed,  2 Oct 2024 14:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880284; cv=none; b=dvYrcrA2Ew4nePeVNBlQS02D1xiYwcGbKvunBmtiwqBZKOckLa/dRfjbKGQpja6pNcOhQ6TJSeQ/d4H9jIdLipLHa9+XHsIIOa7bkdUUQBtM2W+KDmUxfecVxEFgSMxdkhDM7bGScuCoaHYlB2owH8fA8AikwvTqNSFcRlTj64Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880284; c=relaxed/simple;
	bh=YMqbZdF0TmUa16pwLX34iQFRYqv1gPfyHuBgpgAy8YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSIPBLCNbQmH3vFQTAiw/0brQbFhWJmiOF9EAVl6t40xyg3ku7ncNJoTSLqCsQhWAYWqrepWLf8ROyNQjoiXnj5PvQ6bmytYf5GC7sRLjH0ztYLn1lDwgrYj6T6BV5Bnui4IEjWRgDZKzCH2nz0KGzt3S31xgyH/QqcIEesB2Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WWnymB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WWnymB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21D6C4CEC5;
	Wed,  2 Oct 2024 14:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880284;
	bh=YMqbZdF0TmUa16pwLX34iQFRYqv1gPfyHuBgpgAy8YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WWnymB9bZyiIeFfLbaNEYQFlyybP7vUrIowlUjrI6sVs1aXOxA7tlBjk0uHGWhWH
	 85bi17V3r1LsoC/eEsPMiqgrbAWtSQxmyBHrxeBM5nOT9kg8Iawe4dYFuc3b1Aj4Ge
	 0HLf4aEhMCyO8UZvMzKOK/TPnIHukINVpd25N69c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 407/538] Input: i8042 - add TUXEDO Stellaris 16 Gen5 AMD to i8042 quirk table
Date: Wed,  2 Oct 2024 15:00:46 +0200
Message-ID: <20241002125808.501087024@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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


