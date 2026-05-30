Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE88332EA7;
	Sat, 30 May 2026 17:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161653; cv=none; b=TBzBEFOMcK14+z2jrpFYrWO5eti/D1CKh8kvwk8pobyCFagY2OXRpD47RM5QIj5ebyT+5wQ8siHtb1Qje3kq7KtQLbIrINO8iOHUeCNX0Vu4V2YaBSrdSOhUE8E6TumeVIGxDI7y7W6UeBHFIpfnl6PuB9eNwq7khQxhmw+qpv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161653; c=relaxed/simple;
	bh=F0ZtX0VjBRnayMmsaSs2sqW3zxxgQMvrp+bwgnmcnOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkYTb8z/c+/Xrt6TdHH0S27Rie2vdNjDTE4uxS/ctkAkQ8Hu3SR+iQnqnc98QUhGjka+S78989L1AFUMLtSlrn8r6e/JnZASc29y/hmXL5OEul8l23OYVbf7LdB6A3jXOtZSCpXnnm6tiLyFgtGF4G6Z9WcUj/dmwqGp2536pHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNPODl/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNPODl/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDA11F00893;
	Sat, 30 May 2026 17:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161651;
	bh=kW0paqam0CJAVprf/N6IBzOEmcSTuvbMfazwqQ62ZMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNPODl/ZG6r+go+fqUXz7eIkcpyxd+Rpg5jyHTn+ThokHKw6aKulucIeDvokXL6Fe
	 2TKrRPtBOr9Ow17/G8s66YYQAlTxiKMgwdMe6+Gy2+kNZrUePZQYcFPn2X0y3dESmq
	 AWwoovN8R4coQvZkSTcO7702Vlj6pWB/AHE8rA2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 686/969] container_of: remove container_of_safe()
Date: Sat, 30 May 2026 18:03:30 +0200
Message-ID: <20260530160319.450819357@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 848dba781f1951636c966c9f3a6a41a5b2f8b572 ]

It came in from a staging driver that has been long removed from the
tree, and there are no in-kernel users of the macro, and it's very
dubious if anyone should ever use this thing, so just remove it
entirely.

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221024123933.3331116-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 21e92a38cfd8 ("tcp: add data-race annotations around tp->data_segs_out and tp->total_retrans")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/container_of.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/include/linux/container_of.h b/include/linux/container_of.h
index 2f4944b791b81..a6f242137b116 100644
--- a/include/linux/container_of.h
+++ b/include/linux/container_of.h
@@ -21,20 +21,4 @@
 		      "pointer type mismatch in container_of()");	\
 	((type *)(__mptr - offsetof(type, member))); })
 
-/**
- * container_of_safe - cast a member of a structure out to the containing structure
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
- *
- * If IS_ERR_OR_NULL(ptr), ptr is returned unchanged.
- */
-#define container_of_safe(ptr, type, member) ({				\
-	void *__mptr = (void *)(ptr);					\
-	static_assert(__same_type(*(ptr), ((type *)0)->member) ||	\
-		      __same_type(*(ptr), void),			\
-		      "pointer type mismatch in container_of_safe()");	\
-	IS_ERR_OR_NULL(__mptr) ? ERR_CAST(__mptr) :			\
-		((type *)(__mptr - offsetof(type, member))); })
-
 #endif	/* _LINUX_CONTAINER_OF_H */
-- 
2.53.0



