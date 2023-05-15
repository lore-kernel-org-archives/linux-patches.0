Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45C5DF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7048DC4339B;
	Mon, 15 May 2023 16:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168614;
	bh=MUg+TlQV/Afc9yt1ZeVxzmwjMaLLFamnNE4bjYiGGDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDj2E5bL64NOwE92eNUgEtumqGn27iwgPPncxWTvi72KeIiIDqkyiIzwHr/HRCla2
	 X3Y4n9yoVuvC6znQFSmkmHcFRkJdNGYhwvnmWtZB0oLtFDD1EeFn0cOMlQm468Rzae
	 TGgzdUlSUIcySv/IS01bKP75bTbA9MYEJWnh/ne4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Korotkov <korotkov.maxim.s@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 090/116] writeback: fix call of incorrect macro
Date: Mon, 15 May 2023 18:26:27 +0200
Message-Id: <20230515161701.260802894@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Korotkov <korotkov.maxim.s@gmail.com>

[ Upstream commit 3e46c89c74f2c38e5337d2cf44b0b551adff1cb4 ]

 the variable 'history' is of type u16, it may be an error
 that the hweight32 macro was used for it
 I guess macro hweight16 should be used

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 2a81490811d0 ("writeback: implement foreign cgroup inode detection")
Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230119104443.3002-1-korotkov.maxim.s@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index be6096f195c5a..05e2fbe892199 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -702,7 +702,7 @@ void wbc_detach_inode(struct writeback_control *wbc)
 		 * is okay.  The main goal is avoiding keeping an inode on
 		 * the wrong wb for an extended period of time.
 		 */
-		if (hweight32(history) > WB_FRN_HIST_THR_SLOTS)
+		if (hweight16(history) > WB_FRN_HIST_THR_SLOTS)
 			inode_switch_wbs(inode, max_id);
 	}
 
-- 
2.39.2



