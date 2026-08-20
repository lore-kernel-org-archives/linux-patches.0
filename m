Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2065637F330;
	Thu, 20 Aug 2026 15:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238766; cv=none; b=qCa6WzGAnP9h8K1RHIuyh66KI3ISYcZfAdbz/ncrJJroxCnzZ6eR3+yeA21dwB6atnQBiBsuQHm/FJNwbYGGgPADz2jOua9WKv1Avj53K1Xnge0t//nwNzkU+FfsOT2x0+a4Qzavxmrl0FITRcbaAJaiVqYpnhy5Wr2BspuXkdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238766; c=relaxed/simple;
	bh=pkOh6rcjC9DC5GjvoJ2E40lOupEBnGpDCrQ2IqGMoJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4o6p1NUq+7Bk8EperRogvC83twtDFlNXfNOYmcQa6xt+dgESOnvvF2GgAVcm2PPZ7NA9UFqCCnAZB1pXky4QJjGzdJjPy6G8rgiZOrBJS5NCM1KGXDiYPboaqQvORFULeazIkxdQKB0j5Y3OhrzNym6eLR5dPXhTQkXrL6P/Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zja4ua9r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zja4ua9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2FA1F000E9;
	Thu, 20 Aug 2026 15:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238765;
	bh=31cStd5AM+ZovvoOB6cXZ5vY5I0gwrj3e8FhKD6QaCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zja4ua9r9uoWRrHk951sXN5mhycDzAdjSTAOMahXVudTCATtreqr3Y84PXSpLFNAk
	 4qCaBfMTjVLffcJ/PBJnfOdrB3wDge96fRUK2dQbTj3AWkF4GHT9/8Sbh7zXNgHzl5
	 E9noBjb+LlxQ3jo5xU2ZiMKczqe4bpS3mCIGnfXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"KADOTA, Kyohei" <lufia@lufia.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 032/217] Input: xpad - add support for ZENAIM LEVERLESS
Date: Thu, 20 Aug 2026 16:53:20 +0200
Message-ID: <20260820145238.584889097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -428,6 +428,7 @@ static const struct xpad_device {
 	{ 0x3285, 0x0646, "Nacon Pro Compact", 0, XTYPE_XBOXONE },
 	{ 0x3285, 0x0662, "Nacon Revolution5 Pro", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0663, "Nacon Evol-X", 0, XTYPE_XBOXONE },
+	{ 0x3507, 0x000b, "ZENAIM LEVERLESS", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x100f, "GameSir Nova 2 Lite", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
@@ -591,6 +592,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	XPAD_XBOXONE_VENDOR(0x3285),		/* Nacon Evol-X */
+	XPAD_XBOX360_VENDOR(0x3507),		/* ZENAIM Controllers */
 	XPAD_XBOX360_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOXONE_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOX360_VENDOR(0x3651),		/* CRKD Controllers */


