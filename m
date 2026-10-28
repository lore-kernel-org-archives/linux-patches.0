Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213694;
	b=d0ixZhm3PBCOlp/wHm3DtmNzITS43ylBhbIWJ78WdOHRuUN4xHm2JnbXTgGPT7d/DwGo
	 EswwQMv9bPEcyHTynBzGboRU8fHjAuNSpI2XAKA2GG85k6R1wfjO7sxOqVufgpZ4lDo6c
	 IxvRt+dG3WFDya9/MZtEGgRhEr9fOxDpPv4ijykRDmUdZDgqWMxsX2foxZ60TFYTXL9kl
	 saeqSyfoTW2Y7r3Q+3RJ3W4kuc57Hr9vu7NoYTB0wqTLR9OPxKfE2M947muv6mq1PsG8o
	 G4ufMj21InfKjauxN4t62p7QPDPN4MBkGtjIQxcbNI142DB1Rncf4b+Uuyzq9PmmAGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eL5obuI8WSwCGy2SZvpBHMK+CYe0aYu1tlyzOkyOn14=;
	b=Aw06UYNtp3XKptvoedYcNNEB3l6dBee6aUbNKl0Of82dS9umdeMKmBFkFGmcmZEITtrl
	 2zOlGL+7rz4vKzcIarpwgPf9AFw0cTzeV3+acCBojl7Exhcsb8DQMVoRTQDjq7Jgnsi9e
	 ajGF7mnJXBK76fAnwW61YihvvkWib04yEg9CiCzVOOjP56GeD4N5Hg9OgpGfBTTQ1SupW
	 NbIoz2Qq12x1Eini/Ew1hHX9S5iI100woOB44IXkGtLRkIzF20iDao0SRgR0ZN+tcdzy3
	 AYL4amNUTg1g1BsFhvDikJC7MIBic4mscO8iXNKKAl44BbstpYIyQtx9z1IsoffKmLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mAWCj5t9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D127E606A31F;
	Wed, 28 Oct 2026 18:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mAWCj5t9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17BF1F01825;
	Wed, 28 Oct 2026 18:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213693;
	bh=eL5obuI8WSwCGy2SZvpBHMK+CYe0aYu1tlyzOkyOn14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mAWCj5t9fLR3GsYZOjd1XZxo1Bui/vBYpUKn7oQBdRRIbtzDplVacAiey+QzSV8/c
	 NLuiJx1HwghyAACp1rVky52KyhBmvWecGpqF+PrctKq8D9gzk4VPnP6Z+ddlCn/+Yo
	 B701u+apJVEgpGrRQpdV94cySYmvaJ7xgcYtsnCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Rapoport <rppt@linux.ibm.com>,
	Yongqiang Liu <liuyongqiang13@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0596/1887] ARM: 9359/1: flush: check if the folio is reserved for no-mapping addresses
Date: Wed, 28 Oct 2026 17:44:52 +0100
Message-ID: <20261028170512.979747687@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Liu <liuyongqiang13@huawei.com>

[ Upstream commit 0c66c6f4e21cb22220cbd8821c5c73fc157d20dc ]

Since commit a4d5613c4dc6 ("arm: extend pfn_valid to take into account
freed memory map alignment") changes the semantics of pfn_valid() to check
presence of the memory map for a PFN. A valid page for an address which
is reserved but not mapped by the kernel[1], the system crashed during
some uio test with the following memory layout:

 node   0: [mem 0x00000000c0a00000-0x00000000cc8fffff]
 node   0: [mem 0x00000000d0000000-0x00000000da1fffff]
 the uio layout is：0xc0900000, 0x100000

the crash backtrace like:

  Unable to handle kernel paging request at virtual address bff00000
  [...]
  CPU: 1 PID: 465 Comm: startapp.bin Tainted: G           O      5.10.0 #1
  Hardware name: Generic DT based system
  PC is at b15_flush_kern_dcache_area+0x24/0x3c
  LR is at __sync_icache_dcache+0x6c/0x98
  [...]
   (b15_flush_kern_dcache_area) from (__sync_icache_dcache+0x6c/0x98)
   (__sync_icache_dcache) from (set_pte_at+0x28/0x54)
   (set_pte_at) from (remap_pfn_range+0x1a0/0x274)
   (remap_pfn_range) from (uio_mmap+0x184/0x1b8 [uio])
   (uio_mmap [uio]) from (__mmap_region+0x264/0x5f4)
   (__mmap_region) from (__do_mmap_mm+0x3ec/0x440)
   (__do_mmap_mm) from (do_mmap+0x50/0x58)
   (do_mmap) from (vm_mmap_pgoff+0xfc/0x188)
   (vm_mmap_pgoff) from (ksys_mmap_pgoff+0xac/0xc4)
   (ksys_mmap_pgoff) from (ret_fast_syscall+0x0/0x5c)
  Code: e0801001 e2423001 e1c00003 f57ff04f (ee070f3e)
  ---[ end trace 09cf0734c3805d52 ]---
  Kernel panic - not syncing: Fatal exception

So check if PG_reserved was set to solve this issue.

[1]: https://lore.kernel.org/lkml/Zbtdue57RO0QScJM@linux.ibm.com/

Fixes: a4d5613c4dc6 ("arm: extend pfn_valid to take into account freed memory map alignment")
Suggested-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/flush.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 7ff9feea13a6a..b19ecc307ad46 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -280,6 +280,8 @@ void __sync_icache_dcache(pte_t pteval)
 		return;
 
 	page = pfn_to_page(pfn);
+	if (PageReserved(page))
+		return;
 	if (cache_is_vipt_aliasing())
 		mapping = page_mapping_file(page);
 	else
-- 
2.53.0



