Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061964;
	b=hlpp6Hd+I0J+4qjYrR6AZT4eZJhNHA84mWUzDFRWt8vGQkgGTJwRcOOxpNAy2MtsIfr9
	 EAGvugXTlDW6qrOogLOmFNJW28usYXagui8CQ8XXjAOdlxoImNuqyEVk4cFWqSZgO1Pj7
	 hQTAU9Nt5Q1/5bpQLfRQqfxbqtWSyln3587LOHsQoQENcQ+bEtcNJuWwOdSii9sbhXJSA
	 yuhSESypa+eZcRJ1KP2yK09bIbj5mRrspLZeMj1gb5lIj/CeN4rrPnatZ5VVOjwzR+0cF
	 1HMa8Hw4yTsG+ASQq023vWZYOX8qRlZkBvUsvIWnmrD4eTDvJyWxIBisaWeLAeD5HOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ofm7yYeU+56+TjidE0SGgbh4fo4b034B1j7V/0P/SLU=;
	b=E2HdWekM1+GNnS59gPe65PRCSaRqIsSBrrn/JsysEv4MLUXOcv+X9ldX/qQDpca+eHZD
	 lKCqdnJFJWz6/lsEVX1VBY2dzWSkdFiNr5RRG7iB6wVF0JSP9ZsyUfW6FGBD6+OGs8Mq9
	 cScopgePMwnloEynhnJJ/H1ZkD2FHJpu7lmi4swQhDJ5n37e1uh720fDJpaOPp4477iId
	 ubZ8nYL30q80sn/AJGidUb/yxFkNHYqtGnVfMFN3BOJKN2bGkA8D37GGU9UynxXwFor/7
	 aE/g0L+NP8gT0rihOGbQr4//xOSx6otlPEoefgwq+LWklSCOWBS1+DZmXlEcXlS4Wqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+kPkMDD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C889F606A32E;
	Sat,  7 Nov 2026 14:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x+kPkMDD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2081F0089F;
	Sat,  7 Nov 2026 14:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061963;
	bh=Ofm7yYeU+56+TjidE0SGgbh4fo4b034B1j7V/0P/SLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+kPkMDD2R47qWRu/We3fo6QGxgtJyDi0+yYa17jwUlQkX4HrK5AG3U3LsKzd5FqK
	 /Th52uiAjAzpqy9UvuHFlNSLDjGJNPSLzBpTyHp7dHqqU6tFcDIcdhajQxr5gQ5lrp
	 gOzJd+YYtrPOTQDSab+zcveiOws8S/9WnyjNK1ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0961/1536] ACPI: pfr_update: zero-initialize capability query result
Date: Sat,  7 Nov 2026 08:49:37 -0500
Message-ID: <20261107135024.642993820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index be9b3b5e00c56..a9fa2f23c4ec6 100644
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



