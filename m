Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41642E62D1;
	Tue, 15 Jul 2025 13:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586617; cv=none; b=b+cr35CiOX6ELAm8eRqlYw75Y+tW39JN8PZ5XRlxcN0J20GMv+eQoE4NnkkQ+dz//aBnqrrLG5aTvVe5XIJOgufD7sh+xK1anVx9PfKY9dK02lXDlM96jTPcwMF3E1CICl+OAJJgAMGJdghLV/vrb03MPWbaeTDtEUukSATEUgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586617; c=relaxed/simple;
	bh=KjIB0PcOneRow9pndEqEGLxwYcFlDHPM05Snz2v3/4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQ7DiSTAkVMLInb3c3khT2XpAxZvAs9sBlRX9+GprruyAHt2Edy7Xm1K4Jq34a1U2wwVIuAsyKqhvOvaMINa+3oiZbgtKFXhxfiQT9+eA5xrs0OTYZyo8IL9wcAg0goJQx7MltoJPsRyE3TAKdnUr9Op8SoOFyKZqYG7mnjt0a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoLmFufh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoLmFufh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B8EC4CEE3;
	Tue, 15 Jul 2025 13:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586615;
	bh=KjIB0PcOneRow9pndEqEGLxwYcFlDHPM05Snz2v3/4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xoLmFufhuoOivWSJvwbww3/tf2eStFfG3VtW2ktunowThb51wyexqX99JecSyJmqo
	 2DA59BVz+sLo9Xn7whDiHE3WyBjc8bw5YuuFRj+pzlTD11k+5X9INQGwZ/GPVkSf8u
	 mJI1fD00d22sbRxEb8Bb3kzY4B6gHYa6iheiI8is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/148] Input: xpad - add VID for Turtle Beach controllers
Date: Tue, 15 Jul 2025 15:14:13 +0200
Message-ID: <20250715130805.538197013@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 1999a6b12a3b5c8953fc9ec74863ebc75a1b851d ]

This adds support for the Turtle Beach REACT-R and Recon Xbox controllers

Signed-off-by: Vicki Pfau <vi@endrift.com>
Link: https://lore.kernel.org/r/20230225012147.276489-4-vi@endrift.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 22c69d786ef8 ("Input: xpad - support Acer NGR 200 Controller")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index fb714004641b7..21a4bf8b1f58e 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -452,6 +452,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOX360_VENDOR(0x0f0d),		/* Hori Controllers */
 	XPAD_XBOXONE_VENDOR(0x0f0d),		/* Hori Controllers */
 	XPAD_XBOX360_VENDOR(0x1038),		/* SteelSeries Controllers */
+	XPAD_XBOXONE_VENDOR(0x10f5),		/* Turtle Beach Controllers */
 	XPAD_XBOX360_VENDOR(0x11c9),		/* Nacon GC100XF */
 	XPAD_XBOX360_VENDOR(0x11ff),		/* PXN V900 */
 	XPAD_XBOX360_VENDOR(0x1209),		/* Ardwiino Controllers */
-- 
2.39.5



