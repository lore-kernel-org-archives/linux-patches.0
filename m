Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C563DB327;
	Wed, 16 Sep 2026 19:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586965; cv=none; b=boaTa1lyblb92y8XldQ2pXxiqg8yD5dqIS/Oq147BO4fBwG3oLtEaRfPg3bDm6PvgQyMAV58KbiSnruG6jnEcWlp1I8TQnqjb7Hdz2KRV5VbDjZ7sHk3Yzjo3abIybM1LdmfaG6+DM9ZUpypBb2nSNjVvMg+QRdzfp5YMdPNJAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586965; c=relaxed/simple;
	bh=RU+X52qBBG+hiKnofr9cKKNO/k2KZ5rePUmZYcWRj4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkUyIEF/gr3MJFJ5iq/gLJG7ynEJpiCIgtgVy7Aao7Z64v+hdXgt+EYMQedA7argQP31SwmVYJiq5GNTHgDSOk2iuCIVV92+Wp20AfLuci2gV/mqshuPlrQdQGRL41f4UU4/kfhIXqdYLOJw/yWAjtv3kNeSyik0oy87FhlGyPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ik9MaOoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ik9MaOoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E7C1F0089C;
	Wed, 16 Sep 2026 19:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586938;
	bh=qvdkDqv1kwXLZM9Yamweu9phvCI0+fStlLSmdkFErb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ik9MaOoo11J52nkOLXHr7QItadHUgp8rspYeXRzszxTgVC/DSjiKetqocWOGGukkQ
	 UU0nXrawb2hirLqNuxlXHZ5BkDmBAY+4IzaRlJXMIxIdoCZL22nLxSZw+lMV1yJVOe
	 yMtPTeVfANoS7UncXkEii3ThQi+Dwval+9Q59eh5DHPtqMY1t7xyTQ93V6OUcuW/Y5
	 xqxgekRpWa1MHLb70iLIXlEHKm+h40HgjhOm4F6Uc+4ZUeL2NAMyohcQrMs+0UXNx0
	 aWsVQg0Ytkgzb82qipD+DbD9A9VCI6wqqFo8enXQCIAG3mnJ+vNklEHnZydvBaYiLe
	 qB815Q0n0TzAA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1094/1376] bpf, s390: Clear fetch destination on faulting arena atomic
Date: Wed, 16 Sep 2026 15:28:17 -0400
Message-ID: <daily-reply-20260916-0027-re-bpf-s390-arena-atomic@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <830fb27b-d5d3-4f7b-b074-d1b8762fbfde@oracle.com>
References: <830fb27b-d5d3-4f7b-b074-d1b8762fbfde@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The new s390 call to bpf_atomic_load_reg() has no declaration or
> definition in the destination, and the normal s390 build treats that
> implicit call as fatal.

Already handled: the revert of cc3e12330599 ("bpf, s390: Clear fetch
destination on faulting arena atomic") is queued for 6.12 and goes out in
6.12.111. 6.12.110 did ship with the break.

-- 
Thanks,
Sasha
