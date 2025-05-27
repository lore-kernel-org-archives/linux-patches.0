Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236F2194A45;
	Tue, 27 May 2025 16:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364667; cv=none; b=QtJa2clevCSXMWjk48aI6hU+/2dUPY2TuFr3bX5rciD+lXf5cJAQ/wc2LMaZ2iPf1WJHv3lRzvNjxfhbDP6ALRmcWqnQLGcgZC98BiJJpkR4T9T/1InX55Tjq+u6h3nFbBnq1wGcVreUlBxe89E9AY7HyFZ7OOxDYc9Rhthg6kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364667; c=relaxed/simple;
	bh=6JjcTRvtaRWODpB6UUlSk3h7ISFKQFc79F24G3YBBgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e72WiZx6IcQWfgPHwXXkRHXVFtludp0+lxRrmyzektG3Qxx4qY1AMeBnuKbtIDSazP0GGKzrZ8B7nVsPuRVL6JrSZKiBfrzZmXJKALDW7yavzK9TXS2TjMGOwr5VlI6cHpWN3g322NkWdeSL3gBizPUN3VRnq8cerTgLV1U8grs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9bMYuKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9bMYuKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1284C4CEE9;
	Tue, 27 May 2025 16:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364667;
	bh=6JjcTRvtaRWODpB6UUlSk3h7ISFKQFc79F24G3YBBgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9bMYuKCcEseJrfB3FEXyLdHK3Apnle/X0hsl2Fcg7COPAFFFaTD6c/FeIASygebF
	 jvscUIn1uGxxmGLxnQfXkicBxDROxdSQJC+0mj13VhuFdEpGWEoH/MJ6dAIfq7/KTu
	 lpt53yb/Oc5BVH9ORwHqWibAQmQnYdHjR+Wj4DqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 129/626] um: Update min_low_pfn to match changes in uml_reserved
Date: Tue, 27 May 2025 18:20:22 +0200
Message-ID: <20250527162450.268872037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit e82cf3051e6193f61e03898f8dba035199064d36 ]

When uml_reserved is updated, min_low_pfn must also be updated
accordingly. Otherwise, min_low_pfn will not accurately reflect
the lowest available PFN.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20250221041855.1156109-1-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index a5b4fe2ad9315..6ca9ea4a230bc 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -70,6 +70,7 @@ void __init mem_init(void)
 	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
 	memblock_free((void *)brk_end, uml_reserved - brk_end);
 	uml_reserved = brk_end;
+	min_low_pfn = PFN_UP(__pa(uml_reserved));
 
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
-- 
2.39.5



