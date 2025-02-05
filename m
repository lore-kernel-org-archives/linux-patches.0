Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902E4B640;
	Wed,  5 Feb 2025 13:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763299; cv=none; b=FV1yo920SmcFZ7chZei20ToROQ/xVVMt2aOrBdyKtcHAnJnQHKVUVue4Lm9HVUplGoZ+/U0krvXF3urT710tR+au0Xqs+12yylaoSGKc8KDJn40eR7/2cAe4VaoC5vUoKSks6zCUbvdrY/W7udc9kHRm1XFT7hwt289CsXHdHGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763299; c=relaxed/simple;
	bh=xqoR5rhpFukXLwOevTASphH3JYj4zDfdI/QHpJgk3LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgifvWhoElGXrIpD1XXQK0+L20UgM/DCNXeZcMA69imHH50yNA5jT/nm3XHU0oeufXmBtFrWGi6UNwSqjNQv6/SsfKjQn+Ogc3y+q4SFM+XxP8hFPdTKYW/srHj4hhiMMj35f+gU3XcToIZbT6DDLzv2HTNOqqzPRTMRHpZpakE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPV36Rkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPV36Rkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92058C4CED1;
	Wed,  5 Feb 2025 13:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763299;
	bh=xqoR5rhpFukXLwOevTASphH3JYj4zDfdI/QHpJgk3LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPV36Rkfu1ktgfNtGivaOgjb9Sp/HC0v0G2OrnYJg7BDIfooxfCr5hYruV4CtV52D
	 KYJOJnXESyVWXv5jF519eHCiW+z5z+W+CvsJg7Q/Hu7awKU81+j0ttQ9730mgOamIu
	 XeR3GyJX38Kl+n+9PsDLY1gTR+XXjQOoDMstwwFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/393] fs: fix proc_handler for sysctl_nr_open
Date: Wed,  5 Feb 2025 14:38:45 +0100
Message-ID: <20250205134420.535001110@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinliang Zheng <alexjlzheng@gmail.com>

[ Upstream commit d727935cad9f6f52c8d184968f9720fdc966c669 ]

Use proc_douintvec_minmax() instead of proc_dointvec_minmax() to handle
sysctl_nr_open, because its data type is unsigned int, not int.

Fixes: 9b80a184eaad ("fs/file: more unsigned file descriptors")
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Link: https://lore.kernel.org/r/20241124034636.325337-1-alexjlzheng@tencent.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file_table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index ee21b3da9d081..234284ef72a9a 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -133,7 +133,7 @@ static struct ctl_table fs_stat_sysctls[] = {
 		.data		= &sysctl_nr_open,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_douintvec_minmax,
 		.extra1		= &sysctl_nr_open_min,
 		.extra2		= &sysctl_nr_open_max,
 	},
-- 
2.39.5



