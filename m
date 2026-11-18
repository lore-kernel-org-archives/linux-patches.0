Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050912;
	b=HA5049v49tcJwPVl+B0LM3PgmPPksJUH7p25m1jmJt92ZeoegDI3yC8b9stMm1Je6gkw
	 xo7aW3fBpNFI4hbDONkGZzbPdTcUsBwDqWwwsGM9bc6426Lxk1y6O99mj2aOjDt2N5Pqc
	 qQ4hPR/TTh8Jt+YCMAIwk+QTy1Ow5+5bJ6yilIF/iBJAx+Bs8/m/h80U6rjvtulhKyyIZ
	 DjZsjD6DMaV8rjec63/fSWBbHnPs3nRKSjlnw70ap1J4n1MXVsE5H1+jEbUCGpC/CkhO1
	 WvBdMuwiXBAOyTzoxAUxmv8Z4VyqPPy37mcjE4LnNGmA8fy6KI0yenZsWR61enQjVlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=omDws6Jgur77TFUjb/Znd58nsqg53CZQXgVlXK+WxFM=;
	b=JeCsk2LoApdIeYTrtjGwGO43731OiXY7je5HoH9FN1ebq6hueWMDT5VXAFnqKt26x7xR
	 9hMMbj+tKBlgTh2L8PpRRamnjxNaTDvjQbzDIEBWvAp3DY8/CgKxbxFhn6fJvSXkWQnzW
	 dGHx/ql155a9XzO1WdV9JYtGY+H1RtizVKsUsEFrQHH2P690rLEr2lOT271ZgXTs/0I0R
	 Skh7+1CaTe9lGc5LqzjKHTkgyezZ7mqQ0U/9RAj1b+ZBQjtFzOgdFQgt0evPBx6WVoha4
	 DFeE2/PA4cyXJWeYuNq3AyM7q3p5wqHaBZlvC5w7CNgZwq8gsKHVlAEZq8Q3rpklp9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tex9KFkg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD156606A32C;
	Thu, 19 Nov 2026 01:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tex9KFkg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBF11F000C4;
	Thu, 19 Nov 2026 01:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050912;
	bh=omDws6Jgur77TFUjb/Znd58nsqg53CZQXgVlXK+WxFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tex9KFkgvYHhr9fFEOJu7OxAox/h7LLk+qWQLTkYZ60JBiXmeiEvtfS2lhmEAVfm6
	 tuKRdkNOxU/ESjkHsr3kdL7F5LD/j/AaqtRQg2IMKHHpFZuwVA1D/CPkbXbLikNW4+
	 WtupYl0Rr4mzSNQJglY56XEwl8FaFx9I6yUiGU18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shu Han <ebpqwerty472123@gmail.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	yao zhang1 <yao.zhang1@amlogic.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0005/2214] mm: call the security_mmap_file() LSM hook in remap_file_pages()
Date: Wed, 18 Nov 2026 15:28:01 +0100
Message-ID: <20261118150010.355834835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
(cherry picked from commit ea7e2d5e49c05e5db1922387b09ca74aa40f46e2)
Signed-off-by: yao zhang1 <yao.zhang1@amlogic.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 53fa4f5167dd0..4e3c2f796fdd1 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -3055,8 +3055,12 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
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
2.53.0



