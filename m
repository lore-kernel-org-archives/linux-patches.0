Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065240;
	b=pFYCcrLWqjUucLPJGRMFcQmBibAstq83KgLoFQEm6+PpTEG+WSUwH4QP5/nmIWSx1g8F
	 F6CjBTNpTnoVSgyGY3kBiq77fFjovbW3QHlGX/AoiE3CWWkrNkt8Y3gk5q7c3js1OjMWg
	 Q9VB4o/ghweF+Hgtsyng4iyzUGWqciprfO7FsgmSxxKn5GuXWL/uYlr0ylhWTuzWUTEg9
	 uLCCjRXwubk+HhFHOQfBmJGbdvUMi4RlizB7ccOCgZJtqzeQE6qGZ9N/xf9rBTszgKtk6
	 D7WOELaZSN829nBOwebwIV7ZAF/ur1PVCCoZe8CWHg8gK4YNFyc+m7YVuPC0yuQYYrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cGlnTOEVd6wCMMxiQjhGGnmIba9BsS94CRMR9TwJ2sQ=;
	b=NBFrBnfKOLd20dqQLCizCnGMJFiW3RlDh9DPXr8rU0OUq+4khX+vc4i1rKq9h1l7PBtc
	 Pz7P0rhoZjgovJaqMl404GA5i5fpR6K8XZgaccpAImBlvdyjb0vo3j9EI7RD2CJCo6XCa
	 G2g3fK4GYMFi+XwGjwBpUYfe9x3TwubeksOAnzd6etXCgEKXutYLcEta1RsyEKXELDgSI
	 krjdBT0bMfWLYKuIF3q0YzKYCFxIn4tXE1znqIfveM16tdVPKrLZ13DhIzumMU0eVGAPs
	 FsfQ8tUfDiOZ8lbsjdVdNAYZMDi5JelJqvHyMQQgqyc2R8IjjykNi+k3UXS7U11LDqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=11EIc2Li;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD36606A32E;
	Sat,  7 Nov 2026 15:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=11EIc2Li
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0241F0089F;
	Sat,  7 Nov 2026 15:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065239;
	bh=cGlnTOEVd6wCMMxiQjhGGnmIba9BsS94CRMR9TwJ2sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11EIc2Liss58Lsr4LKLI29SfJeQNdE/SkOkN9uJRCN/l3lGnUdwi0UOLgNjc+5D1d
	 aqZSt7uYP6YcQ6dv1yvPAuP5NRc65o9/SXISMArm4B5WoxIaov3r+AhDaQkaKekLBq
	 fOhGksoysB5G4m+2NhotGhVDZIpiYQ8of0sKGyi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1020/1257] statmount: dont copy the reserved empty string past the buffer
Date: Sat,  7 Nov 2026 08:55:16 -0500
Message-ID: <20261107135007.504882168@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 11eef75006819f4e71d04ca2b9a1fb1580854a55 ]

statmount_string() reserves an empty string at the start of the seq
buffer before it calls the handler for the requested string. That's
what the offsets of unset strings point to since commit e52e97f09fb6
("statmount: let unset strings be empty").

If the handler emits nothing the early return from commit 75ead69a7173
("fs: don't let statmount return empty strings") skips the size check
against the caller's buffer. Back then an empty emission meant an empty
seq buffer and there was nothing to copy. Now the reserved NUL byte is
there and copy_statmount_to_user() copies it to buf + sizeof(struct
statmount) no matter how small bufsize is.

So request a string that may turn out empty with a buffer that's
smaller than struct statmount and the kernel writes one zero byte past
the caller's buffer and reports a size that's larger than the buffer.
STATMOUNT_MNT_UIDMAP or STATMOUNT_MNT_GIDMAP on a mount that isn't
idmapped will do, so will STATMOUNT_FS_SUBTYPE on anything but fuse or
STATMOUNT_OPT_ARRAY on a filesystem without ->show_options(). None of
this needs privileges. The byte only lands in the caller's own address
space but that's still not ok.

prepare_kstatmount() already refuses a buffer of exactly sizeof(struct
statmount) for string requests. A smaller buffer can't hold a string
either and it can't even hold the reserved empty string. So refuse any
buffer that isn't larger than the fixed part. That's also what the uapi
header says: string requests need space after the fixed part of the
structure.

