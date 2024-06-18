Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D994198856;
	Tue, 18 Jun 2024 13:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715891; cv=none; b=m6nURa6GyV5QXEERzTUa+dh6kTywrl0bMw4GmV+K3VbdiLyJz+x5fZPGI8l0lTCWOUcr9smzhNgbBy/VpbzWTAfAurgfW4s5BsqzvATo0/010LtsTRsjDbQ7AAlrEsFGkcFQwC2jmPVaZEGqo25X4+9L8gOUj9TtPXuIDqqAaxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715891; c=relaxed/simple;
	bh=upNMw2ZykPSyJrcukkwGuV1Y2btGSUT2/7pqzvNml30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kCxHF70uuvGpIcH0/SIlf5/GPhymxdDJv0CtUG9gBHVfwZfPR4NneQZkx+AjneVt4R7PRqOrBKoW1vRyUZa2lf452aKChP+XAe8b8jfEaHw+Zr5jq5/PitTuhInvAMVadKGp1OgNmdMQV3TOgZ41BM/EAAKHFcL84AWOuOr0pe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TAJBewv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TAJBewv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0583CC3277B;
	Tue, 18 Jun 2024 13:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715891;
	bh=upNMw2ZykPSyJrcukkwGuV1Y2btGSUT2/7pqzvNml30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TAJBewvvXv6GfLhednpQmCmTlIFhyDgNa699r2C1uc0adWhUJXGG1a6FdIvqh8Cr
	 wpDUcu6G8bDo6BrWgPiq2TIMtPU4YD6djo7Q9gHmH4VvBaFlE5+p3i6MEe8bzU/Gbg
	 504DDOpwjhb/hL9kbl1ffkD3R9LdMjPSbAAC9/Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 462/770] fanotify: remove variable set but not used
Date: Tue, 18 Jun 2024 14:35:15 +0200
Message-ID: <20240618123425.145924253@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 217663f101a56ef77f82273818253fff082bf503 ]

The code that uses the pointer info has been removed in 7326e382c21e
("fanotify: report old and/or new parent+name in FAN_RENAME event").
and fanotify_event_info() doesn't change 'event', so the declaration and
assignment of info can be removed.

Eliminate the following clang warning:
fs/notify/fanotify/fanotify_user.c:161:24: warning: variable ‘info’ set
but not used

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 3bac2329dc35f..6679700574113 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -146,7 +146,6 @@ static size_t fanotify_event_len(unsigned int info_mode,
 				 struct fanotify_event *event)
 {
 	size_t event_len = FAN_EVENT_METADATA_LEN;
-	struct fanotify_info *info;
 	int fh_len;
 	int dot_len = 0;
 
@@ -156,8 +155,6 @@ static size_t fanotify_event_len(unsigned int info_mode,
 	if (fanotify_is_error_event(event->mask))
 		event_len += FANOTIFY_ERROR_INFO_LEN;
 
-	info = fanotify_event_info(event);
-
 	if (fanotify_event_has_any_dir_fh(event)) {
 		event_len += fanotify_dir_name_info_len(event);
 	} else if ((info_mode & FAN_REPORT_NAME) &&
-- 
2.43.0



