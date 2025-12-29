Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850C62701D1;
	Mon, 29 Dec 2025 16:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025631; cv=none; b=d/n8fbO45H/rINwHIHgaH6siOd/WZwxyOg9nmM/iWCYL5c1ppEByZQ5FuwIqmjj/HiChqhk6P756nGzgf8Bx10zIas/4X9iU4iuH/bQDIgGnKnR98lJiBqLGHoqI/4p0s2SpQ4tFg01XKQoM9O53KtGRj9a9oq3L9pL5dyTsbUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025631; c=relaxed/simple;
	bh=r3mcXsd6iyjgUzSXfFZzrz8PL5vqSBoGB5kSOhZAHrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/LALNqboqB1cc7I/0tJt9YBlCaZ2TPxwhqDjE66k9D4f7jxCxrETUX4846Mh6YnE1Ac7kufSbkbGbNwWoj/WxBo7kbEKJn5Q5TroHAiOPmyW34bT3k7C09MOG94O1Dds6rFW5B/akDpXcL8iwHI6xpijeBBhHJdgIP5V82H68c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5q3qJEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5q3qJEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC502C4CEF7;
	Mon, 29 Dec 2025 16:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025631;
	bh=r3mcXsd6iyjgUzSXfFZzrz8PL5vqSBoGB5kSOhZAHrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5q3qJEmOp8Hgw7wf+/kB9HEN0iWpqNlMko7Msh5M3Xg9/PJu7GCUPxol/XBNLTi+
	 //zrqGBVgFu0RtC8hrptyRKXYPbucjlg6MYs+cwPTdFpzA3U1ThPfJv82/wb29hosj
	 gLTlnEA98Qgh+OUwEj0z811HmC31qBYJ0TLOA4EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 282/430] media: pvrusb2: Fix incorrect variable used in trace message
Date: Mon, 29 Dec 2025 17:11:24 +0100
Message-ID: <20251229160734.724114273@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

commit be440980eace19c035a0745fd6b6e42707bc4f49 upstream.

The pvr2_trace message is reporting an error about control read
transfers, however it is using the incorrect variable write_len
instead of read_lean. Fix this by using the correct variable
read_len.

Fixes: d855497edbfb ("V4L/DVB (4228a): pvrusb2 to kernel 2.6.18")
Cc: stable@vger.kernel.org
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -3622,7 +3622,7 @@ static int pvr2_send_request_ex(struct p
 		pvr2_trace(
 			PVR2_TRACE_ERROR_LEGS,
 			"Attempted to execute %d byte control-read transfer (limit=%d)",
-			write_len,PVR2_CTL_BUFFSIZE);
+			read_len, PVR2_CTL_BUFFSIZE);
 		return -EINVAL;
 	}
 	if ((!write_len) && (!read_len)) {


