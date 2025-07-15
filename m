Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB3D2E974E;
	Tue, 15 Jul 2025 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587900; cv=none; b=Zekofg5qirY7Z2grSitV4clMsYBIvaQdWjLmGzUePA8exrfVtCz9eV8lsCz9At0J4uF///8IIReAHuSiB96AE9yfD8LXcYkcy41DKeEkz9zLhdGrBBfoj4Q3nqRFyHPIQEf8eD58cYJhGxRr8dnyniHJftUvgPE8NMOl6kcaPDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587900; c=relaxed/simple;
	bh=1fZfVGSRVFFTEpkMTux5pJCuh1Uj5Mf3uATSVHKfBlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVCq+QrdHukxXmJCHEih1jXTL7++JlQTGzrg2ekguhe7O/2qM3lQTZFCBHisinDGzgXTU4mn7ovrBTSdAHLIuhjmAjrmM99YHMhpnZAXV0J1A51mJ3mJwGdom1pQsJYfpWWio8PBMGlphjCy8XBg/RAb4vi158y01eMYnEXUaOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sowntz6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sowntz6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1F6C4CEE3;
	Tue, 15 Jul 2025 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587900;
	bh=1fZfVGSRVFFTEpkMTux5pJCuh1Uj5Mf3uATSVHKfBlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sowntz6vxPisGJHlaf++hSx6qJPN+vExsJFpqBasSK735i8HO2LcveGiKlyV+tyd8
	 PNqAZI+V8hZRYeq+no9sSysd7UNZaSic2MaFxLB9JuSID8DHLM2gyARc8Igri+fk8Y
	 HqkGS1yMZxr77Q4Qwi1UzOzwX+2hMOJ7YRQgHgPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/208] Input: xpad - support Acer NGR 200 Controller
Date: Tue, 15 Jul 2025 15:14:54 +0200
Message-ID: <20250715130818.363908998@linuxfoundation.org>
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

From: Nilton Perim Neto <niltonperimneto@gmail.com>

[ Upstream commit 22c69d786ef8fb789c61ca75492a272774221324 ]

Add the NGR 200 Xbox 360 to the list of recognized controllers.

Signed-off-by: Nilton Perim Neto <niltonperimneto@gmail.com>
Link: https://lore.kernel.org/r/20250608060517.14967-1-niltonperimneto@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 21a4bf8b1f58e..a0362201b5d35 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -147,6 +147,7 @@ static const struct xpad_device {
 	{ 0x05fd, 0x107a, "InterAct 'PowerPad Pro' X-Box pad (Germany)", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3030, "Chic Controller", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3031, "Chic Controller", 0, XTYPE_XBOX },
+	{ 0x0502, 0x1305, "Acer NGR200", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0020, "Logic3 Xbox GamePad", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0033, "Competition Pro Steering Wheel", 0, XTYPE_XBOX },
 	{ 0x06a3, 0x0200, "Saitek Racing Wheel", 0, XTYPE_XBOX },
@@ -440,6 +441,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft X-Box One controllers */
 	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
+	XPAD_XBOX360_VENDOR(0x0502),		/* Acer Inc. Xbox 360 style controllers */
 	XPAD_XBOX360_VENDOR(0x056e),		/* Elecom JC-U3613M */
 	XPAD_XBOX360_VENDOR(0x06a3),		/* Saitek P3600 */
 	XPAD_XBOX360_VENDOR(0x0738),		/* Mad Catz X-Box 360 controllers */
-- 
2.39.5



