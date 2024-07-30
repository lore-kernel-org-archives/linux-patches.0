Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D98189BB6;
	Tue, 30 Jul 2024 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358312; cv=none; b=cfJ3JbCERG/ri0WEHc/pbL7G/uHB5Pu3vC00mVqSQK1ucQlVplzN2nIa47IUwjsgdQhghgXQyb+veqbeK/Em/bYSxlvgZzRh2dM8l1orEAjhYv5cB5YLOty3XSelNUh+5m0q4amW0tQHriLLA89smxhXmRVMl1yzzETFOUQo+PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358312; c=relaxed/simple;
	bh=SUp+JsmRVJR4LDnGCDNo37ce+7eETYqjfumkk1TeILQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G14FzKwp0cSM2O8gG7glelxEcSuxStfTjadF0lTPo7vcg6JLV5deflXVKyHDYLkCl4eQMXblKvPz7SqaUQ5TLiRY564iD/DqtxX+hZdOTu5LUguZ/xukXOCc1p1fNjg4A2cVTq1fZ5MZFMsq4ocJZ2dJxV9CM/0jnz6OXftuHkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjfzXWKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjfzXWKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D547C4AF0A;
	Tue, 30 Jul 2024 16:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358312;
	bh=SUp+JsmRVJR4LDnGCDNo37ce+7eETYqjfumkk1TeILQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjfzXWKuAI2ENZAMFbYgeSBO013rSLSmoTpJdSXerW5EjEqFZSQ2kFU7ymPlGeeBg
	 7Bj6VwFIgsmVnuupw8bzxugNxfUq6Qhs5ikcTt6n4Gm9eDXceWKx01ztM2ZDEPsbH7
	 D46KdbQcnJl5far2ukDmse6+Kbifptea7HMBUaO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 350/568] fs/ntfs3: Missed error return
Date: Tue, 30 Jul 2024 17:47:37 +0200
Message-ID: <20240730151653.549074269@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 845f9b22deef0..931a7744d1865 100644
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



