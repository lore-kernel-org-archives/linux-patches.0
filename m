Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618919;
	b=KbkyrXKrsxSDxot4m/24jyST+p1mtT1NBmkP+RiDuBZM2Z9tk1tZwxhvDEZKW3KOLFT8
	 6vbOl0izEVpJsMU8bkoW5CH4NIHP0ntyJBD1UhsO0pAwfuuxwut9lh3zxHs3WzXy0m/5q
	 7dG2tSh+AysvMZewWqmshKLPGXUq89zxpJKaMPcwp1o4DbWI+3EhHd4GymcS4JqPcHq8l
	 FNo1QEQtBORt+6GAx6GFTr0qorZ3GaBzTzUqv+ken1jgA/Ze+W0+en9qX7rnUpW2lypao
	 aF7vwK0tMixisSAQVr8tN9W1Ex9SRweh+iXejmeNe67RvSHI0CG71sruwpLr226rbGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pW/glrBP0aqTXm8O+JtTTsN8lJy9NW5TH3rnMYY2JnA=;
	b=47HW0S7wtwvIEqtA4seIC6VyUglIHSxRAZM5Z/LSDYU02uK8fVF8HnXttHFBRJp6Y95n
	 EbOUmGZahexIeyov4/2L3HREskAyF1t2698PmSkp4uQwYM4fvV+hGTdJti5g3QTlxW839
	 O98YVUPF2umrom83f+vNofvrJ1ok2JwMQng2B7xZ6JI0PfzWl9xhCUjvbaEw8evwJ9FJA
	 0dSzTKIcYJeJ8hXaYaMF+S3XoRUvwt5Z/EDweIZ1IRvlvYJnQJEK66Ez+X0NzocUDsaKr
	 kmG8LyUtbPdNC+LxlHZU6EbDRmr0NXySIEgnrUQTzzk+m9yL9y1av9fcE0HQ2U1qH+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hi0rxhxr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7F6606A31E;
	Wed, 25 Nov 2026 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hi0rxhxr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAEC1F000C0;
	Wed, 25 Nov 2026 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618919;
	bh=pW/glrBP0aqTXm8O+JtTTsN8lJy9NW5TH3rnMYY2JnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hi0rxhxr1LtMhbAHmzMoqLgMU0vzEK0qBCjdb7A7x4FESv58AkYMas+7sKdzSaeoJ
	 3zZbaITUJS/m9jHMRRNltnVjCb3SBMP1Ns3Yt+JUUSiZItEj8axnX1h42Z1uHP9Q18
	 XpwzQfbyia7Lpfue7GyntLQQmLC2yHFCdQi2f/ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0430/1005] NFS: Fix inverted cross-directory rename check
Date: Wed, 25 Nov 2026 15:29:28 +0100
Message-ID: <20261125143831.825987290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit b9d518902ff1969f93d2b4787951d98e50ab0181 ]

nfs_rename_is_unsafe_cross_dir() returns false for cross-directory
renames, causing nfs_rename() to skip nfs_sync_inode() even when
filehandles may expire on rename. Same-directory renames may instead
trigger unnecessary synchronization.

Current condition directly contradicts the function name/comments.

Return false for same-directory renames so cross-directory renames
reach the existing filehandle-volatility check. Keep the conservative
fallback unchanged..

Fixes: dcd21b609d4ab ("NFS: Avoid flushing data while holding directory locks in nfs_rename()")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 71a342e9589f2..2bf5fa015b851 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2735,7 +2735,7 @@ static bool nfs_rename_is_unsafe_cross_dir(struct dentry *old_dentry,
 {
 	struct nfs_server *server = NFS_SB(old_dentry->d_sb);
 
-	if (old_dentry->d_parent != new_dentry->d_parent)
+	if (old_dentry->d_parent == new_dentry->d_parent)
 		return false;
 	if (server->fh_expire_type & NFS_FH_RENAME_UNSAFE)
 		return !(server->fh_expire_type & NFS_FH_NOEXPIRE_WITH_OPEN);
-- 
2.53.0



