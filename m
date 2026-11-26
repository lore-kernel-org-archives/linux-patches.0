Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705824;
	b=VLCICgBOKTL52SX5xKA550BhZpYfnuciC1xtj6Evnkrs1gdcxrtwJLeQfmX8tCVxUL8K
	 +Wn6RCYpSMAwqbCeznnY75itJ3TXeJVTXbdAZXpeBSExInj0UMRd4y7HeKeVrbmqDCa4F
	 P3TPe2olffDPT4T3pR6g4z63RgQ/5uADoIQBIvhg0DNR2SS5/slO101tNfkbHfBNQet9i
	 Gzbquv/FFxkD/o8HEQqZfJVJ6pYFYU2c1XAbz2XygcxjF2z6MrCjxw+komZdGPkT0/a51
	 vag1lRA3kIqplEKfMPD5LEb534r0K4VIGjoqDdr1+eShd06MSV5vfhyr6E136tnpZiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MF27jd7seLZCgf93bDYZXbUVLEr2yJgomb9OeN6znYo=;
	b=g+SnyFs/kvNrZgMSxTyuftF9FWFMiWm+TGd05/OEI9OdfLOxQDoSXuO02RVYE9wYBkCn
	 uCenFgzAZUxrYYvBJiT5ON7mQAl2h6I8xCPxaGu4eVxxxkNjjcNK8kPH5UHb9bZCJgTRD
	 fPq+TXqydSulsRnm7PauD8rjzFBqwVVDUTMuPnZizDuRTnQgSoiP8lqxghp/G/8we6CC7
	 tJrMqU63nwIVG06WvF0DHSKFrocLHv4O6cDFcJMnzs0bz+vplQFaTP3spXIpVSSnXTPBn
	 Id7Rx1nYUedMeIDUHT9bYQhnNIA4ri+d5IFjB5n4CoKsuqDXyCWpUHbt1t2ybL+kYuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEnnf3gM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80011606A32A;
	Thu, 26 Nov 2026 15:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEnnf3gM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B851F000CA;
	Thu, 26 Nov 2026 15:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705823;
	bh=MF27jd7seLZCgf93bDYZXbUVLEr2yJgomb9OeN6znYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEnnf3gMldIImYB/t0WHHuIM1CZde1SqWMJpf/A+V1ok1uJn26WPiEPKQtqnW4vIe
	 oLoikYCMGp5RbKTMShHKpBfrUgzwFtmJpASWdQttb5VIUH91pofzQth4ovruVljTWz
	 MRGACaub0mTh60uoSPfUzaC0ffAuxN+vJpeCu0UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Rapoport <rppt@linux.ibm.com>,
	Yongqiang Liu <liuyongqiang13@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 314/319] ARM: 9359/1: flush: check if the folio is reserved for no-mapping addresses
Date: Thu, 26 Nov 2026 15:41:22 +0100
Message-ID: <20261126144013.848172936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Liu <liuyongqiang13@huawei.com>

commit 0c66c6f4e21cb22220cbd8821c5c73fc157d20dc upstream.

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
[ Roman: folio_test_reserved() replaced by PageReserved() because
commit 8b5989f33337 ("arm: implement the new page table range API") and
folio infrastructure are not backported to this branch. ]
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/flush.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -280,6 +280,9 @@ void __sync_icache_dcache(pte_t pteval)
 		return;
 
 	page = pfn_to_page(pfn);
+	if (PageReserved(page))
+		return;
+
 	if (cache_is_vipt_aliasing())
 		mapping = page_mapping_file(page);
 	else


