Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F281C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04A3C433EF;
	Wed, 28 Dec 2022 16:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244370;
	bh=IvG6SARDwQjWSH+ffasGt+RYVyM+wHEIdsJp6Sgu43Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4YfmmY2RCLzPVSbk9xRRbmf7WT1Woh4LeIxJaBYl/Rcu8AOvmWMcwmJ4cTTlv62I
	 hZm20RAw/1kHKtKAFv/+flVq/S7yyO50BAYAhJJxx0Y+Pch3aNXjqPQaykA7LefZY4
	 y9tuhU4NWIuVgkUShRE/+zgNSueC6XzSmtA2FGfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Nick Terrell <terrelln@fb.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0658/1146] f2fs: set zstd compress level correctly
Date: Wed, 28 Dec 2022 15:36:37 +0100
Message-Id: <20221228144348.029423637@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index d315c2de136f..74d3f2d2271f 100644
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



