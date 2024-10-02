Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D517E1D0956;
	Wed,  2 Oct 2024 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878637; cv=none; b=e8RAsq0f2r93bNeDn2qcc21g6vMf3KPzUGnVndS8KJqYwGTlnS3GnTpnGw8ihXEfZ3Foya1GKGSHbCZX2BconZM+dLdMULtVCzpWajq3OGo4Fts/AXE7PyJsSZZWbER47RVHH8/cTAG5hF0Sq8tG8F7NInClan9qx7zyFHOgnVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878637; c=relaxed/simple;
	bh=QiaDtRPWLNMtFQD82UqbkxP5SjLexHMBDroAddK6H9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efj+Jfsucl9YYYPRfAymdxYvpA3huZtAgtRH/Uxh0wUb1F1BrqOTg9lz3MFMa/bbrrjw1Qf5WOdkxYD9l0C1I84ZsIjOlNKotWPRTV6c0BPY39J0woC8EHw+4U+QCs3kP1B2LJSGiijkgvPh+DM+FlKPsnT/XOxJ34k5DL7yjOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fa1Ujjq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fa1Ujjq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C64FC4CEC2;
	Wed,  2 Oct 2024 14:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878637;
	bh=QiaDtRPWLNMtFQD82UqbkxP5SjLexHMBDroAddK6H9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fa1Ujjq2nNjackwQDbb6wA1N0zqWMfFi8OSooYrwZYR0lz85UpAcYrb/gFzR+E1J8
	 D76Klt7R29vXP/QSHJS5jk0aIqNPqHRIXANGP6PHuOs8wXS9kzwycgBFHxSIwIBD5R
	 7kOIzNbzArtdLv6wOJuLsPq9pCU+7ScaW7rKlgt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.10 482/634] Input: i8042 - add TUXEDO Stellaris 16 Gen5 AMD to i8042 quirk table
Date: Wed,  2 Oct 2024 14:59:42 +0200
Message-ID: <20241002125830.130076856@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


