Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9451E909D;
	Mon, 21 Oct 2024 10:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507819; cv=none; b=GcVZaQ0KBuT+Tj9UPFcVNkn46yYIn177K6OK3x07Q1ISU9Lw9WE7jGErF/RhxJU092bSdiM/FHGlhk5wqbY7O8W2BCuNP5Yc6HYMRRpJzA55owTGQIrAjU9Hh5BMIYontbLcSPFx5FPk89+hCo9h1wO+iKw703aHOfPPC3FCHEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507819; c=relaxed/simple;
	bh=w767fstcC75rPj6cq0JP01osaDYWN+koYQQChjFqW+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pC3a9yp524eSNnFchjZJOPD7ToKNbAklA+p7nidA2nEsHediDWanxSIJrwPrmWYpHgJTSAvDImXsLsvreL16W0k4KBt7vtV3nxBhUCk1/xwzosUZjrcq0RUBRv4zW9HdTf9P04ms/9gqBZVhKc6wJukuX6FYy0uyEhSJmxfLUoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFLMgG2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFLMgG2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D3AC4CEC3;
	Mon, 21 Oct 2024 10:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507819;
	bh=w767fstcC75rPj6cq0JP01osaDYWN+koYQQChjFqW+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFLMgG2tmnomeV7IEbfIR6GaiZyOn1wsopStL/PcAep9azkAAOxzGIxwHbI3+am1L
	 ZwKtZF/0cRpynXPvPUUzH1DbLKoM435v4sKUbhv1edA6LLxp+m0uuYIlFuXXtELKsj
	 jpP2atGAK/000o2952ftMcmScqa/8maNzs1l49A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	syzbot+ef0d7bc412553291aa86@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 08/52] fat: fix uninitialized variable
Date: Mon, 21 Oct 2024 12:25:29 +0200
Message-ID: <20241021102241.953527257@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 963a7f4d3b90ee195b895ca06b95757fcba02d1a upstream.

syszbot produced this with a corrupted fs image.  In theory, however an IO
error would trigger this also.

This affects just an error report, so should not be a serious error.

Link: https://lkml.kernel.org/r/87r08wjsnh.fsf@mail.parknet.co.jp
Link: https://lkml.kernel.org/r/66ff2c95.050a0220.49194.03e9.GAE@google.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: syzbot+ef0d7bc412553291aa86@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fat/namei_vfat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1019,7 +1019,7 @@ error_inode:
 	if (corrupt < 0) {
 		fat_fs_error(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __func__, sinfo.i_pos);
+			     __func__, new_i_pos);
 	}
 	goto out;
 }


