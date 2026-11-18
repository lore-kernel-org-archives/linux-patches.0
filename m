Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057616;
	b=jkr0P8fn33+rF9KJQXIIj1lATAUNdUzd2IXoZoZr8OcxiC3MEKWS5DZ3B/XCx26KOwwi
	 DMH1ty3R86WxXf9Jl8MuubfxVsPJzQYCpExCntzHZG6nMcFpFqQ50bCFh+ORb+kkvySb4
	 /LGN+UUmMXq/w8RCDWoOcWBk7QfEQndeWIfVQejQGqbIHa+Qn1Ma9Qb98z1Q30s3AkTWA
	 vnAqaJMuSDWM/HY8rU6Rm2T3spY4fi9xXMW1Y914phafCPlvil2oHOMmGWVDhMGjIpTom
	 h5JpL1S10DQyrunlbLFwaj/0lXnxAc9wdU9ERDxcCSXj7WN08S5MOFHXZNMbYZR50dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lOnAzucQeY+k455p4igr02hhX/KLY4xwC+LmuCxSWZI=;
	b=aXyabQtwLADZoB971UxAMdDZp1ZiFxcNPNYRohDHZ1FIGebpD5hnxLVYm7X5yLmf9jsx
	 bGCjddSrK3UFrUdOQneIq+oay5KQAlXnaQjESGIfSZbcbuhn2Gzro8ln5x7poiksRyzRh
	 5RFTk/K9PWp+pJTBDFHKw1ekx5XnG4woyc9K3izDTzSHwYxkmj7h9GSu84h55QsLHLsIc
	 mw4oDjn7KebV+bFtnFG9Ox7fcLDiRJFFE0tNyxI2DxlQbQA4ubcZ5qcrXDkPWoDazD3W5
	 bVT34oLJ3AWM8dpthBgYqq9Pz8yBRz2/6fGJlTA0YLQK8Ja0IgnsA6Ox6mV9R5ZNOaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDe8HrPx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30800606A33D;
	Thu, 19 Nov 2026 03:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDe8HrPx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418401F000C4;
	Thu, 19 Nov 2026 03:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057615;
	bh=lOnAzucQeY+k455p4igr02hhX/KLY4xwC+LmuCxSWZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDe8HrPx+7CgiO77l3px4ndkxDRieL8CBWvw+wqCcZu/5bs98s3wW84Sm/3n6CpRL
	 w2GST/WRDIMZYoERi066iWsX6wfoocxQvV9oJnwjNijdOvWJ8O7trGtP/LK0IF+S+q
	 pIhrfs5bz2jDmE7t/g602SM2A77OqJ97i7eqkdts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youth Cao <cocoh2os08@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0194/1848] HID: i2c-hid: Add i2c-hid-quirk-bad-input-size quirk for 0911:5288 device
Date: Wed, 18 Nov 2026 15:37:12 +0100
Message-ID: <20261118145919.896560374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youth Cao <cocoh2os08@gmail.com>

[ Upstream commit 58d97b45f3f43af0afd9c74e8480d22d36fd3f72 ]

I have recently acquired a cheap Apollo Lake-based laptop that uses a
Hynitron CST128-A touchpad controller. While booting from a Debian LiveCD,
the kernel log is flooded with the following error (though the touchpad
works well):

  i2c_hid_acpi i2c-ALPS0001:00: i2c_hid_get_input: incomplete report (27/42405)

The CST128-A was identified via ACPI as ALPS0001:00, and the I2C HID
device ID (0911:5288) was shared with the Hantick 5288.

Add the I2C_HID_QUIRK_BAD_INPUT_SIZE quirk option to the existing Hantick
5288 quirk entry to suppress the kernel log flood.

Signed-off-by: Youth Cao <cocoh2os08@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index bf122b594aa97..c34c638c9c74d 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -170,7 +170,7 @@ static const struct i2c_hid_quirks {
 	{ USB_VENDOR_ID_WEIDA, HID_ANY_ID,
 		I2C_HID_QUIRK_SET_PWR_WAKEUP_DEV },
 	{ I2C_VENDOR_ID_HANTICK, I2C_PRODUCT_ID_HANTICK_5288,
-		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
+		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET | I2C_HID_QUIRK_BAD_INPUT_SIZE },
 	{ I2C_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_VOYO_WINPAD_A15,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ I2C_VENDOR_ID_RAYDIUM, I2C_PRODUCT_ID_RAYDIUM_3118,
-- 
2.53.0



