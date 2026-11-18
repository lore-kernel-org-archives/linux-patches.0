Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044968;
	b=GCJhmSc0zh7QhO6oQqulOuUdASfDdR0YEtXho9WxhCIERqxEUn8wSA3J1D4A0F2y7cvw
	 wQbvvh7E468VM6xL18e8QUHt1DS8UvgNQ6MwVZGNhmOFlBuJKNpY3gSWe7ztZUs1/Q6ly
	 dwfAh99CRNEMY9XCO8UD+N6v9mUkdiUJxOmr3Krpxf0Mo7UHTMNZlWWZc/UJDtypMZe4O
	 bmdTDEdfmjPznu4R4BnXin2Ghokhp8AyRBXQKDIqtj4cXf2dSrAQaJfhRSCmRxqF968lM
	 m0u3haCHjlbmpd83MbgBrydOqLXBH9VLZW6gMDdWW4lgYPSqNyUbe2L4cUC3EzwpnBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=awTqpwyewrs4feEaIeldg3+VRlM/biSltpKM3+2KIi4=;
	b=g8UAmaXcDu3a1PwMEOsD7wG1kOJG4OEEOvc4ZAWg+SjgSFl1gEh+7ROFOGk9+SRLEkeG
	 eFXhLL3hjm/86O3Ew7h6zUX0DOFQQHrX6eIiFbCqHOaBjvczc/tw6+Qbz4kX/iS2PfA8y
	 0NuvRBDqWOpOZaQbFpiYA0QMZhWIWtWodzchfPnTSXeXyjwFQ6A951j1uV7RxIB1j165K
	 9ZnEoNlIz+RIRAT2pEQhWu1T1tzKwTkeR+Geid2oHj1QF1UlXETLW3AVwceVBITRAox6z
	 xEI1zT9fIFpp9yMNDewStnDQaW8jbM0MSBlNQbcQIuLRbQ599RY/uEqQSU3jWZWarFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnZ6xyIe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44318606A331;
	Wed, 18 Nov 2026 23:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnZ6xyIe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994F81F000C4;
	Wed, 18 Nov 2026 23:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044968;
	bh=awTqpwyewrs4feEaIeldg3+VRlM/biSltpKM3+2KIi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnZ6xyIeNsNIAcn3uKQh755PxzrYbVghfBjfJayguOrz+z68RPHe+7h7slXvsB3n0
	 BOg0HvHcbo9PR4PWEBF268Aqsm+USHEkH7t23sw0kK4UFbSi6uSs8n+cWLl2W4UJfX
	 1CiteN0s8xCgZ2ntyX0NpiDsaDikUZak2YY/XkWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0756/2857] ACPI: pfr_update: zero-initialize capability query result
Date: Wed, 18 Nov 2026 15:29:50 +0100
Message-ID: <20261118150228.771999465@linuxfoundation.org>
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
index 27d75a46936c8..31c31f02445c4 100644
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



