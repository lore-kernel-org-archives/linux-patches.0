Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BC61581F4;
	Tue, 23 Jul 2024 18:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760065; cv=none; b=s8rYUKI/O6PSNCDxvOYZOYC5GLcD2vnaPJawapsttmTQLihDi3bpPkQgsTqvGQWfCMoj6Y+/ENeKPcgX9bo02pBv3y7h9thR6pKXhmDTb9QIi+GMyLHl0lrfgZVq0y9Lndr6Au+tfeiFAxLuoar0Q64VOsdLazQbtva/mwmz5DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760065; c=relaxed/simple;
	bh=Fk57PMR3DLlt20LOsfQlr0ycBOm3xPLzDZa50oana1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNkZgjONsANyOAaS8eI1q2p2ZXcG13paiVOfGreul1+3KzXmnzhvu74HbwUza+nl4qr5mfLBj02moOMroEBRlESUe/IjKvRhJckZSJ+B51qLaVRONpqgD+8YcGQaihzKNsIs50WtvBkAcLnHXhbzVM5xUogzX7FNbCJ/rQVt+nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiBMYGMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiBMYGMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAF1C4AF09;
	Tue, 23 Jul 2024 18:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760065;
	bh=Fk57PMR3DLlt20LOsfQlr0ycBOm3xPLzDZa50oana1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiBMYGMR9dCXKXLvH/64TnEBCRKDmnl/Xmlgxm0KB2w1+kL4te4Zp92j1rTkqKTbL
	 +YmUOvuGMC3atd6TsO5JqdQf5uen5/SXGbN+x8pDF56Y+S51yLQLiWxZwo5tqPSFB+
	 /bep4Gii+ohw9ka5bziiYPT3e8QCsFbY6VyFGim8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 091/163] Input: xpad - add support for ASUS ROG RAIKIRI PRO
Date: Tue, 23 Jul 2024 20:23:40 +0200
Message-ID: <20240723180146.993156643@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit cee77149ebe9cd971ba238d87aa10e09bd98f1c9 ]

Add the VID/PID for ASUS ROG RAIKIRI PRO to the list of known devices.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20240607223722.1170776-1-luke@ljones.dev
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 6fadaddb2b908..3a5af0909233a 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -209,6 +209,7 @@ static const struct xpad_device {
 	{ 0x0738, 0xf738, "Super SFIV FightStick TE S", 0, XTYPE_XBOX360 },
 	{ 0x07ff, 0xffff, "Mad Catz GamePad", 0, XTYPE_XBOX360 },
 	{ 0x0b05, 0x1a38, "ASUS ROG RAIKIRI", 0, XTYPE_XBOXONE },
+	{ 0x0b05, 0x1abb, "ASUS ROG RAIKIRI PRO", 0, XTYPE_XBOXONE },
 	{ 0x0c12, 0x0005, "Intec wireless", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x8801, "Nyko Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x8802, "Zeroplus Xbox Controller", 0, XTYPE_XBOX },
-- 
2.43.0



