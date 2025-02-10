Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2A01C07F6
	for <patches@lists.linux.dev>; Mon, 10 Feb 2025 19:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739214682; cv=none; b=kJouUENiqmFJ0qMdVhgloFqhL0wHf+DOh2M9L8L3FIgu6CQ+YG7RWDycQy0TU/7A9TARQ/l3QdBqRnI8xA7ceq7Kj+EJTzqh6m+ATA1lr8y1zQfylU1Vud8+ahgXPaFlLbGz1hP51NogOVdaHTUVv4SzbwYhgxDD00+poZFCTB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739214682; c=relaxed/simple;
	bh=VtPDo7IM1T02mCad0u7MsSJbtDJvlGO622e86WJ/UIY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GrjUwMKiEQatsFwF5YiWGcFAgH0LeBWGp/hcvmL6Gb7/NmF5tZVTgHpuIYS8sUTK1UhFPpyauIojbTGdPn9ZTaXUVL9zW1HseLl8QJ4BBrkONdDoVFJLgylFC7iNYyAE0R5/ChTubHLjUZLH42421PMU7HQNVbaoXFvmBypcIQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=j4PdrqpC; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="j4PdrqpC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1739214682; x=1770750682;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Jl475qfeV7Dgsnu0TGpEYP0VzEjAfVYauQNa5Bpd2dg=;
  b=j4PdrqpCNIYJB74BGKPFMbbcCwEK73NTSpRZWN32bFqx3+iPAf8JkZtF
   qbKteLmsZXLgfojff6CqZAAhjbTNuzc14CHE9N3Xp9MMcqizHr9zBAA/p
   aBLTtKp5yiteLw1uLxs+c5AYqwalp3O3SrwTehVIeAiV9Pmopo9iDDcab
   0=;
X-IronPort-AV: E=Sophos;i="6.13,275,1732579200"; 
   d="scan'208";a="376136794"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 19:11:17 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:16300]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.35.229:2525] with esmtp (Farcaster)
 id eebc1289-a144-4932-9511-459ce49bdd5f; Mon, 10 Feb 2025 19:11:15 +0000 (UTC)
X-Farcaster-Flow-ID: eebc1289-a144-4932-9511-459ce49bdd5f
Received: from EX19D028EUB002.ant.amazon.com (10.252.61.43) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Mon, 10 Feb 2025 19:11:14 +0000
Received: from EX19MTAUEA002.ant.amazon.com (10.252.134.9) by
 EX19D028EUB002.ant.amazon.com (10.252.61.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Mon, 10 Feb 2025 19:11:14 +0000
Received: from email-imr-corp-prod-pdx-all-2b-f5cd2367.us-west-2.amazon.com
 (10.43.8.2) by mail-relay.amazon.com (10.252.134.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Mon, 10 Feb 2025 19:11:14 +0000
Received: from dev-dsk-ptyadav-1c-43206220.eu-west-1.amazon.com (dev-dsk-ptyadav-1c-43206220.eu-west-1.amazon.com [172.19.91.144])
	by email-imr-corp-prod-pdx-all-2b-f5cd2367.us-west-2.amazon.com (Postfix) with ESMTP id 8DE08C11A2;
	Mon, 10 Feb 2025 19:11:13 +0000 (UTC)
Received: by dev-dsk-ptyadav-1c-43206220.eu-west-1.amazon.com (Postfix, from userid 23027615)
	id 20F246669; Mon, 10 Feb 2025 19:11:13 +0000 (UTC)
From: Pratyush Yadav <ptyadav@amazon.de>
To: <stable@vger.kernel.org>
CC: Shu Han <ebpqwerty472123@gmail.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <patches@lists.linux.dev>, Stephen Smalley
	<stephen.smalley.work@gmail.com>, Paul Moore <paul@paul-moore.com>, Bin Lan
	<bin.lan.cn@windriver.com>, Pratyush Yadav <ptyadav@amazon.de>
Subject: [PATCH 5.10] mm: call the security_mmap_file() LSM hook in remap_file_pages()
Date: Mon, 10 Feb 2025 19:10:54 +0000
Message-ID: <20250210191056.58787-1-ptyadav@amazon.de>
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
index 9f76625a1743..2c17eb840e44 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3078,8 +3078,12 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	}
 
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

