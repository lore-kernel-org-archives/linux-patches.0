Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3E17C6C9;
	Mon,  8 Apr 2024 13:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584165; cv=none; b=peFQWdDJfqs/ljelqr8wjGoHt94KAPVarqCJpd7msCcX4NlluFLz+Umg9YghOaGv2SGYbaxDo1LHbsj9ay+ZiIfsQVDLPoEwDHgmHv+VAifC39VGa8D3KU/4m0MqKBtBHwzbiZkJMw0oRPST+hX1CD1o8bgbNMeB17zlVkjzaL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584165; c=relaxed/simple;
	bh=BMydoNVYkSprmKMeKhzDTM9k+pdqIqnkz7GphRrQm3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4QefDnjlXFGc0qIyPL1ezIUKxSpUNpmkr1cZ8/FtUrB9jOMiqjDcGgv9ZxOchBmojFdnj9AAFSKjjB7A2WO6gUVmapYyML9gbI9Xkdmmc6pi1QfJMJPXHCvg9qv4A/FDmx2LJoSIcvqJDtDGFg76y2j+1Re0iIupEAW5gnbxkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzFpAFrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzFpAFrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E11C433C7;
	Mon,  8 Apr 2024 13:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584165;
	bh=BMydoNVYkSprmKMeKhzDTM9k+pdqIqnkz7GphRrQm3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzFpAFrf8R5nEqSVol/i+CCbZ3ln2JQ+AAIhN7y1qEnKp1T9UQRoq4kfiQSsGC5/N
	 zSsOhdz9zxBTOGTE7R7GWZxCkACsGypyH9yl3H0pBFPckkSOJJZi3PV+PmdBAA5X2j
	 aJ5KM7uL6Ky3KlSBGgtyFszAJMn1dq20RcN8rnjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 344/690] nfsd: remove redundant assignment to variable len
Date: Mon,  8 Apr 2024 14:53:30 +0200
Message-ID: <20240408125412.067998383@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 842e00ac3aa3b4a4f7f750c8ab54f8578fc875d3 ]

Variable len is being assigned a value zero and this is never
read, it is being re-assigned later. The assignment is redundant
and can be removed.

Cleans up clang scan-build warning:
fs/nfsd/nfsctl.c:636:2: warning: Value stored to 'len' is never read

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsctl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 0621c2faf2424..66c352bf61b1d 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -633,7 +633,6 @@ static ssize_t __write_versions(struct file *file, char *buf, size_t size)
 	}
 
 	/* Now write current state into reply buffer */
-	len = 0;
 	sep = "";
 	remaining = SIMPLE_TRANSACTION_LIMIT;
 	for (num=2 ; num <= 4 ; num++) {
-- 
2.43.0



