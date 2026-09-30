Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61C65208B3;
	Wed, 30 Sep 2026 17:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790367; cv=none; b=NrgXez+K03K21cIgHU/PNvMe0BFFPXbyUowlD+er9VqEwTzq/jUEUxjrmLCQdZlX9V8O1vfvVA7EqW5lghs5MYknZ7WHT9DI0LbIhu9xicxDKLKyoQG/gxBHFO20XVEX3v8bISPRszKQvZTypt8OFSuD0VWJFnhdm07y6BodAEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790367; c=relaxed/simple;
	bh=Vi1703eo/TOEhunZrKRjatTxyu7m+pCoCgsQ9z4nrGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmXjjrTim32XYO8H/ks5PKlAXhmaHhXIyh75IsvyjDsFifNE3Eu/Nh5qLdhk9UHQhR7mrBepxS9BCLQt7zUB/xYTN+fNAhsQzlUdDJcXsnazIUarHVWCIigV0LC49e0NZxe3zWt8tOG5TbfxnJMQ2f9UIOrJlFYzd2y86Q1SU6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tt/HHUJ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tt/HHUJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB831F000FF;
	Wed, 30 Sep 2026 17:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790366;
	bh=S7La9Imq+L0ZUjFckl6x8LPuZKFAT5F4rDFANccQDUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tt/HHUJ8GksvjOU6Y0njuqFflI9nZolgLAZFHoo6Bg4eOjQCxk382GkP9x+v3m64J
	 brUBs5yw0pKIqLGA4MBfF/WXNWAmjAfkvm3Pu6GXJfpwVvWUW3+FKgTOzb8+pOxMmB
	 aDueCNH+19hr8DCsCBCCDszHmIfJvrLknyJ0yxug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 804/877] smb: mark the new channel addition log as informational log with cifs_info
Date: Wed, 30 Sep 2026 17:28:35 +0200
Message-ID: <20260930152432.065645262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Bharath SM <bharathsm@microsoft.com>

[ Upstream commit faf1b64888ff13caa94fa09835fcfdabee18b057 ]

For multichannel mounts, when a new channel is successfully opened
we currently log 'successfully opened new channel on iface: <>' as
cifs_dbg(VFS..)  which is eventually translated into a pr_err log.
Marking these informational logs as error logs may lead to confusion
for users so they will now be logged as info logs instead.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: d034e836eefd ("smb: client: fix use-after-free of iface in cifs_try_adding_channels()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/sess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -267,7 +267,7 @@ int cifs_try_adding_channels(struct cifs
 
 			iface->num_channels++;
 			iface->weight_fulfilled++;
-			cifs_dbg(VFS, "successfully opened new channel on iface:%pIS\n",
+			cifs_info("successfully opened new channel on iface:%pIS\n",
 				 &iface->sockaddr);
 			break;
 		}


