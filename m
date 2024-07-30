Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7F81A76C8;
	Tue, 30 Jul 2024 17:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359661; cv=none; b=dOxONsDF3ZXcT/Fj0O+XkIs1J8en/vFIvGW7LLzzLUuFUGlielxhrAuvQiJxlyL/WZlFvWM6cuqJFaQOZAHQCFGp0bzPDoEkzqvhlCzfr8vj3WB79x6h016F2lEkcvPXaY9XLXYKJcNK6SzxNeNJSotD4Thtnu8bkfWJoWq0xoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359661; c=relaxed/simple;
	bh=G8Xm7+z7RmuHDdcdbZjfI166bwfPpFC3Hd9cvWC2AiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECTtlpSvnj/EMg/XyYFPkfz99y272lZO7L4RAqk1Hif2Z0+pC31lLnSn7tlkpiuQDd2XiUukNP0lmZbOVKi+1T16umvjkIftDHF+lou+puyX9smyJAo8c/VwiuZMcDSng9AqUuSUQnZSoA2SVTfcZJ068ibEFLu482xG/fzGlMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlj8FlIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlj8FlIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA447C4AF0F;
	Tue, 30 Jul 2024 17:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359661;
	bh=G8Xm7+z7RmuHDdcdbZjfI166bwfPpFC3Hd9cvWC2AiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlj8FlIKg1ULylvhOl1JcYYomEfo0ha++A73SjisswIGT+Wk3oNrLwAZzx8kvvGIU
	 ubl+Fqylo4DLfhz+oESUIXl8l4r+nwNRaYV2DV2LYGn/g95K8DA2pLtLqNUMatEKUr
	 21nN0Ieh4cjZVYaBTnrTQ86NPCbI7n+RTAOVL1Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 515/809] fs/ntfs3: Missed error return
Date: Tue, 30 Jul 2024 17:46:31 +0200
Message-ID: <20240730151745.078472073@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 2cbbd96820255fff4f0ad1533197370c9ccc570b ]

Fixes: 3f3b442b5ad2 ("fs/ntfs3: Add bitmap")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/bitmap.c b/fs/ntfs3/bitmap.c
index c9eb01ccee51b..cf4fe21a50399 100644
--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -1382,7 +1382,7 @@ int wnd_extend(struct wnd_bitmap *wnd, size_t new_bits)
 
 		err = ntfs_vbo_to_lbo(sbi, &wnd->run, vbo, &lbo, &bytes);
 		if (err)
-			break;
+			return err;
 
 		bh = ntfs_bread(sb, lbo >> sb->s_blocksize_bits);
 		if (!bh)
-- 
2.43.0



