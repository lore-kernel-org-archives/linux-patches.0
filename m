Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED1A33290B;
	Wed, 21 Jan 2026 18:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020117; cv=none; b=l7PZdAx1wEmz/sqrYC2Ca5iW8tEDXuxT6EuaGvQhN87xavzlvVuamYEqPDUF19c3Mx1ugzoMX6hLJzrhp7TwyHJywCKmth/jBHJhg4AUILWpQxecmR3NNJkhve4oumzkvjNaUd9KPF/1NxdnpRCif3S9ArxlmCwy0ZTqwsWhyT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020117; c=relaxed/simple;
	bh=/oQraJPDluVabvMGu4QgyxgAFusD7xlUP2lkUIVvjPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdhP74vwDyL+ny/fm9TgPcSgNQVEuS1fM8QeeAeoW/7oPTLYsawpnHu/8tgHPEW2NMX3qMKMr2FlkPAB12yNkj8pWCYtP0H8yYuep9JnDPqkRNXsIWk1vpZ9SvHiMZ3PtShWsmuFPpGUqpjZeUDzq/y5TGs74c+oARTIrIzcb5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzuqkQRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzuqkQRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC19CC4CEF1;
	Wed, 21 Jan 2026 18:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020117;
	bh=/oQraJPDluVabvMGu4QgyxgAFusD7xlUP2lkUIVvjPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzuqkQRDcbRsuwopBhsece8LZ9Vrk6glgBBrdOBSkbpXfPI7weCSJYx8ejIiz4cOz
	 wu0uSeWWP74aBLGD3YKWEgwFN7xrMFhii0aRUlJZmvzfZe2OyY23ceepqqf7QBLUSH
	 VLDKehZB/CMbSPhm8xeJudEt87/oaBecnIgVzYpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/198] mm: describe @flags parameter in memalloc_flags_save()
Date: Wed, 21 Jan 2026 19:14:51 +0100
Message-ID: <20260121181420.825172192@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit e2fb7836b01747815f8bb94981c35f2688afb120 ]

Patch series "mm kernel-doc fixes".

Here are kernel-doc fixes for mm subsystem.  I'm also including textsearch
fix since there's currently no maintainer for include/linux/textsearch.h
(get_maintainer.pl only shows LKML).

This patch (of 4):

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/sched/mm.h:332 function parameter 'flags' not described in 'memalloc_flags_save'

Describe @flags to fix it.

Link: https://lkml.kernel.org/r/20251219014006.16328-2-bagasdotme@gmail.com
Link: https://lkml.kernel.org/r/20251219014006.16328-3-bagasdotme@gmail.com
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Fixes: 3f6d5e6a468d ("mm: introduce memalloc_flags_{save,restore}")
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/mm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 0232d983b7153..a3094379b5790 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -323,6 +323,7 @@ static inline void might_alloc(gfp_t gfp_mask)
 
 /**
  * memalloc_flags_save - Add a PF_* flag to current->flags, save old value
+ * @flags: Flags to add.
  *
  * This allows PF_* flags to be conveniently added, irrespective of current
  * value, and then the old version restored with memalloc_flags_restore().
-- 
2.51.0



