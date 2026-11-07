Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062813;
	b=JzAgN1izwcxiuRKQNLHzOlzCg8Xlf5SICA+EFScdioa0ROmhm1LH4j2d0lXrlnuiuJuh
	 /uT/KuQaL/YT+1k+19xBmOE9bFVVNWeCrPoL5EAj/DSNmdJrM0jJA7kkSwurGI8aHzTFu
	 0Jd69bw94vzk0fmvH0PyfSu6eaMcMVlNHgr8m+JQ1Bzo4Qrza8h+3TBkeOSddW8/00V0P
	 FKK5IKD/xbfo44Z9SJvk1MRAfWGSVpDHhIVPH/YCZOD2zDHdVYXGFBLeRR3DCG+E1EwRg
	 cjKG+C9RSeP8qj2Aa1LTA8TR6OFt3fekhlAiExf0aLCjXPc9RhtQ3OC5xLIkOTMrwog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FFy2Udmx0NIb98/tQIsu50NgiVPjL/fJlsFy+tDVPEU=;
	b=VXtxuTtt1CUbk+BWYIoJQkJm5XkiGeVWHdB0oi7RPp9zMVrM9/G0w+DQChkcnIOVHmFp
	 x1RlPkGK5QIW791XZsQ87Y4DfViWsxdD3XLS8NUUDaw+GkTRohTJnvXhGjlRyhg0PBA74
	 ZQYLxljHDr+bEMXMrwtsrL9/ve26SURpgtX1kCOaazVDy+x/tA7n2g4iqG0q81po8MQma
	 TOYUTmsA3AfjSs+tXlqEc8+zPYpELnNAcNVCGa+hz895if81TI8+A4sdbUN8WG1HKykpR
	 XY/sqY8wyVltsrRbxdNWL4h+LRiX5dLCtfEtJhsBWWhuhDThl6zrJLetiUZxmPpDPpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LsqyWLHA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE625606A33E;
	Sat,  7 Nov 2026 14:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LsqyWLHA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541721F0089F;
	Sat,  7 Nov 2026 14:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062812;
	bh=FFy2Udmx0NIb98/tQIsu50NgiVPjL/fJlsFy+tDVPEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LsqyWLHAoq2V8xkMbVZ5obUI2d7ctyQWBjAklEBUq/xDIhFw8EiYicy4+b/f7Rr3v
	 SK76jrqJzZEHIzVGuSQRC+6/kxuwx7Fni7sa3YKaVp36QdZ1AREEcegOilRwSVnkU7
	 +j/EWxIZ8TM+G+QcXIr+OIZdGpbrtVEgUaVpnjIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/869] ACPI: pfr_update: zero-initialize capability query result
Date: Sat,  7 Nov 2026 08:46:33 -0500
Message-ID: <20261107134856.347605824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



