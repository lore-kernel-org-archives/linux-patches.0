Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110BF3BE64A;
	Mon, 23 Mar 2026 16:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282572; cv=none; b=NLA77IjkHlKvRjRxUpQIpJz1Tqr/O9kafUML/55BIStQ2/GqZUGU0QT5nCjiPTeHZYYbprxzG9XiDAXzXu53l0gUUxWJaIeZDsq1wBIZ9OkW6QakLIb9wiMBL598fgGxFS2kS/XYMsg7gYEHtNKa9sRgyXgJMgFNmJ1ktzKepZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282572; c=relaxed/simple;
	bh=/DgUV81pLnyocjw1jaCyI2cAW28hJnsvbl1Wca/OCZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHiLjtZe0JodblwmmkEtFI+aXUD8msaSWVAM1sk5nZ0vJxz5ebXh/MjouyPY0wXHcz50tX5Dx+ssS5U63R0y0SUKc0blPIME0gj70JhH0NFibqoRh1F3dGSbRdGEDXpNg3Qc3sDpCKlUHLiHRpp7C2NQwZGF5sw3QpB1wx+Hot8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/UhKM7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/UhKM7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94286C2BCB4;
	Mon, 23 Mar 2026 16:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282571;
	bh=/DgUV81pLnyocjw1jaCyI2cAW28hJnsvbl1Wca/OCZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/UhKM7bQzQbdmrwEG9NKh232iJObU/Hm69AoYruYWxO1ddhLqu60MKn8M9I+mOsm
	 N20pyWjSU43fetEROUGQ4k5uWWJWhLjoyIrU2ARj7ebiGCBKL0VXZ4GCxm2I+lsEdS
	 sLDKu7TIs4Ji9PfVlamPdLuok5qUD0ATH6usaW1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Vahnenko <vahnenko2003@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 206/481] USB: ezcap401 needs USB_QUIRK_NO_BOS to function on 10gbs usb speed
Date: Mon, 23 Mar 2026 14:43:08 +0100
Message-ID: <20260323134530.191251649@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vyacheslav Vahnenko <vahnenko2003@gmail.com>

commit d0d9b1f4f5391e6a00cee81d73ed2e8f98446d5f upstream.

Add USB_QUIRK_NO_BOS for ezcap401 capture card, without it dmesg will show
"unable to get BOS descriptor or descriptor too short" and "unable to
read config index 0 descriptor/start: -71" errors and device will not
able to work at full speed at 10gbs

Signed-off-by: Vyacheslav Vahnenko <vahnenko2003@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260313123638.20481-1-vahnenko2003@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -585,6 +585,9 @@ static const struct usb_device_id usb_qu
 	/* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
 	{ USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* ezcap401 - BOS descriptor fetch hangs at SuperSpeed Plus */
+	{ USB_DEVICE(0x32ed, 0x0401), .driver_info = USB_QUIRK_NO_BOS },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 


