Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7E1155333;
	Tue, 29 Apr 2025 18:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950441; cv=none; b=Zfq+VVqJbbX31nyHUGZW/3p4BF5JuA/S8rXYR40TYJVM8tKeFbNMIgiu1eQ4RzkBo6g/r1COgBFL6PLXvzzPVC/wb2hqxD0/3KsbHBNpVd5rj4dJOKB+9xQbh9tCMk2mBbCgNynmoguOvZ0115tf2laYcntspyTkp3NftVZ6FpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950441; c=relaxed/simple;
	bh=cN78O8Gg/Ri3W0s78eDdfU/CGNtjSmyFhkDRh+0kq7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkUmESJsVJ2cyraPcxODiS4/C9zrLytFtSjimZftp9vWpM/mU7RHANRCYqAUd6uX6dHQgslmTSDoB4Xa4+Gu1CphSKGbfrPBuD+tPtZnU9Sudwbxnuiy2OeE5K+8tAfGFwYHCQI9DH/tD0Rdk1WP1ZwiLhlX5j5HEwJrGCN5IOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeRK6yre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeRK6yre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D49FC4CEE3;
	Tue, 29 Apr 2025 18:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950440;
	bh=cN78O8Gg/Ri3W0s78eDdfU/CGNtjSmyFhkDRh+0kq7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeRK6yremrzAhns8dotWTxjfd2pAm+EwIZUQnwQl2SxKZopejBzLp7MysoqQtJKAn
	 v+Lzps//DywowQBW+XuJbqibI3mDIediYlMtxoVQGkXafURJMHsydB/aTkrRTjbToz
	 TkOdJ/a2Pp/5XN6I3bOjk1qHsKmr4vu8IEa1jLag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"T.J. Mercier" <tjmercier@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/204] splice: remove duplicate noinline from pipe_clear_nowait
Date: Tue, 29 Apr 2025 18:42:35 +0200
Message-ID: <20250429161102.169694273@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: T.J. Mercier <tjmercier@google.com>

[ Upstream commit e6f141b332ddd9007756751b6afd24f799488fd8 ]

pipe_clear_nowait has two noinline macros, but we only need one.

I checked the whole tree, and this is the only occurrence:

$ grep -r "noinline .* noinline"
fs/splice.c:static noinline void noinline pipe_clear_nowait(struct file *file)
$

Fixes: 0f99fc513ddd ("splice: clear FMODE_NOWAIT on file if splice/vmsplice is used")
Signed-off-by: "T.J. Mercier" <tjmercier@google.com>
Link: https://lore.kernel.org/20250423180025.2627670-1-tjmercier@google.com
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index d983d375ff113..6f9b06bbb860a 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -45,7 +45,7 @@
  * here if set to avoid blocking other users of this pipe if splice is
  * being done on it.
  */
-static noinline void noinline pipe_clear_nowait(struct file *file)
+static noinline void pipe_clear_nowait(struct file *file)
 {
 	fmode_t fmode = READ_ONCE(file->f_mode);
 
-- 
2.39.5



