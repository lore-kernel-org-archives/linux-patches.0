Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F8851AEF3;
	Wed, 30 Sep 2026 17:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790803; cv=none; b=Sa8W8MSmXAm9v88FrPB6PG14byqHUj0rA5MgkxVbu39o8bJY14+R/mXwoPrvwU11pWtu2sRV452Xh3oR6CcjUaOakUBflApeOS5jcDtofrQ8eLMBrtcu9XjyKiegUaIWq/EIR6c4EBme5mIoARdmBcPHDbXznyTYQmX4T/PfdIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790803; c=relaxed/simple;
	bh=qh3YEaKqOzsm+LARwRLwLHEsUY5l38vnZXqy3aK434s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btCPCXJQqAt55AQOfxw52E9qaKBGVekYa9/pSgyjAQbR6Rx4SksAJaXgz4svqsOGTvmJjdR9Fhth0l5glG/Fz5C7CQG2hX2DbYlyPZCXDYYMeXIZcjPptSkIiWcnv7Ms0wAi7cHeB8Ce6kX0Umld7C1iED1CkTPHKFyJleMxkiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chRTBAH5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chRTBAH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351E41F00898;
	Wed, 30 Sep 2026 17:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790801;
	bh=sCAhE7MTqJBIuHwRQ3pxoxH2jYQl1IrxBVjRkOfXj80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chRTBAH550GqseA1kW5wglYcONGIkF1XGeG3hT+X9Tcshv1DmpuiSMTEJfDgAYfbe
	 mycEws325WaU+APrhyNJ4qrjwClu7HNOUPvROkFc4j0Br3lc7a0do1D6R8uDmh8qqL
	 bS5w83I77qU+5Bs16VtawatHg8vlxcoBJhA3kypc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Baldi <baldovic@virgilio.it>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/752] media: imon: Add iMON VFD HID OEM v1.2 key mappings
Date: Wed, 30 Sep 2026 17:18:24 +0200
Message-ID: <20260930152358.887818732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a70f449f35290..86310c9b05177 100644
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



