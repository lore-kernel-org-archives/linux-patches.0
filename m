Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5956B2F2D;
	Tue, 27 Feb 2024 13:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040821; cv=none; b=bHFGZrzDheOkNEQHj1VNFq6IDL5gzIuSxEWgfc77T7TNISH752ZBZfbqdvFavG7/OU9KKH7SkLbTShU0qk6G6X3Um5/LtdjXJS6UOsImdOziFjU9Qyg11VOZCnp/kRfINS22/FpWmVFx829ercfGFOWaNKGIjo0MzarSWRZCHcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040821; c=relaxed/simple;
	bh=rhrn/G1o6MbDXkara9AXWBH13Hwd6c9o7eQwNMT5Gvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3cNbZfM1eVAgTvXKkB6In618lnsOCp988tfnTfBgaL5EaI/r2lfJnQBl0Cg+w/tpmdUso1n2iDl1O5xAQ16Mu+Od95OcTWnrJfIh9fBEMtGHOi9b9frgYAz5nNBdzAwSixRiwtBy7VKzVbQEUwGEFimI1IDeGGnuo5VjwxaDrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgrbbnvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgrbbnvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE08C433F1;
	Tue, 27 Feb 2024 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040821;
	bh=rhrn/G1o6MbDXkara9AXWBH13Hwd6c9o7eQwNMT5Gvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgrbbnvVuZWBI7JtT/ehhOdwTumQ30+LpgcBywT0N/cP7sE6HOMbp3gPxswkcEmh7
	 WovK+PhVYWGfFaaaKurkV4/toYCM3PjfVmNJDQKayEJmvMYFpcdeeUNCem6NOL9hbX
	 aBf8d1v0v9/j3OPv/t7K8Mh93LrzIcFuvJanX5nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 091/334] fs/ntfs3: Fix c/mtime typo
Date: Tue, 27 Feb 2024 14:19:09 +0100
Message-ID: <20240227131633.452270363@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 652483bfbc45137e8dce556c9ddbd4458dad4452 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 8744ba36d4222..6ff4f70ba0775 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -3291,7 +3291,7 @@ int ni_write_inode(struct inode *inode, int sync, const char *hint)
 			modified = true;
 		}
 
-		ts = inode_get_mtime(inode);
+		ts = inode_get_ctime(inode);
 		dup.c_time = kernel2nt(&ts);
 		if (std->c_time != dup.c_time) {
 			std->c_time = dup.c_time;
-- 
2.43.0



