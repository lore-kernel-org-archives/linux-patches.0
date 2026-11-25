Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617749;
	b=J1o6FpQaeczyeGw6/9QAHs02JNT1zxnMS9miqk139XGtRwNbbyIgctkeOvNJDUcY9Pxa
	 a7RP/PQRy+Nh/ZlfCBnnTy3JiUHf1tf8TxegbzNPicJTak1hJZvw5WuSlQ1ZgVQU8oBo3
	 NgJTqQWgcbZyIcvyEw1lxvspGzfvJIdgXMx79H0P4dKJo1Qz+GM/4YiLnlfdFZZ9yvGtn
	 wsL4zmhji2Q7LQTqAbgwF/whx1YSXgMEqdtD28h0jdj2Q0InTLWyVWfLL8xdDCca3R+TR
	 3fvAD/GDO56aCelhaM4fW/0iXdat/YKik4Zkouv8imKONJ0+KypiT8cYQZclieZJMYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6g67FGrgqm4LA+/bkVhlPZcMAoUvpDlO+GO19LjT1EM=;
	b=FDZErG38XtNWhuLc/5GuoBfSKRWFzxFbzj1tiSMvkXNWkLJXn3x8d9jYeZUhuhV8LSIR
	 t+dysy6B09+n+JhHzQjan502DLzxrFnLDB8QfB2+zClFSAOGt2ZvHduaJ6yGaFmuP0xRz
	 n8zfzzk4R9kpIe6ImTmsc67jqj2GShtfj35BfF8cChJO3oQLjdvmUp1TTRGGpI/MQAiSM
	 eO5OelS4IaM/Va8Jjjglim/of32ExF/7vTkc/Kg1L2Rr1po/e4OBwopCsyOr1KsSjpP4y
	 ZlKEXxU7juuh5aiFZHwsif0d3xlkTJDcAI18qeeH8TBvWv40Aqb4rsg8Gr4l3RV/rYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lCxRSNhF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00314606A31E;
	Wed, 25 Nov 2026 14:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lCxRSNhF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522661F000C6;
	Wed, 25 Nov 2026 14:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617748;
	bh=6g67FGrgqm4LA+/bkVhlPZcMAoUvpDlO+GO19LjT1EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCxRSNhF5YxDUTd/UytzwK/n/V9G5ZzU97xqR76C95wZy3V9JGEmyPm3SAXqipz2a
	 N3f1cE3PmlKsmmU0NpQ0mSyEoVdVHIUtpd0cA3TkzmQJdluC/1ClZN09vka41HtZAp
	 eOBxuErMxxhv10qikwcG3KfFSo05Lm0U7jDoYfcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0060/1005] ntfs: avoid overflow when limiting attribute read length
Date: Wed, 25 Nov 2026 15:23:18 +0100
Message-ID: <20261125143823.147109205@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 4b927614d92d7326f265d22b50ba7b4a33966e48 ]

ntfs_inode_attr_pread() limits a read to the attribute size using
pos + count. A large count can overflow the signed sum and bypass
the attribute EOF boundary check. Compare count with isize - pos
instead, after validating pos, so the read length limit cannot wrap.

Fixes: af0db57d4293 ("ntfs: update inode operations")
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 64c415edc398c..907fe8ecb2a30 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -3630,7 +3630,7 @@ s64 ntfs_inode_attr_pread(struct inode *vi, s64 pos, s64 count, u8 *buf)
 		mutex_unlock(&ni->mrec_lock);
 		return -EINVAL;
 	}
-	if (pos + count > isize)
+	if (count > isize - pos)
 		count = isize - pos;
 
 	if (!NInoNonResident(ni)) {
-- 
2.53.0



