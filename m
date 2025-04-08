Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B5C26A0D6;
	Tue,  8 Apr 2025 12:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115097; cv=none; b=p7sb8yL4jnZ+0OfVrvvBO92iF6l1JZcSC3R4X2rXv7HHqD4NH03rqenRwb7BQQjhwP1KB4wi1X5TlR+Yp77ir2zax4eXWEhZpHcLF81i+8FjoLH4XRlgGkJ19vuGFe6tSB9AugHWVQnWJ8dOmB00VxQr+ncRQ0ou6sGY1sksY30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115097; c=relaxed/simple;
	bh=hX3p/6jefavijanwfs1QM0gYhqbQBNzAMce/ull4gbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPYxJzTIo1cT7z5yxFEn5zAhyBzhdF94Wt2R5n8IUATBiwS0y5BAcz2YB7q48LC2kl9zH8KqXKE+OEgJ6p6JSPMGLI8/K28KCt0+SnmZwrvxhlRIRwwrUwNJ1z4/fYA9imwh+h7RDqTUv5Fwnd21Y4qgnYaU7JAetnyA2j9N4UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caW7N9Td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caW7N9Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8EAC4CEEA;
	Tue,  8 Apr 2025 12:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115097;
	bh=hX3p/6jefavijanwfs1QM0gYhqbQBNzAMce/ull4gbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caW7N9TdzVOCKQZZ+1WxMrefTqteg8lD4Zgl9uCy2GO16PiGfyO2GaE0SBB+mUfzZ
	 VbFFPHBoTFPSdYJBG4O1Dcs+qJkEWIPB38GFwNssW+qm2gUeVsdtfIvk8/Dx8VTAJx
	 FRIjQoH8pSbG9NfAHcMeVGXCNVy1KgK3J7wNaDVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 349/499] hwmon: (nct6775-core) Fix out of bounds access for NCT679{8,9}
Date: Tue,  8 Apr 2025 12:49:21 +0200
Message-ID: <20250408104859.929524772@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tasos Sahanidis <tasos@tasossah.com>

[ Upstream commit 815f80ad20b63830949a77c816e35395d5d55144 ]

pwm_num is set to 7 for these chips, but NCT6776_REG_PWM_MODE and
NCT6776_PWM_MODE_MASK only contain 6 values.

Fix this by adding another 0 to the end of each array.

Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Link: https://lore.kernel.org/r/20250312030832.106475-1-tasos@tasossah.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index fa3351351825b..79bc67ffb9986 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -273,8 +273,8 @@ static const s8 NCT6776_BEEP_BITS[NUM_BEEP_BITS] = {
 static const u16 NCT6776_REG_TOLERANCE_H[] = {
 	0x10c, 0x20c, 0x30c, 0x80c, 0x90c, 0xa0c, 0xb0c };
 
-static const u8 NCT6776_REG_PWM_MODE[] = { 0x04, 0, 0, 0, 0, 0 };
-static const u8 NCT6776_PWM_MODE_MASK[] = { 0x01, 0, 0, 0, 0, 0 };
+static const u8 NCT6776_REG_PWM_MODE[] = { 0x04, 0, 0, 0, 0, 0, 0 };
+static const u8 NCT6776_PWM_MODE_MASK[] = { 0x01, 0, 0, 0, 0, 0, 0 };
 
 static const u16 NCT6776_REG_FAN_MIN[] = {
 	0x63a, 0x63c, 0x63e, 0x640, 0x642, 0x64a, 0x64c };
-- 
2.39.5



