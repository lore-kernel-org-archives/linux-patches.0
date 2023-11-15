Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B615E3C46A
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OT849bWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68913C433CA;
	Wed, 15 Nov 2023 19:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077537;
	bh=AuFAGQyyUYq7GNf6wMgklPOhSLk5XAW3AFFQw3SiROc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OT849bWstp2djRIBLyfHdgpLhOQ3AUY69Ge30J9qzwuCy2ge548y0tiDuN8G48ExP
	 5ZPXpwBH6tVRwU0s04GQhQmlEMgNvaggp+XQDu0Ej9sGYWtIZ8eEDdP/jAwjMgXgbB
	 TiL3psNLceR/nIKUyyZTy2G0J56mDJrzNR65Vaic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 364/603] ext4: add missing initialization of call_notify_error in update_super_work()
Date: Wed, 15 Nov 2023 14:15:09 -0500
Message-ID: <20231115191638.705115909@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit ee6a12d0d4d85f3833d177cd382cd417f0ef011b ]

Fixes: ff0722de896e ("ext4: add periodic superblock update check")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index dbebd8b3127e5..6f48dec19f4a2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -768,7 +768,8 @@ static void update_super_work(struct work_struct *work)
 	 */
 	if (!sb_rdonly(sbi->s_sb) && journal) {
 		struct buffer_head *sbh = sbi->s_sbh;
-		bool call_notify_err;
+		bool call_notify_err = false;
+
 		handle = jbd2_journal_start(journal, 1);
 		if (IS_ERR(handle))
 			goto write_directly;
-- 
2.42.0



