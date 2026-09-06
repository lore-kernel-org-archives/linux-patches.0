Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54B51EFFA1;
	Sun,  6 Sep 2026 15:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788706961; cv=none; b=XzVZlJmsVSFG+GYuu2HD6yVonCk6uavL145o8fdqbspbs437oQG8ZaSW0MIW18t3gIAd2Y7hB5/GfYytYlJDWymVpMy/hpHHXF+AUCjIKQ8CBI/9kb3W97bCJHVhFx+65nKx9D1qeOSTeoXSlwReGutOYy+GHubUYXZuWlBkrRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788706961; c=relaxed/simple;
	bh=7pDJCR65DBR51XFQLK2tNCHPhSTxp/hv9aP0NX9l86M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xky+kdsSFPa3IvmOpboQsToTSIWr79tpP9dzmfo+lTnDNu/od/H/JUhLC0HJlpNyNRds1o20fNHj+iptOJ+70GIYtDE7U2YuUbQ+IvjW13lM8XEvD/gH9fHFxaKTNkVvn+chszqaTPGt8Tf7N039DahOfrRkGYZHyVPyAlbsXs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQtP7Uhq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQtP7Uhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028991F00A3E;
	Sun,  6 Sep 2026 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788706960;
	bh=Sm8Fb+j815tG0LKYLY9nMDjYGIN6dVEVuMWWoqEQmxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQtP7UhqctvsuiofGfcJf1MJ1vROcb78xqlmQ40Ra5+JNXn1OQENcFhIDkHrgnw8q
	 VGAe2EEO0twQy6AiQmnj7D4H/Xvq2TO4AJzqf20IP9EEUo3c+ubLWIO/+oC1j9cPTG
	 eTSEcrXrMdN579OFzmssm449zyBbJnzI/OKztFM6o62ooTYxoPlE2KckXHJi2fyglm
	 hAlkcMsZLtVa0xCGyGWigRjjWV77iuKWKjBE5KTun0iJGyHrMjWl0WQzC32KfewcIm
	 brvs7/n9IsIdOug2XJn7gVhMLf2gNC6oM7kcNj3IIFPaHiaYTYIuvOmmc2/w2iKsWG
	 5YOrnY6xecfpA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Ye Liu <ye.liu@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 023/403] mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()
Date: Sun,  6 Sep 2026 11:02:30 -0400
Message-ID: <20260906181100.reply7-sasha@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2fdbae4d-081b-4963-b009-b803d7f3bd53@oracle.com>
References: <20260904045734.806166532@linuxfoundation.org> <20260904045735.340715126@linuxfoundation.org> <2fdbae4d-081b-4963-b009-b803d7f3bd53@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I would suggest dropping commit: 5672bba8d5d6 ("mm/page_owner: use
> memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()") and
> replacing it with a 6.12-specific decoder that tests MEMCG_DATA_KMEM.
> Thoughts?

Dropped from 6.12 and 6.18, thanks. Kept in 7.2, which already has
f1cf8d2f36dc so the obj_cgroup decoding is correct there.

-- 
Thanks,
Sasha
