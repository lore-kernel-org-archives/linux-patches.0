Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AA92E973F;
	Tue, 17 Feb 2026 20:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361400; cv=none; b=rjdYYb/12JQxqrRMvRqz0zV5nGblN/UKbWT0fzoxb2Dpi6P7JtqQlwA+TvJ2hrYQj1LmVqeRLDys/mndRhNQnsQLQtH9h/pLerepFiiia1oJ6sPwgJT1CQd1JxRJVG04Fl6UgwbLeuomGHhupOTA1zGqW5gaBcHznpx2i5SKnlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361400; c=relaxed/simple;
	bh=J08MPTXFFcmIt1CUh27u/ORZSpirRQQrdtdWmgaWRVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcKq+VvgcT0RGhx0seL1TkmBGtkmH2dtQ8VBQGoJRAOzTKpPO9MMgrqwBHVnwsBRPv0a8QGU8R7aI5tDmijer8HbgbhGFw+m7xHQd5BdG+HT+o/XCQU9J8hLIqLJrtsPFv767DSQEjHUR2/LNniEgtvuZHENTU1rz45Cipd87t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGh9rsrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGh9rsrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACCBC19421;
	Tue, 17 Feb 2026 20:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361399;
	bh=J08MPTXFFcmIt1CUh27u/ORZSpirRQQrdtdWmgaWRVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGh9rsrNR5lXzKRLCYC5mN3iJWg01IULmL1Ht0q+EHzFFQv6fxrbwKW57RcL6pc7n
	 RsIIgCbwx2YuDC+KAR1taPWNLjA0cWeVnbD1aldZxRoiL9ZeGOi5UlfDMETC7YFDr3
	 8SqIzMjDtlpDkrRo0r00wdaAwjj4TSOwdCAxzO7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.19 07/18] f2fs: fix to check sysfs filename w/ gc_pin_file_thresh correctly
Date: Tue, 17 Feb 2026 21:32:03 +0100
Message-ID: <20260217200002.973285440@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
References: <20260217200002.683975158@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 0eda086de85e140f53c6123a4c00662f4e614ee4 upstream.

Sysfs entry name is gc_pin_file_thresh instead of gc_pin_file_threshold,
fix it.

Cc: stable@kernel.org
Fixes: c521a6ab4ad7 ("f2fs: fix to limit gc_pin_file_threshold")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -749,7 +749,7 @@ out:
 		return count;
 	}
 
-	if (!strcmp(a->attr.name, "gc_pin_file_threshold")) {
+	if (!strcmp(a->attr.name, "gc_pin_file_thresh")) {
 		if (t > MAX_GC_FAILED_PINNED_FILES)
 			return -EINVAL;
 		sbi->gc_pin_file_threshold = t;


