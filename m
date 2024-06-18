Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F411D13C683;
	Tue, 18 Jun 2024 13:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716139; cv=none; b=fpwVxL1EM2P8jfg0+GanzpqBjA5fOkL4kTpF9jrxf9MUFJnDJ90FSmIQs2sguIISx5T+fQN4owpW9/brZkIeMDXBBJAlvDD8wxPNWq5oV2Tiu4tfBVmMML7kWu5SV8sypmvU0lX0CFzqw+OO7mbpP+0FKU0urHkiM0je12502Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716139; c=relaxed/simple;
	bh=/kpickA8Z/8e74pCHhVcCuEk6cHJN5E6Onkqv1azeNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Un1OMQ9RC/BzzLevodcclBRytuO5UfWuUKr72vEJ80E+2LWeWyWShnXetCSAwUaVtHAKw3W8h6g5HHrknTlnkADFR/HEPg7PXH6puBwA5AtdpMqVWO4La+HGEHaWrsOkUdITtWw6ub9HQ91/B/UHLtcU7xAfcO9Qdd/GSjeyONU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGnImO8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGnImO8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322AEC3277B;
	Tue, 18 Jun 2024 13:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716138;
	bh=/kpickA8Z/8e74pCHhVcCuEk6cHJN5E6Onkqv1azeNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGnImO8AuvL0Oim1QMiRoZDwd6cgYChFvl0MeHhyM55c2KuDk0po6ZZ9S6ZA4Hcg6
	 8xJDJnNWaGKkPx/A59PKhbx38PkUMXUqtsXR3+fbhffwHrLSVWXeYSoAk11TdqqYbM
	 Fke+03MUMDHwsjxvpJZUnYXvHjc0gwjzK6ZIKt0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Ford <ojford@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 544/770] fs: inotify: Fix typo in inotify comment
Date: Tue, 18 Jun 2024 14:36:37 +0200
Message-ID: <20240618123428.306782755@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Ford <ojford@gmail.com>

[ Upstream commit c05787b4c2f80a3bebcb9cdbf255d4fa5c1e24e1 ]

Correct spelling in comment.

Signed-off-by: Oliver Ford <ojford@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220518145959.41-1-ojford@gmail.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/inotify/inotify_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 3d5d536f8fd63..7360d16ce46d7 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -123,7 +123,7 @@ static inline u32 inotify_mask_to_arg(__u32 mask)
 		       IN_Q_OVERFLOW);
 }
 
-/* intofiy userspace file descriptor functions */
+/* inotify userspace file descriptor functions */
 static __poll_t inotify_poll(struct file *file, poll_table *wait)
 {
 	struct fsnotify_group *group = file->private_data;
-- 
2.43.0



