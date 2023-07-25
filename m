Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920E91ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1533CC433C8;
	Tue, 25 Jul 2023 11:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284531;
	bh=LASVBGJVgJFr5Dje8n7QR3NDbpkl/+2QXpb7Ae7EEB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ea90aZ1nQnkaBZX+4+tTU194W/JozsAL+4LJkIN1iwAyBOdscZhMAWdNnLpkMttCS
	 2CNLXnT95BbDhQgnCQ0Af/T8IMf/aby3AmbpvzdMRs6p0ukXxwfAiIZ1hgpY1wwm79
	 HuarqL+aiR1Eu0tgrPKocWeywgLuDm/cSK9Fc/B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 390/509] ext4: fix wrong unit use in ext4_mb_new_blocks
Date: Tue, 25 Jul 2023 12:45:29 +0200
Message-ID: <20230725104611.610876697@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
@@ -5642,7 +5642,7 @@ void ext4_free_blocks(handle_t *handle,
 	}
 
 	if (sbi->s_mount_state & EXT4_FC_REPLAY) {
-		ext4_free_blocks_simple(inode, block, count);
+		ext4_free_blocks_simple(inode, block, EXT4_NUM_B2C(sbi, count));
 		return;
 	}
 


