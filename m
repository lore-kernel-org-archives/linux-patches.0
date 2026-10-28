Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212743;
	b=OtOc7ZIqaI8ZOlu+ge4umpP34mFf92wgKwdNFJSXjoV9Uw0rpoodJhncWrR54Hb93mFo
	 rFgEGKlHnhMXlAJVbsFUDzVSE5tWr6FV8N8TiA1GWKrMJTb7zNXxeCTXo07s/C8Ovtfy6
	 wO2wwtRd7kRLuKrFR6HfnqMDQtgCqYJmyjighZZc+bNVEJFugNBU8jg8Hckj9t0UWbkF9
	 iK/BykfwlWvwkl3oUkWTXPC4iot7QN6hPeZA8r+dt2xZQnR17iA3G/Io69KUvgy7FLcT3
	 3o9Lr3EpIaPRnmhDWT96ZrB5pzs3K4aRbtFbA/fphIEWQQiiG4hbF/mkwxxIit1J4Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dll4qN21eK0g4WTI4m7t8hQkl+dRX/aXbyJNKWvbq8k=;
	b=CyBMHJKmbv7c5699q2UEouR9nbylfy5IW9E5WhQumzJo5K4pOaReFTuPOnAkik91BRAb
	 MJybwZi7mGmblG9JnOzKF9mMOIECSw98RJLfN2F/3ROzmgfbukAsBCtMC8Xy42Q00AG1C
	 abmb0jwVuR41m9RZKnf3/u3cyTL7QcA64fR2FIIcUea8dUMiNjhIVLtubPKg7Dj1byfaS
	 WbqAkIt61rOH5ZoO1Q+NjcLAW+1Hv7qXuqVe6g6QWkQ6bg31ubSa4lvlIvlaWuoVvJkg6
	 m/SL/WTJ2DIUMRDWANoGyLyQwkFOuJkL235hhkKZcHX9rf4FwyQZGT5g2Bwcc6KcUqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVyMoz8P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6AA606A31C;
	Wed, 28 Oct 2026 18:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVyMoz8P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDAE1F01825;
	Wed, 28 Oct 2026 18:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212743;
	bh=Dll4qN21eK0g4WTI4m7t8hQkl+dRX/aXbyJNKWvbq8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVyMoz8Pb01pI1O5JRGiB4G6Cljo3CviBn7WyYXrvotQeHs15fLy4DwxKMBqPznG8
	 EZ+AIh+x3BaL1yUwZvCSfEfF7xk/NBxleBSH4bmE3a/UEvQOUWG3vMN7/R2BJWEQVM
	 xUdM5UUxjI8Q3bGSqfATa3eieyMlaja9asz76/rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0262/1887] Input: s6sy761 - fix resume ordering and restore sensing
Date: Wed, 28 Oct 2026 17:39:18 +0100
Message-ID: <20261028170505.193156380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

commit a215720959c5450b3699e243904b39c3f8f68888 upstream.

System suspend powers the controller off and resume powers it back on,
but the resume path enables the interrupt before s6sy761_power_on()
checks the boot. The firmware raises its boot-complete event on the
interrupt line, the threaded handler consumes it, s6sy761_power_on()
then reads an empty event and resume fails with -ENODEV, skipping the
touch function setup:

s6sy761 2-0048: PM: dpm_run_callback(): s6sy761_resume [s6sy761] returns -19

Power the chip on first and only then unmask the interrupt. Once resume
completes the boot handshake the chip comes back with sensing off, as
at probe where input_open() turns it on, so the touchscreen stays dead
after resume. Send SENSE_ON again when the input device is open.

Tested on a Pixel 3 XL over several s2idle cycles: resume succeeds and
the touch function and sense status match the pre-suspend state.

Assisted-by: LLM
Cc: stable@vger.kernel.org
Fixes: 0145a7141e59 ("Input: add support for the Samsung S6SY761 touchscreen")
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260926-s6sy761-suspend-v2-1-8f00a96ee6e8@ixit.cz
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/s6sy761.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/input/touchscreen/s6sy761.c
+++ b/drivers/input/touchscreen/s6sy761.c
@@ -508,10 +508,22 @@ static int __maybe_unused s6sy761_suspen
 static int __maybe_unused s6sy761_resume(struct device *dev)
 {
 	struct s6sy761_data *sdata = dev_get_drvdata(dev);
+	int err;
+
+	err = s6sy761_power_on(sdata);
+	if (err)
+		return err;
 
 	enable_irq(sdata->client->irq);
 
-	return s6sy761_power_on(sdata);
+	guard(mutex)(&sdata->input->mutex);
+
+	if (!input_device_enabled(sdata->input))
+		return 0;
+
+	err = i2c_smbus_write_byte(sdata->client, S6SY761_SENSE_ON);
+
+	return err;
 }
 
 static const struct dev_pm_ops s6sy761_pm_ops = {


