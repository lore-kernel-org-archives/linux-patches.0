Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C16A3B1016;
	Wed, 30 Sep 2026 18:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792173; cv=none; b=Z4SglnCOfTmDtD1bAm5nJynfeh104LY5WpABPRy3xuMLtzhhX1zBuPwWex2Pd1CJXYVXT+XPy5Czb4FAHSWgpRxRDmNnyUMCNfYQWDjz6bSx2LvAkh0N0oRbv0KC82bNYT4hAfMoTc+m5orEFLN3dNrrPdOvhwdPsFm4lBc20qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792173; c=relaxed/simple;
	bh=k+6CRtz9a3rhOwX5Az0h0rsIzVdIUmntVg1r/9V5wh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLrUIz7Csw9UMYxRsrADS1OlHNGtVXeQzyJ5ttyo/93hVuLQ4IXEkZ0jwcs1jffzV4stDT85XNuDfL6JYDMBX5xMHDnxNYHpraq5E/x3ke81dj7TN9FLFu6y43QT5w/rE9cQbHPBFrj0fSQyzKcMij/gvdRgrjW2OUJ2OxZVNqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=my0/ZMYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="my0/ZMYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648801F000FF;
	Wed, 30 Sep 2026 18:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792171;
	bh=CV16NDQZtU3jelpZIi1T6zeqB2ts1W3YP0p2hi72RUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=my0/ZMYaHRMN+Y22N3zp9y73QH4/hI1TTQqDAYKAk7yIIF1HOcWKSLJuu36gvNy6Z
	 JgUDf8Qbh/hzUdTMJxHtdoGlZ9QiemQdRisHs1SIf3dlHzKmSec25b4wrXFNhunUhS
	 +NOU+koQHSAsfz8JWBIentMvO+wRlP9Fq7HsobZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erich Sartison <byt.es@mailbox.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 516/752] Input: xpad - add support for Victrix Pro BFG Controller
Date: Wed, 30 Sep 2026 17:26:26 +0200
Message-ID: <20260930152409.422733936@linuxfoundation.org>
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
@@ -222,6 +222,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0213, "Afterglow Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x021f, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x0246, "Rock Candy Gamepad for Xbox One 2015", 0, XTYPE_XBOXONE },
+	{ 0x0e6f, 0x024c, "PDP Victrix Pro BFG Wired Controller for Xbox", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a0, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a1, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a2, "PDP Wired Controller for Xbox One - Crimson Red", 0, XTYPE_XBOXONE },


