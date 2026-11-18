Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043953;
	b=hFCOp/LnvGyGWdmXSekGAH1dHGgt3sud7GaF3gQFktkm9cTBFAqU+P+d1a4J0kjpHMRQ
	 48B21vLzsob2fGd68/YNdZ/VMlkeURmF3TnDiLk/1wXxTJOmOplSgwTO69X/FcMtDqBGS
	 jECeyYS6sLl5x5gwB+q7hPmAFpFYyTNKTxw3KE1ZQn2JZz+xyp+D1DuseRZ80KIjrYAOK
	 Vwc7nkUuQVkzDcIrKCQaee3Yeaiga8zizBlz4BnYsFDUX+2jURWyT28NWl+dYQ1N1eXh3
	 uFXsMv8KJc8Qjh2KugXZ/mAA6SJjhS1KaGdiaeUS88qeceScKCtw4RafdYXTHajL0MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ydn5iVREjgyIabhmhMFXHLoraMNM0QyQ/iwGzZUdYVs=;
	b=NABDCBz3FTPtgM9fYKr0Zm49rm/0TuGizyBF68yp72AeOQTNsovOhNfpCMDi8h+ZcLth
	 aSrMKlBjLpGEuhcQygRIcx0pY5t1TWTpjR+pfthJx1P/J0I2Mxk3xVfiMTP8H5cKvuieD
	 Zkmull0eDobWeZE/CDhsvHsrekk8pjFuYD9rTutBQKUaf4bQA+aaxZGafjZ5vdJhBEs6R
	 C0nY0XSRcUcjIJvMgiJrDk1A8FL9/WDSObS/PSzP/F3zgPcCEvDXofRY4XDP4k8CJ11aV
	 FwXnG2ldHlN636kozW/xhGByiqmIDr2wfQ35K5DYGyWMmfRnHwOBg/S5HwPFFmAtErA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ohWKnrgv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5B0606A32F;
	Wed, 18 Nov 2026 23:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ohWKnrgv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACD81F000C4;
	Wed, 18 Nov 2026 23:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043952;
	bh=ydn5iVREjgyIabhmhMFXHLoraMNM0QyQ/iwGzZUdYVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohWKnrgvBK+GV984HgVJAPt/GrP7HitzHD7I/Y9pz0iKPgdlYYnVogBiGOqeYEAI+
	 fxFHzcpr/HdJnbb7+n4Ks/MJnYVW6FVJCKUB1N7VHGgheou7F8MEGobcKBof0tDGxJ
	 KAaeJvQd7wYiERuOOWZnaTpp9QKIdOIoeNP/aK7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanishka De Silva <kpskanna1915@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0393/2857] ublk: clear VM_MAYWRITE on read-only ublk char device mmap
Date: Wed, 18 Nov 2026 15:23:47 +0100
Message-ID: <20261118150215.547438459@linuxfoundation.org>
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

From: Kanishka De Silva <kpskanna1915@gmail.com>

[ Upstream commit 6e2b571b0a54755b06e092501913e1dfefe75d6c ]

ublk_ch_mmap() rejects mmap requests with VM_WRITE set, but never
clears VM_MAYWRITE on the resulting read-only mapping. This allows
a userspace daemon to mmap the per-queue command buffer PROT_READ,
then upgrade it to PROT_WRITE via mprotect(), since VM_MAYWRITE was
never cleared.

The command buffer holds struct ublksrv_io_desc entries that are
kernel-written ABI; a writable mapping lets an unprivileged daemon
process corrupt fields such as addr, op_flags, nr_sectors, and
start_sector.

Same bug class as the drm/panthor and drm/vc4 VM_MAYWRITE fixes, and
the 2026-08-13 ptp/vmclock fix (a5edadbae57e).

Verified via mprotect() PoC: before the fix, a PROT_READ mapping can
be upgraded to PROT_READ|PROT_WRITE and a write into the command
buffer corrupts io_desc fields (confirmed under KASAN). After the
fix, mprotect() returns -EACCES.

Fixes: 3fee8d7599e1 ("ublk_drv: add io_uring based userspace block driver")
Cc: stable@vger.kernel.org
Signed-off-by: Kanishka De Silva <kpskanna1915@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20260830070133.559-1-kpskanna1915@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: replaced vm_flags_clear(vma, VM_MAYWRITE) with direct vma->vm_flags &= ~VM_MAYWRITE since the vm_flags_clear() helper does not exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 538827b68d881..97afb83e973d6 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -980,6 +980,12 @@ static int ublk_ch_mmap(struct file *filp, struct vm_area_struct *vma)
 	if (vma->vm_flags & VM_WRITE)
 		return -EPERM;
 
+	/*
+	 * The per-queue command buffer is kernel-written ABI; prevent
+	 * the daemon from upgrading to writable via mprotect().
+	 */
+	vma->vm_flags &= ~VM_MAYWRITE;
+
 	end = UBLKSRV_CMD_BUF_OFFSET + ub->dev_info.nr_hw_queues * max_sz;
 	if (phys_off < UBLKSRV_CMD_BUF_OFFSET || phys_off >= end)
 		return -EINVAL;
-- 
2.53.0



