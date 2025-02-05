Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDCA126C18;
	Wed,  5 Feb 2025 13:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763399; cv=none; b=shAU+ElAz74pmTmSfOPDG7ukLjHLgTKwzXyxV30Kmom5ajNVeo0y2UeU8kozfBocw3CFNsn8QtwGh3kfqoyNNDoEvh4HM3eGeBrXxg+MzhXavvfBCIZLpP+R397fsvYZZ7b/TVjiYnBppBDZqWaJ1mF7G56JhnthOMjmkcuutos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763399; c=relaxed/simple;
	bh=Y9CY3bY4GzwdUfN7nlDiT6gZD1FXURRuxx0A/+UVgTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuxZcv0Bou/CLmZHe62o8fMkDDoqvmo7THDOZgh56NEbIMuqJ61UhmCr7WgiciruBHIOL0EjoL5eWW/QF6maKSN/g/G+CnMxNde0wEmiSn321HRYYRiQ75tMvUZwS6hScDa9f3mfRLiZFAbKHfKxuApgjOZHS85hNdyeADIlpcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYV1ETqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYV1ETqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D14CC4CED1;
	Wed,  5 Feb 2025 13:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763399;
	bh=Y9CY3bY4GzwdUfN7nlDiT6gZD1FXURRuxx0A/+UVgTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYV1ETqp95DZ1PzKI0gu1rB0n6TjFJ8dVtlWGr0B19QAz9+w7ZdSKxsLdOLS7qMD2
	 X50jU0YWZGtrMmraZGeglKnyv2oDMNLsMnDfKfO2tFjJT3NVBvQtOXm3H0fGvUPLVQ
	 p6fhK5HIWew/g55KWdMrJU0JKKQxi314/fUmkWRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/590] fs: fix proc_handler for sysctl_nr_open
Date: Wed,  5 Feb 2025 14:36:03 +0100
Message-ID: <20250205134455.551038187@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index eed5ffad9997c..18735dc8269a1 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -125,7 +125,7 @@ static struct ctl_table fs_stat_sysctls[] = {
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



