Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B85298CAF;
	Sun, 20 Sep 2026 00:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789865243; cv=none; b=cZTPyGASqXU0FyydTfMoAiZ5A1dQXCN2790lzBB4xRrehJWSfe1aNTn9CiKBfB8t524IKu16B30FuVb0kQG/ap27Q7TjE0VyJHZUIQzDtREISRJYQ/Igvl79dAFolExeFEkvzN4dCaK8VT5A5byhAe+ilcxJGVi1KAnWr7Pxlxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789865243; c=relaxed/simple;
	bh=t0wTfYsVkQMoumYmwSw8/IRHjBVFjeylLd5g+w1DvXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Peenmr1YIqF4ZLNyOJB0LQA3OYJCnxwSZamISsndHpT3ji4K6hGYhdoJMW3rHd01Xmp5mET9mNgztY7hqbRMhiJqEwS95vdo6c3pcmxZJ6w3oIxKffZEsUG6/qRXMgXXMjuuDKY5aFd4Hdwy4nqWATdx2d0QlUK2u1OJgClqKFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+5fO3kk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+5fO3kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F6B1F000FF;
	Sun, 20 Sep 2026 00:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789865241;
	bh=CV8ATigJk6TVgflRWdwJ4pqcDb/6V9Yfu5/k0Dc3Ljc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+5fO3kkmqhhj1ch0jEix43IDzu90NQ+YCtPxDHR+JcEmhxz8QYqZJCQJlD7wd6dP
	 MYGLvsD4TpHuNokbLCHbUkxH11Kv+FgX4aMVKFztubcLGCp7oT0nL3AVfzZRG5Bbes
	 XK2j+oB0thvfU5QNMg61oqnysBRytFXiRiPtsuNHGvBtDLdqz80XCosnIQXUvDWUvz
	 FXFL7hRpRGQo7Kc0LPbuiEq80mqe1QWqUzdaXvJIB/hJqB0v6zMUbxtD1OPO6YL5Fw
	 I7ivpQ7nygWKlfBIK/D+WOZLd2QyQj+NRMwu8tOOHHi/S6XhUz6RdmfRzViWHcntJ+
	 9GY6gd5D/A5iQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Stevens <stevensd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kalesh Singh <kaleshsingh@google.com>,
	Leno Hou <lenohou@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Wei Xu <weixugc@google.com>,
	Yafang <laoar.shao@gmail.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0996/1102] mm/mglru: use the common routine for dirty/writeback reactivation
Date: Sat, 19 Sep 2026 20:47:09 -0400
Message-ID: <20260920000825.5-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <c1b0c844-fb36-400c-a66a-6fc31a60d06d@oracle.com>
References: <20260917151539.408551884@linuxfoundation.org> <20260917151605.728374490@linuxfoundation.org> <c1b0c844-fb36-400c-a66a-6fc31a60d06d@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Sep 19, 2026 at 09:42:11PM +0530, Harshit Mogalapalli wrote:
> The backport removes folio_clear_referenced() as upstream 75d4c3f5fb98
> does, but upstream first applied:
>
> 4d5d14a01e2c9091b128fb46e1d07475e9a7bb72
> ("mm/mglru: rework workingset protection")
[...]
> Maybe we should drop this series of commits ?

Dropped from 6.12, thanks.

-- 
Thanks,
Sasha
