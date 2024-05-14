Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098C357CBC;
	Tue, 14 May 2024 10:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683165; cv=none; b=eLu/qawcCSh6ib8gbOsy3pQHKsn7u7de967VbHGGXQoKXgv05HfohW4xHfp3RC+YLN7oygHlVd7sl7+uX8ZNQpiX2rcbyUR5mW8dslLnev9QNnKWztVWYILAYuT5oVwFMqhl2dmJ+gjpr9YE659ubK0TKY7Ocgfc4sVejEMOQ7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683165; c=relaxed/simple;
	bh=OXebOZYgVt5/rhhBk3HKlJBZwqdrKCtU2aA9RaLq+x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5BDpY1zKH+5L5GbV8wVuBP0HvQ8Md7fBmMlZ6/Lu+Rj6AUT14h6KYnZ3cGr1rMnm10Cg+YitGWfoIaOlgjqg7IHaql4RtnOwgI3a6Kdys/opXyzeHlPVKx5ul2mdrVPgX6LeHNKFdrAMXUKK7Ishq01JVI/UQgmXDUGYJk7GZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYCBI5Lo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYCBI5Lo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A06C2BD10;
	Tue, 14 May 2024 10:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683164;
	bh=OXebOZYgVt5/rhhBk3HKlJBZwqdrKCtU2aA9RaLq+x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYCBI5LooyFx0eqB35A/+LogNjojk7P2tmBKkxKKHNaveOD02ggwxrbIOCjwr/6WL
	 3gjWE15rhXm3ZhquuwifHjFqBHb65svdofmubAFCZH1Tjzrouk3wFSOulsgqoyUOQR
	 mRd8RkwYj8hbbFVsjjQFGYESu1fO/Rv3uetQFisE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 145/336] memblock tests: fix undefined reference to `BIT
Date: Tue, 14 May 2024 12:15:49 +0200
Message-ID: <20240514101044.073562442@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

[ Upstream commit 592447f6cb3c20d606d6c5d8e6af68e99707b786 ]

commit 772dd0342727 ("mm: enumerate all gfp flags") define gfp flags
with the help of BIT, while gfp_types.h doesn't include header file for
the definition. This through an error on building memblock tests.

Let's include linux/bits.h to fix it.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
CC: Suren Baghdasaryan <surenb@google.com>
CC: Michal Hocko <mhocko@suse.com>
Link: https://lore.kernel.org/r/20240402132701.29744-4-richard.weiyang@gmail.com
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/gfp_types.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 1b6053da8754e..495ebf5f2cb6d 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -2,6 +2,8 @@
 #ifndef __LINUX_GFP_TYPES_H
 #define __LINUX_GFP_TYPES_H
 
+#include <linux/bits.h>
+
 /* The typedef is in types.h but we want the documentation here */
 #if 0
 /**
-- 
2.43.0



