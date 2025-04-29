Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E18251798;
	Tue, 29 Apr 2025 16:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945917; cv=none; b=SGsmFu3Xoiw6Zvw2G4MOOrhpJOXTu2zu/NWX/D3W6HIFDy0nlJPff2NMQbBiqwDfMByIc7afVWqyBPr9Y4G0S4AIcPdYV9Lu7R/XpLgzs4a20dpiAVhTGbm0WaxWgS5CiCQ3p2F1+nO5uSnZK6w8+9c9msZARMThj8sID5Z11Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945917; c=relaxed/simple;
	bh=FReJPVNOEGEkWOUzQkrPE+tIpVmbelHioeVS01U44/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoRVnfq4DxloZkIlKgNcIJYDezWjHIBXyLiDee8paXL4cmRbKNu2Pv/T+zkJlYDQ6d65CKnwXcPz0vIkg+eJMsFwFjL3w0P6V2Vzm5lL8iVc0Y4QGF/N6YdaU4Cyufod/ZVFyr4fvgaDTv+RiLCAg9aW4aAOOVA+1KVhngxmGCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbYuUE19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbYuUE19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7A2C4CEE9;
	Tue, 29 Apr 2025 16:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945916;
	bh=FReJPVNOEGEkWOUzQkrPE+tIpVmbelHioeVS01U44/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbYuUE198xCEAzYK/8leAr+RVAQWZIxlQMpWtClJMpo8iuFh1O9j5zpviLmxkxZX8
	 x4FuC5FG/SlTBBzNPy3wOCUOdv3MH0pAaJq6YBxab4JVfFSbNNjrcmfeEb0UOHsCiv
	 ZiKqa9u7VgHRN3QIpWpsCBQShlx2BYmzouJfUpog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"T.J. Mercier" <tjmercier@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 093/311] splice: remove duplicate noinline from pipe_clear_nowait
Date: Tue, 29 Apr 2025 18:38:50 +0200
Message-ID: <20250429161124.855569848@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 23fa5561b9441..bd6e889133f5c 100644
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



