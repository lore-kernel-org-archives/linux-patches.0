Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7B33E3DB6;
	Mon,  4 May 2026 14:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904879; cv=none; b=XsO1VLy25UPnehzrl++H2djirEHkoZIUFQsWZHy34nA6d1ycfMJ3/zNjoO3qWuBGp+uZMhJfzpl6YmG9jRURl6YepBh74vQSKI44gyLqKqoDzZ/CwKkoSBgEIj0kiOB5TfuYHG1qyUGqk191kCn2vkaDGkvqQsi/xiPNDjpiulA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904879; c=relaxed/simple;
	bh=+yFTBH2MpJnTyHHcCkA1ZuGtaftV+4b1aWA385ovsH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YI9RjrDKgUvLd/h5QqaQcqGPFcBGSZKe7VYRYvKu6qli0XkE1bf4Rz6a/9JHAwny9ER2Sqf18/nvKspBEwAOHrfPwpuzhdQnoW6nPqUyTvTBtSjrhigBnKLkf268N4negp7BJBR/n92fz0Znhfiucfl/iHDJVrGE6Q3CsxHS4HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Azgjy5V+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Azgjy5V+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BC6C2BCF5;
	Mon,  4 May 2026 14:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904878;
	bh=+yFTBH2MpJnTyHHcCkA1ZuGtaftV+4b1aWA385ovsH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Azgjy5V+hfMrDLRzL5GvyTyiMjo+CVCSusorYaKwvhZ0dAfikdAFZ7C8i6iVQ+R2T
	 A2Eh4xGY7MWRPu4Ej/VVL3qKrZs8JSem0+JWJuVpYmkuvvpSC2Mg7WsebE7wIgLNaS
	 gEKjOdzPtwOBN/DUahj9vDq9A+CPzVyZklUM5P1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/215] ksmbd: use msleep instaed of schedule_timeout_interruptible()
Date: Mon,  4 May 2026 15:53:16 +0200
Message-ID: <20260504135136.671879597@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f75f8bdd4ff4830abe31a1b94892eb12b85b9535 ]

use msleep instaed of schedule_timeout_interruptible()
to guarantee the task delays as expected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: def036ef87f8 ("ksmbd: reset rcount per connection in ksmbd_conn_wait_idle_sess_id()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -495,7 +495,7 @@ again:
 	up_read(&conn_list_lock);
 
 	if (!list_empty(&conn_list)) {
-		schedule_timeout_interruptible(HZ / 10); /* 100ms */
+		msleep(100);
 		goto again;
 	}
 }


