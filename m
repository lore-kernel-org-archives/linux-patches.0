Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045334;
	b=ROTmXS5fQ20a8somqDEDdvGZXgQ90iWmyE6zWlzH7LyYaNew4a6i9AqorCgczntfEcNy
	 p8r3cDabVsIE+eplReqn1crKJVz7TCZ2WFsRYud0uzchCkudMLVRdzJPzdYZ3VkoPN3Db
	 MOQFjLRj9z2c9yQh2SFMIPzRjl6HDL5SU4wyNGr5fKvjY3Qfz4wCOGwechXFLy/hMwNet
	 zKorAZbLQwF359h+aLITLNuX32a3ml26P01KsG/7+9vNy6BA+OexZ3FGc8aTA5VD9ERbJ
	 K56ctNC/1jE/InCe3w6ISchz/jZ7ZzVz4uHRujLDFbvngZL6CEAdYaFyFyrMHVyQhmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ISxLxFcdCCA20bsfx72DESlMCigYwS2SifVEDvr8uP4=;
	b=2UHtdXWt3XhhLXEnE+yPblGn0MZ0NW7068FTO0yj2UdZdSixRuwL3+OP7n7qpMTYxp8x
	 rWdlCEA6le5yHj9OYCCrVzyGlL0fRI/4gCtDWLENQcFjcLn++yDeuHMKjOppOwqxHSHlv
	 XbLiagq4Q6c5YseSVfZo/j0XZlj6FYt0/y3lqa+pWirO4aURyJlca8oAMGUz4IP8TwdzQ
	 qDCBoMm29StByL3efTxMhoi0xGeDHw/L2lWMVm19o2QNyddIgSv59UgRIZRQh+hQbDW3b
	 B8OehrEm1Q0ZzR3/QuUWJ1Jsev4z2AzHPiyx7ksS9kXiIRPiFoggEmDvw/V4dBtPyxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUlRYYKj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E67E606A325;
	Wed, 18 Nov 2026 23:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUlRYYKj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630751F000CA;
	Wed, 18 Nov 2026 23:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045333;
	bh=ISxLxFcdCCA20bsfx72DESlMCigYwS2SifVEDvr8uP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUlRYYKjH19CFcy4827hnHgkgr4XtZQLQMhKnJ/lMl8pqki16t1kf7XJplZ3JlfGQ
	 pqRe6Dfk49Eg5jR2v6VSmxwsgItbqXEy3sNmeZ0Cu054BC9VT3yS8jheLwFLPZnAfd
	 rnEaT2y7Sr2QJJ5sHz794b5pFPtiv9IIkz2tf6Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DAI RENJIE <drj19981414013@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	Mark Brown <broonie@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0884/2857] resource: fix lost wakeup when waiting for a muxed region
Date: Wed, 18 Nov 2026 15:31:58 +0100
Message-ID: <20261118150233.388439566@linuxfoundation.org>
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

From: DAI RENJIE <drj19981414013@gmail.com>

[ Upstream commit 405c00e43a9c72a0b9b318cc2d2e298386ffb58e ]

A task waiting for a muxed region can sleep forever in
TASK_UNINTERRUPTIBLE even though the region it waits for is already free.
__request_region_locked() queues itself on muxed_resource_wait and drops
resource_lock before setting TASK_UNINTERRUPTIBLE, while
__release_region() wakes the queue after dropping the same lock.  A wakeup
landing in between finds TASK_RUNNING, does not match TASK_NORMAL and is
discarded; callers hold a muxed region only across a bounded transaction,
so no further release is coming.  The task is unkillable and its caller
never returns.

The window is one store wide, but an interrupt is enough to hold the
waiter in it, and the machine this was seen on runs PREEMPT_DYNAMIC in its
voluntary default.  Since v6.11 spd5118 exports the DDR5 sensors of AMD
boards through i2c-piix4, which takes a muxed region per SMBus
transaction; a third of the in-tree users of request_muxed_region() are
hwmon drivers, so reading a world-readable attribute is all an
unprivileged user needs to drive the contention.  The blocked task sleeps
holding the i2c adapter bus lock, and 27 more piled up behind it.

Reproduced by building a kernel with the two orderings selectable at
runtime and a 2ms delay inside the window.  Switching only that knob, a
two-thread barriered reproducer loses the wakeup 200 times out of 200
before the fix and 0 out of 200 after it; without the delay it goes 20000
times through the wait path and loses none.

Fix it by setting the task state before dropping resource_lock, as
prepare_to_wait() does: the releasing side needs resource_lock to unlink
the resource, so it cannot reach the wakeup before the state is published.

Link: https://lore.kernel.org/20260821-b4-resource-muxed-lost-wakeup-v1-1-37eb6473a76c@gmail.com
Fixes: 8b6d043b7ee2 ("resource: shared I/O region support")
Signed-off-by: DAI RENJIE <drj19981414013@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-5
Cc: Mark Brown <broonie@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 5f8fc8ed8f24c..59ccd9c358ba9 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1241,8 +1241,8 @@ static int __request_region_locked(struct resource *res, struct resource *parent
 		}
 		if (conflict->flags & flags & IORESOURCE_MUXED) {
 			add_wait_queue(&muxed_resource_wait, &wait);
-			write_unlock(&resource_lock);
 			set_current_state(TASK_UNINTERRUPTIBLE);
+			write_unlock(&resource_lock);
 			schedule();
 			remove_wait_queue(&muxed_resource_wait, &wait);
 			write_lock(&resource_lock);
-- 
2.53.0



