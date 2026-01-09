Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAD331ED6D;
	Fri,  9 Jan 2026 12:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962217; cv=none; b=lEjFBEuGS4EFQTS6RDQCZMnwHVmQxjjkbi4KkfBk4EvGwYNCv45qac3NuYD5Q8Fws7IKt8BXN91Kw1ZiLGNYdiQuLR7xpTB0oD4XQ2ea8AE1L+rHh0WLRXinAADyosZbh0gQk6nWn6wDeJ4jmjXuCD32amaem6X8tyXmsUjQvzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962217; c=relaxed/simple;
	bh=GsaXjlM4lK13U2PqQd0VfRJwb63hXXUrKsLIroGes/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoYQBpPIL4aH6dvv1Q7E+TwYSncvAeAOTNpx5jcWI5ozH/fvZUKVSnvDyZI+P3UPhA4Nlc6Q2dRpUqIfscrVq1RHns2U3Cr/CB2S/Wr/elWpdHHI0gvqbFmc25V96L1+quLyzXTEPn4mE2cETN+wx4kuQYl336nTkLg9wZSfS/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgzxdUpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgzxdUpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAE0C4CEF1;
	Fri,  9 Jan 2026 12:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962216;
	bh=GsaXjlM4lK13U2PqQd0VfRJwb63hXXUrKsLIroGes/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgzxdUpYU6dRrIItpemd8vUfI2Xr2n7UG3WlSid0AgASd36wEnXyXr73H12ivIUFH
	 y42DboMr//399DbCMGzbEUuw9M5IHrOIRdmsTqoBxFxw5lYqU1dgcAkFmzS/rLFjYr
	 uzmYMMy3lCjKPmta7YXxUgg1IogLzkNd8v8ttugw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 288/634] Input: i8042 - add TUXEDO InfinityBook Max Gen10 AMD to i8042 quirk table
Date: Fri,  9 Jan 2026 12:39:26 +0100
Message-ID: <20260109112128.368055602@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit aed3716db7fff74919cc5775ca3a80c8bb246489 upstream.

The device occasionally wakes up from suspend with missing input on the
internal keyboard and the following suspend attempt results in an instant
wake-up. The quirks fix both issues for this device.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251124203336.64072-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1169,6 +1169,13 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "X5KK45xS_X5SP45xS"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with the forcenorestore quirk.


