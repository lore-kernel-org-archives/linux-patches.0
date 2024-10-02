Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3341D0DEC;
	Wed,  2 Oct 2024 14:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878640; cv=none; b=Nf7qC49ZQDtUI8TN0NgclhwrqnIfZAdHQa474Kg83nWBw5XiC4fWmx+MporyfGbEaVwodXsgboBLQ2Zzv0mfuJN3HX4RV0m3+3kgcME9RBCvbwwu2jsqo7VWlyHDylwi2R71fvIEqMareQQu9UHTiwHHbC5E7pw2i5P4nQ7zE4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878640; c=relaxed/simple;
	bh=X14s7E7DIGg/VHnM5qvsibS0WxkZz8uDwmqhXOFjDJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rf4m5BC7FpemiSFnlOLGIO1PD2/UWzCIChIBuO7wSV1zIORE2M+0iZuxT8hawQQX3pfTGcHfiJy5epF9U57vp1TbmcERdSHGLGK/N2nOdheBhg51agS/B1klrF3mMcgP554vWniNGlIMbW4vv7EDj2igxa/yIpnTacPGaedMVH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTX6CU1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTX6CU1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F5FC4CEC2;
	Wed,  2 Oct 2024 14:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878640;
	bh=X14s7E7DIGg/VHnM5qvsibS0WxkZz8uDwmqhXOFjDJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTX6CU1fDnnRXOF69SoYIJxErBnBN1AXGcobJtOgArvqfoL71pAIOGJhXWIpsvpY+
	 JyjWStz1GRK5A6pyQU+cACW0RYNbMlRuNiOlOYdZcw+jqaYBGsIf+G07cqO7Lvdx52
	 qXcXk8amvE7j3S2mmilouoMkR2a+sW22TLB9GA/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.10 483/634] Input: i8042 - add TUXEDO Stellaris 15 Slim Gen6 AMD to i8042 quirk table
Date: Wed,  2 Oct 2024 14:59:43 +0200
Message-ID: <20241002125830.168544110@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit 3870e2850b56306d1d1e435c5a1ccbccd7c59291 upstream.

The Gen6 devices have the same problem and the same Solution as the Gen5
ones.

Some TongFang barebones have touchpad and/or keyboard issues after
suspend, fixable with nomux + reset + noloop + nopnp. Luckily, none of
them have an external PS/2 port so this can safely be set for all of
them.

I'm not entirely sure if every device listed really needs all four quirks,
but after testing and production use, no negative effects could be
observed when setting all four.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240910094008.1601230-3-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1143,6 +1143,13 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxHGxx"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with nomux + reset + noloop + nopnp. Luckily,


