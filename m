Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ADE1D6DB5;
	Mon,  1 Jun 2026 02:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780279905; cv=none; b=Zi7pqs6hJ/TzPFmbFIezvIpYQVqpwgalOqITjEqzceAuZ1fN6gtJTShr5r+/1SRYYF5VuX/iC7oq8XEQmNlIrPZ1+YkGUspoL/RiQCIOjR0paqyGsA6LrOQUna+bz5xNkljpOklES9L5pFPzsujhFhTAi44gQAM+bhz4WcaYfFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780279905; c=relaxed/simple;
	bh=tA1QZizeoopIo6Tj8ucLbtMLqG2+jammEQs6M8mTdwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tR7O8TWhoHsSYRsvwykSlxaeBIn6V9hJH/m7Os88h8eTYyQZo8QyGF5m7ghitjsrcko+xoDny/T9eTy+ZhpM4NEWuRcJ46ttBYIVJ7kAMoshAt488SKDAjo2n7Yp4nZxDodnH6njBVo4UCS/yFIaxR+2NAamTqinC+3x0SAzMDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=filYVd29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="filYVd29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D76A1F0089A;
	Mon,  1 Jun 2026 02:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780279904;
	bh=tA1QZizeoopIo6Tj8ucLbtMLqG2+jammEQs6M8mTdwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=filYVd29ZurFFOYZ8em3xG41DGZrsKi0gRsD+Mrx86RivkKu4E7TJye5/EIbfGVI8
	 /PZXSJ3A/Lz9mTLzmNc13P1F1gWYcZO1zO5zQQVx5wJjjNlaNKqSj62doSP/U7fI9f
	 xxqtuPd8cXSN7hTe6yP7A24SDZfvwr8GNQhBdyusjYN9L2nC2kXXeByqz4HNnbWur2
	 WWiJpUj5+9/s+sXyiPJJLS+lCSVeWykhkDi+J/3dVRlSLg6zayRqir9qmBSTaBcPw3
	 +meHbWchRVeT8XfOO5fOuX3CdO5NYTJ0eJ+iuNntO4USPbPN96vF1QNvaMguT1SBQh
	 Z2A/owSnjkSCg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	stable@vger.kernel.org,
	Matthieu Baerts <matttbe@kernel.org>
Subject: Re: [PATCH 6.6 113/186] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Date: Sun, 31 May 2026 22:11:27 -0400
Message-ID: <20260601015021.rc-netfilter-rt-baerts@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b59b3ff3-1279-4cee-a5d2-aa4c5a7016b8@kernel.org>
References: <20260528194928.941004471@linuxfoundation.org> <20260528194931.993505304@linuxfoundation.org> <b59b3ff3-1279-4cee-a5d2-aa4c5a7016b8@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 2026-05-31 at 14:53 +1000, Matthieu Baerts wrote:
> It looks like this last sentence is still valid: some net selftests are
> broken because the mentioned "following patch" -- commit 3c3ab65f00eb
> ("selftests: net: Enable legacy netfilter legacy options.") -- has not
> been backported in this 6.6 version. Same for v6.1 and v5.15.
>
> Do you mind adding it in v6.6, v6.1 and v5.15, please?

Thanks for the report. Rather than ship this incomplete (it's also missing
the build fix 25a8b88f000c that Harshit pointed out on the 6.12 thread),
I've dropped the whole netfilter x_tables series from this RC. Because
9fce66583f06 carries Stable-dep-of: b4597d5fd7d2, the table-removal-race
patches that depend on it came out with it (6.6/6.1/5.15, and 6.12).

--
Thanks,
Sasha
