Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6BC3D45E5;
	Wed, 30 Sep 2026 18:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794107; cv=none; b=WtNiSnxb6EO3E/eua0TTzaiYIqSnT0OIfH3HxDBhCFHV7ovo5CRp7vD3QK8dsEktCf9bAb/sd7k8iQgioKmi47fUYJ+QPVULO54dzR4UVwmB2WAlM57eM4H+WysYk7XC3f48cXUmqQa6rCI8sU+BIdvaZvt01PzN6I+Il6HzG1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794107; c=relaxed/simple;
	bh=wuqMFSylIzWUhxFtUHiSML/ZvXWG1Yy4NyG7uccQ5wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJlZ6d8AI7ZQy9bMlUf1xNe/FIf3dstmULMY8x7XTuM7UlA0Z4Tz2VklCX3PZAqQhOcSL0Xt4LZVBmXwdRvgZNU4lh2K/O9FQ55S2dCYL/QU2gn7UmrmxrMccl5DRUjgT1KA9ZGYdRxSk80Gi7FNyDCdmYIA/GkHDJxlzaHlcJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnOcqGwV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnOcqGwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8071F000FF;
	Wed, 30 Sep 2026 18:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794106;
	bh=Y41h/dHJ7iy/vZoNu4ai7gQvZET/GSDan4fr+4OF2B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JnOcqGwVvzKa0fxj/d0Md4O/TW/bspARaaJQzcgpcLPHKmOur7kXjIdFdaXX7SNxf
	 C+jXYQ4Dxj3nzRY6bSc55sce3NVPHRzGQpHSGQIEvE1J0+UqKkXR7rB/CVd4BX8uP+
	 Zv1dkIYk9CBStRJI3FE9CnyThAAZw3GIlUazzeUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Baldi <baldovic@virgilio.it>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0057/1193] media: imon: Add iMON VFD HID OEM v1.2 key mappings
Date: Wed, 30 Sep 2026 17:12:21 +0200
Message-ID: <20260930152435.546630668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 69e118863aa67..55edf7583aca2 100644
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



