Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031404502F;
	Tue, 16 Jun 2026 16:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628689; cv=none; b=r1MCNOMWdXizGzzT6/8KCrQgrA4njyVk+S5RFXB7aIqj6zh+fFQMH3m5yjR165fWm8mIQwGLI3CD89dZ7YG5hti4F5HHZH5fJtROyjjLV/VkIpC3sXrOcLj71DZFvAFufMN8cb79LHlI8oUzSVyIL9DHojWdA8YGorzn6X5MuwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628689; c=relaxed/simple;
	bh=Tpe2QxTIPqGaMPj0jdiMXVbBSy91IFYilEsRS7sro3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTeKTkasydAYhkue92ByCTYZqclOV4aaxao/vL8tbl2qMFGQmk+mI6a4y5JO4KcRuFbqTc6wLUxfyT/j+mQVuLzsIAx38nbLmh+oRFN328ZK/DK/gHwykaCLoB7ZL42p00WourR1z6iLPoZbj3bRUWeJDsBSS/zdYAzh+8wi8RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFumuhSe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFumuhSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBE61F000E9;
	Tue, 16 Jun 2026 16:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628687;
	bh=mnZAQ1QcX6PGLgJ59rgrClcH4BOLE/jjflLjGsgdp9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFumuhSepmKX+KaQPeawnccC4C6F8HEudqZjM+SD10B+pzeEBvBiSmpAWdbhhCvXk
	 E3U8OQ8FbWDpj32y8X1LZ8vvYQZwahsgOg49nHmEEoIKYbEHeWvlw25057XJSEJkDn
	 u26fcX7FjyPqswIH/qGA1pbcx8bC9OsUIW/qIKQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qbeliw Tanaka <q.tanaka@gmx.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 142/452] Input: xpad - add "Nova 2 Lite" from GameSir
Date: Tue, 16 Jun 2026 20:26:09 +0530
Message-ID: <20260616145125.169800965@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Qbeliw Tanaka <q.tanaka@gmx.com>

commit 1f6ac0f8441c48c4cc250141e1da8486c13512ba upstream.

Add support for the gamepad "Nova 2 Lite" from GameSir, compatible with
the Xbox 360 gamepad.

Signed-off-by: Qbeliw Tanaka <q.tanaka@gmx.com>
Link: https://patch.msgid.link/20260429.162040.930225048583399359.q.tanaka@gmx.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -414,6 +414,7 @@ static const struct xpad_device {
 	{ 0x3285, 0x0662, "Nacon Revolution5 Pro", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0663, "Nacon Evol-X", 0, XTYPE_XBOXONE },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
+	{ 0x3537, 0x100f, "GameSir Nova 2 Lite", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0x413d, 0x2104, "Black Shark Green Ghost Gamepad", 0, XTYPE_XBOX360 },


