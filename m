Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBE43E022B;
	Wed, 30 Sep 2026 18:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794155; cv=none; b=frxFLzAriz5OvsGFms0UouQIdvJaLa5+HfozIOqi4PC5UHr7nEw3tlYOMuNkUGZ77XbVF9YT2dbSrlpNIAGlZVKgz3NZYSb48mwXXR0rU2U6+6k5swVXDTDzFyMusRWtiziSP9VBPU642J5FC1DXAJq1QdoFWHq41KiBSO4FMe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794155; c=relaxed/simple;
	bh=ld7K5kcVlSG4hcf2RBlh6AT9G3U/dD2Fa1sTf6lzt0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o4KySNEIvlQTGe8HfUZKkMWubnAEEqgIzoUCzuZcVwG8Be1mnlZ+mKGWfN9VD2nUjA6zv8sBw/bV4RfHkffRfsbTDupY3gjL6Hp6ceVEv/SFGwjpfoem/pygqn7BbklfFUy+b2Rx52RmF3y3jQMTm0mBVQkiBmzfAmA/JhWGoPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJ0f7Dmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJ0f7Dmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F8E1F000FF;
	Wed, 30 Sep 2026 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794154;
	bh=jhhFQqbxKGAowRCuFq9tw6mw/QzwfYncZsasm+HoTes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJ0f7DmciFSY1tq/OXtg5RK3lkkbIqbCK+w7upENK3Ai2yBjdOfZNDP8Rs585dmJX
	 8w0fyBKzKWf81CMdqrCDobRQFDvKFFA0OO40WdJIE9nTtkSeqBa+mOSD2XMD4Pqmlf
	 sRAxMt8cnqpmzEp4BsQBh3M+9pdQKjIAkARfJ/AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20K=C3=BCchler?= <uwe@kuechler.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0112/1193] ALSA: usb-audio: Add quirk for Novation Mininova
Date: Wed, 30 Sep 2026 17:13:16 +0200
Message-ID: <20260930152436.714361070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Küchler <uwe@kuechler.org>

[ Upstream commit b2e9d2cbbb71b00faf3e27fb741a27b9ad455edd ]

Add a device-specific quirk for the Novation Mininova synthesizer
(USB ID 1235:001e) to enable proper recognition and functionality
as a MIDI device.

Signed-off-by: Uwe Küchler <uwe@kuechler.org>
Link: https://patch.msgid.link/20260526162033.7513-1-uwe@kuechler.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index d1bd8e0d60252..c20a4df886906 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2131,6 +2131,14 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	USB_DEVICE(0x1235, 0x001e),
+	QUIRK_DRIVER_INFO {
+		/* .vendor_name = "Novation", */
+		/* .product_name = "Mininova", */
+		QUIRK_DATA_RAW_BYTES(0)
+	}
+},
 {
 	USB_DEVICE_VENDOR_SPEC(0x1235, 0x4661),
 	QUIRK_DRIVER_INFO {
-- 
2.53.0



