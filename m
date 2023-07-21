Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D6220F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF37C433CA;
	Fri, 21 Jul 2023 19:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967389;
	bh=3S9jrISaPrsRJmfff4zWgNjYFcvFwb9J+fTiUCmerQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tumX66LBtOqu/fgCuyRy4BLuX7QTmWp4yp+UfzKSOuTx02kj+JBJ+FA++6fZ6WEu0
	 tVWiTdVrvh5xwW8+Z3jA8uLsaT1ipPaz1FE4nl/r4wHnpnB8lKusQBdD6nm2YoesiZ
	 HBjP42S/IG3+vlclDoX183gJiv8ANnnrPkSpbk0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 107/223] ext4: fix wrong unit use in ext4_mb_new_blocks
Date: Fri, 21 Jul 2023 18:06:00 +0200
Message-ID: <20230721160525.433391891@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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
@@ -6166,7 +6166,7 @@ void ext4_free_blocks(handle_t *handle,
 	}
 
 	if (sbi->s_mount_state & EXT4_FC_REPLAY) {
-		ext4_free_blocks_simple(inode, block, count);
+		ext4_free_blocks_simple(inode, block, EXT4_NUM_B2C(sbi, count));
 		return;
 	}
 


