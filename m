Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043330;
	b=283e4JN9EfeA09564dwZdnN+88uJWHgQUNo+r5LLb0ZGeNtAh6aGBTPpWOS5Nk8AC3vY
	 5hbjOlgfxeiCoNoBSgYLyO/d6yucq4cqAsCie9mRvEumHpElBxNawovKbnO/Nai3s9AIS
	 LoEO6Anj6jYJExtWb72BQf7A8nzj9gAvWXGfVM0VkDeDq7KCNsp7ULoLXipAd4Obl2qtD
	 eeYyE5NHcxeKN22/0TBiPJ6xXfgzUOK335cPMCMkuo4NjpzZXh5nhERrxBPr1cM+H2lsA
	 e8I6qO9ksIVHOB9TIXpAofiVvFVRnJk+/ayXyqKEymOdGEua6MF4j5DrK363NPyUyPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TwmJUY9paNm2Jc7n9Pl1Zg0LWblI4mXRpjwW2cMonhQ=;
	b=FInJlrcnc9ixy3h07YaDhkjmp8blPEYNa7DHBgOcwkRm7dH6rVLyeojtAFIXr6+uoLC4
	 7US70Y8cDoi2FYYJ6Ay61edjSX3J7aV9oeZFmzjbk2jGQXPaCh5TaF1cLdOMG8NtQmvwL
	 cjGsegwVykOfNEU2izZw3a6r+Ywuw/D566eaaswFSZTznbtd7CF6hJXlSpCUQYN6lMdlP
	 lyAgyQe7QsulYM5VjkL6eOgNwgajN3CEzlAW0CgHXxF7Mtazz+UdXkBA9zisrKC6cbN5b
	 Fv8Rh4L5uyHRweMzR89j5EWZSb5WYSL3pUP/HbBVHr1qz5SvyqIqC7w+HMba55a9qow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mnHK3CvX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD83606A32A;
	Wed, 18 Nov 2026 23:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mnHK3CvX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BB81F000C4;
	Wed, 18 Nov 2026 23:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043330;
	bh=TwmJUY9paNm2Jc7n9Pl1Zg0LWblI4mXRpjwW2cMonhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnHK3CvXkCALqvKt1EnoY8T2OBZAuSyntCHdaFzNElk7egoGHmhUmoqFzz2oXbziq
	 BafWN87AjgHmLDdDc4UoPZtFZZ94zYapyeLR63YN7DGq46bN6tx/kgK5s9DYM1/FoE
	 0Qjnv0r7Nw9SPuXgoR6EDC9HIjiL3SPIPT6mEQDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=EC=9D=B4=EC=83=81=ED=98=B8?= <kudo3228@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0172/2857] romfs: detect hard link cycles
Date: Wed, 18 Nov 2026 15:20:06 +0100
Message-ID: <20261118150207.546813374@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: 이상호 <kudo3228@gmail.com>

[ Upstream commit d30b5a954e0a4dcc16bba9c310c13709a6169a52 ]

romfs_iget() follows on-disk hard link entries until it reaches a non-hard
link inode:

	pos = be32_to_cpu(ri.spec) & ROMFH_MASK;

The target position is image-controlled, and the loop does not detect
cycles. A crafted romfs image can make the root inode a hard link. The hard
link can point back to itself and leave mount(2) spinning in the kernel.

Reject excessive hard link indirection with -ELOOP. Normal romfs images do
not need long hard link chains. This bounds corrupted-image traversal.
Propagate romfs_iget() errors from lookup because hard link traversal can
now fail with -ELOOP.

Signed-off-by: 이상호 <kudo3228@gmail.com>
Link: https://patch.msgid.link/20260701220729.822112-1-kudo3228@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/romfs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index 3bc993634321a..29fce318cdabb 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -250,6 +250,8 @@ static struct dentry *romfs_lookup(struct inode *dir, struct dentry *dentry,
 			if ((be32_to_cpu(ri.next) & ROMFH_TYPE) == ROMFH_HRD)
 				offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
 			inode = romfs_iget(dir->i_sb, offset);
+			if (IS_ERR(inode))
+				return ERR_CAST(inode);
 			break;
 		}
 
@@ -272,6 +274,8 @@ static const struct inode_operations romfs_dir_inode_operations = {
 	.lookup		= romfs_lookup,
 };
 
+#define ROMFS_MAX_HARDLINK_DEPTH 64
+
 /*
  * get a romfs inode based on its position in the image (which doubles as the
  * inode number)
@@ -283,6 +287,7 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 	struct inode *i;
 	unsigned long nlen;
 	unsigned nextfh;
+	unsigned int depth = 0;
 	int ret;
 	umode_t mode;
 
@@ -299,6 +304,9 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 		if ((nextfh & ROMFH_TYPE) != ROMFH_HRD)
 			break;
 
+		if (++depth > ROMFS_MAX_HARDLINK_DEPTH)
+			return ERR_PTR(-ELOOP);
+
 		pos = be32_to_cpu(ri.spec) & ROMFH_MASK;
 	}
 
-- 
2.53.0



