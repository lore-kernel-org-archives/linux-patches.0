Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F061D3653;
	Tue,  8 Oct 2024 13:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393306; cv=none; b=Wf0rBX1JK5SDxqVRagJ67ShcjXhqgXYEoKaR1oRyfJ9ZnfbNLVnoO6GPbRvTkHNh9O+g/FdAAQdzIgZsECSgvqewxqlVH27aE452WptaoC23a2uKc1WF8GEI3ZKMoDDrjypW7edZETiE0kZ5s9hEB6Xm5c3NYumXb01mz+weOPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393306; c=relaxed/simple;
	bh=ODHjpSZkdVqp0Ctw3S8S1Om28QCBTbNEOVDdBIYaZH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoGSQHWCNd7IWEhCz6qdhrTTQdQvbpljreX7g6FwJY8Q6XOt1J45qrlticez7hnYrtscjW02LBy5/P4c2YctCMBWRfSjry7+MeOEC5LGxynFbVrOoM4ryZEQURnXMfQGKVVt6+l7w6Mlq1SgF8QwbqhLxNKXtuuNutJBzdQ4I80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNbW7/rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNbW7/rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871D6C4CEC7;
	Tue,  8 Oct 2024 13:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393306;
	bh=ODHjpSZkdVqp0Ctw3S8S1Om28QCBTbNEOVDdBIYaZH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNbW7/rzB6zRhPKHOXmF55JecJxl7v8tnG4YBImNJVmfFwKllXj5yzhc9nBGGIaqq
	 2K5asIIAAXk7JT5sop0HE/boaTg6C4PDZxbCUVrvDvsFAvib92k6x6D2PRX7YYDKGS
	 4OWtWHwwWMfRv0woZpzCrdiPoaFaWcTGkKxHjYP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Pius <joshuapius@chromium.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/386] ALSA: usb-audio: Add logitech Audio profile quirk
Date: Tue,  8 Oct 2024 14:05:57 +0200
Message-ID: <20241008115633.852439409@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Pius <joshuapius@chromium.org>

[ Upstream commit a51c925c11d7b855167e64b63eb4378e5adfc11d ]

Specify shortnames for the following Logitech Devices: Rally bar, Rally
bar mini, Tap, MeetUp and Huddle.

Signed-off-by: Joshua Pius <joshuapius@chromium.org>
Link: https://patch.msgid.link/20240912152635.1859737-1-joshuapius@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 7c98cc831b8d9..753fb47d25913 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -384,6 +384,12 @@ static const struct usb_audio_device_name usb_audio_names[] = {
 	/* Creative/Toshiba Multimedia Center SB-0500 */
 	DEVICE_NAME(0x041e, 0x3048, "Toshiba", "SB-0500"),
 
+	/* Logitech Audio Devices */
+	DEVICE_NAME(0x046d, 0x0867, "Logitech, Inc.", "Logi-MeetUp"),
+	DEVICE_NAME(0x046d, 0x0874, "Logitech, Inc.", "Logi-Tap-Audio"),
+	DEVICE_NAME(0x046d, 0x087c, "Logitech, Inc.", "Logi-Huddle"),
+	DEVICE_NAME(0x046d, 0x0898, "Logitech, Inc.", "Logi-RB-Audio"),
+	DEVICE_NAME(0x046d, 0x08d2, "Logitech, Inc.", "Logi-RBM-Audio"),
 	DEVICE_NAME(0x046d, 0x0990, "Logitech, Inc.", "QuickCam Pro 9000"),
 
 	DEVICE_NAME(0x05e1, 0x0408, "Syntek", "STK1160"),
-- 
2.43.0



