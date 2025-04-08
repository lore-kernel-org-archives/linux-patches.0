Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCBF26FDB1;
	Tue,  8 Apr 2025 12:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115906; cv=none; b=lRd93srBy1pho+3d5L9aiYvfA/j4YeKXiVyvaveKiM2yu9DkAuD4oh/cbU8Ivtu7HzNZgkaaDT04R65IRkZDpOteh11TZPTYpkqu271Zmlcf4nANe6e9vJWCjkKHgEPji80epnHay2zkSwfjSmFgkUMkSie8TtyQrOyXqvXqetA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115906; c=relaxed/simple;
	bh=Ksw5/5IKNfT9ia67zdYdl1SGams14Q9h9W4s4w3hIFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Au6bV3kt9eOqYMsm+cRW0usYFZTQGz3F0wzb7sEQd/UPeOzSJX+AecHTEEsA6gYgN4vdaPaelMIN15+CWy8zVEx8uUE3u4LxomNMDH/bxlysohQ81iQsYVkAAiG/c0Rn5d/ztITcJDnwaUytLotaPSHILGDB47P1PmcXR6k0etM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IX5MdONP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IX5MdONP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC63BC4CEE5;
	Tue,  8 Apr 2025 12:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115906;
	bh=Ksw5/5IKNfT9ia67zdYdl1SGams14Q9h9W4s4w3hIFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IX5MdONPnzMK25YhZixyilqpqhN9MnHDnN1bUX3pF0R2tvqRgoJF0CJ6DPUXlPvCf
	 KaZtezZYtIeV8S9H3a/FxKOYKBo8+9RUb89192L+B50bnuVtu3e09XBhuHGonyxXd+
	 QqejQMktitNi2kJY6w7KTcsFyPQnpe+5yxsh03ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/204] hwmon: (nct6775-core) Fix out of bounds access for NCT679{8,9}
Date: Tue,  8 Apr 2025 12:51:17 +0200
Message-ID: <20250408104824.607179222@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9de3ad2713f1d..ec3ff4e9a9abd 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -276,8 +276,8 @@ static const s8 NCT6776_BEEP_BITS[] = {
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



