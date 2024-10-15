Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DFC1D4154;
	Tue, 15 Oct 2024 11:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993102; cv=none; b=EW2oFnv4+irFcxSl8Ux8AzVyBMPVT1Da6Ydkq466J/OOaqCx9dA7QMh5mtQ1LW00mJ5cZPFvbzZzRCHE0t2fm4MLMzVJBCfxGb4TDjgbq4oFbPPc16YOHkuxUVZnfcwjhdvQbBmiScr5UY74Fw7TOXYpLJNhBQWP1EJOAv+PKWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993102; c=relaxed/simple;
	bh=TVHEIWvVeVjm45bcIEW+IcbTxQyNlCZzFEdh1hNYeeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/Bav6TNdPVrQZqBzMRhIrLvDBd/Bq1kqxlbl1FxqCfCfpEhh1+/Fb8XaN7G9vKf26nIyvxLieuuD+XgQDlNy8Wpu3kw77VOJPAOSdm6ojGiR2V4EMEdJmgwhc0+T0sf8fC1ztJ00lJK1LJiVBNqwzYnMKU5RoLA0p1Ew7wH9ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaFPQ4FQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaFPQ4FQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE29C4CECE;
	Tue, 15 Oct 2024 11:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993102;
	bh=TVHEIWvVeVjm45bcIEW+IcbTxQyNlCZzFEdh1hNYeeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaFPQ4FQD96QmIZb0yY5dp8zBZPGY+8op3EWlp6H7dj0/XqCNG/rSl6rPy/+VxCGi
	 w7WHB0BfZ2rO1USGVrxAgTRZZNZOyXnv43oUPBPCuDC4NygBc+NYx0Z+QxqId2CNiu
	 sSF83dc4XbIgJ12Mo28fWcCBNp07EmZ4xx9XPzeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 310/691] Input: i8042 - add TUXEDO Stellaris 16 Gen5 AMD to i8042 quirk table
Date: Tue, 15 Oct 2024 13:24:18 +0200
Message-ID: <20241015112452.642756969@linuxfoundation.org>
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

commit e06edf96dea065dd1d9df695bf8b92784992333e upstream.

Some TongFang barebones have touchpad and/or keyboard issues after
suspend, fixable with nomux + reset + noloop + nopnp. Luckily, none of
them have an external PS/2 port so this can safely be set for all of
them.

I'm not entirely sure if every device listed really needs all four quirks,
but after testing and production use, no negative effects could be
observed when setting all four.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240905164851.771578-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1111,6 +1111,29 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOLOOP)
 	},
 	/*
+	 * Some TongFang barebones have touchpad and/or keyboard issues after
+	 * suspend fixable with nomux + reset + noloop + nopnp. Luckily, none of
+	 * them have an external PS/2 port so this can safely be set for all of
+	 * them.
+	 * TongFang barebones come with board_vendor and/or system_vendor set to
+	 * a different value for each individual reseller. The only somewhat
+	 * universal way to identify them is by board_name.
+	 */
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GM6XGxX"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxX"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with nomux + reset + noloop + nopnp. Luckily,
 	 * none of them have an external PS/2 port so this can safely be set for


