Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE3837269A
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 14:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776694231; cv=none; b=XoHNeq/ik+X7untkCXZP8GP7tke6x4baHAgPVpocWPIs+fpZ546khNpvg3FNB+bbATbz4NihYylLKlb47ukNzNBqNfNlL9dPven5/K2FBRRi9LvmrlBcGCuN68PM+bGe/90sJfj0rG8KorrJUZ+JDKJcImJS7Ct5n52qkSUDr4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776694231; c=relaxed/simple;
	bh=An/GgEMwmpzOX3/9Jxg7hce25ihyD8UutVaIHjkkgwc=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=icIRY4r9X/M1AgH1uMkjyxMLhiwWrbR3G/jlCSyP5VwNSjj1Rvv43rNbKJAncuu2C7/wGnp34BEst0/ov78up6x776r4tcbs6EDaDbkYbYpck3nfVmHEBDXxmUuUyc7JQnHl+2ymtBZy3mEo3ayOYqGzcxKvRoXT8sFw5/sfZaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=icBZdToN; arc=none smtp.client-ip=43.163.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="icBZdToN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1776694218; bh=u10R6mI2SU/IKUVDIJuemPsD9YiQMZEcpoI8vLbj0gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=icBZdToNugQLAZ3kCzB9wcE7UMfPCSoUGMIdkUQhqfrBL6hvaXhNrnfUlVA3Xvn3f
	 x8nzdtQ07CAlqB6seY5/Tbop9Q7FxfYkFkSSd5wo8+dK6Icz+Zxt2gYtpMbx+CHPIL
	 keJIRbHGZYh30nTzfmHPaKIWn9EzZfmMc0Bm/bn4=
Received: from lxu-ped-host.. ([111.198.231.89])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 28F85082; Mon, 20 Apr 2026 22:10:15 +0800
X-QQ-mid: xmsmtpt1776694215t37sgs1n8
Message-ID: <tencent_4B576466DB1372836C296F83B20445177505@qq.com>
X-QQ-XMAILINFO: M8Cd2byC8kc43sH8l1EM+1mM/tvr9lk83ddpyrYQ1bH2W0DkoK5DBTJYyr5Fd7
	 JHJ/c82Ny+P3kyeACVoRxUZwuANU8q+QaEUcvJslHr5YuW9G045InMzhq0K1zs2/D4a7bT0Ic7bb
	 zDWq2DSWvN+Ax32IC6sSyPjAEN3vLLHeXl3fl5cnsWhzgnmEf4uEvEIzkOFaiuyFpZjKylOJVpxD
	 89aloxRzxM5eW7sDwjb3xno67jmkiS0jOl5joprEe5d3s05j4VndxCzvtRuLlJWajdybOIkDbjo3
	 wYZcMh5a53dElPiNKnAuY9R4udlbsojRiEM7h7aCV69kWpWaK2oqgZag74A2rhsVH+m9G6f1MIOi
	 0CWjLAzqS/MzfgwMBkLFKEgAYXj05lKOkFvmB8+Iqq3ymXZUG5Q+DNRxrE4tWkQp8QiJOLbdRja/
	 OJ3BXlnL0Yvm5gJUGXf0poMWCXGtxoVU0x6rBhXYlSuPBIkQra+/aXUnP/iFS2IeHzgyyG63+fCU
	 QGXhwRaZO41R0eAT+qgNv6h26Z0VkUfmxkY/pAmLYYfM3QhpJtxxMM5Nj3yN6ALbut+iqmI2gebz
	 VRrS7X9TAqE4WlzUV7JmKeS/BnkvtTmNEw/Ptl3Dqi+89/wsXX90/rpMOZ//Bm/BmgPK3+2+lYwL
	 bAwyyGNepUjWqqdxyDSa/CjYhS0BFvIDAsJVJhPs/+X+sA66eM8a5cpyvzaTQ/PNtceiUE59O4iY
	 nSYclHdXZzetVp5qyekHBnFyIRITVrawVfyz5tEJYQf89Q5Ol0Tl6R56IXuFiRjcs54dTtupbBKJ
	 ws+lrtUEtQvbJGu6/0CGFUB9ca+FVV7x5agrp9Aeb5U1rLVP52+OpmVbnc8hfw2IASpDJIdMSxr8
	 xK1My2E6i150+8jLQk4IB0BgVfphqGpQh0SPvFLSUTZZJD+g6bLImWiJIG4heAmwA1zV+lUFdSGH
	 tpAodJOI7H8kYt+8dgsUdxpD0dHld555gejrN55eKBsWJ/DhnxLpEwfQAtv1HECxztrsPYhpCYPV
	 gPjkxOA0Ph3/XYids9SJDAmnsffiVEJXgSAo1J+mPqNIX2nEaZXcsAuDSUDTGWO2gh7a4e6E9aKK
	 uEepeQ
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Edward Adam Davis <eadavis@qq.com>
To: sashal@kernel.org
Cc: dave.kleikamp@oracle.com,
	eadavis@qq.com,
	jfs-discussion@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	shaggy@kernel.org,
	stable@vger.kernel.org,
	syzbot+1d38eedcb25a3b5686a7@syzkaller.appspotmail.com
