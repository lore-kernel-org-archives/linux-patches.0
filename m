Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71DF1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4084CC433C8;
	Mon, 11 Sep 2023 14:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441848;
	bh=8UFl4AnrnLbEsv7iJtPYFeoL1rel8kz4vDooVRAS1dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJcAc46YXNjo8mLxggmP4Xy58zv7oSUwsDs6xwz0CtpHn4whEbt/6ByrjmewVKF1m
	 /G+RUtTesdnf9veT7K1fUlJBsCtGglcOn/Y770x5EkjKylE8504p+xkx6dW8Tu1zrT
	 J0AWt5I35mS7f4hph2Sk2Ps8Af/AR3pntYFcN7Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Yangtao Li <frank.li@vivo.com>,
	Konstantin Vyshetsky <vkon@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 550/739] f2fs: fix spelling in ABI documentation
Date: Mon, 11 Sep 2023 15:45:49 +0200
Message-ID: <20230911134706.453276358@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit c709d099a0d2befa2b16c249ef8df722b43e6c28 ]

Correct spelling problems as identified by codespell.

Fixes: 9e615dbba41e ("f2fs: add missing description for ipu_policy node")
Fixes: b2e4a2b300e5 ("f2fs: expose discard related parameters in sysfs")
Fixes: 846ae671ad36 ("f2fs: expose extension_list sysfs entry")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: Yangtao Li <frank.li@vivo.com>
Cc: Konstantin Vyshetsky <vkon@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-f2fs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 8140fc98f5aee..ad3d76d37c8ba 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -54,9 +54,9 @@ Description:	Controls the in-place-update policy.
 		0x00  DISABLE         disable IPU(=default option in LFS mode)
 		0x01  FORCE           all the time
 		0x02  SSR             if SSR mode is activated
-		0x04  UTIL            if FS utilization is over threashold
+		0x04  UTIL            if FS utilization is over threshold
 		0x08  SSR_UTIL        if SSR mode is activated and FS utilization is over
-		                      threashold
+		                      threshold
 		0x10  FSYNC           activated in fsync path only for high performance
 		                      flash storages. IPU will be triggered only if the
 		                      # of dirty pages over min_fsync_blocks.
@@ -117,7 +117,7 @@ Date:		December 2021
 Contact:	"Konstantin Vyshetsky" <vkon@google.com>
 Description:	Controls the number of discards a thread will issue at a time.
 		Higher number will allow the discard thread to finish its work
-		faster, at the cost of higher latency for incomming I/O.
+		faster, at the cost of higher latency for incoming I/O.
 
 What:		/sys/fs/f2fs/<disk>/min_discard_issue_time
 Date:		December 2021
@@ -334,7 +334,7 @@ Description:	This indicates how many GC can be failed for the pinned
 		state. 2048 trials is set by default.
 
 What:		/sys/fs/f2fs/<disk>/extension_list
-Date:		Feburary 2018
+Date:		February 2018
 Contact:	"Chao Yu" <yuchao0@huawei.com>
 Description:	Used to control configure extension list:
 		- Query: cat /sys/fs/f2fs/<disk>/extension_list
-- 
2.40.1



