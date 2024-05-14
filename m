Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11B718026;
	Tue, 14 May 2024 11:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686473; cv=none; b=kPSXnB43iREHK+kr/qM2WuBiK4m61/xgtsU+sa+CCEKFRsA5Xmtap1KFWkCO51j+iDxy4Dje+iQnyyVlpDwTy6hQaYh47RPVUTz7I3MyfarDIVZeLnTAA6XBnDjj7H0iFdTCqvGgbmdFxLKzMazN8uU5/IRzE8rjEyU1AdcuHOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686473; c=relaxed/simple;
	bh=PyiPfWXpd2ARZ7fp1rfB4a74bN7OW4c5T1GtDKwwfOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeBmsQFuNHAKh4FeOZYd1rA9dNR6VPQ3+CM6UDe2H9V6SLbEqbPX2QdIWDzNSLaYs0IFMcGE+3jetxgV6xqbdPLR4cOWbBprdn1emNMJ9BGwdFp0UEyU8jnZTpTHi4GEDjxo1leNf4VTYDEZjklEHVxBfwgF5Ym2QcoWL4l1KVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXDhoTpv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXDhoTpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598D7C4AF09;
	Tue, 14 May 2024 11:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686473;
	bh=PyiPfWXpd2ARZ7fp1rfB4a74bN7OW4c5T1GtDKwwfOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXDhoTpvVXCflPASJo6JRUJPy4Th1sHN72O0EDurAvpotu8GMaaelPbmYolrqGAIK
	 t00y7Bg8TlRVjTUkEIiqL454ERCmx8Hrw7ipUSJU60fjOigbgJDeGlnnHevdfXQSxv
	 +0FKwyJ12gYS4cYrwKo7vdD7wWZ6bOSLbx55ZHGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/236] memblock tests: fix undefined reference to `BIT
Date: Tue, 14 May 2024 12:18:01 +0200
Message-ID: <20240514101024.888996851@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d88c46ca82e17..6811ab702e8dc 100644
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



