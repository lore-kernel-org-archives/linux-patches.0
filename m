Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A22F31E857;
	Mon, 13 Apr 2026 16:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099540; cv=none; b=ehuxrO5mGrxIQ6Or8GThOb/lxjZcY6hORmNoEtHHAIcGoZJinRgEcUuIB4S8pQIrvRVr7/pW1Tio7lozJINejLvSZqPeQF4asehjGOWfqoGyiDXdp5ARLp2lZG2YX/UkVmdJSrkRrcweAeK1SujnDRSR1evj6XfneZOZJKDTcfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099540; c=relaxed/simple;
	bh=bcmRsnVkiLmvzsUwC1Xp2spDK9mk5eIX6kvLCwjk5Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edb1tST9OkVG8cpt34jtJpKbaSbzeNBSUMXhUfBO7LYR0F6gJhtd7t0XKM7f92iOsENEvPMS9a15wFia2dvOKOR4/8ANg1hVmDiALkpWOEpTDPhm4Vn8t1ajQJpHotYBefvv7JYFhAXAbu4cNIwUKJ0mAUuSTN05sKlj+APTChs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eq0Mc61j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eq0Mc61j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E312AC2BCAF;
	Mon, 13 Apr 2026 16:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099540;
	bh=bcmRsnVkiLmvzsUwC1Xp2spDK9mk5eIX6kvLCwjk5Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eq0Mc61j7xDMgb1Yvkxy9REESrLZlyeugvoM4YZY1moxl51MWfG9JnzdTjc8hE3TG
	 8mBEPXZSGtYQJTELghL9Z+KIXzJp9mQWJaOamd3ZIm6Q+qZQp1fCAfhvor2Wq3KCd5
	 dvhkySmrrlzeMHauf1eG6Hc+ZmrvHiUfplhKv5pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 378/491] Input: i8042 - add TUXEDO InfinityBook Max 16 Gen10 AMD to i8042 quirk table
Date: Mon, 13 Apr 2026 18:00:23 +0200
Message-ID: <20260413155833.185691984@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

commit 5839419cffc7788a356428d321e3ec18055c0286 upstream.

The device occasionally wakes up from suspend with missing input on the
internal keyboard and the following suspend attempt results in an instant
wake-up. The quirks fix both issues for this device.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260223142054.50310-1-wse@tuxedocomputers.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1189,6 +1189,13 @@ static const struct dmi_system_id i8042_
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "X6KK45xU_X6SP45xU"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "WUJIE Series-X5SP4NAG"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |


