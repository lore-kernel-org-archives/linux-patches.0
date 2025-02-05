Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E465B640;
	Wed,  5 Feb 2025 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763677; cv=none; b=TnazMIdQGj2krtHQENHkmKeA9ECUpJYPqswgH3xXU07SF7Vp5M88WQ8LQ7K3JEv+5jWH1wkXbHbrOG/PHhZi+7nUcoCvK1NZDQigOC888zr6gZEJxkzVgpTKZtWQKvQc9n8L8vFXym9y3UoAvVt7kRlyFS48E4kS6dTtMsedFLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763677; c=relaxed/simple;
	bh=Tg6c7CNLWJ8H8Qqggc4BOsbl0x1dA1w+67YrcOjwJIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0XcIdmQhnMRTQnLWQH3Q0goXQlxwhsK4JyChbiuolGHGXTzbxHgqQaZSGk9iwOy3z/m/JPocQBTJlLjsuSUltoJAzsObQRjI6R9jR+TCPTfvipHTKswBci1bnlUjywyc/qzg3iit0wAowupDBm84uf5tja+vju/4svoKpR5C8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSyvlM3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSyvlM3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA5AC4CED1;
	Wed,  5 Feb 2025 13:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763677;
	bh=Tg6c7CNLWJ8H8Qqggc4BOsbl0x1dA1w+67YrcOjwJIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSyvlM3ZtDMRhhAPCV2kcSosb3PU5g3b6cvVGsbWO/CfqD41SpVBBHzWecVwE0L72
	 SPOdbJa5r2ebEWeCk/YYoJpNXxaF7KYfwo/hbVy1qTcAd2LGDYYscafUi5Hz6fkI0R
	 T6gCvPR9oZSPI2Rg9sFKswi5M1K4XvFXS7Y+HIiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 008/623] fs: fix proc_handler for sysctl_nr_open
Date: Wed,  5 Feb 2025 14:35:50 +0100
Message-ID: <20250205134456.549374657@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 976736be47cb6..502b81f614d9b 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -128,7 +128,7 @@ static struct ctl_table fs_stat_sysctls[] = {
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



