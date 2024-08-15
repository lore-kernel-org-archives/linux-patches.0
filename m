Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD767DA9E;
	Thu, 15 Aug 2024 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729739; cv=none; b=WyrMmgXYoUvfrTxcorYBQcndaJqOlmNUw82QVOD7lw/nV/tzeJLRpAmFKIkaO9ymrm5l1ZfjwlwNau0AT2KoxR3Bty6Wsk5osTnwhNngMOOtlz5PzC7xX9E++rkvddUSHrH/ebYaf0rwZm9qJiHXpwiFysYme66r/++yz0ePcxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729739; c=relaxed/simple;
	bh=v8vUQL4x2vi6IkQx0k3v9ZMNP7/879FzAdO+pVNhOiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTocNj60brl+UUEh9vKDeKRtWlifqpAUyD2PWC4KgQBPivuQ/XNuUKr8Od5O9Ozz7hLJkUXIY595IIe4LffnmNggFEB1G1GDR0oSj2cCpNHAbIJL9gd7+nAjZNXjgU6ykCH0Cnf3EuF5cZuJ84rNIAFYzwitoVx1l6BDHoLjGzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WR3NDe6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WR3NDe6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2396FC32786;
	Thu, 15 Aug 2024 13:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729739;
	bh=v8vUQL4x2vi6IkQx0k3v9ZMNP7/879FzAdO+pVNhOiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WR3NDe6XEsBM+8posUsuZ7g17l8nR/fyrnt7KN9PuYISvZVbE94hR3wgxQNWQjY4V
	 SnszyD8R54b4sQfDEVewC2tOnbtYGNMowHx2OjpDfKI4uRZEKiY9Kglcc/P3Va+I6z
	 akMHE/qMIrrPOJn2D4Q0Hnp53ihigerZqIk/zqhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/484] fs/ntfs3: Missed error return
Date: Thu, 15 Aug 2024 15:20:23 +0200
Message-ID: <20240815131947.784870595@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 21536b72aa5e5..95589a496f0ff 100644
--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -1363,7 +1363,7 @@ int wnd_extend(struct wnd_bitmap *wnd, size_t new_bits)
 
 		err = ntfs_vbo_to_lbo(sbi, &wnd->run, vbo, &lbo, &bytes);
 		if (err)
-			break;
+			return err;
 
 		bh = ntfs_bread(sb, lbo >> sb->s_blocksize_bits);
 		if (!bh)
-- 
2.43.0



