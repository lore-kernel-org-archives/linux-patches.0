Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051528;
	b=bFYOjeHMVKiInXHyqbJZmW3KUxzt87EyOXItufuDTpxTTluGfHpaY1pxKcU+lnDIYIEn
	 y4cfUJUSN9fqSjsTHrP5sZshfD3+aNhQgYNJhzCYjw5W2X/0wSh9F5fXkugyADQJtV1Vj
	 jJNgryaRmWEQt9vvGdmYWoMyY9UtFjJq0WHkKdbqvp35776EBCBUXEvS9j6zkzFabET+x
	 u7miE++1udsS0SP2UqTbDIfC0ouVp895q/+DTi8s/viG8b7rveQZxE1DBMS1h57DjCqCU
	 KdkAIichy/NCA+mdOLOA05NLikZR5dsQsw5EAgVBDkUcHFwPbEJuOBgLI4NUW4nbRdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jzz2WONdZ3p9PWCsaE5qCpG0HDmtvyFeHv0r9Xsk5gY=;
	b=dca6JRBnuyJx+4rc7DgDaDCMdsj5jZ8TX2QdT6PzuWZJ+maiPPhhzRFONAvUHDt9TzKq
	 csz6sWEkrSbbfozCJ1jwU9CVPWab9jTEA69NTOWJHSCJpZ3NTHuzh0XtbhmNGosU6gCXs
	 ALAXzeapBL4gNI1mdVsb29RgCUnhWKitHoUiwKMrn5prLoJE9tb7ydavx5vCzeVbjZSGk
	 d+kSVvaEd5xF9mcp3eKfWuKH3TCuCqVZfXmzZrf8f51lB15eAuJ/2Ov+yZZ5LX1RjaVGO
	 ik9bjS2+uNunCa8eZCFVX+NNNY0coRs+T6+SQqvIyG5VmLW/tyK2jwmEmO+05wz30fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FYjRrKX0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CA9606A31C;
	Thu, 19 Nov 2026 01:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FYjRrKX0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D98E1F000C5;
	Thu, 19 Nov 2026 01:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051527;
	bh=jzz2WONdZ3p9PWCsaE5qCpG0HDmtvyFeHv0r9Xsk5gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYjRrKX01/kFLUQxb64mtXfEt1JHOLECN8DfxBG5dnYPDkCgwyYrrbe/oBAINXAYR
	 Bk4RjwXoREEXbgECo5SrpG3DbNKd4fS6VgTVRXQqFVLzeVJpdQke/75mkHR9V4zdVJ
	 dNIPLtokvBw1vZ3VNtikvlaD3CpmO1qsER9tVxy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youth Cao <cocoh2os08@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0239/2214] HID: i2c-hid: Add i2c-hid-quirk-bad-input-size quirk for 0911:5288 device
Date: Wed, 18 Nov 2026 15:31:55 +0100
Message-ID: <20261118150019.752251497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 93f7dfde6d297..3b3204c7afb75 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -165,7 +165,7 @@ static const struct i2c_hid_quirks {
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



