Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161C9356A3A;
	Wed, 21 Jan 2026 18:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019560; cv=none; b=SUbNg9sxRjS5MCk0PQxKycuieZDKs4qVq0mAbnI3IHhqmY2jTaLWCgrv3IasrP+zYS29NOFW35v4n9I8cY8Qb3VpmOltGlKOICvUEQOiO6s/URAL0jCn9F1/QtySQaSX4RwXOW1SFxgomXBSCdMxbN5Ab4ZNpvOCDFkeYMDjKsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019560; c=relaxed/simple;
	bh=ocTfKgnGrE1UfHnmvVlvyirE2zCJvhnZFhIngHzH1I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTtc9R4vXYM1IUhJ9bMZiLeQI5NBu5GqNa6/0XY83kVDpLJY/poIQRs3d5X6Fjgs0nZLqXMFqmLq+xGdNwHM+4iStvJXUAvUQuyxlPeJ9V8HO0aMVcla/s1ib9qHQdZqiKh0VTorYehTg+DwW1BwRWaP82oLGdW1xBY/g4AeImc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4AelLQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4AelLQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F7FC19422;
	Wed, 21 Jan 2026 18:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019560;
	bh=ocTfKgnGrE1UfHnmvVlvyirE2zCJvhnZFhIngHzH1I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4AelLQjsJf0Pe/HBlvIkJ+aNmNtrTkbDyI/HRkF7lEem5M7OiFnKbr5JZjXixs9V
	 Ypr8UpI3Hc+YvyvQhA0sJQTm+4IqjZAy4ov27jW+53q5FZaF7BGz63hrbA6KAxqwqi
	 8enTH7qcp0pyoob6VeX4qsVlvR1ONYKEXlSq4RAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/139] mm: describe @flags parameter in memalloc_flags_save()
Date: Wed, 21 Jan 2026 19:14:49 +0100
Message-ID: <20260121181412.933315242@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 928a626725e69..ddcaaa499a044 100644
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



