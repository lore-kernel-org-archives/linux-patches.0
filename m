Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042930;
	b=UYJ4GYac2+nuBOJQs55l0zvQiu7rsfSUht0uki9b5CYrFenI92Agq+JymCLB2ZNbJ3nC
	 Brpn53jEZOKHwAlweuaI2ICBuo71D8PSVtuMRbG1S89bq0v5R+d+nVWQGLIsXpjnYce3f
	 ASCVpmp9EZHnwAQXwSteMyBVhKeq92DSkn7LC6eXaBqV/WIrQAbrBE4y0OKCvyi0IePp7
	 Ahx5jKv15fjhZDzvdVbx6IOzSkPW2EAFzEhzPZY64BXwKHD+IpbAEsq+kPYXJ96KOe2pJ
	 wouv4RKGmvlBneTkJ/8vonKFS1lIEWsEJXeOf/LXW+8mBt05t9MEMCq59rqc36ivW4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZE3ZurdM9rt3V44nt7KPedDR5n9ocNnfvYp2hV3VpR0=;
	b=pyoWoeaAZx+XCT4H1QWZFDns82yfPSP5XQM3ayXxkXVff2qm4NBBi77XrnOvGeYVhcq2
	 lLiHD9qUGCo+lCXh5IT4qMK0MyVnnkmGOQvOYKVlneBROv2nmYullpqILMTJ1VvEBQqop
	 pG9pcyyEDSCQzbnYwQV0Q4NRzcwo8RcoEMXjDquFpiFuclK9SiTn1iyesJCAcuAF+agAJ
	 Dz345YRGUeYDy4LFKh0VM3maoJlK3RJsspwIUPv/G0bcw3/Vhk92pfWBy8gRGgDJhypzA
	 /Sty6aQEeMfLlAGRK99OtYru9SNOpMYT4MlbRfgh2FdU9Yn0XXlFUul8ZJyAGiLGcNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttUWXCPm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B949606A325;
	Wed, 18 Nov 2026 23:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ttUWXCPm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4A41F000C4;
	Wed, 18 Nov 2026 23:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042930;
	bh=ZE3ZurdM9rt3V44nt7KPedDR5n9ocNnfvYp2hV3VpR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ttUWXCPmsGIJyaU2hQ1+gQ4f/KmY+xKeGyxQ4d0/esMk29921DzjaBlqqk+Yh2Hce
	 Dzx3oYMf7gGGmM5E6YU+MZaj+qrTIVk+c9igtSTG8nKtF61neWJM9h1SEcQlkBEnei
	 5K61XOAlO0ik0B+Y7FK2PfZPF3FKW5fF377Avvns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0031/2857] fat: reject name longer than NAME_MAX in msdos_format_name()
Date: Wed, 18 Nov 2026 15:17:45 +0100
Message-ID: <20261118150202.467445492@linuxfoundation.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 9d7ed813ee5ff0d469bd99630828ed6fdef4e8da ]

msdos_format_name() performs no upper-bound check on the input name length.
It silently truncates an arbitrarily long name into the 8.3 form (11 bytes)
and returns success. The subsequent fat_scan() then matches only against
these 11 truncated bytes, so it returns an inode as long as any entry with
the same 8.3 name exists on disk.

For example, passing a 300-byte name of all 'A's returns 0 with res set to
"AAAAAAAA" (8 'A's + 3 padding spaces), reporting success for a name far
longer than NAME_MAX.

As a result, when a user calls open() on a path component longer than
NAME_MAX (255) bytes, the VFS only enforces PATH_MAX, not the length of an
individual component. The dentry keeps the original long name but gets an
inode attached and becomes positive. Later in vfs_open() -> fsnotify_open()
-> fanotify_info_copy_name() triggers WARN_ON_ONCE(), and the event is
reported to userspace with an empty name.

vfat is not affected, as create goes through xlate_to_uni() which refuses
names longer than FAT_LFN_LEN.

Fix this by checking 'len > NAME_MAX' at the entry of msdos_format_name(),
the single entry point for all msdos name handling, aligning with the
NAME_MAX check that xfs/9p/ceph/simple_lookup() perform at lookup.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Link: https://patch.msgid.link/20260629130943.3671939-1-wozizhi@huaweicloud.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/namei_msdos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index fba3a07d39478..ea6ff97d3aea6 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -29,6 +29,9 @@ static int msdos_format_name(const unsigned char *name, int len,
 	unsigned char c;
 	int space;
 
+	if (len > NAME_MAX)
+		return -ENAMETOOLONG;
+
 	if (name[0] == '.') {	/* dotfile because . and .. already done */
 		if (opts->dotsOK) {
 			/* Get rid of dot - test for it elsewhere */
-- 
2.53.0



