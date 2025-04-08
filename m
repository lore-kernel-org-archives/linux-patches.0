Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A76E2063FD;
	Tue,  8 Apr 2025 12:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114974; cv=none; b=St4abKNPTHVNpS+hbIiWVy/3ZLZ285EdNuJK7ieHg+Ho3ULQcr2M1lboqzkKuVcd+/i9/irNV8cx7VjkEEj0zSVZWmCIe8QkwqDwvrdhu2pimCjVPMG9oo7VSxXLdYFW2p2g+brz/QndGHRlfTdwj92n2LI21DGAYQw+ox4pf1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114974; c=relaxed/simple;
	bh=D6I8ZOL8mVCRJi1SYCWt+SmkFDSR/5zl6jf8+aUKlZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOHl6bEmlOfsRo63l8sWfBXbEqYP1u1Y+jgKKk9dDgHUVgbrm+cvb5/jrKYdZ6Y00GaEBpNOSSre5tVLD9S5CQ72mus66dFZyjiM1RMdtZefnHjiSLwYUNohYXTgGRQWXhHlQ3zl7166bE61XUYZj1cuKvg8j8gxVq/5NqHl6V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1g0Yvof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1g0Yvof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC143C4CEE5;
	Tue,  8 Apr 2025 12:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114974;
	bh=D6I8ZOL8mVCRJi1SYCWt+SmkFDSR/5zl6jf8+aUKlZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1g0YvofMXktLvDrJ+ydHkL5dzpWh/IleTzXcs9pq80d3BQf/w6OwxkgO6SolBV0r
	 217AiNJMABl5WnfQt82DDEkt9KvkpUlBK058+wwCFU8PNYWAUiRuXq9STc4GUMXISM
	 S298t0HRBBHCPYaI8bG2kOsiiHz2O5z4jJ/tAHkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Lothian <mike@fireburn.co.uk>,
	Elizabeth Figura <zfigura@codeweavers.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 304/499] ntsync: Set the permissions to be 0666
Date: Tue,  8 Apr 2025 12:48:36 +0200
Message-ID: <20250408104858.799495341@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

From: Mike Lothian <mike@fireburn.co.uk>

[ Upstream commit fa2e55811ae25020a5e9b23a8932e67e6d6261a4 ]

This allows ntsync to be usuable by non-root processes out of the box

Signed-off-by: Mike Lothian <mike@fireburn.co.uk>
Reviewed-by: Elizabeth Figura <zfigura@codeweavers.com>
Link: https://lore.kernel.org/r/20250214122759.2629-2-mike@fireburn.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ntsync.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/ntsync.c b/drivers/misc/ntsync.c
index 4954553b7baa6..c3ba3f0ebf300 100644
--- a/drivers/misc/ntsync.c
+++ b/drivers/misc/ntsync.c
@@ -238,6 +238,7 @@ static struct miscdevice ntsync_misc = {
 	.minor		= MISC_DYNAMIC_MINOR,
 	.name		= NTSYNC_NAME,
 	.fops		= &ntsync_fops,
+	.mode		= 0666,
 };
 
 module_misc_device(ntsync_misc);
-- 
2.39.5



