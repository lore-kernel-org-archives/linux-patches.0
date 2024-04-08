Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9020E74BE5;
	Mon,  8 Apr 2024 13:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584115; cv=none; b=JG0JdhO9AMdtkDb1Fjq8SinbckwWmozh0D5P80B2I3EobRnlQmvBwRgnpWc5gHhbTDJH6yOmUZK8yBQeTL9taPCQehg3Ua/myIFTpAt4rQUJv7j2BXFZyp7yNlF4aTDBGmWuDicsxLGqI20VkLXs804SWC9N4BhF+WZ6pz51xoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584115; c=relaxed/simple;
	bh=n/T3lufhI2dsg6LKeA42Bxw7WjaCjJdmO151EVU976g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heNmz66yf76y/FYzpqWq8qgczdn/jA0ouCytlUD4EnjTv+l9220cDRoeg3OJcCl661P5+Dcuv85ZK8suIRa1H7orV6jF5O3PppxUNv7wVY9S1ghwxg2hJb7uoOGwdCITmJMwCoTk2mjCcXkLObfz49h8U0eVNHNipI/ccnkowls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPpNOue8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPpNOue8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A87C433C7;
	Mon,  8 Apr 2024 13:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584115;
	bh=n/T3lufhI2dsg6LKeA42Bxw7WjaCjJdmO151EVU976g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPpNOue8o32YOwvgvTq12QH5KiBlTkZIdrugPFel8ZB95DL9Twk0u9vEkSflriZam
	 RHXynBhjsLyLM50Brw2De5aHYEkVg6kMBpPq2k6VPeGhJVW2w92IIS2FKU5b9EA+jM
	 99sLcptwUOLTMjZpqjNrgz2DRZY2SEsR7R0rOb3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Ford <ojford@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 336/690] fs: inotify: Fix typo in inotify comment
Date: Mon,  8 Apr 2024 14:53:22 +0200
Message-ID: <20240408125411.782938147@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Ford <ojford@gmail.com>

Correct spelling in comment.

Signed-off-by: Oliver Ford <ojford@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220518145959.41-1-ojford@gmail.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/inotify/inotify_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 266b1302290ba..131938986e54f 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -128,7 +128,7 @@ static inline u32 inotify_mask_to_arg(__u32 mask)
 		       IN_Q_OVERFLOW);
 }
 
-/* intofiy userspace file descriptor functions */
+/* inotify userspace file descriptor functions */
 static __poll_t inotify_poll(struct file *file, poll_table *wait)
 {
 	struct fsnotify_group *group = file->private_data;
-- 
2.43.0



