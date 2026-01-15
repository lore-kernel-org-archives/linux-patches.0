Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBEA3D6493;
	Thu, 15 Jan 2026 17:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499371; cv=none; b=axAl4WDfRuDZJG0nTJmhLg8zS72pOF6JNL+R+59ABsah2Ys65H+KgKx9cC3ImRHdss1HAr9D0yra2qvGx6u0ovtWOFoiGaoyg5SriYEKw+EMRnvsbX4xzMfwc5ERvgsAwbDbSeF1gbI/65TSDgtfFWn//15ciBAEhmCz9yBtJ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499371; c=relaxed/simple;
	bh=/4OLCc4VHOifrS6i6ZwcmK0xxW1jaUbX2ySBuiABqXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBtkWYERQy4urK6RDa91dGchJrwf3PObjJ2idzOtyuNonJJvMNfGxjkcOkPCuGFS1xPkbEcGmuXzjyXe8qIwSnDmx5j8mAl8fxr97JHqGvZQMNpOKuEHCNfxklLP1H2ol0yIDPQpevHYl2VhOY5LbY9VnSSSNNou2pin9+9EMYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1XfJ1hR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1XfJ1hR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095A2C116D0;
	Thu, 15 Jan 2026 17:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499371;
	bh=/4OLCc4VHOifrS6i6ZwcmK0xxW1jaUbX2ySBuiABqXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1XfJ1hR9kTugKimq/qyG7gQRHlqgiQhWbznbHvwE8OvAwruInWOvRk09WuCca9mY
	 pBG43hs6qPFHaSLi4hFuwCNvTvnaIzZIfWZPj1W46DLFLMQt7m277O3hAhP0doYnup
	 Y9rjjZ2lDuG1JtoX5P/MFx85ZdkFYd+STjI9cf8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 196/451] Input: i8042 - add TUXEDO InfinityBook Max Gen10 AMD to i8042 quirk table
Date: Thu, 15 Jan 2026 17:46:37 +0100
Message-ID: <20260115164237.991764534@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit aed3716db7fff74919cc5775ca3a80c8bb246489 upstream.

The device occasionally wakes up from suspend with missing input on the
internal keyboard and the following suspend attempt results in an instant
wake-up. The quirks fix both issues for this device.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251124203336.64072-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1169,6 +1169,13 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "X5KK45xS_X5SP45xS"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with nomux + reset + noloop + nopnp. Luckily,


