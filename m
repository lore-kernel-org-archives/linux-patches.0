Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D556E1CFEA9;
	Tue, 15 Oct 2024 11:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993105; cv=none; b=QPUN2lLXDFfLioUOSTPSihXTbDZWCZ6oI91ag55Bo37qyUA6KQCg7UWpjDBelScboe+6dkhnYcOSZKdr+1oMUFQi11XzcJDcFX106gKafRIFbsdfKNboQxJ1o7z0Vp1q3klcjtsTUpksOaDM2jnVuisW1IEahUa2IBFCuwBnKoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993105; c=relaxed/simple;
	bh=uHXOQ8vlXv43Z341mgzPCgEo2NY0TEOXDfvS73g4Yn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d61u7L8ulB9okS9hjrCy1xmttiAU6ncdmScS/Up3Pe4vyyF6ECAIp497U+fEjP70bLH9pEiUL1Tp9EjbuxZBoDOZc5mfFqGePW9iHRPpXLPCgfrBRRoaTVsN0nOfPksY9dgKntWv5NTXVGPFnWO7v8qieUIp6is5FG29y+QjHzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LH8dMkPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LH8dMkPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424F5C4CEC6;
	Tue, 15 Oct 2024 11:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993105;
	bh=uHXOQ8vlXv43Z341mgzPCgEo2NY0TEOXDfvS73g4Yn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LH8dMkPvi1iqwCtubRInpvORPfWuLUpmj0INyO7LG9KjuO6UY+AG7hCj2kcqoQKCR
	 vZxuqMJ0zfUyQeiww3x7481veDgE+6KGBX5eQl6cGsw+s8gCmGIEs1cAz767VL3qS7
	 KzYgdFybaxwRezEcpaw/yCxYuq+4S5OWj/XYOZBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 311/691] Input: i8042 - add TUXEDO Stellaris 15 Slim Gen6 AMD to i8042 quirk table
Date: Tue, 15 Oct 2024 13:24:19 +0200
Message-ID: <20241015112452.681679155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
@@ -1133,6 +1133,13 @@ static const struct dmi_system_id i8042_
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


