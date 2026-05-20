Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9295E347512;
	Wed, 20 May 2026 17:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297421; cv=none; b=GsFi3F31qTNbcmihWHBRx1MqTvIB8ORXAcClXWBYsMFqngu03rTYy0ZJ7KOHNCMpVCXBqemSqx1OvlIpoD7qkWzsnqD72l6v48Mc1HNgtihwYgpfuR5e/4q+sQuwr+A3DPmV4Fe+MX54qhJQ1cVxRru7G35KQVgAsR8clcUb5xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297421; c=relaxed/simple;
	bh=+Clh+3mq9bBX+HFglWyytg4i4VEeiJGCPLSHifec3FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAqGpvI9uInmxHme/2/ZdvRy4ozYcxp6BY+7KPl3gSxfuyyZBcQtGNRlO+RMruRdvi/2iPeiKRmPHENJ1lRiNxw6kBKCFeK8UdwNu09UlkOMZIMMkFgRFP3hQwGHOYtbuxinop5iww+XGYzVrzrlVFF/59uOPrgrczNcEG1SoTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSkMwOUX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSkMwOUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6C21F000E9;
	Wed, 20 May 2026 17:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297420;
	bh=eyg0IkLSEi2VeJvdbtB8jnd8xRTWZ2mthapPLCcTFfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSkMwOUXhzNKKAlcKvPSA3zYU5DgaOe0U7TBNTw+aGU9TClmWv0WUeEZdHEXuNMtd
	 mahTwwoxuNliXYjuH94fiSD34bLXFtcvqr55zW6TDbgcgRTrMBWNFp9mkPaffWh8wj
	 /f5SNbaI3l38WdhQwsGva3j30SSWJ88KItuBRhUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/957] debugfs: fix placement of EXPORT_SYMBOL_GPL for debugfs_create_str()
Date: Wed, 20 May 2026 18:08:28 +0200
Message-ID: <20260520162135.104765652@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 4afc929c0f74c4f22b055a82b371d50586da58ca ]

The EXPORT_SYMBOL_GPL() for debugfs_create_str was placed incorrectly
away from the function definition. Move it immediately below the
debugfs_create_str() function where it belongs.

Fixes: d60b59b96795 ("debugfs: Export debugfs_create_str symbol")
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20260323085930.88894-3-hanguidong02@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/debugfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 252fca572eb76..880a8a9deacfe 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -1047,7 +1047,6 @@ ssize_t debugfs_read_file_str(struct file *file, char __user *user_buf,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(debugfs_create_str);
 
 static ssize_t debugfs_write_file_str(struct file *file, const char __user *user_buf,
 				      size_t count, loff_t *ppos)
@@ -1142,6 +1141,7 @@ void debugfs_create_str(const char *name, umode_t mode,
 	debugfs_create_mode_unsafe(name, mode, parent, value, &fops_str,
 				   &fops_str_ro, &fops_str_wo);
 }
+EXPORT_SYMBOL_GPL(debugfs_create_str);
 
 static ssize_t read_file_blob(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
-- 
2.53.0



