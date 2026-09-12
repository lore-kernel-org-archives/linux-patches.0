Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACDC37CD32;
	Sat, 12 Sep 2026 10:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209554; cv=none; b=rbqKfs0uKTnK8lhQixAwQszYkIZvnSENTiHTR0bteQhhc/PgJTlFQwuPeWQ/EffvmnbYdklJMS8EX/7wWbxsiUdbzVCo5ozjKXj+YVyxzCKOb5YuAY/tLpzZCv/nnx+Zi60Ys4fyKgE+Mr5Wk/Rtb6pSSup37WOZJ58Nh9kJ0pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209554; c=relaxed/simple;
	bh=ZVawQjdidpVEZybE7sYz1xQOkb0mdbivCKrN/MHB9CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEq9+zdzNriXwb3C3OzPYCdUYp1ZBGC9xbN+sPy0enSVWg4L5xMSyeftFYwJLcLfaPuvbYnJLh/6hA9gH+CTlsd1JgVUgDOl323/UHYG4L9NfgFve8xVgRSqcZkrjtEEgA7TKMpaxGzbWQJOk7Af8SvdsLlDomvuTPV2celj6NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u00jDA2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u00jDA2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10F71F000FF;
	Sat, 12 Sep 2026 10:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209548;
	bh=gFbwor7rO9qh5DhFhZmZ4sRolwCv0TM3gMzqNq4g5UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u00jDA2FplEdr2x6UT/0CR8GSQd2cf7yYNr418zH63Y8pBvjc3gop/mD7GXRIguA4
	 c+2QXK/PWd0GzuPfb+xGPPfsc+wGNfyJKRl9m5ZXY/N/xee8PdY9eHbYAPUZWV+y/O
	 5v32IIFHG73synlmFwgMVub1Rhp3BQySQaXBJFGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0844/1518] HID: steam: Rename some constants that got renamed upstream
Date: Sat, 12 Sep 2026 08:50:13 +0200
Message-ID: <20260912065642.535716573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 6afec3c8fff2af0050ca802c9b731303ce0e2b8e ]

SETTING_MOUSE_POINTER_ENABLED was renamed to SETTING_LIZARD_MODE upstream.
SETTING_GYRO_MODE was renamed to SETTING_IMU_MODE in an older commit, but
the associated enum was overlooked.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 33ff7b49c38b ("HID: steam: Reject short reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 349d4930451ab..3eff6d0b13b2c 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -150,7 +150,7 @@ enum {
 	SETTING_USB_DEBUG_MODE,
 	SETTING_LEFT_TRACKPAD_MODE,
 	SETTING_RIGHT_TRACKPAD_MODE,
-	SETTING_MOUSE_POINTER_ENABLED,
+	SETTING_LIZARD_MODE,
 
 	/* 10 */
 	SETTING_DPAD_DEADZONE,
@@ -260,14 +260,14 @@ enum {
 	ATTRIB_STR_UNIT_SERIAL,
 };
 
-/* Values for GYRO_MODE (bitmask) */
+/* Values for IMU_MODE (bitmask) */
 enum {
-	SETTING_GYRO_MODE_OFF			= 0,
-	SETTING_GYRO_MODE_STEERING		= BIT(0),
-	SETTING_GYRO_MODE_TILT			= BIT(1),
-	SETTING_GYRO_MODE_SEND_ORIENTATION	= BIT(2),
-	SETTING_GYRO_MODE_SEND_RAW_ACCEL	= BIT(3),
-	SETTING_GYRO_MODE_SEND_RAW_GYRO		= BIT(4),
+	SETTING_IMU_MODE_OFF			= 0,
+	SETTING_IMU_MODE_STEERING		= BIT(0),
+	SETTING_IMU_MODE_TILT			= BIT(1),
+	SETTING_IMU_MODE_SEND_ORIENTATION	= BIT(2),
+	SETTING_IMU_MODE_SEND_RAW_ACCEL		= BIT(3),
+	SETTING_IMU_MODE_SEND_RAW_GYRO		= BIT(4),
 };
 
 /* Trackpad modes */
-- 
2.53.0



