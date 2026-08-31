Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6B434D4DE;
	Mon, 31 Aug 2026 01:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788140367; cv=none; b=Yc0l/m5KnD14s0zKJdHo1GZxneMPQF2/B23LndXLQxuuILk39DDT27vyWX4tGZ9OQvdIizDjATn48I9wKtt6obEzuLOEiglyvRkIJpqNGw2fwFL9Zsz2qXIJ31lH1k8mf84NAw0EBu91KwuCgx+KxjyrDc968Tljy03flNQDr0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788140367; c=relaxed/simple;
	bh=o0s6nuGRf7iEuMmxTv+A9zdSxmJAbCmH/UvGy4znr0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AA7sazou2K4jse/za1Q+kCRrLUj7HxYc+nRfh9KDPgXt8NcNvIpTuMThDM58k2u/K3ZSkovWwdXclEOAhUG7w/5CK6d4JaQgmnAiEAmcMYbeSfEoaOuCidxccL8ed3zCt4extw5cIcdz+3vxEVucfMWHodgFH+kMdp0SzJ/Yxvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQqTO6sG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQqTO6sG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E02B1F000E9;
	Mon, 31 Aug 2026 01:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788140366;
	bh=3Vo60SsofioewEk/hakNWs8htBGiu8cleHsJFO70b9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQqTO6sGCXp4phAaQvyQH4iaPj/4dh/fGyL+sJEmVMU4H6EroVzErW6MQgR7nmaQJ
	 MBJ9D9CthNJRGKszokB0T7bwWhWV1oZzmcNNtdw9nrYqmEj18HSluT2C5vYcHbDbtn
	 eD0L4BNU27tA8+AOcPtx7yPqMHhTQcIAdiTfw0T4IFY/tNBB1hX6MtM3ErLuJrJQzX
	 41ap+iEmyCv6/6r+fR9rCDTOrbFSzU9bhYPXMq+yDi76ryiTrtil8aMuQBZv9d2+gv
	 7Op3UTphyh/vwRqsorz5QxNCbrbDJ18SOrya+nEpZKNGc7NJOUQoEE7NcAU8OZPfYV
	 GwZ6qr13Ur7sw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 184/220] ring-buffer: Make ring_buffer_{un}map() simpler with guard(mutex)
Date: Sun, 30 Aug 2026 21:39:09 -0400
Message-ID: <20260830194800.0004-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <69d0d491-b9ef-4e85-93ba-d500de1ae6e9@oracle.com>
References: <69d0d491-b9ef-4e85-93ba-d500de1ae6e9@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I ran an AI-assisted backport review and then checked c7f40b670e5c
> against the 6.12.y code. The refactor changes the first-map exit in
> ring_buffer_map() from:
>
>         return err;
>
> to:
>
>         return 0;

Queued for 6.12, thanks.

-- 
Thanks,
Sasha
