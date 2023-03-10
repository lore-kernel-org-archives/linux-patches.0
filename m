Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D5B8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA923C433D2;
	Fri, 10 Mar 2023 14:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457175;
	bh=J6+tPsO0qCrDAFh6zPMCDSrZBZljPQlV5UCNcAkKIH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7WJjq6XujFKnA/AseZpMfGm8fQL9u6AN7hHYoTimh3/2KeXnqot18PZHjtoHVcj3
	 3zUt8lp+DHi4giIunXB1ygWMWoyvomSHnZ3A8zbi7DnjGUtjTuMj6KzPOmJqeO4dgb
	 CLrJP7KYpGeuPs1QLp8bVVpOQaZngGcGsEH5TCTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jianjian <wangjianjian3@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/200] ext4: dont show commit interval if it is zero
Date: Fri, 10 Mar 2023 14:37:33 +0100
Message-Id: <20230310133718.508989241@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Jianjian <wangjianjian3@huawei.com>

[ Upstream commit 934b0de1e9fdea93c4c7f2e18915c54fae67bdc6 ]

If commit interval is 0, it means using default value.

Fixes: 6e47a3cc68fc ("ext4: get rid of super block and sbi from handle_mount_ops()")
Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
Link: https://lore.kernel.org/r/20221219015128.876717-1-wangjianjian3@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index aa4f65663fad8..22ddd89c868aa 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2146,7 +2146,7 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		return 0;
 	case Opt_commit:
 		if (result.uint_32 == 0)
-			ctx->s_commit_interval = JBD2_DEFAULT_MAX_COMMIT_AGE;
+			result.uint_32 = JBD2_DEFAULT_MAX_COMMIT_AGE;
 		else if (result.uint_32 > INT_MAX / HZ) {
 			ext4_msg(NULL, KERN_ERR,
 				 "Invalid commit interval %d, "
-- 
2.39.2



