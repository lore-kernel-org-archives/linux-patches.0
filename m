Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017469;
	b=5GluP+AjkRHL0AT4/EIHoOSbEclmHR9AAsLi/hlfrLAW5MuG4twgzq+T7BqJ9DS4gyzm
	 ksv1fBnAAgij2J5m27nQHZyPODDcIaH/dlhWOIJlARA6Oo/BguGibP4KgQxFV3ng35bAm
	 1lhJ9gG6tC8JWvbHXQPprZly/jrX2FAlb450TvqQ8eIiE7rDpsXuA4x0moG1l1idNKsCJ
	 87aSNYuMbJbdvvLFEWy4SZLV0xOyanZu2JIKu3kXJtkE3KrfVlJ9up3scWBIKXm4MUI5n
	 6cvx1iwPFH+j3F5wwA9//BKmasu4f1DOsw7vp9oRJVhPxVNIM0tjtJWqc8J0nEdsWHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8IpVul37O60DklVDG07hYu+ZDpR0maIV9QXxlpP7kCQ=;
	b=UJ4ygKCGX0oEgfHM518iYY6fot+JcXaJTWb0Tso6TWEXMnDCxJbGwLyQ4ykZJTTOZyeU
	 S2F7FArNWyxZ/dp5VqL+LX5jOPYetymR9p1BjDijd7KckJSQhB27CYzs0tNGdLACxFCw9
	 HCrYW9pl53X2byBrLG9hFWsyqaOCZ3NlwQOghXKUze++H7MQufH9L3MkRaYNVlNJ3sDb6
	 w+ucW9o/z8R4wxDi2yW42wmiWxX8HqdmUuCwq4SfA19k2XXUjOtu6sIU0PKwdHYv16QKL
	 X/d5Hi7lFvCQ6ngv+T8vekOnWi63vPqCeiZfzFu+6HVIamWnr2q/CtPqeFXclsGfTsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hIf7z0Pk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0543F606A31C;
	Wed, 18 Nov 2026 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hIf7z0Pk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564871F000C6;
	Wed, 18 Nov 2026 15:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017468;
	bh=8IpVul37O60DklVDG07hYu+ZDpR0maIV9QXxlpP7kCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hIf7z0PkKLo879pMH6xHhGQ2zfsf6vGBQbeHUQYmpUcvjiv/ibO5ro9LPLjkJlgZK
	 50fYGFsZaXP8RiMscRJmMEK790UBr7uxkzqB+lELrt40cHB5eROiscoxUC6V6jlGrB
	 bGHOw0lUBMjR9YenJ0GEJt73PrdiZFdvRV0DH+4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0895/2651] tools/nolibc: fix readdir_r() with 64-bit directory offsets
Date: Wed, 18 Nov 2026 15:35:35 +0100
Message-ID: <20261118150320.084479203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 00c81514ad49110574e4b9bdbc448551004161f2 ]

readdir_r() stores the result of _sys_lseek() in an int. Directory
offsets are opaque cookies which can use all 64 bits: ext4, for
instance, gives 64-bit processes 63-bit hashes, and
0x7fffffffffffffff as the offset after the last entry. Truncated to an
int, such an offset is negative about half the time, and readdir_r()
takes it for an error.

Since commit 4ada5679f18d ("tools/nolibc/dirent: avoid errno in
readdir_r"), readdir_r() fails at the first entry whose offset has
bit 31 set, which on ext4 is usually one of the first few, and returns
the truncated offset as the error number. Before that, only -1 counted
as an error, which the last entry always hits: readdir_r() then
returned errno, usually 0, without filling in the entry, so the caller
got the previous entry a second time and never saw the last one.

32-bit processes get 31-bit hashes from ext4 and are not affected.

Keep the offset in an off_t.

Fixes: 665fa8dea90d ("tools/nolibc: add support for directory access")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260925211600.119116-2-danishkhateeb03@gmail.com
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/dirent.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/include/nolibc/dirent.h b/tools/include/nolibc/dirent.h
index 4e02ef25e72d8..f6dbe3a66e902 100644
--- a/tools/include/nolibc/dirent.h
+++ b/tools/include/nolibc/dirent.h
@@ -67,6 +67,7 @@ int readdir_r(DIR *dirp, struct dirent *entry, struct dirent **result)
 	struct linux_dirent64 *ldir = (void *)buf;
 	intptr_t i = (intptr_t)dirp;
 	int fd, ret;
+	off_t off;
 
 	if (i >= 0)
 		return EBADF;
@@ -86,9 +87,9 @@ int readdir_r(DIR *dirp, struct dirent *entry, struct dirent **result)
 	 * readdir() can only return one entry at a time.
 	 * Make sure the non-returned ones are not skipped.
 	 */
-	ret = _sys_lseek(fd, ldir->d_off, SEEK_SET);
-	if (ret < 0)
-		return -ret;
+	off = _sys_lseek(fd, ldir->d_off, SEEK_SET);
+	if (off < 0)
+		return -off;
 
 	entry->d_ino = ldir->d_ino;
 	/* the destination should always be big enough */
-- 
2.53.0



