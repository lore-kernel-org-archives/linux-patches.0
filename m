Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE339383;
	Thu, 30 Jan 2025 14:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246580; cv=none; b=GdVn9LopBr75BqVsJLqzedERI4c/RQlfDppENverK+LcOKu71yR8/MlBcOfaJAz2ALODtLelg3JEgZ4/4sD8Oc61BgDvnNlJRb+cwg2Gx1+yiAmhcjGwvv4XKqDXUXcMgHK/fWalyVGkZg2qQNBPVLDNeEL27puIvZkVCR55H4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246580; c=relaxed/simple;
	bh=WtwYU2pDAIcqnp107o8miOIx8xJxREx8Ao9bEViZq2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xae3rlpite7ggJbvCstt2LzVSG8M/nhoAt1B0P26gB5dctOn1YyJI+YSZ0zevzq9zm3MUT4oTornwXzyGE5UrtHz3XNtObczmIhH2i5xOuPeLVVelKmJBD8aHeOWTvmCedKH+mFDvA+ay0nm5qFkJHVMJ5aZUt93RyqtY5WOM+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFF5MVjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFF5MVjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D92C4CEE2;
	Thu, 30 Jan 2025 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246580;
	bh=WtwYU2pDAIcqnp107o8miOIx8xJxREx8Ao9bEViZq2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFF5MVjD+TeHiv6eOA7EbAWZ8cLN7hh9PtQVSpOBEIXWgZWundZR7BiWyPef9IZQT
	 zflLzusmOGpQx7njFH0ckdysfUS8HasbMJcUq2/fuve9uyvAny8aUuW0tocb6mIH7K
	 GinEr6DxaUOppi35L70JNotWBSfeDu0frTCIerSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
	Vicki Pfau <vi@endrift.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 40/43] Input: xpad - add QH Electronics VID/PID
Date: Thu, 30 Jan 2025 14:59:47 +0100
Message-ID: <20250130133500.506233769@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>

commit 92600f3295ff571890c981d886c6544030cc05f3 upstream.

Add support for QH Electronics Xbox 360-compatible controller

Signed-off-by: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
Signed-off-by: Vicki Pfau <vi@endrift.com>
Link: https://lore.kernel.org/r/20250116012518.3476735-1-vi@endrift.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -306,6 +306,7 @@ static const struct xpad_device {
 	{ 0x1689, 0xfe00, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x17ef, 0x6182, "Lenovo Legion Controller for Windows", 0, XTYPE_XBOX360 },
 	{ 0x1949, 0x041a, "Amazon Game Controller", 0, XTYPE_XBOX360 },
+	{ 0x1a86, 0xe310, "QH Electronics Controller", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0130, "Ion Drum Rocker", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
@@ -515,6 +516,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x1689),		/* Razer Onza */
 	XPAD_XBOX360_VENDOR(0x17ef),		/* Lenovo */
 	XPAD_XBOX360_VENDOR(0x1949),		/* Amazon controllers */
+	XPAD_XBOX360_VENDOR(0x1a86),		/* QH Electronics */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harmonix Rock Band guitar and drums */
 	XPAD_XBOX360_VENDOR(0x20d6),		/* PowerA controllers */
 	XPAD_XBOXONE_VENDOR(0x20d6),		/* PowerA controllers */


