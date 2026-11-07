Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063969;
	b=tUqoq7HyIqmQmlj20PMJporHqvedNQtcG5RJ0cfCJSBhfPxaK9dpggJqr1dxkl9uDzXU
	 LhQFibIOxN6Z7Ibss2HUxe1qLYjBjOgbv00enHr5izTWxVeIiu9GFFsNbLYjV4H6V5NDu
	 Z5JwElvm/Q9gQFMKf/0MwXt45CwTfLisyOA+C9FnhTZ+sjmk2uz0Q3G0j43KI9UHfVEdL
	 clqW6461XvAftQ0zlT1qQoOLBbD8jvY0Y0agQKL609uRUeldlD58g0xu3SB1OiQrlLl+p
	 2dvliU6Q/ICKJk+8GXIj4/FUjaBFVqaPgWG0SRYMymNH2T78VKiSdLciEnB2eEO/qDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nIVA8PCNkT6TcckvmnDBve6eLcMYSiu3Ur41MyA2JUU=;
	b=PQQ11wQ26bmanl11Zqd6H6qbvxgMEAgVOhCQiHT2gOfTw/KpcutxKLmv0n2XVV18VbZR
	 Y3zf+uCis3QOhHHX8ZvuU/Wne23XBxeFxRwmemqfYVuxxxJA4nLKCpfcO44Md98r2OliX
	 JtDrYKYI82ANnr3+57z/3Lz7QEf4lrbCrBI2gtkTQb5KE7ZAjT5FW3xYEhzFoYeWyYaZB
	 cFHyGHPUF3S9tNSN599rWzJ8SFyGcAssy59iaifrsX7Lw7f2HKv7mCBqQA1+Hw/5tno1S
	 poqenajzUJPUnsZxZSwAPBMnrERpihnQOuQbcznUXYyDGRoYjMR/8bIOEtWlWzEWuAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AA+fUdoT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87966608362B;
	Sat,  7 Nov 2026 15:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AA+fUdoT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA51F1F008A4;
	Sat,  7 Nov 2026 15:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063969;
	bh=nIVA8PCNkT6TcckvmnDBve6eLcMYSiu3Ur41MyA2JUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AA+fUdoTtNSGJ8PCVbXmGptXXEJ39tejYCbHyjMztNYG+ZVn81kkRI+FcuvXSuOdO
	 n9Uygc605scqUzAd928XntTrS392kf4/WmTAVMInBHBYFLbLxung6fJbtnnFkpPmXc
	 ZvyYOaveezQ1hz/fKTPeRbP+xSYh6pWRK5LRR7oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0128/1257] ACPI: pfr_update: zero-initialize capability query result
Date: Sat,  7 Nov 2026 08:40:24 -0500
Message-ID: <20261107134942.858365956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9afd2c52fdbd8..98ace679601b8 100644
--- a/drivers/acpi/pfr_update.c
+++ b/drivers/acpi/pfr_update.c
@@ -422,7 +422,7 @@ static int start_update(int action, struct pfru_device *pfru_dev)
 
 static long pfru_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct pfru_update_cap_info cap_hdr;
+	struct pfru_update_cap_info cap_hdr = {};
 	struct pfru_device *pfru_dev = to_pfru_dev(file);
 	void __user *p = (void __user *)arg;
 	u32 rev;
-- 
2.53.0



