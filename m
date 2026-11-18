Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016776;
	b=cqoEqIixIqRxDDzYZ4eglw1paQYqf3hmvB7z4ApVgxZqwPgAmmwyApZZCf6gGxCRvBCL
	 KzScJuOnVghPHXR6Q5nbWCsdHNAHWtIikjqrdOndqsKyOE05NAqk0z9bE8ou8breunSK0
	 xiJg8+HImneeMtdi9huWtIbwlCNAAieBs+DYNre7exvFqvGcv0nE/PQO8xopLvJ+fjwFu
	 VRu2bKtkGoNwHaojRQupJRB5oyjZ6EKalLLbkwJfzUeJGiIIJQg91hwDjDWqAVJTJ83GX
	 ZERLgRg1T/9z9tUZC5vCVGJI9aPLdpnSDcNLnkB44b3Q33+Y2CoeGwVtliVggSc2wAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pgHQ3Unch+KWvw9EmbJUcqkyZAa9/XoYjS4YjIW8dP0=;
	b=ebTdJPomiSnspz2XTRys4MCp5CUCAt9xiSPkhUOOj7Ol8Frbg5wtfwIIuprlmquPL1JA
	 n0VUXi5UvmIHe1EEGBNg3YHGRiNXEvDGlhN9tsrdmEji4X2pkxDg2hbuOnEdJq0jAqU4G
	 s32kMD18usfF/Kgxhbziln0Ob4fGEmDTfnNanlGFlLlUHVq8l2M72sVNdx7uNPHqlqXm7
	 912BITbVrLiK6Lyz+eoz2UqsvJkAmgDOGiIg9mTzAk+xDRqDpTRYVOcQxiNziACX4xlxn
	 QcUAGgK/MhwVZgeN+hj7DXWBdqzoSs/sOTZM4AVcMf27O4rXwfvvz/NCzbdx2V27DaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e78yN527;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B15606A320;
	Wed, 18 Nov 2026 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e78yN527
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113871F000C5;
	Wed, 18 Nov 2026 15:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016776;
	bh=pgHQ3Unch+KWvw9EmbJUcqkyZAa9/XoYjS4YjIW8dP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e78yN527piD7El69m67Vh712LQWHDntdJF02tu5P5aHS4vHx9gg0PHGrizn31nTSV
	 Vstqt30lxihBlfW+5cbKOyzc1DTlBuCFTcN8YTjTUzE7dnYlaNbS4WER/J4Lq2eFTx
	 BU0TsXA+TbwU9XCrdR0QwhkDYPU/zG5D/pE/OYBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0608/2651] fs/ntfs3: fix valid_size not being updated in attr_allocate_frame()
Date: Wed, 18 Nov 2026 15:30:48 +0100
Message-ID: <20261118150309.608989054@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit a1972501ffb15313f7ae598989bb2cd32829e625 ]

At the end of attr_allocate_frame() the on-disk valid_size is meant to be
updated to the value passed in via @new_valid:

	valid_size = le64_to_cpu(attr_b->nres.valid_size);
	if (new_valid != valid_size) {
		attr_b->nres.valid_size = cpu_to_le64(valid_size);
		mi_b->dirty = true;
	}

but it writes back the old valid_size that was just read instead of
new_valid, so the field is never actually changed even though the record
is marked dirty -- the intended update is a no-op.

ni_update_parent() spells the same read-compare-write out correctly a few
hundred lines away, storing the newly derived value:

	valid_le = cpu_to_le64(new_valid);
	if (valid_le != attr->nres.valid_size) {
		attr->nres.valid_size = valid_le;

In practice that path, reached from ni_write_inode(), re-derives
nres.valid_size from ni->i_valid on inode write-back, which normally masks
this, so the visible impact is limited.  The assignment here is still
wrong though; store @new_valid as intended.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index fd2640878e6a5..d9f538c31e6ee 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -2010,7 +2010,7 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 
 		valid_size = le64_to_cpu(attr_b->nres.valid_size);
 		if (new_valid != valid_size) {
-			attr_b->nres.valid_size = cpu_to_le64(valid_size);
+			attr_b->nres.valid_size = cpu_to_le64(new_valid);
 			mi_b->dirty = true;
 		}
 	}
-- 
2.53.0