Reproducer, unprivileged, on any mount that isn't idmapped:

    #define _GNU_SOURCE
    #include <errno.h>
    #include <fcntl.h>
    #include <stdint.h>
    #include <stdio.h>
    #include <string.h>
    #include <sys/mman.h>
    #include <sys/syscall.h>
    #include <unistd.h>
    #define STATMOUNT_FS_SUBTYPE	0x00000100U
    #define STATMOUNT_MNT_UIDMAP	0x00002000U
    #define STATX_MNT_ID_UNIQUE	0x00004000U
    #define SM_SIZE			512 /* sizeof(struct statmount) */
    struct mnt_id_req {
    	uint32_t size, mnt_ns_fd;
    	uint64_t mnt_id, param, mnt_ns_id;
    };
    static uint64_t root_mnt_id(void)
    {
    	unsigned char stx[256]; /* struct statx, stx_mnt_id at offset 144 */
    	uint64_t id;
    	if (syscall(__NR_statx, AT_FDCWD, "/", 0, STATX_MNT_ID_UNIQUE, stx))
    		_exit(1);
    	memcpy(&id, stx + 144, sizeof(id));
    	return id;
    }
    static void probe(uint64_t mnt_id, uint64_t mask, int guard)
    {
    	struct mnt_id_req req = {
    		.size = sizeof(req), .mnt_id = mnt_id, .param = mask,
    	};
    	long page = sysconf(_SC_PAGESIZE);
    	unsigned char *map, *buf;
    	uint32_t size;
    	long ret;
    	map = mmap(NULL, 2 * page, PROT_READ | PROT_WRITE,
    		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    	memset(map, 0xaa, 2 * page);
    	/* 100 byte buffer ending right at the page boundary */
    	buf = map + page - 100;
    	if (guard)
    		mprotect(map + page, page, PROT_NONE);
    	errno = 0;
    	ret = syscall(__NR_statmount, &req, buf, 100, 0);
    	printf("mask 0x%04llx%s: ret %ld errno %d", (unsigned long long)mask,
    	       guard ? " guard page" : "", ret, errno);
    	if (!guard) {
    		memcpy(&size, buf, sizeof(size));
    		printf(", size 0x%x, byte[%d] 0x%02x", size, SM_SIZE,
    		       buf[SM_SIZE]);
    	}
    	printf("\n");
    	munmap(map, 2 * page);
    }
    int main(void)
    {
    	uint64_t id = root_mnt_id();
    	probe(id, STATMOUNT_MNT_UIDMAP, 0);
    	probe(id, STATMOUNT_FS_SUBTYPE, 0);
    	probe(id, STATMOUNT_MNT_UIDMAP, 1);
    	return 0;
    }

Before, on 7.3.0-rc7-00252-g4e3259b08c54 (vfs.fixes) in a VM, the
same on a distro 7.1.13:

    mask 0x2000: ret 0 errno 0, size 0x65, byte[512] 0x00
    mask 0x0100: ret 0 errno 0, size 0x65, byte[512] 0x00
    mask 0x2000 guard page: ret -1 errno 14

After:

    mask 0x2000: ret -1 errno 75, size 0xaaaaaaaa, byte[512] 0xaa
    mask 0x0100: ret -1 errno 75, size 0xaaaaaaaa, byte[512] 0xaa
    mask 0x2000 guard page: ret -1 errno 75

Reported-by: shaos <shawnq1@163.com>
Link: https://lore.kernel.org/r/20261020110747.959829-1-shawnq1@163.com
Fixes: e52e97f09fb6 ("statmount: let unset strings be empty")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261021-work-mount-statmount_listns_fixes-v1-1-8917a4c1bd14@kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c30f063742f40..6c9c0cdbe890e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6058,7 +6058,8 @@ static int prepare_kstatmount(struct kstatmount *ks, struct mnt_id_req *kreq,
 	ks->bufsize = bufsize;
 
 	if (ks->mask & STATMOUNT_STRING_REQ) {
-		if (bufsize == sizeof(ks->sm))
+		/* Even the reserved empty string needs room past the fixed part. */
+		if (bufsize <= sizeof(ks->sm))
 			return -EOVERFLOW;
 
 		ks->seq.buf = kvmalloc(seq_size, GFP_KERNEL_ACCOUNT);
-- 
2.53.0



