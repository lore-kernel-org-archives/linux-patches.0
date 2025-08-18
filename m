Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E657C2E228D;
	Mon, 18 Aug 2025 12:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521923; cv=none; b=FhrK7zh0LIn2tXjFtTgD3aL56mHcbe5HfHTXD7cGtCuT8VJ2cz/aJo6lbLLgZwtuzve4kSU6w/v5ZxtZm9l+juKmMLPQQnLXUGCkpLrQZkA9RzM/gxe8aSR5zeJihz0GAG94JpdEOd53ej2TU1N6VT5Dr3NKk8joQfE4/N1TKZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521923; c=relaxed/simple;
	bh=EZnSBnexFkPeg4K99aebOD6Sdr0V9gQBRFv2PcWUg4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0+g1tO2Rhfdfjt6oeeKQHYnLA6mHQMJJfZ6uDE6pviL+XDAg7o3Rwoh6P4nyWN59650HFjV2UNX4FcY8sbRltG7D2mH9AfRWBeh4CHo5JxZG/e2g9MARqU1t+CZmCD3wz1Cp4ZkXYX3geUC4saLYFamXNmKfGvhTsxSy7S03Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ra2p/240; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ra2p/240"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC27C4CEEB;
	Mon, 18 Aug 2025 12:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521922;
	bh=EZnSBnexFkPeg4K99aebOD6Sdr0V9gQBRFv2PcWUg4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ra2p/2408JpB7jFrnhstCiN6UqeF4Xp1MNsKAup9rsEx64C5e/W1p7luntsp+1ayX
	 iom4ySQTR9EOL6MDUiLKyxJo8jCSgDmI7tDapW7CZU6k2mEQbrugDSV1dPf3/Dqygq
	 rRIB0zwhY9LMtLhiykC4H8aU55yuUQntWzlbyY8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	David Hildenbrand <david@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/444] powerpc/thp: tracing: Hide hugepage events under CONFIG_PPC_BOOK3S_64
Date: Mon, 18 Aug 2025 14:43:09 +0200
Message-ID: <20250818124455.007950006@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 43cf0e05089afe23dac74fa6e1e109d49f2903c4 ]

The events hugepage_set_pmd, hugepage_set_pud, hugepage_update_pmd and
hugepage_update_pud are only called when CONFIG_PPC_BOOK3S_64 is defined.
As each event can take up to 5K regardless if they are used or not, it's
best not to define them when they are not used. Add #ifdef around these
events when they are not used.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/20250612101259.0ad43e48@batman.local.home
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/thp.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/trace/events/thp.h b/include/trace/events/thp.h
index f50048af5fcc..c8fe879d5828 100644
--- a/include/trace/events/thp.h
+++ b/include/trace/events/thp.h
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
 
+#ifdef CONFIG_PPC_BOOK3S_64
 DECLARE_EVENT_CLASS(hugepage_set,
 
 	    TP_PROTO(unsigned long addr, unsigned long pte),
@@ -66,6 +67,7 @@ DEFINE_EVENT(hugepage_update, hugepage_update_pud,
 	    TP_PROTO(unsigned long addr, unsigned long pud, unsigned long clr, unsigned long set),
 	    TP_ARGS(addr, pud, clr, set)
 );
+#endif /* CONFIG_PPC_BOOK3S_64 */
 
 DECLARE_EVENT_CLASS(migration_pmd,
 
-- 
2.39.5



