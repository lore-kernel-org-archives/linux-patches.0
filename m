Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AB7298C28;
	Mon, 12 May 2025 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073292; cv=none; b=KbEoKWdNL4ppJcqu3dqUqIvWIZXz8LBniLU1DN/H/r+DWQgfXzW2A20MQHEFMhwolc/+FbMxDkO1wf9OtVxlsZrnR9WA+1wa5LeCV+OD636V8uYAWU+v59inaN1VZ+TxgyN7606vsZGwFMBASpw2VO0cSv6H3wJnjKktGS5IfEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073292; c=relaxed/simple;
	bh=ZS38nKHGtXvasIpnNZtzN6jqYIL3SsnOkVXDLXCIwsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBW4si6vK0R4P4fRPicrFxS469GJ3rlfplU3LABS76PCcEK7Fn6Bl5mQ05v6aZyy1TTtH//jvHDZUg72sdASsj26SU2oLlwbC3xhQq5Hk8HnyFwzbCu33xU2nXK9h3GtaymKFi5Pa+fh7btLpko5YyVswSHMxUQv4tDK4lpYLgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNTpZt1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNTpZt1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C7EC4CEFA;
	Mon, 12 May 2025 18:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073291;
	bh=ZS38nKHGtXvasIpnNZtzN6jqYIL3SsnOkVXDLXCIwsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNTpZt1MVz6d3f7uDOIwU2EFDRQT9abanfGjM8HBiTdJVFRdUOXxAij2OZA1J7m+8
	 42zymPEnJIDEIynl/lLsT4AZN+RzdHmL9Pqk+d3lALhiqLAqkmt96b05tNOwPv5TRf
	 qSnJgf1C2D/LGn2LU1ro4bQbS2geghVzB4KXSKjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lode Willems <me@lodewillems.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 030/113] Input: xpad - add support for 8BitDo Ultimate 2 Wireless Controller
Date: Mon, 12 May 2025 19:45:19 +0200
Message-ID: <20250512172028.903356035@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lode Willems <me@lodewillems.com>

commit 22cd66a5db56a07d9e621367cb4d16ff0f6baf56 upstream.

This patch adds support for the 8BitDo Ultimate 2 Wireless Controller.
Tested using the wireless dongle and plugged in.

Signed-off-by: Lode Willems <me@lodewillems.com>
Link: https://lore.kernel.org/r/20250422112457.6728-1-me@lodewillems.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -387,6 +387,7 @@ static const struct xpad_device {
 	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x3109, "8BitDo Ultimate Wireless Bluetooth", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x310a, "8BitDo Ultimate 2C Wireless Controller", 0, XTYPE_XBOX360 },
+	{ 0x2dc8, 0x310b, "8BitDo Ultimate 2 Wireless Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x6001, "8BitDo SN30 Pro", 0, XTYPE_XBOX360 },
 	{ 0x2e24, 0x0652, "Hyperkin Duke X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x2e24, 0x1688, "Hyperkin X91 X-Box One pad", 0, XTYPE_XBOXONE },


