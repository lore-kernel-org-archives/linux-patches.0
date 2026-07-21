Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7441A3B6BF0;
	Tue, 21 Jul 2026 22:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672098; cv=none; b=mnE16RqBlWAjpzNjPuh4n8d+GxOC/PLc0+cLOhtOKZyRN3AzkMEt+V33Y3pMiGgzaBYN+aIRSCfluIxC95Y/rD11UgQfwYi26kUB1PravsyBOL3oZUQfH5iugyNC9zyabUUpeJR7scyS0ADQpPWhznOqNlY8RyN3gNvCWMqJn5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672098; c=relaxed/simple;
	bh=mNICrveGqoUVPr+dZSbhlXaRIrhGSzlhtRVz3OiMgxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InL4yZfx6kkzpjneuhEQVUP193ubYruZz7EqeEwWJUjzJcxTaTXaq9acCvLkngljdM/UgfJJwEYLb9peJ9EPrBbQKdaFG6pLGL6RlhlCCyCKYYBvpGCD+Vyo+Ub6633OrpB9DaxS6xxkCQpiph/qCPcXRFpvfr6qIfV9WxBtSMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtHeIfSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtHeIfSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71481F000E9;
	Tue, 21 Jul 2026 22:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672097;
	bh=MidGQrZb2/Aw5LP5jFWx9oqt65DgDI0imyJkyP+MAXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtHeIfSpvSSIi6DzTxDK3cw9gghOLmA7lWrbXdzZsxUkNz9OTsvgqRr544mXxZD+9
	 sjD5b1U5tUewU/fiv1pXqem9eFn7ToJSNpUG4AV3cgGanrcY4SLi/5bvBPuIfmc/Xx
	 kIgtlr+OeZhguR4SOdLmK6JFvbarJi1eH37WS4fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sayali Patil <sayalip@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 454/843] selftests/mm: clarify alternate unmapping in compaction_test
Date: Tue, 21 Jul 2026 17:21:29 +0200
Message-ID: <20260721152416.241113697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sayali Patil <sayalip@linux.ibm.com>

[ Upstream commit 69ba1d76d93ab818245333cf400928477ba72053 ]

Add a comment explaining that every other entry in the list is unmapped to
intentionally create fragmentation with locked pages before invoking
check_compaction().

Link: https://lore.kernel.org/da5e0a8d5152e54152c0d2f456aac2fac35af291.1779296493.git.sayalip@linux.ibm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/compaction_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/vm/compaction_test.c b/tools/testing/selftests/vm/compaction_test.c
index 00ebd9d508ffdf..442960f3381dbc 100644
--- a/tools/testing/selftests/vm/compaction_test.c
+++ b/tools/testing/selftests/vm/compaction_test.c
@@ -231,6 +231,9 @@ int main(int argc, char **argv)
 		mem_fragmentable_MB -= MAP_SIZE_MB;
 	}
 
+	/* Unmap every other entry in the list to create fragmentation with
+	 * locked pages before invoking check_compaction().
+	 */
 	for (entry = list; entry != NULL; entry = entry->next) {
 		munmap(entry->map, MAP_SIZE);
 		if (!entry->next)
-- 
2.53.0



