Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830903;
	b=Vlf175JfdT3vqgMn11Wu+RFjXD0jF7/pE+s/lpZkSzy2Tfq8J4VGCvvrpx//Je+mG6wH
	 jEwjZFZk6sv/k7YeVi0MoJrh2KGX+aBbh2FoSlCMrMADGms9NpQe02fWeD9Dkv7o1g5iX
	 7LiAXnFPd3gDBfgnXfHN2B61bdpdX06HD1wBFSK60WBLWWmLjx8ryC7N/HyZUHvWvuLjL
	 Y1uCvdXJHA+0i5oqdQ3lCZYeYekDY9uemeNIBoFTYkcdNz26uwwG0rMn4cacn1QpYZmol
	 8Vk2LoaurNI+gHBxPbBN/4HKzsL9VcE+0BeIvdrYCOuyU3kwbpXGQDG3wKiUEuiQCjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y0RXNUH9T5V9UX4n72pvnsZZfpm+N0ol4CYu/X+JSWs=;
	b=AYfj8CbFIovyxAicgbbr6tmhWhE+6ApNEGBq3BFC7/Ns20nSQ1ZiacOxeZa+RnLu+03u
	 FlPNBUt5SzMbzod3JaBeXpTR1LHonOyokWVam0IVJSz8+L1iH5fhmlUx1FDlEwUWo3+zp
	 OB76O1+xwtXzuEayziPoVZd6S+E9LikX+0/xKuOLIkvexa+dDe/1GNXcY+wncFqgXRrKr
	 /MpU6xWVtBLcdcQd7Wt3+92eX9Rm8IXW/Ltm39068u9qvTE39T/2ijqubiReRHXajGQIt
	 ZlxWxf1dFbm8kJkf7hbRFyVtpz/Q8hmFzUsmYkMhzbYFcsYGzB1qBJ6vYm3WJLLkSlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQvyqyj8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEE4606D806;
	Wed,  4 Nov 2026 22:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQvyqyj8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4623F1F00A02;
	Wed,  4 Nov 2026 22:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830897;
	bh=y0RXNUH9T5V9UX4n72pvnsZZfpm+N0ol4CYu/X+JSWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQvyqyj8oyoW16LzdiIeT2NDDaTpS/Kzp3etJulPh2XCPw3w4EyKnXKYv2Z8U2zZr
	 5WUIz4TsgEQOYu8P7L/LktgGf4IiK6Dpbo/QCDCTdPmQj8ZR4FtmvbJ7hBOTQ9B9nY
	 R+5XW0R8yqXv3U4FKzliW0mn8KkLemTOj1MEhm4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0389/1005] soundwire: dmi-quirks: Disable ghost Realtek on Asus ROG Zephyrus Duo
Date: Wed,  4 Nov 2026 16:02:02 -0500
Message-ID: <20261104211054.979049747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 5b08a3afd2995e5312c4c47ffea9d21b651e8e13 ]

The Asus ROG Zephyrus Duo also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine
driver into attempting to create DAI links for the device. Add a
quirk to remove this device.

Suggested-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260807121425.1952003-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index f738e547a1f30..768255dd12db6 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -193,6 +193,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)ghost_realtek,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "GX651AR"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
-- 
2.53.0



