Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A38198A1A;
	Wed,  2 Oct 2024 14:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878643; cv=none; b=ahI/IwCFFyahRsQm/PfWeO2BySRDqUWRXw8MCstSFIeU4MbNJuLKmtI4Olg+2JmXWIRXn+FcthysUl3Qsl/+VdLxV3UWKGxsx4zJjQAyxsmVDwBCUDGgduc2j47kaVwWG750bFKumoNlaQ/VdC4REuGsSeQEvXaYJA2bw+x54rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878643; c=relaxed/simple;
	bh=SvXIwUttCmfCnEabiktHBYdfyCzp13OH5KkTR7F+Rkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFezU9AiCqWjcvt+7q/YyUNQ1i+XhCT2OzkvRqHnYGEnMDip3r3B16vUKk8WGQjMPwgkjNxyqN5bOejkrIYnJPiuwU9fudAkyp6jNppXy+Delc0dX2ZF0yTapAoC55vsCsFmLpaDcNo/OEZb/8U0NnYpfZnndBG0fA3fyWSG+/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm2HekiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm2HekiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C55C4CEC2;
	Wed,  2 Oct 2024 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878643;
	bh=SvXIwUttCmfCnEabiktHBYdfyCzp13OH5KkTR7F+Rkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bm2HekiVfkOkiy7wkCB3IAZy/CVD25OGOk0ZAGpIYdBs1OVXuilrgVb5UYkBscaiZ
	 i+vG62+53xMpfqSHPYZdi7x3/DBH+g2vekyuROzFTEu984TZjP+LkqVQOuvpgOhioi
	 ROWQd2VBfivOMJd7e+YST7fCZCCTvJVIB4B32Lig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.10 484/634] Input: i8042 - add another board name for TUXEDO Stellaris Gen5 AMD line
Date: Wed,  2 Oct 2024 14:59:44 +0200
Message-ID: <20241002125830.207417011@linuxfoundation.org>
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

commit 01eed86d50af9fab27d876fd677b86259ebe9de3 upstream.

There might be devices out in the wild where the board name is GMxXGxx
instead of GMxXGxX.

Adding both to be on the safe side.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240910094008.1601230-2-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1138,6 +1138,13 @@ static const struct dmi_system_id i8042_
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxx"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxX"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |


