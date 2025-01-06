Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADF714A617;
	Mon,  6 Jan 2025 15:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177912; cv=none; b=apTmnAnP9B9L9nwg0voOA4B9lW1ILK1HTPb/MdhutbQq1aY8KU9y3Zf2RjyzaucI6t6WtJo6GgEK7/hqKt2cqhM+3A+6Z5FhR4P5WTZACqb4rz3NdzfqrnK2eE7YiP8GPF9Q7x1TNLZMPAFJwczzZltuv9Vgr1wVt72imrTLh3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177912; c=relaxed/simple;
	bh=CFokBEMoaHM6di8G3nUzhBwuE1KTw2yWNlD5xA/2ALk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZIodhP8myhUkBMpNjne4HgVSFKLIoLKXzE0BeChY2rXZ+uJ02DHRrxp+dhZLj4BVfc0a/0bJ5NCN/Zwb9HSFOOr2r0yUq/RDvR2OMqhq5wmMKQvpQBJExrQaSZ7n7uXfgsCzFKvqHetRb142yLyFv8NGQkYPzmno+4BuR2Sqis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9yvLpb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9yvLpb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09B2C4CED2;
	Mon,  6 Jan 2025 15:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177912;
	bh=CFokBEMoaHM6di8G3nUzhBwuE1KTw2yWNlD5xA/2ALk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9yvLpb6h8MnXFtBbUNsiIpYtX4sj3HyHWzgpHHzdY1cfqk9jsKeFVrCpCx56rX1Z
	 9w19rObpGhNR7WpErxbUWFVPybDjheyQISUglCL/3Sodx5tWrdjFEGecBaJXQviWoX
	 SUtsbg6YSxaliJ3XeayJPTkOTdfJxjBIuBs0Zk98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/156] smb: client: destroy cfid_put_wq on module exit
Date: Mon,  6 Jan 2025 16:16:25 +0100
Message-ID: <20250106151145.454560212@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 633609c48a358134d3f8ef8241dff24841577f58 ]

Fix potential problem in rmmod

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index bf909c2f6b96..0ceebde38f9f 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -2018,6 +2018,7 @@ exit_cifs(void)
 	destroy_workqueue(decrypt_wq);
 	destroy_workqueue(fileinfo_put_wq);
 	destroy_workqueue(serverclose_wq);
+	destroy_workqueue(cfid_put_wq);
 	destroy_workqueue(cifsiod_wq);
 	cifs_proc_clean();
 }
-- 
2.39.5



