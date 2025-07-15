Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211562F2376;
	Tue, 15 Jul 2025 13:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587895; cv=none; b=BgqaMUQ7PHmIYvt4o+HUJOZYWtc/oBlaGuZjjdlcmnNdDXsCn9LKmSUoh4SVf/FNsLGEPlDvE/fLDm1oTbQaS/0slCJHnK1wHqbmNximSHoythMGQQP+vkuEUV9i1TMiAwbHJFdE5ioIT8X3u8S6kgG2XFGJHWrOVReUZl2G4XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587895; c=relaxed/simple;
	bh=PIuXTNMY3XDdy6Sw+a29uu5UoMKab7YHxKQbH692GqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBObLessCsbP91QEp7dhQZMyMFU/Lnr5U22eZVDxdahj0tmjWepIxb759nmr28VHTcHTxRv2ZYQa+vFppk6ekp0EKT9i9agzPmCJPZq18PycwCwzxgaiBLdhZ3uic3OcMlITInIVRpTplkf4QuRJmRR5+Diw3BKZAV+TbnBC4fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZQsc4wn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZQsc4wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A902CC4CEE3;
	Tue, 15 Jul 2025 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587895;
	bh=PIuXTNMY3XDdy6Sw+a29uu5UoMKab7YHxKQbH692GqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZQsc4wnDF9xvOLHTbk7WXy1eAdHkj934VeLf6xPYnOZElrQSVrA9ZJvLAz52Kt12
	 00suPnLbMOzVYmBE9pkHlhSu0I3lQp+yESc8z7kCJEzSKbctgDd79r8VSWuS+7vcYe
	 EvbQ36nMZJSL4S8Cc2hO11imn5BxICWSuJ3aZuUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Reynolds <mattreynolds@chromium.org>,
	Harry Cutts <hcutts@chromium.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/208] Input: xpad - add support for Amazon Game Controller
Date: Tue, 15 Jul 2025 15:14:52 +0200
Message-ID: <20250715130818.287724169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Reynolds <mattreynolds@chromium.org>

[ Upstream commit 05665cef4b745cb46b1d1b8e96deaa25464092d3 ]

The Amazon Luna controller (product name "Amazon Game Controller") behaves
like an Xbox 360 controller when connected over USB.

Signed-off-by: Matt Reynolds <mattreynolds@chromium.org>
Reviewed-by: Harry Cutts <hcutts@chromium.org>
Link: https://lore.kernel.org/r/20210429103548.1.If5f9a44cb81e25b9350f7c6c0b3c88b4ecd81166@changeid
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 22c69d786ef8 ("Input: xpad - support Acer NGR 200 Controller")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 00b973e0f79ff..fb714004641b7 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -275,6 +275,7 @@ static const struct xpad_device {
 	{ 0x1689, 0xfd00, "Razer Onza Tournament Edition", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfd01, "Razer Onza Classic Edition", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfe00, "Razer Sabertooth", 0, XTYPE_XBOX360 },
+	{ 0x1949, 0x041a, "Amazon Game Controller", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0130, "Ion Drum Rocker", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
@@ -462,6 +463,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOX360_VENDOR(0x15e4),		/* Numark X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x162e),		/* Joytech X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x1689),		/* Razer Onza */
+	XPAD_XBOX360_VENDOR(0x1949),		/* Amazon controllers */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harminix Rock Band Guitar and Drums */
 	XPAD_XBOX360_VENDOR(0x20d6),		/* PowerA Controllers */
 	XPAD_XBOXONE_VENDOR(0x20d6),		/* PowerA Controllers */
-- 
2.39.5



