Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043760;
	b=tHizsLaLQdmuFSlvINCw3uHhe5NAljthbOQccWCvMYpWVAqXoxdMYEvduuGv68645ISO
	 sK+mTTs6JdE/XDI+rg6vF8T7Ui0bXyN2mE+ZTCWAPWybO2nU2viXkKNUb433gq54LqeXM
	 FZ/nVluv07ry2PAZN0Q66N6cL/G4XPfafgDK83cZsZFxkzjSXIGzlOOLjn5IOhLxz5Kgn
	 543CNqmOUlOBkEwDTUT6yEriMUUj45L8kQM6Av23X7oEGeOMu2cXGh+lzyfilligAwbz6
	 Me7dfAZ738d+G/oFUma5KHsQx5dEmjsOiYmo+rP8DyuxDY4PU+/IHTedBGMm0rzv+Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8mgVmJtJ75Y/WCYpgp9OvvP8IZ+e2Qtys6HEiqlSzJA=;
	b=RmGe5koNwtID9SO1eAElBXDBg0BfSRu03+xLWL47P/y1ilMQv+so3z9Aj4bDwE6q5OPy
	 7uHi7xdcH78WOZpkDJxGxy9+3qv7AOq2xuEgL+KUlMGEFa8dqI/9aOqmtxGJBcOcFPKDE
	 cbkm3HSQUl81CRIpKWCYTPCIloh+hxFhrwkGwOiEaXQFWo2PpWBwnOSLcpoGsix1XuhvE
	 ev6TUNpCIANbGD8aGo/RdiwK5Ub9kR9mEyoUpLecxYJKl0tjXhbqjpMqukEQD4R/QDnvo
	 6UMTbjkciD1yBp5uEGnxxAAWGu3UD2eCanABCWfISzZQMm51VbKAIErShhrIzV/wabw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ru+Ph0YX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C0A606A331;
	Wed, 18 Nov 2026 23:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ru+Ph0YX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707B41F000C4;
	Wed, 18 Nov 2026 23:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043760;
	bh=8mgVmJtJ75Y/WCYpgp9OvvP8IZ+e2Qtys6HEiqlSzJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ru+Ph0YXNNA6yk9tEM1+Icna2C20DxXHf96H1drz0xPvg7mr5N+LJu6AChrSZ3YQ6
	 LQPFVSbao+AI4M8Ud60X4FBgpn0bojZkXQyEprDA31Q0gSb+H1mnd1DKDYiHeIdHPF
	 ZaCm83cYLPRNuXfLFQeASXSHo7hvOENQXOeeiak4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youth Cao <cocoh2os08@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0284/2857] HID: i2c-hid: Add i2c-hid-quirk-bad-input-size quirk for 0911:5288 device
Date: Wed, 18 Nov 2026 15:21:58 +0100
Message-ID: <20261118150211.651093178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d301dc5acd31e..7d151ceab1c84 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -125,7 +125,7 @@ static const struct i2c_hid_quirks {
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



