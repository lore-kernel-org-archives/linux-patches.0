Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391E51A314B;
	Wed, 19 Feb 2025 09:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955943; cv=none; b=Wy0NWZxKaBH99fXJ5HQqJTkmwfMLALHPIUeoJjMk50TKZFXD0lyDKrrATEIAEJomiJUg27nTanfefyLh/jVFhH+p52KrTiJh7KAf/UVF/6t5YjKnnVs+uqCjqwsN3B3p3y7vUaYlN5FKWYfNUaR8MNQfj9YHN1crRN28myItwMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955943; c=relaxed/simple;
	bh=r7FhFREqFlhTUa/D2YBhaP9hWtKbGkkO9VH2R0dUfLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGUzSGsZqCDtTLwMN5c75JtMNf/2gTBI7TEblg+f8E1I/TCT012h9g0YzZjzqcq3r1S8HM13b/vjQFghTvVHUx82uURTYzfrD9P++e3+Ll/hIRN3UHBinlZJbBSHhKxI23A1YLFH+Cv8DMxzOX5TQFlxFJzhN7d9t8PTWB1pYEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUMay1zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUMay1zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3626C4CEE6;
	Wed, 19 Feb 2025 09:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955943;
	bh=r7FhFREqFlhTUa/D2YBhaP9hWtKbGkkO9VH2R0dUfLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUMay1zcaFKfx0jz3sJECExNThFS3l1c1wnhKsOjElUGb/JIZ+Cl7JYSAwYXcnZUP
	 TgS08utat8/moco3cwp0bjWFeTfIvbSyhStXMmQzIv05VNcYTjrP1axAArMVk7nUyX
	 U1g4yfPFGJ1un1vJe7bipDbfYm5eHoh2mq5Ron0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/578] fs: fix proc_handler for sysctl_nr_open
Date: Wed, 19 Feb 2025 09:20:08 +0100
Message-ID: <20250219082653.072916792@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dd88701e54a93..cecc866871bc1 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -110,7 +110,7 @@ static struct ctl_table fs_stat_sysctls[] = {
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



