Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F221C361972;
	Thu, 20 Aug 2026 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239401; cv=none; b=GKmdgiczA5152V3ZNTujCnWkHA76yw3UnviP+DF2nWJ9U8iMCLgSvfwhGOBb/QFUKdc7HIgpysvt1b2tRlgOdfaO2FMKGCMcsfEs7oq26wHOl6LZ/2511hXkeR8uVOtpBKVU8Tso/p09cmbUEkMQO01zxuFeeNDeTv8wOf1RzWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239401; c=relaxed/simple;
	bh=tv3iUCd02pM2lDFYMnOqAdfafWvf0l5g+wrtdxy9M8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkCN3YGbKY6Wd4h0H48KSMK7S498xrLMfVtm6h3vTt4RMlOwIFr/46y7yPtx/olPQwpt2KJcoD+HnSxzqKn7cIQ8ZPLrHgJffEyrpFrFfpgF41Y64kTp4BMstVLjcJmYPi41C0ZMFI4G8ymA8Q2tjQvgOEDjqID3pw8NhO8fcks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODRZGqvT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODRZGqvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593091F000E9;
	Thu, 20 Aug 2026 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239399;
	bh=dNBZLwSMQe+DrYh+YbI+XHrACeR7zUdK53EYKuXneXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODRZGqvT/5dAhcaRlF29suEM3/bs1UC6j7Y7y4tgPZuyXQwfwx6VchwdezOsbwp/h
	 iXxrQJqRWSpkptEWhlIUj1aUwtXlak2ZvgSInXvrS1mCG69JsNSU1JWez8rTFVvXe9
	 a3rqRKkZXmbC+hrwS7FNj7wrHPxXZva4sMhjkiyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"KADOTA, Kyohei" <lufia@lufia.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 036/220] Input: xpad - add support for ZENAIM LEVERLESS
Date: Thu, 20 Aug 2026 16:53:46 +0200
Message-ID: <20260820145224.585108414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Kyohei Kadota <lufia@lufia.org>

commit 7d971337ebfad0b173cb46097c709db174ac3557 upstream.

Add the VID/PID for the ZENAIM LEVERLESS controller to xpad_device and
the VID to xpad_table.

Signed-off-by: KADOTA, Kyohei <lufia@lufia.org>
Link: https://patch.msgid.link/CAFMepckDUuOHiDDVVhUYc-UqJMeCqrWSfCuxbJ2x2sGgdDD4nw@mail.gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -418,6 +418,7 @@ static const struct xpad_device {
 	{ 0x3285, 0x0646, "Nacon Pro Compact", 0, XTYPE_XBOXONE },
 	{ 0x3285, 0x0662, "Nacon Revolution5 Pro", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0663, "Nacon Evol-X", 0, XTYPE_XBOXONE },
+	{ 0x3507, 0x000b, "ZENAIM LEVERLESS", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x100f, "GameSir Nova 2 Lite", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
@@ -577,6 +578,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	XPAD_XBOXONE_VENDOR(0x3285),		/* Nacon Evol-X */
+	XPAD_XBOX360_VENDOR(0x3507),		/* ZENAIM Controllers */
 	XPAD_XBOX360_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOXONE_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOX360_VENDOR(0x413d),		/* Black Shark Green Ghost Controller */


