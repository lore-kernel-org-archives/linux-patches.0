Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBCA1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61077C433EF;
	Wed, 28 Dec 2022 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244021;
	bh=31dveTOZMi2sa1tCpqRZ2Zgv5cc/8M0x7U6lfXNWyPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/X2fenjJQiRWPy37qW3kbMVB+TmRgk7mJ0n/tZM6D7E2sBAd8ZU93K33L4cg92Qc
	 RfL6v8JMPpPNG1H3HQ1mXgRKyL3kSgpBiU3s+cx68lBwsngvCaA+ayHv7HaahuLStP
	 /qbjFUFKDxNYurgFwTVDYhI1dvnCSnxFz5UdTl5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Nick Terrell <terrelln@fb.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0633/1073] f2fs: set zstd compress level correctly
Date: Wed, 28 Dec 2022 15:37:01 +0100
Message-Id: <20221228144345.234986897@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sheng Yong <shengyong@oppo.com>

[ Upstream commit 4ff23a6547b81ca22adb852dfe93ee5fc45328ac ]

Fixes: cf30f6a5f0c6 ("lib: zstd: Add kernel-specific API")
Signed-off-by: Sheng Yong <shengyong@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Reviewed-by: Nick Terrell <terrelln@fb.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 70e97075e535..e70928e92b2c 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -346,7 +346,7 @@ static int zstd_init_compress_ctx(struct compress_ctx *cc)
 	if (!level)
 		level = F2FS_ZSTD_DEFAULT_CLEVEL;
 
-	params = zstd_get_params(F2FS_ZSTD_DEFAULT_CLEVEL, cc->rlen);
+	params = zstd_get_params(level, cc->rlen);
 	workspace_size = zstd_cstream_workspace_bound(&params.cParams);
 
 	workspace = f2fs_kvmalloc(F2FS_I_SB(cc->inode),
-- 
2.35.1



