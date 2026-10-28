Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214912;
	b=sGzdln4GGFAwSvvfYv+gEXN0q8VkRc7f5aGunkQpnVIoEHU09msWiOQeQaxJokcfiiKE
	 xiNB5MClwmuIk5pAJS4kMXWYdPJH8estxm1dsTav1VUuACCMASRbI+qh7SLuXPenMRFFe
	 GaNFvnfkx0R0K0lkBbLj7ykqCl5VZ/Zf2Ae3uT0UXgSAKokh2WIRWFSfqIn0l8lcOP3Ad
	 XmcQ8PHMkn2Smig1bS8exUz+80G3ru3bs1d2fL0x/sliHVWIUict0AYny4SceE70c65kl
	 gyBa3+p4MQLOPBAburwlgb/vKOh58siXEJbJgE2RqNJ9uTggdp9S6Pdu515pqXqHU/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XKnZewmRcKvSz6dJQ+Rz/w8CCRUsTWpPkT0pCvOzf8U=;
	b=s1puFOYUtWtR+z2zYGXE3/ZBmt6uq4EvNW79h179KwqJ3tZwovKRH+7eFaYcVzHzrbGK
	 GflPy+xsm8kGxXWz+VRJRN26q3oCrEmHLUfJLJRTRvVKUOar4EFYeN32hDclN6/38hvza
	 2OwPkvYh+uS4QBQPlduSLbTYIc5nRk2HeOwU2bActt1lUDMbPbv4HHQIiU/EMh5cMhRNC
	 RiDlLJu4y6cFiCVrHWVnl/5scAvlgaGwoPdwLEvYMk8q/3CZPw+1I9fbd6xXhLQRFH33Z
	 7p4jz7gkubqN2FljaTYq+gDbW8uvaGLbMvhmVOsJnv0nt4rJF4EiXeiphRltrAnAogw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wT5OgmAh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3520D606A32C;
	Wed, 28 Oct 2026 19:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wT5OgmAh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D711F01825;
	Wed, 28 Oct 2026 19:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214912;
	bh=XKnZewmRcKvSz6dJQ+Rz/w8CCRUsTWpPkT0pCvOzf8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wT5OgmAhQfbQPxUC77x5Yn2TzM3mel7yk85bJMMhypjuySbkxKDvdSe6cfz+QWffy
	 aqVC2D9AfvDVahdORgxBLgx/i06dKAVLqnOCzf/GICzJXuElT4XAjkw4mdHAGq0eKL
	 ePb4+ciXd4WeDTg3c5cZf31HuNxY0C0N4ccU4XV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lin <ryan.lin@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1025/1887] HID: intel-ish-hid: fix NULL-ptr-deref in ishtp_bus_remove_all_clients
Date: Wed, 28 Oct 2026 17:52:01 +0100
Message-ID: <20261028170522.740759914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Ryan Lin <ryan.lin@intel.com>

[ Upstream commit 56f7db581ee73af53cd512e00a6261a025bf1d58 ]

During a warm reset flow, the cl->device pointer may be NULL if the
reset occurs while clients are still being enumerated. Accessing
cl->device->reference_count without a NULL check leads to a kernel panic.

This issue was identified during multi-unit warm reboot stress clycles.
Add a defensive NULL check for cl->device to ensure stability under
such intensive testing conditions.

KASAN: null-ptr-deref in range [0000000000000000-0000000000000007]
Workqueue: ish_fw_update_wq fw_reset_work_fn

Call Trace:
 ishtp_bus_remove_all_clients+0xbe/0x130 [intel_ishtp]
 ishtp_reset_handler+0x85/0x1a0 [intel_ishtp]
 fw_reset_work_fn+0x8a/0xc0 [intel_ish_ipc]

Fixes: 3703f53b99e4a ("HID: intel_ish-hid: ISH Transport layer")
Signed-off-by: Ryan Lin <ryan.lin@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp/bus.c b/drivers/hid/intel-ish-hid/ishtp/bus.c
index a2a6b935bf5ee..2bf5073ce128b 100644
--- a/drivers/hid/intel-ish-hid/ishtp/bus.c
+++ b/drivers/hid/intel-ish-hid/ishtp/bus.c
@@ -730,7 +730,7 @@ void ishtp_bus_remove_all_clients(struct ishtp_device *ishtp_dev,
 	spin_lock_irqsave(&ishtp_dev->cl_list_lock, flags);
 	list_for_each_entry(cl, &ishtp_dev->cl_list, link) {
 		cl->state = ISHTP_CL_DISCONNECTED;
-		if (warm_reset && cl->device->reference_count)
+		if (warm_reset && cl->device && cl->device->reference_count)
 			continue;
 
 		/*
-- 
2.53.0



