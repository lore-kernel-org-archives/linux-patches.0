Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061449;
	b=Ct3/DYzAGkeOKTItldsBegP3hA8YCsPBMid7ENdWZU1+lhipdjN6T68QPcJpe+J9OkfE
	 8qdWFOFwcd7EITl4P851K58bOqMtDfLQny9tjH9OKPsyeslYC78K/+NCS70hGsCvNYpz8
	 MFMhljj5ndb+SFb29j7o0shX9LyueAWj419OIJnLUwuMjvCRPGlDpTsZIArHX3Lqni12N
	 GGr2OmArJsgrlOCq1VolMzPl4eiHm+CvVdKLZmAwqUk6ke739XXoc0TkbhXZIldWZ50TT
	 Go6waUwrgkxH6cS9pKL5QUV9EF/v7vjKaBXP0oBGW5y6Kox7bdNsjZXHjecFyD9tN7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fOsU8tu5KDmbiYYh1pPonQECGAa41ltSepe1nGG/v0s=;
	b=39q0VwXGT7kn9HJlU4GyysEm7xP39xpQeFXyKOuQw5siBV6YrR0oDMeh1dU9sTQbsdaM
	 eka+Q6Yr/jzCllQDaDQs/uO2N3XjMG7F0fS0p9+P/cIX4PYHrSynbhxVFTbwiRyCDdltn
	 KQAi4BqvqLksar8zqTS5bbZq6JWUZLW+jgPDyOjsO2pdlBc+fPUufY2BAoomnD9tbxCKa
	 ObYwF25bTFbMkb2jsyHerhCVoigcGOYFNwOObphbZ8PCtC3GDVpjPXJV4i4hYSLLiLG3B
	 JAmeHzHSH/NqfiW6LICdL4l7Uwm/KDCjQAOc2FX0JvkD+OkezCxm39JK9/+LrqsswaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qzSg2Es/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA322606A336;
	Sat,  7 Nov 2026 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qzSg2Es/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A731F0089F;
	Sat,  7 Nov 2026 14:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061448;
	bh=fOsU8tu5KDmbiYYh1pPonQECGAa41ltSepe1nGG/v0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qzSg2Es/1T7f0nCv0cyMsr5qAk8UAYRWSKwBX+hcNfnRX9KLpuy5GvqzvAcUKZGo9
	 2JIIXizbN2itSIWThtK5EzTwwJ6UYeH+NeRdVujLbtzq7fGBVQHXhNR2B6IDfQqXys
	 wZqABjIX5RaWW9LclmnhsQF5AR0lXpx3LmnWQ90g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bihaan Sen <stevewholikesthings@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0555/1536] Input: xpad - add support for 8BitDo Pro 2 Wired Controller for Xbox
Date: Sat,  7 Nov 2026 08:42:51 -0500
Message-ID: <20261107135013.180813993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bihaan Sen <stevewholikesthings@gmail.com>

[ Upstream commit 41363c27b8509bd4efcba244803edac9ba25d1b5 ]

The 8BitDo Pro 2 Wired Controller for Xbox is already matched by the
vendor-wide XPAD_XBOXONE_VENDOR(0x2dc8) entry, but a later hardware
revision reports product ID 0x201e, which has no entry in the
xpad_device table. The device therefore binds and functions but is
exposed to userspace as "Generic X-Box pad".

Add the VID/PID pair so the controller is named correctly, and set
MAP_SHARE_BUTTON to expose the share button as KEY_RECORD.

Signed-off-by: Bihaan Sen <stevewholikesthings@gmail.com>
Link: https://patch.msgid.link/20260925114459.110253-1-stevewholikesthings@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ sashal: Dropped the missing 8BitDo Ultimate 3-mode (0x200f) context line from the hunk, so the single new 0x201e device entry is added after the 0x2000 entry. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 80fb5ceb86475..3086fc4a0642f 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -406,6 +406,7 @@ static const struct xpad_device {
 	{ 0x294b, 0x3404, "Snakebyte GAMEPAD RGB X", 0, XTYPE_XBOXONE },
 	{ 0x2993, 0x2001, "TECNO Pocket Go", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
+	{ 0x2dc8, 0x201e, "8BitDo Pro 2 Wired Controller for Xbox", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x3109, "8BitDo Ultimate Wireless Bluetooth", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x310a, "8BitDo Ultimate 2C Wireless Controller", 0, XTYPE_XBOX360 },
-- 
2.53.0



