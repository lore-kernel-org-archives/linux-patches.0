Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617697;
	b=cd8sUaQLTwRCNnU0ABpXVxhy1cErhD1Y2x8nl/lokyo4EL3bfbt7jKg39u/SGYVI3rgV
	 Eb/a2jXcFdwun9pyTa1zgs2X2OsKNQ9NUOBHtg1L86PT1814hZTvLeJdJXrbefgIM1c3M
	 ei22MKAPTVvJq9WQN23VoJwrpiT2e3ALa5JVd3JyIQ7hOvaiF5SrjS/p/ymlwsCISFdwu
	 d/uAXMGdMdxByG4nLMmexmu674CE8P0lpdDFy8yg6KsDWQky0C6INXfaJ/1W+fAnccpMM
	 PR/reLOklPiI3tT1aINoE3UKgIAAC+jvlraURBgG5Z7+XzaPRy1L/hnz2KsakPlaXGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jDWgCSPRrP1ayWOOmbFk+O0MF6pMYFpzN3cE9xa7m/s=;
	b=n9kfbIJozFEmh1cuW0lECZCzkD2ZTl16aOSHsNhqR4jDlpXbKocatTcSf7ACT8ejuKBo
	 NEdZq8+q1OvgI5MKu3XORZjLuuLcsCKrdW5ISZ2fstyo1j4kFV8zQRvrStLPHzjH3PN6m
	 QGHYRvrV9zjK3hpIg/83yKHJOKjxAnsS9QAq5t7BN2C61V1hNVdZyAZy6WjRJEJaNSCpV
	 II35X0uo0yJUEyDJZO8/aJjSW1wClamxVTjLnVWFogw1qj7I4qRlkmhnBrBsMHVvXOzbt
	 63mWKHSMwFCnxWO9YIptfjJAuRTckxkwL8LomlodxKJ72yAbmE0UUgWRRvb1GjfWMtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SC7HmTb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE08F606A327;
	Wed, 25 Nov 2026 14:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SC7HmTb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AB01F0156A;
	Wed, 25 Nov 2026 14:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617697;
	bh=jDWgCSPRrP1ayWOOmbFk+O0MF6pMYFpzN3cE9xa7m/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SC7HmTbJoslwu3mP1c5rSlHMqToybi54Kgt10IyJqUfak4/H3XiTygG+glnki6Mi
	 uIVhpJNETbfKR73lEJA4j1LH0I4QJxfwITFuFUd6tYSw+lWQsiGmh6c1FhV2hHrMaE
	 nBJj9MUN1nhOmIx1vP9HlFnOhn0or7K/gu3u3tc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0046/1005] ntfs: Fix error handling in __ntfs_create()
Date: Wed, 25 Nov 2026 15:23:04 +0100
Message-ID: <20261125143822.820246209@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 5210eadc44ccdd9632b1ee66205742610a486989 ]

In __ntfs_create(), if ntfs_init_acl() fails before
ntfs_mft_record_alloc() is called, jumping to err_out frees MFT record
0 ($MFT), unmaps an unmapped record and unlocks the unheld
&dir_ni->mrec_lock and &ni->mrec_lock mutexes. Call iput(vi) and
return ERR_PTR(err) directly instead, matching the
ntfs_mft_record_alloc() failure path right below it.

Fixes: af0db57d4293 ("ntfs: update inode operations")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/namei.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index 3e0adb9a0ea42..850555bc22b22 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -449,8 +449,10 @@ static struct ntfs_inode *__ntfs_create(struct mnt_idmap *idmap, struct inode *d
 #ifdef CONFIG_NTFS_FS_POSIX_ACL
 	if (!S_ISLNK(mode) && (sb->s_flags & SB_POSIXACL)) {
 		err = ntfs_init_acl(idmap, vi, dir);
-		if (err)
-			goto err_out;
+		if (err) {
+			iput(vi);
+			return ERR_PTR(err);
+		}
 	} else
 #endif
 	{
-- 
2.53.0



