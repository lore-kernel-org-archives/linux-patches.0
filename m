Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A324E322E;
	Thu, 17 Sep 2026 17:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667504; cv=none; b=NBwIoIvFGAwLdTPvFtLyUpyUxrY1AJ54ub1wvuVD1KLPfEwiVTU28KHrTIFqSfVcLqImEFqA8bZwb/T++ckQ+QOd35GS+z+iII17qnjQasQGzpwU4zc+G+cI2+UUWtGCxYTX9fDoNn5IBPOgHW+rwF6TeqpG671PoGrffK+Z7t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667504; c=relaxed/simple;
	bh=oGBPelQfSieYFur7ySsjYvQGcRAmEUETwsWi1JZchPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDrjCHfGSQ2knAYxBi8MeDJAbaZPBk54unC8LVbMM8gTE7w4S6y0+5OzELNeEz78v7coiX59HxxbP732I6QaA4tqfj1kqKeAt/ElVa26i3fIP78twzXdLxlOv5L5Ms6PZ+YDQfb6GnZTIVRYYsWmAhFcprDYU5lH3nd6C2Vslh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3UU+aoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3UU+aoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4361F000FF;
	Thu, 17 Sep 2026 17:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667503;
	bh=iac/EN94S6QkZ9XxTd3DK45ZHCbYfgjHtybVujSbuIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3UU+aoCmoUK3842x5C3F2XBJPhwN1gQLwMSLQrdN/bR8P6XoLVSTIJkwBDGpQeh0
	 wl5xKxip+HaQY9wm7IMqVEG4UW+eQo1lWCwqdwJtI3Bravjso7w0n/jGRRJWFMyTv9
	 yilSn8BmOd14o1JIBwcU4W8FD9caAx23IL4ff5HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Baldi <baldovic@virgilio.it>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0088/1102] media: imon: Add iMON VFD HID OEM v1.2 key mappings
Date: Thu, 17 Sep 2026 16:00:31 +0100
Message-ID: <20260917151541.687292845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Alessandro Baldi <baldovic@virgilio.it>

[ Upstream commit d97d13c24d7893abcfb80d38630ce74daaa1434c ]

Add Vol+/Vol-/Mute panel button mappings for iMON VFD HID OEM v1.2.
This version differs in the codes that generate the
KEY_VOLUMEUP, KEY_VOLUMEDOWN and KEY_MUTE events.

Signed-off-by: Alessandro Baldi <baldovic@virgilio.it>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/imon.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index cb9bd5a6ff54f..15b66fbfaca35 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -295,6 +295,10 @@ static const struct imon_usb_dev_descr imon_OEM_VFD = {
 		{ 0x000100000000ffeell, KEY_VOLUMEUP },
 		{ 0x010000000000ffeell, KEY_VOLUMEDOWN },
 		{ 0x000000000100ffeell, KEY_MUTE },
+		/* iMON VFD HID OEM v1.2 */
+		{ 0x000000000a00ffeell, KEY_VOLUMEUP },
+		{ 0x000000000b00ffeell, KEY_VOLUMEDOWN },
+		{ 0x000000000c00ffeell, KEY_MUTE },
 		/* 0xffdc iMON MCE VFD */
 		{ 0x00010000ffffffeell, KEY_VOLUMEUP },
 		{ 0x01000000ffffffeell, KEY_VOLUMEDOWN },
-- 
2.53.0



