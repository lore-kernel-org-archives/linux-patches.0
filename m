Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831907;
	b=s3ElyGEGYHx5SBz3duyN0p7czE0b8zlWLOjt65jodQA5iU/zHWA1zYZdLfwSKxZSy3nm
	 Mn1iz/bDwUjtSQsPM8oZAc/H2pzhj9EFR2oqBRMWMGJD052cJFtwg932nOgx/33forkxJ
	 Wy4W/1uTDUZdIzci8Xtkcy53B6kA71BWRg6T47NGA9hmjERVU4lFmqLNqRYhbp9MpKIx8
	 fGQ9m+J1bV49iiy68Pob7FIeDFnOjNB+FnG+9KCKVfM6xut8ehKdXNf73HWsnw40iLyfH
	 8hG6RBXx3I16vJdPV892mHb/8rni+EHySeXHkuQhjWl3/xYh5MB9I8EHUcQhRrSUfGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QpMHiOd0e7DUaySupHLRL37dTv7BmmvDJ8N9V9g+kqg=;
	b=YqqUh3ZGVay2oINCmQ6NMYEO9Xyi6J8eZK5+/zTk3eOgNpjMlXbIRwgUzxuC/nPJkcoM
	 axxzvRqEte7u953htp8sA945gNUVhMXAO2Pbeqd6gRCCUd1lju4xCnhMq2qVGOf9y/A1u
	 W2tlAZ3AtfSL9cf3/XHw3JncdBT7ONjZtq+m49+1PPJOsU2o88MuG881VnsXQWGwEfZ9d
	 3PWxHkZT0t8UoyS41hItyGhKmgO9rui+v9WpnNi9uNvKGyx1IOHakx71f+3tBuFnahHBy
	 FFVLb+iag3Aac8zx4p1/FHwvDIaMP+6sIyD3U6FAM1NaCzfbBECFB7bUfo/6UiQZPVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jMsD5ldd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9801A606A338;
	Wed,  4 Nov 2026 22:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jMsD5ldd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0011F000C1;
	Wed,  4 Nov 2026 22:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831907;
	bh=QpMHiOd0e7DUaySupHLRL37dTv7BmmvDJ8N9V9g+kqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMsD5ldd8MJH5/yTgja+bJ7aX/ZAJNMUYJyyvoCJFo/lLJ2kphbgOqYwdBSH9s613
	 z2vpwmWLA5TtdqYMQELG7SLBlJMh/pp2LBQ6ANpVzZyeIZxr/Mmr7NBmJAbtpD4o0t
	 EBpNYsyD0SmvcbbS4inIAPWUv33eyhZuFvmqkLrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrej Scek <scek.andrej@gmail.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0946/1005] HID: amd_sfh: Remove unsupported motion-state field from accelerometer report
Date: Wed,  4 Nov 2026 16:11:19 -0500
Message-ID: <20261104211109.611705063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit 6ff86122906357687735dd379c6279e3b2fa26af upstream.

The accelerometer HID report descriptor declares a trailing motion-state
field (usage 0x0451), but the Sensor Fusion Hub never reports this data,
so each accelerometer input report is one byte shorter than the descriptor
advertises.

This was previously harmless because hid-core zero-padded short reports.
Since commit 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing
bogus memset()") such reports are rejected instead:

  hid-sensor-hub 0020:1022:0001.0003: Event data for report 1 was too short (15 vs 14)

As a result the accelerometer input events are dropped and screen
auto-rotation stops working on AMD SFH systems.

Remove the motion-state field from the accelerometer report descriptor and
drop the unused in_accel_shake_detection member, so the descriptor matches
the report actually provided by the hardware.

Fixes: 1434f9fc0e47 ("SFH: Create HID report to Enable support of AMD sensor fusion Hub (SFH)")
Reported-by: Andrej Scek <scek.andrej@gmail.com>
Closes: https://lore.kernel.org/linux-input/CADrS85612m-Hh-G4BJmOhy-y6r3Ni3kD8_GM-2QRBeWWEEZWuA@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.h        |    2 --
 drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_report_desc.h |    7 -------
 2 files changed, 9 deletions(-)

--- a/drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.h
+++ b/drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.h
@@ -48,8 +48,6 @@ struct accel3_input_report {
 	int in_accel_x_value;
 	int in_accel_y_value;
 	int in_accel_z_value;
-	/* include if required to support the "shake" event */
-	u8 in_accel_shake_detection;
 } __packed;
 
 struct gyro_feature_report {
--- a/drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_report_desc.h
+++ b/drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_report_desc.h
@@ -169,13 +169,6 @@ static const u8 accel3_report_descriptor
 0x95, 1,		/* HID report count (1) */
 0x55, 0x0E,		/* HID unit exponent(0x0E) */
 0X81, 0x02,		/* HID Input (Data_Arr_Abs) */
-
-0x0A, 0x51, 0x04,	/* HID usage sensor data motion state */
-0x15, 0,		/* HID logical Min_8(0) False = Still*/
-0x25, 1,		/* HID logical Min_8(1) True = In motion */
-0x75, 8,		/* HID report size(8) */
-0x95, 1,		/* HID report count (1) */
-0X81, 0x02,		/* HID Input (Data_Arr_Abs) */
 0xC0			/* HID end collection */
 };
 


