Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E64622094;
	Tue, 14 May 2024 11:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685102; cv=none; b=M809SfSYQbAwydyAJq+z1sJvBJX89hFtKXtlrWxYyZMoRpUsQrIQ/cWE9sosP/cf01WiiEaQPr4aW1lf9FFdIZyI5i9b/7UJgwC4uceuQVtooBL9/kXVR831JmvSpRh2CIi4t+Z6h+sGo5VBSEUTX9x7HbkuOAj4xDjEGGa9IUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685102; c=relaxed/simple;
	bh=Yd7xX1ONvPixy87zMFFJihDAJjFMQEC81aGLZg9Unbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWbUtJvOBuGwOP5dL0JWDoExRNerVANycazrWSlJs4mbFWDJQd2PgBFlW0xdl+FK/FcL8ucPocYH+/LEQNslk9amhKbzlV1bHJJBz5LMw7ZYLRW7GxWQtUizHSluQqRG+t1F+EF+Hc0nHPWo2+9cS67e7dqOA0wdwpgYAWJxxMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zunH29Mr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zunH29Mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F49C2BD10;
	Tue, 14 May 2024 11:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685102;
	bh=Yd7xX1ONvPixy87zMFFJihDAJjFMQEC81aGLZg9Unbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zunH29MrfEXlXgs9HbvGkXXzHlFDAHslGNFPt5lNeGCFfFssNSt1fqSmVZyRIZ1Ns
	 em97jykdO9nDcD2EiK6OOAp/ukTi0GWPlEeWkRJBPbL1FeCJPdDe+UJZPv1ZjH3rk9
	 RjITbNT5nQw5ivSPBHyRqcmBGDShLKnTuIUKgbow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/301] memblock tests: fix undefined reference to `BIT
Date: Tue, 14 May 2024 12:16:49 +0200
Message-ID: <20240514101037.465196510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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
index 6583a58670c57..dfde1e1e321c3 100644
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



