Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A1E50B8A1;
	Wed, 30 Sep 2026 15:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782396; cv=none; b=i2+iQpQ0bT3Blwce42t/gnjKjdeTwYJdaGmwFKI+Kp9ucgDEAfOYFQFqtqJkWmZ+PJ0RA1x13IY3hoXwBz3r9fDDFrgiC+Krho4KW6bSGrHJOWd8JGLhr/3Ljs7lriLy1DTNEjRAr1kZPvsMATCNRhhOGvboYnJydhHX8Mqx2D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782396; c=relaxed/simple;
	bh=4BEh88bT4RCcyTfi0qxNDynPELQ4NrZ63NieHog+zu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaoolDsGvq5bZR6cEc3vVt1nB8H1fYHftpVuCeirX6uLYQEFyaj3RJ6KEjOTtOKsoVUFkk8FTQ5bqKgLCiNIwGO5uuh8MelOz3EcsT/cWF6KqoL1lYJWYT68QMkTnkEknCZ5I3ntPeg0Z59bPn8EgbaLdB3ySuWo+FtAaXoRNeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pguDezRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pguDezRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFB01F0089C;
	Wed, 30 Sep 2026 15:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782382;
	bh=u9A0QQYoKFG50vMqID7Gc38X7omSZcpLyCqswiDJZCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pguDezRNyHBO4JhrVUrYW53AwtIuGV4Xxt3FYsCM+TglYqMmqjRBbgv3ElFtVynBD
	 w1GBTH8rR0yH9OT5sWFkhKYi9b4wnXKz+ayxsl+TwqHj+desoYjLsgjmzMeuFtmj3l
	 ZasRbhRvIeyTCT4D4STrkpsLGkgQ6oJwcOUETyD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Baldi <baldovic@virgilio.it>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/595] media: imon: Add iMON VFD HID OEM v1.2 key mappings
Date: Wed, 30 Sep 2026 17:18:41 +0200
Message-ID: <20260930152348.333928084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 565826cff0db4..dcdccfe5a7318 100644
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



