Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044760;
	b=xEsmqPSe3dx4ag7fwHBBNuJmpNhBOG1UIKojqFzcMRIBAtSaqkG+v3kbT2N0DN4muk2U
	 gKaAhTnseS//YQ/6v0L3Qp2CmHrQjJVvN3HsD6pzYvlbtL+iKsJh8AvZDJPCulLp6h+Lq
	 BRFFZLiba6t9Zkfr9mOjN2m0eAY4yydeH504hqNNFwEKwESBvK/aPIWkFRGQF9CI5GMx1
	 DKmjT9aEmQwiQPSOK0zoGkUtIRx4+eYf3yKs582ipuniLcPoc9W2E4iwlh1WkGCa7Me3X
	 qkeLBCvwfINcEqQ2bATnuhfdeNihdNMS22Net4NtOq5KBzZ/7g8g/oM3eGSwXxbggiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YGlz02wBiplppSEd42GpV7DigA/Csi88oYCU/dpyGL8=;
	b=TVIEA6UniIDwBC5W5I07VqjTkBbuIuSiuotaC+KwbxgN2ok62PmUirydHNpnyypI7TNO
	 649T4hl8Q/9VBeuJwPGFwtbD/ZLHAwqQwBWS32TbNNOnz+FuZcBzycZnkwuZlXuEKAEYV
	 qg4HFpis+NU8sHoOyIl/Bl9wAqwQEwI1J0NXY5Yj/BIDDh/33gWHe4XQ1M5uR6HZgeLKL
	 7d2X5CAY4UJN6FUWsf7S5fgG61JoWBRzOh2RQdsHC2/A5I0ke+DA8MT3mjQ0gt/QYooab
	 jzXU0kVACnWVocV7lThU0wt6bPns089wkQ57b1Sird9bPUykGjFxIxRMXFhZIV1xF5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kbK7ukfF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BBE60A2601;
	Wed, 18 Nov 2026 23:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kbK7ukfF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825121F00931;
	Wed, 18 Nov 2026 23:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044760;
	bh=YGlz02wBiplppSEd42GpV7DigA/Csi88oYCU/dpyGL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kbK7ukfF1hE1UTqbo+XmBF3jlaWFsaKf9fipf4lhF6F1v+nb1wEJPqc4+gCkq5E2f
	 oUXeHgdexFYqxINM7E2+3NpCSoRiWCdOw60Ld+jUbQCIv531ccGCUG+XzJfiOKJhM2
	 CHnHLyvTZundFaq5fxFklDT85wDx1EnR+vjVbxUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrej Scek <scek.andrej@gmail.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0631/2857] HID: amd_sfh: Remove unsupported motion-state field from accelerometer report
Date: Wed, 18 Nov 2026 15:27:45 +0100
Message-ID: <20261118150224.222298641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


