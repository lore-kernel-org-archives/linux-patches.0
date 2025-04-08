Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C98266EEA;
	Tue,  8 Apr 2025 12:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114097; cv=none; b=UmxxRebSJPo0b+q22F5C7X8dLTEhipibvyTi70LlC2wIVZDd6Njpvidj6Mzh2nl44aKPP/+Wxgaj4BzuXdaLHX/fich0BTp56YpEz2ftp1Pvn4fNoE6qdWxm2h8ZFobTODjT+/vjVpE+SzUwWAbaWBWL11jMWBJdAlJpp5Nk3sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114097; c=relaxed/simple;
	bh=BxMfCWwegHSWaLcQK2iaGWUbV1xB2ggVkpzz0eVbW+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JR7AYOkT+vskfEGU9ZG96ZPP7S64VJcxrXaGTYp1Q5da348HOd0EueqWqT7KCgqJriZ5ycvPuPjgmNsLJUhndolOO+wI22/GNHmPTy38edZjekccm44GpC9no/3UPTP3BW9/OtvT2of7X9GUehG9TKnQZ1XAqPjH11oVjWMpaCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpgaZAw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpgaZAw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EABC4CEE5;
	Tue,  8 Apr 2025 12:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114097;
	bh=BxMfCWwegHSWaLcQK2iaGWUbV1xB2ggVkpzz0eVbW+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lpgaZAw7olcF1X3q7QNYgI9emRQBJ8ZuKDj2u/ef+vUL5EOmWbmqP762Elmi12p20
	 Ji1Ss8NLJBFGNpJK2lUXwy+dJb5ziCf7uCnsmiQedrHIasJJ9uL8p0pfsa+Ee3tTEn
	 yG+PxvDMWLbIGNF4Yotf4+fK/6ipuPSgvGTfGfis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/154] hwmon: (nct6775-core) Fix out of bounds access for NCT679{8,9}
Date: Tue,  8 Apr 2025 12:51:16 +0200
Message-ID: <20250408104819.640415577@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/hwmon/nct6775.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index da6bbfca15fee..a6b7919ab63fe 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -420,8 +420,8 @@ static const s8 NCT6776_BEEP_BITS[] = {
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



