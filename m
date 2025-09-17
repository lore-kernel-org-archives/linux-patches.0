Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC702C3278;
	Wed, 17 Sep 2025 12:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112924; cv=none; b=LIxqjuO1Lc8sYcjoNpvpU9h3kTkQlCVhR/Q+0lFKQdU+XbQaUCoCLofj9qktNe/6oiGMhNuIzXybLWY3/VunodmCqWe+SacTOBSJjP3Whev0ecn+MfaVc5omxKXP4ecvsRTgg93QNtlAfZXtohR1lGXbprEpdICk2TEV4XPSd0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112924; c=relaxed/simple;
	bh=j4hovHMgRAmBbyRgv4tXYIMlCyfil5pGEXLsmUj0gHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdfbbnoB/lcxWjAqkFFkFPxrATeW0jx9TZT36l72OA36iS0ixV8kZxy7vxMVHf3jVjq+kvhvBF8KXqmMpMASmBJpkufYUMpxYCcZE1+kYF55qon/OedYQTcHubS8+ONHkiwVEEtB22lDYu++mRABYRasMSBPahz/DA7XlXg6xk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+VofyMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+VofyMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E0AC4CEF0;
	Wed, 17 Sep 2025 12:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112924;
	bh=j4hovHMgRAmBbyRgv4tXYIMlCyfil5pGEXLsmUj0gHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+VofyMy+lxsUCGD+/BxFnlJwO5sDDjUwSv9klQmgLoGj44YaMYo0eEBeCdXyiAD2
	 bH3WO8LSYVWLIKYESftInHk1VZmFwrtidV/fuCwBxfZ0eRZsPBFiLmul/+/zGbiaTc
	 YqOhakFxwW4W1HTC1iK/pr5x0kSA0AptONvthiHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Lin <brandon@emergence.ltd>,
	Sergey Belozyorcev <belozyorcev@ya.ru>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.16 118/189] Input: xpad - add support for Flydigi Apex 5
Date: Wed, 17 Sep 2025 14:33:48 +0200
Message-ID: <20250917123354.746617039@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

commit 47ddf62b43eced739b56422cd55e86b9b4bb7dac upstream.

Add Flydigi Apex 5 to the list of recognized controllers.

Reported-by: Brandon Lin <brandon@emergence.ltd>
Reported-by: Sergey Belozyorcev <belozyorcev@ya.ru>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20250903165114.2987905-1-lkml@antheas.dev
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -422,6 +422,7 @@ static const struct xpad_device {
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
 	{ 0x366c, 0x0005, "ByoWave Proteus Controller", MAP_SHARE_BUTTON, XTYPE_XBOXONE, FLAG_DELAY_INIT },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
+	{ 0x37d7, 0x2501, "Flydigi Apex 5", 0, XTYPE_XBOX360 },
 	{ 0x413d, 0x2104, "Black Shark Green Ghost Gamepad", 0, XTYPE_XBOX360 },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0000, 0x0000, "Generic X-Box pad", 0, XTYPE_UNKNOWN }
@@ -578,6 +579,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOXONE_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOXONE_VENDOR(0x366c),		/* ByoWave controllers */
+	XPAD_XBOX360_VENDOR(0x37d7),		/* Flydigi Controllers */
 	XPAD_XBOX360_VENDOR(0x413d),		/* Black Shark Green Ghost Controller */
 	{ }
 };


