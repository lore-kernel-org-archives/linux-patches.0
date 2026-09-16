Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE9141DDF1;
	Wed, 16 Sep 2026 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586956; cv=none; b=GgBuKekKVAaplBguQL12aaOgVQ3V+PmaTLK/PNiEM3ne8ivdnEsI9Avnot5/imsl63s90pPS1fe9qGEDSLcpvS4saL4ie7ph3LYqEZdMPjUjsFtJVMdlJNv5oAwjHDyXI0DLTs/0nIi/uQ+kFMvdOldL/wrWdYYJqlVGyAqnlWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586956; c=relaxed/simple;
	bh=gcJdQ6TJtkEjLxxVCmlqbP2UJoX/EV9YQG+yQa61db8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9iQDO7vj8laAYGLzr9WCuso850EVwScomm5wAoQ+43UjosQV8owry+821To5+/wh1a3enqkLsSAm8OsN3Z4q701/t6GlTRXJQwuscT3kFHdP2JCgRtHBwV9+Hoy5YyVc/XMWEmCVU6xcHplElj8s+SPBsQ6pVCdVbGpoyqtgxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VD+/gj4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VD+/gj4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3011F0089E;
	Wed, 16 Sep 2026 19:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586937;
	bh=15mqdFDdt9LbPKXeMWL/wVMjVRZONK7t8kACiHD4Hoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VD+/gj4M95az4NLshztUFxjG3UXBHnLnF84xsWkHnFsLYK8PrgTFk9eKTrAZjqBqi
	 u7nuTaq2psmooE/yhHUGKxoxWt/CwY2B0yaQFQWoccDFPzqS6xEUOSjODx20QqtSBk
	 efzzh2jY+t40PXRy0qbHdioVd0CZvJjTxUb6GFHwwA+HDnrn7oOPkkJDpIDUrFs8wN
	 zOEmwGgqvZAJQSKPjfA+d0vp/TfACtF13Lp3Q5p/vP5EJX0C7Q3HSLfemcBqfbt0Bc
	 sdWoMMl7CvIop07xLm6QQDoKMsgtkTiZR1FGucmOisEWENAbp58cRsePkwjIe3pg2R
	 ODXgtPLm2Qx5g==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Zi Yan <ziy@nvidia.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0069/1376] mm/mempolicy: fix sleeping allocation in alloc_pages_bulk_weighted_interleave()
Date: Wed, 16 Sep 2026 15:28:16 -0400
Message-ID: <daily-reply-20260916-0026-re-mempolicy-kzalloc@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <f80a9a46-930b-4c62-81b4-20cca6726e84@oracle.com>
References: <f80a9a46-930b-4c62-81b4-20cca6726e84@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I suggest retaining the GFP fix but changing the allocation to
> kzalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK). Thoughts?

Agreed, that it looks right for 6.12 given that e341f9c3c841 ("mm/mempolicy:
Weighted Interleave Auto-tuning") is not there. Greg has already asked you for
the patch in this thread, so there is nothing for me to queue until it shows
up.

-- 
Thanks,
Sasha
