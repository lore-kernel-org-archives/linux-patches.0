Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D095227F3E
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547BCC433CB;
	Fri, 21 Jul 2023 19:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966778;
	bh=P+vWxZRY23U1jjum0DwHhFXy3i0b/+DY8N4vpyBPdAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNwRk9KSTBMOKvfcSqS+AXoDMx6GBX5Gopv0CX8V3fhZyuLz6QbfgzbvU9TyLMMAP
	 0499eTvdtCZc0Ye6UGAEKDfddo1VgYTpmRwei0M1ssghvVptFEqqJKrrrYWXDtm4+w
	 NxZ/RFzUmWvsxH4EvqH6vJf8HfhACn0bN3P5RaaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 464/532] ext4: fix wrong unit use in ext4_mb_new_blocks
Date: Fri, 21 Jul 2023 18:06:08 +0200
Message-ID: <20230721160639.706918582@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
@@ -6179,7 +6179,7 @@ void ext4_free_blocks(handle_t *handle,
 	}
 
 	if (sbi->s_mount_state & EXT4_FC_REPLAY) {
-		ext4_free_blocks_simple(inode, block, count);
+		ext4_free_blocks_simple(inode, block, EXT4_NUM_B2C(sbi, count));
 		return;
 	}
 


