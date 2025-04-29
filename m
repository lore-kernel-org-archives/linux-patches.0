Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224FA1FE468;
	Tue, 29 Apr 2025 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947722; cv=none; b=dmwXV+N/7e4LrEjTUSpPEjux9AwYo0hdicq8yUzsg6q8JWgNjAshaMjPZbBrmvIsLeuMqOcmq1ngJdTNwBEcDBcAd9TGBGQkjrSEVnFVpkS6TpT4RXvad/EnWZWbCE7EflcaJNausEpQHFREqEDe8LnOkNdKpwDDrAbP05+QSKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947722; c=relaxed/simple;
	bh=VB8NGSiMNi9U1eV9qZqCCe8fo4ZBuSjFy0LYf0RhoH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAFzZ/U//GSwy/1F53raguyHJl+h6X69YdqsliZAvTEYUh+1cCk4UU41jIciDsohP9z7U6Fp9NJVG2qUebybY8AxmDfoVeERp9GzIpEyAVgxjOhOG4XZlkNdMca8KZEGmfougvrDygLe5QzpklWkdhT2v+H3xXAY+bqM1miGYCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhqOqUj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhqOqUj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6EDC4CEE9;
	Tue, 29 Apr 2025 17:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947722;
	bh=VB8NGSiMNi9U1eV9qZqCCe8fo4ZBuSjFy0LYf0RhoH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhqOqUj5QkFLW2Ce/VGOoV9go1hmuv0sWLwLEbndLR5NHiSMhoUjXkr36Pb8wYhFv
	 /Q4pCDawlwkfkK9TEf+kAkmbvRMq5gih4lLx4H+T/W6jXVHBGToF583gRX/XSntXtk
	 SgOJoJbxYNqmyKAUib3jOJC75jZNvmRuYtrMdGOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"T.J. Mercier" <tjmercier@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/280] splice: remove duplicate noinline from pipe_clear_nowait
Date: Tue, 29 Apr 2025 18:40:27 +0200
Message-ID: <20250429161118.629754905@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 06232d7e505f6..38f8c94267315 100644
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



