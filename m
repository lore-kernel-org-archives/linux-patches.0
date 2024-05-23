Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAB213A897;
	Thu, 23 May 2024 13:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470715; cv=none; b=WIXYxO6UB40/bwBd8zqZcbXcOEvz4tqGbRlKrLwNY0+uNxAvVhzxWu1wIgWGhYYaDg5V4sm1avlWZA2H8IFbL7ag9H23NFjfsiFfUWjVxDhEIRPqWJ13Srg4brxkv1HRhec9bot2g2JdSErEQrXOaMIFQ1ccoPKymmM9gWcQTiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470715; c=relaxed/simple;
	bh=KfbWAN/7c4UqAWvUo66/lPHRW8sZJCLu+CAy5nxcqD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKn81FCE9cxVHWZ9uXae/Ai/8xzfV5+7L/QcJ13iqD80aqvU0P5IOQhu3DouBmZ0x0cSWIR/uLEEqmBoyS3Jqtp1F3VCaBD3XivviX5bZqBVHHiGyO7xBrBtA+OrYeSxLudVBhTJxoAZOko4+E2yDrXHOUpAExblHCWZo599gP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVNwNGzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVNwNGzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54015C4AF0D;
	Thu, 23 May 2024 13:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470714;
	bh=KfbWAN/7c4UqAWvUo66/lPHRW8sZJCLu+CAy5nxcqD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVNwNGzor0jjXR62UiPNZTWh161l/IA0YJ7ets7epLoMRAxu15IxPPV1AS+pwfStb
	 GvLAe2kP5BJCSx3/wUVD+zPT0BXzETq7aW3IgmERr4HRZFrjAPxYj6XLxHnuQ1uPxf
	 bmbE1/Es52EVv6/aTIly/03sMFCYMi2TxyPYR8ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/102] cifs: remove redundant variable assignment
Date: Thu, 23 May 2024 15:13:28 +0200
Message-ID: <20240523130344.847200822@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Bharath SM <bharathsm@microsoft.com>

[ Upstream commit 2760161d149f8d60c3f767fc62a823a1ead9d367 ]

This removes an unnecessary variable assignment. The assigned
value will be overwritten by cifs_fattr_to_inode before it
is accessed, making the line redundant.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 67ad8eeaa7665..b304215a4d668 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -401,7 +401,6 @@ cifs_get_file_info_unix(struct file *filp)
 		cifs_unix_basic_to_fattr(&fattr, &find_data, cifs_sb);
 	} else if (rc == -EREMOTE) {
 		cifs_create_junction_fattr(&fattr, inode->i_sb);
-		rc = 0;
 	} else
 		goto cifs_gfiunix_out;
 
@@ -846,7 +845,6 @@ cifs_get_file_info(struct file *filp)
 		break;
 	case -EREMOTE:
 		cifs_create_junction_fattr(&fattr, inode->i_sb);
-		rc = 0;
 		break;
 	case -EOPNOTSUPP:
 	case -EINVAL:
-- 
2.43.0



