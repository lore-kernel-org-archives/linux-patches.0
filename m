Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052033;
	b=pVnjMB0qP1wBNjXSa9do1EASBqBB7sT+FQCQ7BEab8wZG1Z33AH40fu9p7d7q04aZiL9
	 kmKO8d2xoPVVlWnynYndNKnzNMc0LmXOqcsmnSjBkSwaBVBnGsJWTD6c4y0W4i9mlHq7s
	 Ka5gp+GQWN7ipwQD6uYZRdLg7CecswwMNf2DjjAcrvYZecRY6r2IhUDa6VrferIZpj8AE
	 lqhLw7SgyIPaSxRlewQnfEyk0+3390nxZYBryujh4Mlt9dFJWJi6eRqbHtiP+y8jAJkSd
	 FlFRdt42qGQ7W5x61el6f0jYf5tGUGz/OTi2qZGK1dXrGe+W/9pU7m/T96ihwvBXttQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dIEM/zDKCm1rWppJNV0fE3pBxNLU8yqQdgipTE/fjvk=;
	b=pRTO1v1R+bCcJiDMcbvd0r08L9qKJaZDRuSp/MaI7q3MzyfoV1qM44DuCgVgoratMYRT
	 n5auGLrRWRO+bh/CC4zR93Ywd/2v39ReBwwOKHmG5Z+UDlzcDbHnWCsIAy09RH1wL8gLe
	 ymyYykmRx84+6nf12QDqRLIDa8MErBRXoZ5zq7kqHVzPKO1c0dpl3cxdx3/1z+EFzvMi/
	 FM9ZfgyvCOAE0Ihuh5OrIAbpEUu4fpjsHshA7V0rcwCXdpzOQACz9R2EfpnJajBcjVafo
	 +WqTySD2LT+ocwb2EhF1jyhukGHGoOJJkTVsYzUeuNy/iXP2ttcT7TbXt7FEBTHtc1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u47m9whn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCAA606A31C;
	Thu, 19 Nov 2026 01:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u47m9whn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C541F000C4;
	Thu, 19 Nov 2026 01:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052033;
	bh=dIEM/zDKCm1rWppJNV0fE3pBxNLU8yqQdgipTE/fjvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u47m9whnOQ2OozaBKvKCSMgHJ9AIoJOaAL9l2FeCv6aHPAV0zuUZAuhUJ+cLDenLi
	 cEj0+U6hMJjREZ31TrYeSLM26m4JGPToPvSDJCkZ7k87GdLPjCeyGdKQ9QrJ52oNtl
	 X+czoyE6mDF6viTUh4VQpH4sJM0hQecTBeKFjkcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrej Scek <scek.andrej@gmail.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 0370/2214] HID: amd_sfh: Remove unsupported motion-state field from accelerometer report
Date: Wed, 18 Nov 2026 15:34:06 +0100
Message-ID: <20261118150025.530669839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -47,8 +47,6 @@ struct accel3_input_report {
 	int in_accel_x_value;
 	int in_accel_y_value;
 	int in_accel_z_value;
-	/* include if required to support the "shake" event */
-	u8 in_accel_shake_detection;
 } __packed;
 
 struct gyro_feature_report {
--- a/drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_report_desc.h
+++ b/drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_report_desc.h
@@ -168,13 +168,6 @@ static const u8 accel3_report_descriptor
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
 


