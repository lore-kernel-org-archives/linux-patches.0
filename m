Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043344;
	b=JV/G2oMkNTg/+fDljb5frSSbf6fzCCwYJIKrbfF2E/PoJ1stZdjio+1D0hcZhGaJRJ8w
	 /PiXDaXqLOb0mnnJwLcp4Y7eE//HTN1K5rqlpek4U3PzNOqDjg8OzP1rvLOggcuA+zQZf
	 wGofS9AmRIHEzZZOW4drHrt1TmgC/aWU0WgIdHpW0mLUVaMtFcXg9bS2hcw957Ss5XGeE
	 yWHv6BA9a3yH38lqKELyhJUQzUlSmQGWsI0p8agAAeZ3lBnHFvUjfGTPmkGd2JvaZ/ABm
	 fnqp2+Fxgz9LdEDskcN2VIOOlX4+pymrg/2z3lYShxJsS3DhcqWiDFBT8OqNzAdFLNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NS4BOHwQ6wmVBYa921YGNQ1JDco89lyQUoC0qKEfmLI=;
	b=ictTWswqsyD2Y/ErkRmdQqvv+PBcUiq2f+QP5D+FNtjzi4oSRhViUW9WS0RLNQMXiX8g
	 sEBIyQbpX/aQQP0iwbQXDdFZaKKwxMLfVOKwKfyNzRgYd1KHlNqva0Y0GqJOPb4M5L9Vb
	 qEmhjig+5JZmmaF4htrVHhVO0xkGCF7EYGEEu3FJgaDIUm7I3xQGiMe6cvNOp38qV3c6i
	 2TP3Qs6FHb36bW/8aKVtJMJ4Ycbzhb2iC7IH7e2WwUk8k1P2jLw3hFhY5Jr5u5o53No5K
	 wk5hcs0VkhX22Ab5LeTK0zRXA6iHcYp5wj0AG7ZZdu7PcI9+aWF8uDPvFrPdgpxj9tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B5vgIX4Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D34606A32A;
	Wed, 18 Nov 2026 23:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B5vgIX4Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D079C1F000C4;
	Wed, 18 Nov 2026 23:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043344;
	bh=NS4BOHwQ6wmVBYa921YGNQ1JDco89lyQUoC0qKEfmLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5vgIX4Z7HLJwW+vKnKtcGOOKCqG4pKrcrHhBVRCnmlrOrh5Fjj24LexAYbsgQwvr
	 tSCZFTr1wXjqI5GgST5BUjAhVI6WivDHjdkroX+BKGAjDOUbCR0YfWNdcf9YyFDTEz
	 jOWEIHMVsfIm3pXKf8wVrfQjH5V0cCu2addev3BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+905d785c4923bea2c1db@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0150/2857] ntfs3: fix info-leak in ntfs_rename()
Date: Wed, 18 Nov 2026 15:19:44 +0100
Message-ID: <20261118150206.749299805@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 2fa56613b25d0c983ef3ff6d3e865d4254280abe ]

Hard to say about copy_to_user_iter(), but at least the first splat
looks correct. At the end of fill_name_de(), data layout is:

struct NTFS_DE *e = buf;
...

    |<- data_size + sizeof(struct NTFS_DE) ->|<- XXX ->|
buf |-----------------------------------------------------------
    |<- ALIGN(data_size, 8) + sizeof(struct NTFS_DE) ->|   ;; e->size

If 'buf' was allocated with kmalloc(), XXX remains uninitialized and
passed as such to memcpy() called from hdr_insert_de().

So using kzalloc() for all buffers passed to fill_name_de() looks
the simplest and most safe solution. OTOH if someone would have
said that an overhead of PAGE_SIZE'd memset() is too large, more
fine-granted solution is to memset() XXX only.

Reported-by: syzbot+905d785c4923bea2c1db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=905d785c4923bea2c1db
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/namei.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 1adbc4af6aba8..25c833ca7a6e0 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -20,7 +20,7 @@ int fill_name_de(struct ntfs_sb_info *sbi, void *buf, const struct qstr *name,
 {
 	int err;
 	struct NTFS_DE *e = buf;
-	u16 data_size;
+	u16 data_size, real_size, aligned_size;
 	struct ATTR_FILE_NAME *fname = (struct ATTR_FILE_NAME *)(e + 1);
 
 #ifndef CONFIG_NTFS3_64BIT_CLUSTER
@@ -51,7 +51,12 @@ int fill_name_de(struct ntfs_sb_info *sbi, void *buf, const struct qstr *name,
 	fname->type = FILE_NAME_POSIX;
 	data_size = fname_full_size(fname);
 
-	e->size = cpu_to_le16(ALIGN(data_size, 8) + sizeof(struct NTFS_DE));
+	real_size = data_size + sizeof(struct NTFS_DE);
+	aligned_size = ALIGN(data_size, 8) + sizeof(struct NTFS_DE);
+	if (aligned_size > real_size)
+		memset((char *)buf + real_size, 0, aligned_size - real_size);
+
+	e->size = cpu_to_le16(aligned_size);
 	e->key_size = cpu_to_le16(data_size);
 	e->flags = 0;
 	e->res = 0;
-- 
2.53.0



