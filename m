Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6A6322DCB;
	Mon, 27 Oct 2025 19:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591920; cv=none; b=atWA38TAJq9225yTIU/xHgwupDoXyTqCfZzOVoCNuOnSFk6JhgQ8QOFh8uBZyW9mlBDELwOYr2EYsH48zo5xQmMIm0lo0tf4hbCad0nZtpMjFFrtlU26BchUs/iMCL6E6DQMzzfw181bwGl0usgow1ML7IqHtrCNyGDHpAc+Kbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591920; c=relaxed/simple;
	bh=FRbEd9TwZy5Q0+mqewBBs3iJhCEEe4Anp1Xw2/lgFBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilyubuO/tCEyhslOwMo3EFr30b6BL2BSR3gmlWIkh3A637SLMX3eO8hmvU7J5C2F7TRS8dj8nH1xcW/7s2XddTLCTSyuuQ54SGJ0QgcLKCcsxnb4AEZ26tteeay+J++CHcTXsW8+DxQNaz4foZdY1FONcyM5CohCxJl6Z0K2H18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnqPgdIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnqPgdIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D93C4CEF1;
	Mon, 27 Oct 2025 19:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591920;
	bh=FRbEd9TwZy5Q0+mqewBBs3iJhCEEe4Anp1Xw2/lgFBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnqPgdIjP3lpzEjC6nowfOF4WytK5zPuSvBke8OpjxGxlrhICE2PXRR7jfzoYMR/h
	 I+JmZItqu9uZYVaW/mdkWflH0BGdns4rr+8oYwy6Y+aP0QRAQcJXvsos8D8k/odMzN
	 cSfcgBQLWkR4fpe5h2z61LqM4xwcDUWUs4mgx+Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/123] dlm: check for defined force value in dlm_lockspace_release
Date: Mon, 27 Oct 2025 19:35:28 +0100
Message-ID: <20251027183447.683517053@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 6af515c9f3ccec3eb8a262ca86bef2c499d07951 ]

Force values over 3 are undefined, so don't treat them as 3.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lockspace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index fa086a81a8476..5394c5713975d 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -785,7 +785,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	dlm_device_deregister(ls);
 
-	if (force < 3 && dlm_user_daemon_available())
+	if (force != 3 && dlm_user_daemon_available())
 		do_uevent(ls, 0);
 
 	dlm_recoverd_stop(ls);
-- 
2.51.0