Subject: Re: [PATCH AUTOSEL 7.0-5.10] jfs: Set the lbmDone flag at the end of lbmIODone
Date: Mon, 20 Apr 2026 22:10:15 +0800
X-OQ-MSGID: <20260420141014.543625-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260420131539.986432-26-sashal@kernel.org>
References: <20260420131539.986432-26-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 20 Apr 2026 09:08:12 -0400, Sasha Levin wrote:
> From: Edward Adam Davis <eadavis@qq.com>
> 
> [ Upstream commit b15e4310633f90072d66cc9b6692acbf6b4d7d00 ]
> 
> In lbmRead(), the I/O event waited for by wait_event() finishes before
> it goes to sleep, and the lbmIODone() prematurely sets the flag to
> lbmDONE, thus ending the wait. This causes wait_event() to return before
> lbmREAD is cleared (because lbmDONE was set first), the premature return
> of wait_event() leads to the release of lbuf before lbmIODone() returns,
> thus triggering the use-after-free vulnerability reported in [1].
> 
> Moving the operation of setting the lbmDONE flag to after clearing lbmREAD
> in lbmIODone() avoids the use-after-free vulnerability reported in [1].
> 
> [1]
> BUG: KASAN: slab-use-after-free in rt_spin_lock+0x88/0x3e0 kernel/locking/spinlock_rt.c:56
> Call Trace:
>  blk_update_request+0x57e/0xe60 block/blk-mq.c:1007
>  blk_mq_end_request+0x3e/0x70 block/blk-mq.c:1169
>  blk_complete_reqs block/blk-mq.c:1244 [inline]
>  blk_done_softirq+0x10a/0x160 block/blk-mq.c:1249
> 
> Allocated by task 6101:
>  lbmLogInit fs/jfs/jfs_logmgr.c:1821 [inline]
>  lmLogInit+0x3d0/0x19e0 fs/jfs/jfs_logmgr.c:1269
>  open_inline_log fs/jfs/jfs_logmgr.c:1175 [inline]
>  lmLogOpen+0x4e1/0xfa0 fs/jfs/jfs_logmgr.c:1069
>  jfs_mount_rw+0xe9/0x670 fs/jfs/jfs_mount.c:257
>  jfs_fill_super+0x754/0xd80 fs/jfs/super.c:532
> 
> Freed by task 6101:
>  kfree+0x1bd/0x900 mm/slub.c:6876
>  lbmLogShutdown fs/jfs/jfs_logmgr.c:1864 [inline]
>  lmLogInit+0x1137/0x19e0 fs/jfs/jfs_logmgr.c:1415
>  open_inline_log fs/jfs/jfs_logmgr.c:1175 [inline]
>  lmLogOpen+0x4e1/0xfa0 fs/jfs/jfs_logmgr.c:1069
>  jfs_mount_rw+0xe9/0x670 fs/jfs/jfs_mount.c:257
>  jfs_fill_super+0x754/0xd80 fs/jfs/super.c:532
> 
> Reported-by: syzbot+1d38eedcb25a3b5686a7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1d38eedcb25a3b5686a7
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> Now I have all the information needed to complete the full analysis. Let
> me compile the results.
I fixed this issue a couple of days ago. Please see:
https://lore.kernel.org/all/tencent_3AEEC18CAA27D286CE92DAC674C9B02EEC06@qq.com

Edward
BR

