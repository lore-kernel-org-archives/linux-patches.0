Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1588713D518;
	Tue, 23 Jan 2024 01:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972109; cv=none; b=q9nj0RPQ0RT/P/wNTevfcJZ+I4+Z3IxuUjJpsiuz1nlWWOO6htB1RE0lhTgMs4TLzu8lCrVMRnva+RjwTkvqkD7CoT/cbWZwULvcrK7i6enAlM1cmPyEmg08KMmqFe/VG62/IoXiYMqalXr/F3aLHBCCeiG9EQgtyShRJ+zpO+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972109; c=relaxed/simple;
	bh=e7jO3ES1npAE9DDvh5QjSNE6UTTVxfJNE0KGx8NNzX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFVMa7ildQVUEfZxq/wsnQu8CDPibXuhqXcNIFB8NQQYZ75EepcxtTxEcHxO6ePOjlSHAuIQUW7tXjDV0ABfSkMHki/7pKYr91pQMNJ6eRkIf0z2niF/MYGB0JW+0lVX0QhrOFzRW8rg+w/3sxr7ywfM1seNYnRyu4n5jixP0lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYU+nWAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYU+nWAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9C1C43399;
	Tue, 23 Jan 2024 01:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972108;
	bh=e7jO3ES1npAE9DDvh5QjSNE6UTTVxfJNE0KGx8NNzX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYU+nWAdAwPkkj2JH3IIBD/t0u89L8MTHiB7d774XNx+CZNVL2sGqyKz1bxoGMmiF
	 4H4iGcoszTUWe5PqnHCil4yEjUNDZHaURXL3XNxEt2QvI7Fp4EwhBC8wal085gaYA+
	 hlFdv57Fl9vNEgDTJPX1WaGmQdLcwnYSWxz3i5SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@z3ntu.xyz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/374] Input: xpad - add Razer Wolverine V2 support
Date: Mon, 22 Jan 2024 15:54:59 -0800
Message-ID: <20240122235746.113113643@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit c3d1610345b79cbe29ef6ca04a4780eff0d360c7 ]

Add the VID and PID of Razer Wolverine V2 to xpad_device.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Link: https://lore.kernel.org/r/20231125-razer-wolverine-v2-v1-1-979fe9f9288e@z3ntu.xyz
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 3bf5c787f914..1ff0d4e24fe6 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -268,6 +268,7 @@ static const struct xpad_device {
 	{ 0x146b, 0x0604, "Bigben Interactive DAIJA Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1532, 0x0a00, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a03, "Razer Wildcat", 0, XTYPE_XBOXONE },
+	{ 0x1532, 0x0a29, "Razer Wolverine V2", 0, XTYPE_XBOXONE },
 	{ 0x15e4, 0x3f00, "Power A Mini Pro Elite", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f0a, "Xbox Airflo wired controller", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f10, "Batarang Xbox 360 controller", 0, XTYPE_XBOX360 },
-- 
2.43.0



