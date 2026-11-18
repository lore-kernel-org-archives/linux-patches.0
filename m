Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034473;
	b=GGOLVhYw58UgguuFyAqkZ3dne9dDWSyEkDbyKTT83K3DBDqZzQR3D6lG+yf8e/8YrU2z
	 9nlJwxRsqtgyNPU6SpiEtEdkr9PVHzHJD3NiZWQLFF6OODtgQvTIlBOCx7g9b6NN2eWhy
	 q2/y9iZao4zERBFJUR/COG5fLCYpARqx+QM0ggyuCF0YyKY17l2tpEHxtOQN1JepqF8rA
	 YReCAQdc3EOFhDYEjOOMvFGkU2wA7rdXUEEBQlDJFpiMJsCRfKAN2Sz/m9AW7wiA1DCUH
	 xoYkPetbFGZYCZMDvcjh059LcMHporE7FCzC9Mc2NqcYEDv3yloAR2jmxhyvoI2ju2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vVo89aDyS3fgmD73DL7AGywL6p6uheHxx4Q3e+9fz68=;
	b=dBSOIluxyckyW3T+S7FZZCJcGvsw8ElIVRHQox7yn9FW8XBQb7PF/VsqKAZXiJU2hX44
	 A6aO1cBzDPDrUAr0HqWdFyvf8nKIg8mcJwJAkSQhfm9M5gjQgGsRiQTVhAbilcCkqIOOW
	 JdQvaoxsd61sj0SGXL6w2Vstw5riHFqxqkw+BDpa9PEdyvoAm2JmOsx1aUfYU0i8r9DLD
	 DKMgdoME3fP3PMlaz5mMLKAJUvwCxLmawsHdQ7NVZpfq8WnF/MLg7HHnyC9X9ERIfy0k4
	 2qtvGPAaSzXaTuR6BmN2YYZbUzv3WKICm/o4q4jnoTpfogFe1I7GtIQ+fBthKlBBQnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncsnTRvo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B60E606A31C;
	Wed, 18 Nov 2026 20:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncsnTRvo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29701F000C4;
	Wed, 18 Nov 2026 20:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034473;
	bh=vVo89aDyS3fgmD73DL7AGywL6p6uheHxx4Q3e+9fz68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncsnTRvo3jbmL0bD9XT4nGWD4425kdiPS/UaO1Y34RGCUBopwniW4fVMVdQR5PM4m
	 64TWqyudHifSAOCSBwLOOW+VtuZV/FjF5XK/w3Lu1LIfxPvpcoq0elfi++/XSqfJz4
	 4GifxJua2SNoBNrwPDETLIhzSz0gGzK31rQpmc1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youth Cao <cocoh2os08@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0335/3318] HID: i2c-hid: Add i2c-hid-quirk-bad-input-size quirk for 0911:5288 device
Date: Wed, 18 Nov 2026 15:15:57 +0100
Message-ID: <20261118150326.000838481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 60f04a36d5f8d..cbffeb7186a6f 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -120,7 +120,7 @@ static const struct i2c_hid_quirks {
 	__u32 quirks;
 } i2c_hid_quirks[] = {
 	{ I2C_VENDOR_ID_HANTICK, I2C_PRODUCT_ID_HANTICK_5288,
-		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
+		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET | I2C_HID_QUIRK_BAD_INPUT_SIZE },
 	{ I2C_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_VOYO_WINPAD_A15,
 		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ I2C_VENDOR_ID_RAYDIUM, I2C_PRODUCT_ID_RAYDIUM_3118,
-- 
2.53.0



