Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015786;
	b=KnCXeoU4nZQTG5xvQMxpbhV5xGU/PJBNcV/GBrJRY3bJJVWFC5wm/mGUQ5HQQjb5Gnru
	 kogkDKJMFwRqDKCe9qpj3x8Tb4L/cMiaH2DmtZmlXq2sWn1enSbETPjpGMrmpu66Pee0j
	 8m7HWHPiT8MxH/JCPeSa7AsjRq3Jre+F3Nyrv0XF4QbbnpEv8yktm466v8JyOkOt71EsJ
	 /uUOTzKMKWXN1tOgMOaOnqBQsQK2GA8juhlyzuHz0n1cOhllcFP/PDoB8W+wZrh+4Zq1p
	 YxLhO8GGaXsasYGl5uSSUj5JqbhBbmCv2eKNhi+gxfbx3TPrpighd9l1FGT1BANPd0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gczulTgXNVjpCoi9izEn1Pmj4aTs3IQhDgX0YLkx9B4=;
	b=g6MuiEu35pdG6lRHpQBkWfdiV9Hv/9GY9CMFdEz9edjP9rTiT4MLiQQym8dybadRtL0V
	 OUAErPbPuye8fFbe/OFWS8kvzXQxnHrLvX7C8icEpl1f6BCC4+kc1q2wyY5Ar4TS6SmUi
	 BXidAeerNwD8yiZaSaXEk86FcSFrc95QDuVzQehdM3R6ZE9G11vCtCp2DT3BN0QsB+DF7
	 ziHNqAnKp8+qxbUFMyikwP7nUmn6meg8+8bxDo8/pioAcviRwX3LQn5aQ+JDzlpCN+4W7
	 TR2tfAN/CPdmXFRRCMrDZ95afyyaHnkfYS8M5n2ebXSxmsuCTbz8Ufdv5RJlIFu++Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pW1xIUse;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7008C606A31C;
	Wed, 18 Nov 2026 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pW1xIUse
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C0C1F000C8;
	Wed, 18 Nov 2026 15:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015786;
	bh=gczulTgXNVjpCoi9izEn1Pmj4aTs3IQhDgX0YLkx9B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pW1xIUseMvSXR+2h485Ix/Td737Z67cH4bmErwW+4LtqfFQWbngRwBS/cB2B+O44o
	 m5wYaqQ33ZfhcLcrG6HlICUhPbRFsNNWKyBmoWvtchLkYwf+z68kr3uL/BjYLI5eyH
	 pGGbxtmzbdDWn9T7zM/o3yEeH1ghqU3Kd7qvxIYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varun Gupta <varun.gupta@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0255/2651] drm/xe: Guard page-fault worker with runtime PM check
Date: Wed, 18 Nov 2026 15:24:55 +0100
Message-ID: <20261118150257.041285143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Varun Gupta <varun.gupta@intel.com>

[ Upstream commit fcc2431d2213dc4d04250c4f1ae87d9c3ae0d455 ]

During VM teardown, the VM's runtime PM reference is dropped
asynchronously, allowing the device to autosuspend while stale page
faults belonging to the now-dead VM are still queued. When the
page-fault worker later tries to ack one of these, it calls into
guc_ct_send_locked() on an already-suspended device, tripping:

  Assertion `!xe_pm_runtime_suspended(xe)` failed!
  WARNING at xe_device.c:1267 xe_device_assert_mem_access+0x11c/0x140 [xe]

A live VM/exec queue always holds a PM reference while it has
outstanding work, so if the device is suspended at ack time, the
owning context is already gone and the fault is stale.

Take a runtime PM reference across the entire pagefault
queue worker to safely deliver acks for torn-down VMs.

v3:
 - Move PM ref to the generic xe_pagefault_queue_work using
   guard(xe_pm_runtime)(xe) instead of tracking it in the GuC
   backend(Matt Brost).

v2:
 - Hold PM ref across the entire batch (begin/end) instead of per-ack.
   This prevents the device from autosuspending mid-batch, which would
   leave write_only acks written but the end flush skipped, and skip
   counter++, desyncing the cadence check.(Himal)
 - Add a comment explaining stale faults.(Himal)

Fixes: f289f7807119 ("drm/xe: Add xe_guc_pagefault layer")
Signed-off-by: Varun Gupta <varun.gupta@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patch.msgid.link/20260907050011.497181-2-varun.gupta@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pagefault.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_pagefault.c b/drivers/gpu/drm/xe/xe_pagefault.c
index a4986df8328d6..7a0ea4d414ca6 100644
--- a/drivers/gpu/drm/xe/xe_pagefault.c
+++ b/drivers/gpu/drm/xe/xe_pagefault.c
@@ -304,6 +304,13 @@ static void xe_pagefault_queue_work(struct work_struct *w)
 	 */
 	guard(xe_pm_runtime)(xe);
 
+	/*
+	 * A live VM holds a PM reference, but a torn-down VM does not.
+	 * Guard the entire worker loop to safely drain stale faults and
+	 * prevent autosuspends from desyncing batched CT flushes.
+	 */
+	guard(xe_pm_runtime)(xe);
+
 #define USM_QUEUE_MAX_RUNTIME_MS      20
 	threshold = jiffies + msecs_to_jiffies(USM_QUEUE_MAX_RUNTIME_MS);
 
-- 
2.53.0



