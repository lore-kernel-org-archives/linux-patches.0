Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C58308F02;
	Wed, 28 Jan 2026 15:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615106; cv=none; b=NeOGaoYD0iBwOyY2T35V7OkzfvkA1hcdNrMEeNWJ95kFBFjjGdQoK9rJvpi7JOuEpci1wZ33rNU3YSbTSbDJa/ZoLJRw/1WiI+TTHVNqRnIkwWvhPiouDnMJQDx9cIpHQlGAWDn1umYoNSlXvbHWVVEAMF0DaBUdVoNk1vQjCd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615106; c=relaxed/simple;
	bh=oGA4EQad8IeKK6vSqsZ7BSt/yyPejH5pO4TikY/gY6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFCDRwf1ql2gUAk6ffKX0A522eroIXlIx2eqtNrdnOCi9XLHRsOBFkGtzSelkJUrIjJjwXm5L6KYlH9u3Yf1DfJJKzQ4+WgF5JvDW454hC9XLkEkl9kV6pDKEvcdDRcF6Zr7ESjtVeIqYfT3X3t6kMsfvFOup9HTsJ4jw2SKdC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiwP2+H2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiwP2+H2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88246C4CEF1;
	Wed, 28 Jan 2026 15:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615106;
	bh=oGA4EQad8IeKK6vSqsZ7BSt/yyPejH5pO4TikY/gY6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiwP2+H2wmq6dIu1Zmxb0nu/FdfT/DIaIcrpgzQZc30+2ZGTu0BJgkAgLPPJCm9CH
	 EnuZUpTbjDlOXp4beSooNosCKvIkodV6NHiMenrcgvY1FQMHJ2eFaMa2BZaWzG9g4x
	 b807Uer6PO0UFBF/ySDOaVAfz0Of+2jM3disCCBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gongqi <550230171hxy@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 048/169] Input: i8042 - add quirks for MECHREVO Wujie 15X Pro
Date: Wed, 28 Jan 2026 16:22:11 +0100
Message-ID: <20260128145335.746307349@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: gongqi <550230171hxy@gmail.com>

commit 19a5d9ba6208e9006a2a9d5962aea4d6e427d8ab upstream.

The MECHREVO Wujie 15X Pro requires several i8042 quirks to function
correctly. Specifically, NOMUX, RESET_ALWAYS, NOLOOP, and NOPNP are
needed to ensure the keyboard and touchpad work reliably.

Signed-off-by: gongqi <550230171hxy@gmail.com>
Link: https://patch.msgid.link/20260122155501.376199-3-550230171hxy@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1176,6 +1176,13 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "WUJIE Series-X5SP4NAG"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with the forcenorestore quirk.


