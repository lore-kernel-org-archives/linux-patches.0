Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060823;
	b=JAPtspGxKzyWsYfTeCli1e7YiOYxVaM1sKF+XOBv1BbuMeS++T+ZRvuFx/vtVuwhzMrH
	 pzbQS9oU5zLzRXJmGfbkqF6gCm9Ny4UleOAYBDna4kzDyR9pmIVSYbwFhu05mE00eDbj2
	 QdWKrXkWyWCNLrLP5ko9RoTCDTXjDnfa093Q/nXOhwsWSpET2feyW6z81c3X3u0oFoPYk
	 M5qJeQLN3eQMDzcy7LtUJlNjKXShYga2k8pAXxCGo1TouWEx+380BqOpiMT1J296rzVce
	 qHKXgd3i+gyq1TMabO5i0a/QYx55PdB8PkpKfbSnUIqmvpT/uPEzWEsR8WZbYQtWGag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HYliPzXrjhQRJ9yWGGZ1JX1lhc9XGSguKI0RKC94Qlk=;
	b=FhobXjdI6M2oWmde5uq4Nrtek+Or7wDNz5FLI/LgkG0MQZSIrYBScfyK+yIJhsE2h7w6
	 hrKrASmD34FNeCiQ2Csf/d3c2Ho176qz18F+Ww7u0ghiaRXkIe9me0ydcXYzQ3Q3FwBwo
	 wMRLFTzLLkW9A3AQak4NLMlYqcigBGo6nCYelk9erpbHGp0xVADz8I4bV1EUmmUXel93G
	 rrj2QLNSd2b8KLRKWkVJdvOIvOnKr023++ez/HKqPOtumJylQffkGvT9gsalWBRNtB04Z
	 bb+bhIe01wogjBJqyACAa/HMBfgFEyFPrERwkMGiKwt3J29rp34clUnGHeegvM9PmKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EyxwgFVH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E2D606A335;
	Sat,  7 Nov 2026 14:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EyxwgFVH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313211F0089F;
	Sat,  7 Nov 2026 14:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060823;
	bh=HYliPzXrjhQRJ9yWGGZ1JX1lhc9XGSguKI0RKC94Qlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EyxwgFVHQVR8GqWxcukC8Ko39SEHmE+IZlr+D0lU9Znxk+5N3j8MG45EJ8fn/7hXt
	 TbqcZGC09pAqjeKD5z3cHe78o3l0/TvL3go5wwB7JQ5F1CUOEE5XaqMHqXZc3XDmvB
	 2w7xZwaUUo70jj4H27ipMq5dzR9IYGWIkHkL43ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0220/1536] exfat: write moved entry before removing source
Date: Sat,  7 Nov 2026 08:37:16 -0500
Message-ID: <20261107135003.844026413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 896fcc93574fd511ee04a4110e8ea59d6d8d43d7 ]

exfat_move_file() removes the old directory entry before the new entry
has been written.  If writing the new entry fails, rename returns an
error after the source entry has already been marked deleted.

Write the new entry first, then remove the old entry and update the
cached inode location.  This keeps the source entry intact if creating
the destination entry fails.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 22eca587cb953..80acb54531126 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1149,11 +1149,6 @@ static int exfat_move_file(struct inode *parent_inode,
 	exfat_init_ext_entry(&new_es, num_new_entries, p_uniname,
 			     &mov_es, num_extra_entries);
 
-	exfat_remove_entries(parent_inode, &mov_es, ES_IDX_FILE, false);
-
-	ei->dir = newdir;
-	ei->entry = newentry;
-
 	ret = exfat_put_dentry_set(&new_es, IS_DIRSYNC(parent_inode));
 	if (ret) {
 		/* Best-effort delete to avoid duplicate entries */
@@ -1167,6 +1162,11 @@ static int exfat_move_file(struct inode *parent_inode,
 		goto put_mov_es;
 	}
 
+	exfat_remove_entries(parent_inode, &mov_es, ES_IDX_FILE, false);
+
+	ei->dir = newdir;
+	ei->entry = newentry;
+
 	return exfat_put_dentry_set(&mov_es, IS_DIRSYNC(parent_inode));
 
 put_mov_es:
-- 
2.53.0



