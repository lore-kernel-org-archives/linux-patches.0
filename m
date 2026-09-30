Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC2D50255E;
	Wed, 30 Sep 2026 16:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784273; cv=none; b=Fts6RQn82ZKls/SSH9n938XsJvfeVrusYKeZnnvTrjds5bxT8MDfP8g8PuqQAzDvQ3aQl/Ccj0hixLGAGvoyDKQDzlf9kcGfCe9G1ars9wsF0+Y5DQHsq/2VfZ/QVlucK6B2i9Hog8VgGQUN3+KRoSlN79Qss7Cssf0jW3FCF9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784273; c=relaxed/simple;
	bh=chSaUjq5h/HRDExg42FKjUyoZJCJVNf0KFOmYptL7L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q2iZw6wjBBJbxZxwrL+RN++b++E/Eg2U181Wsmt+wT/hCZzYHELRzYnJ3Cp+RNuk5qj2JmBtFgnBdj1oF/giOShsY/r8DwegnS1NTWTGGrDFp5/EU38kbPuk8woA5yBhtW9q4onp2rzrifNDBwq5pNO7Fh1N5ylDOdPeHS7Jp9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbNg3W5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbNg3W5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3041F00893;
	Wed, 30 Sep 2026 16:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784266;
	bh=ZipYcSgu4yBNUFAwMPnSyJDAGcYcw/K/6Y5hjXdHAn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbNg3W5ToKXFeg2j5gC4gixsEBe3k4S8+iotJwVDkRv/dUQ6KytJ33uhB2XXOcQ7G
	 4iH779/seRsPZfwDGFrtuOgpVXeB532LQ0HEq88fgTL7hHq4g6/plbalhNigBRymyW
	 Hx1rjJNrn9i+gjpDEVVbWHRIukNf06kjuwAXHcjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20K=C3=BCchler?= <uwe@kuechler.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/982] ALSA: usb-audio: Add quirk for Novation Mininova
Date: Wed, 30 Sep 2026 17:13:51 +0200
Message-ID: <20260930152418.852534265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



