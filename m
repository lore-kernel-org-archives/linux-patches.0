Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035868;
	b=byoNI5IHKR+08GfVGMXdOifg+TFJ+cnFqHgi4cJn9FL+NPu0STorB8xDrn+az+8VV1lN
	 s1u/GBW0gYXCbwwSrKPwWXX+wNvmlSlBW0aTfVJ0ZLLuLyxqKiMklg6VNnTsiUorxx8wf
	 KkdzlKnILYYP708+CAw2Et+UhvD/ZsuVVfk+ZIAtAUsPyz//Z4P9+T9zINqxgtPUme/XN
	 hTLNG7QQrLsiWL4Ef3vSBYMxx/rMT5CvzVbn0opmF4YzFankfGTIcC+hsSRobvQrdQlbM
	 XbjsPQ6wUeYZOlIHlJNPhu0jl/QxcBDAVy3zqZp4MW8JEweVfQ6QjyNJGFPH2UkYwgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mVjk9j1Jo/Iq0h471a46tuJPf011Y/4qhwLKa6XOs+s=;
	b=INIczwzjTfnHI7gqxH5ChzMO+ZDKnq+upM3OJJ2VAyUbS2aqRGVmcBac0ZHKu6xtydVG
	 +vOICs0tH995CyRE1wdnBGu4v+oM6r5Idk93ZdqsgZEK6tru7F4gQ6+fcFA6yQHMsWhai
	 qOsgixS9nMmTP9hPyAlN0vM6N6+g4Zi73v376xfpXiFnaP2w/tmdm7SfrNAOGu0SAOimq
	 3FJzQ7Klr9hTwTSXEpi5Q2GC14f+AKZ4BP3k3fshOozMKIatw5sRlllGbl+qiMdEGWAw6
	 Jdfx/Prg9acXdMusUS6ac/iVbwTXmueb/iWk6WB9Dnotbn6dBGhIjoDJGZsQjWe07Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYOdP5Ce;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935E4606BE17;
	Wed, 18 Nov 2026 21:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYOdP5Ce
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46071F000C7;
	Wed, 18 Nov 2026 21:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035868;
	bh=mVjk9j1Jo/Iq0h471a46tuJPf011Y/4qhwLKa6XOs+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYOdP5CeTtGGqccWdCG9kCRpY8cHPtthHySuCU8JlenzAenWKPuY00TUO/zOQeJ1d
	 7Z2foEwA7me0WgPTkPIDHAwCa5eVGDrUuRUEfouwcGIwkqEUiXLb8p/N3IjUesSmpx
	 c/GdN062EzV+YgaGBGOChmWocrC5OSXiRtnJubgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0856/3318] ACPI: pfr_update: zero-initialize capability query result
Date: Wed, 18 Nov 2026 15:24:38 +0100
Message-ID: <20261118150344.931529089@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit d776369a9eded071df83e4738e1572c4c5b912d7 ]

query_capability() copies four ACPI buffers into fixed-size fields using
the firmware-supplied lengths.  The existing overflow guard rejects
oversized buffers, but shorter buffers are accepted and leave trailing
bytes of the stack-allocated cap_hdr uninitialized.  PFRU_IOC_QUERY_CAP
then copies the entire structure to userspace.

Zero-initialize cap_hdr before querying the firmware.  This preserves the
existing handling of short firmware responses while preventing disclosure
of kernel stack data.  Oversized buffers remain rejected.

A QEMU _DSM returning one-byte buffers reproduced nonzero stack suffix
bytes in all four fields.  With this change, the ioctl still succeeds and
each unwritten suffix is zero-filled, while 64-byte buffers continue to
return -EINVAL.

Fixes: 0db89fa243e5 ("ACPI: Introduce Platform Firmware Runtime Update device driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/1a001e1fee9.637da6dc3533246.238498880682901704%40a0rg.com
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260827053741.79425-1-kmehltretter@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pfr_update.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/pfr_update.c b/drivers/acpi/pfr_update.c
index b89910a30bb93..8bf3908a6a852 100644
--- a/drivers/acpi/pfr_update.c
+++ b/drivers/acpi/pfr_update.c
@@ -395,7 +395,7 @@ static int start_update(int action, struct pfru_device *pfru_dev)
 
 static long pfru_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct pfru_update_cap_info cap_hdr;
+	struct pfru_update_cap_info cap_hdr = {};
 	struct pfru_device *pfru_dev = to_pfru_dev(file);
 	void __user *p = (void __user *)arg;
 	u32 rev;
-- 
2.53.0



