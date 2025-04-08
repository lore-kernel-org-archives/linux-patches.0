Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C443F26981C;
	Tue,  8 Apr 2025 12:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116875; cv=none; b=jlPuJurs4XD3py+uEgvz783bMHHGT8Xci56rx4a7Al63bk/sf/GCUr527QZhknxmGCLsuyCJp0Aa0ks9MI02X8MppsLcHJr/VLS86b122u0+F7cPfrn0KDNYSC70pTYybR6Q7Jd9qDJ4pg4NZnner7AKENL8M4NhGJXeuyirtTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116875; c=relaxed/simple;
	bh=rpPU3dg7pWgFc2lrGoF3GHLYfJYUICF8AF9k9c+MruA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJbv14xLOgKNi7RqTUrJcgemwc7lUwK2Q7h4rP90XlU2upCpIl8MyZ88xlsHkEIQaCTRX8GiBNatTrOGnFBLT1o8j59F1Pm/iuYNlWE9XS46UqCd1TQy6I9BcuQEl8CUs2HbMQXPZcNRM7tP3t5wjomKwbSmYhmoU2E61mMuTdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbGjWnIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbGjWnIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568E9C4CEE5;
	Tue,  8 Apr 2025 12:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116875;
	bh=rpPU3dg7pWgFc2lrGoF3GHLYfJYUICF8AF9k9c+MruA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbGjWnIjsymOziNJtcjAsG9tsO4rysrbpoMH04NJ1foTfhnDtuQxu4iL+nx9Mw0Fl
	 /JQu+5cq8Pq8PUtsCIaIvKUcUVzm+yPq1ISzUzUIPoZnm5PqnN/XyNseF2o2B7RcQ7
	 vXjCEdVD3T4I1JbBr++wPgCkhaqQCkpdG031fXVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 299/423] hwmon: (nct6775-core) Fix out of bounds access for NCT679{8,9}
Date: Tue,  8 Apr 2025 12:50:25 +0200
Message-ID: <20250408104852.755790182@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



