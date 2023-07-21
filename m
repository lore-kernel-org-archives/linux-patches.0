Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2BF1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A48C433C8;
	Fri, 21 Jul 2023 16:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956252;
	bh=SZXmvrAOlq5F+Hg+9pUkyhWs2FbETBMSGjQdJY3YqkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLc0erU0LOnYujSohY9CiXFBEC96Ox0dVQIJ8JF7DgvqKYIk0mc3c8Sy3hfoeDYxb
	 YA+sGF5XZCu4RVXVBb6h9JPP3NczxZDATQpXQdaCGQlyKwsz8DMz1Qa3pVV0LYmGjl
	 k7OK2r7k0w+w9e9UDd7fCS4kVcQMMG7JNwu2oTFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.4 153/292] ext4: fix wrong unit use in ext4_mb_new_blocks
Date: Fri, 21 Jul 2023 18:04:22 +0200
Message-ID: <20230721160535.472995840@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit 2ec6d0a5ea72689a79e6f725fd8b443a788ae279 upstream.

Function ext4_free_blocks_simple needs count in cluster. Function
ext4_free_blocks accepts count in block. Convert count to cluster
to fix the mismatch.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: stable@kernel.org
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20230603150327.3596033-12-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6336,7 +6336,7 @@ void ext4_free_blocks(handle_t *handle,
 	}
 
 	if (sbi->s_mount_state & EXT4_FC_REPLAY) {
-		ext4_free_blocks_simple(inode, block, count);
+		ext4_free_blocks_simple(inode, block, EXT4_NUM_B2C(sbi, count));
 		return;
 	}
 


