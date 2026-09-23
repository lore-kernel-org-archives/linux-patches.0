Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C15D53B346;
	Wed, 23 Sep 2026 14:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174695; cv=none; b=CuS6LY/gfqmal1MmkYM0EAeL3700Ri+otVpz5PoBIU+QDPosROovsG/8UZk0JUhn66/ihM/i9Tcn5cXHmFlRvv0eDq85QIzyRBWfxTQ5LQ9mut2zh3quW62q6B0FTaVpIo+WKCEkctnrM5PWT1bm0TPwtmE2SR4MSCm1ww1XgXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174695; c=relaxed/simple;
	bh=x3iwwMQjH9K0ZrlDasFJ5h9Ljx5HGsMLCXxy8Hn/4rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPsXkaVpuYHY3q9FD1cH56pJW8aQbbMlHNe3iH/mWR8f25+yHN9N5gKqbLXhPjEOe6hyAZ24FOMYzydWsWBg+1POlRAK3xAEnJkBjeQ8eqQs9zgS/6M4YfRVvXQFVZeoQmXfl0y64t3dcXHnTtq4Ztig4hePfQRCD5ImK+ECKLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMVOecXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMVOecXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B7D1F000FF;
	Wed, 23 Sep 2026 14:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174694;
	bh=l/YBqfaqBvILNYg5DoDCOgROlMAvURBzlV03FFW/wwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMVOecXNnFqXIq7TDxWSbqYy6LIy7e6p8N1bE/Sya2U55InKcLdLC8IBCbCZx7JYO
	 mLwFVAoAwPiNZDkDUw4D6/EHYVE2eIZLT3UnroAgmMq9XvGdOkOtPh3jUJ2lZUZb4c
	 SM77ZsXdE4qsIWtLPyCTcN6o8wQ5PQPJyunZaq8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erich Sartison <byt.es@mailbox.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 196/398] Input: xpad - add support for Victrix Pro BFG Controller
Date: Wed, 23 Sep 2026 16:04:30 +0200
Message-ID: <20260923140648.504035095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Erich Sartison <byt.es@mailbox.org>

commit 971fa7ea8621e123feb9c8d7dc61be1c656bd945 upstream.

The controller doesn't currently work via USB-cable.

Signed-off-by: Erich Sartison <byt.es@mailbox.org>
Link: https://patch.msgid.link/20260903103137.630170-1-byt.es@mailbox.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -261,6 +261,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0213, "Afterglow Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x021f, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x0246, "Rock Candy Gamepad for Xbox One 2015", 0, XTYPE_XBOXONE },
+	{ 0x0e6f, 0x024c, "PDP Victrix Pro BFG Wired Controller for Xbox", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a0, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a1, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a2, "PDP Wired Controller for Xbox One - Crimson Red", 0, XTYPE_XBOXONE },


