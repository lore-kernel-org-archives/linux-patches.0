Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E051C425CD7;
	Fri,  1 May 2026 21:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777669865; cv=none; b=ETNwyP9Goh9/aVXlaVZfRYVeCX7gSsAOuL3GVBSEP6ehQi4PmxnH/E/DTmg/5RqoTIYhraYueqYhDOU7XTAaZuZX93xqaJox2eUG922JJnFN8+BF91LB+ZgusucVTZNpHD3XxH547H1fJjggWYTGNoWOJUUry07DUFAuJJ5aKqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777669865; c=relaxed/simple;
	bh=VI1zz9K0tGpoQmh+UzGw5dgiQHxDITp2U1Z5MAkkSxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwHM25ZctZ3GssUqgE/BI1pyk7/idZF0BL1DQ8I935EpFzNnCoKASMciPQYI9K9KFM2t0BbA16Z7jj6V1MVo0NEDjdUwM/B6QVvHnfA8szuykOTXi5tnn0aybfNyqBNs061+uEoWqddb+c+HOs+a2GEzHqyYpIsEJGY59bMNhj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyoPfPSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyoPfPSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E27C2BCB4;
	Fri,  1 May 2026 21:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669865;
	bh=VI1zz9K0tGpoQmh+UzGw5dgiQHxDITp2U1Z5MAkkSxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyoPfPStjMgbsd7dYKOV3VyC3omA1OSBl8JRZWBuaf+hAvRr7rbBsooeWlGVfKvRv
	 c8/kEa2KmraJRGKrQ1zgNH0p+tkkEzXkhRraDy8Yh4zePevKhks9M2uk/T9UgMtc/r
	 IdoGm1tfP9+H8rQS9QRJ1IYAMjVVt2g9/jj7VmZBb1cXpLx0IU4q/tXmbqHq/Oq7AF
	 Mjxgtaf87xRHMTG3uWs7rS7WEhhF6HSWKKflSKX+tLd0fwuOd2uArYSyXG9WwbNZR5
	 84dBNFZJxOcEk9byc7XjXSRsB2ivqMNDjYVZa4nCbmM4DVGfKQS0rapg7+dbUklY/S
	 hPol5udkcb/rQ==
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com,
	lvc-project@linuxtesting.org,
	Fedor Pchelkin <pchelkin@ispras.ru>
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle io_poll_add() return value on update
Date: Fri,  1 May 2026 17:11:01 -0400
Message-ID: <20260501200000.item005-revert@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501111233-b371eac52cd006bfddfbd9e5-pchelkin@ispras>
References: <20260413155819.042779211@linuxfoundation.org> <20260501111233-b371eac52cd006bfddfbd9e5-pchelkin@ispras>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 01 May 2026 11:54:18 +0300, Fedor Pchelkin wrote:
> The Fixes: tag of upstream 84230ad2d2afb points to 97b388d70b53
> ("io_uring: handle completions in the core", v5.19), which is NOT
> present in 5.10 or 5.15. Additionally, in 5.10/5.15 'preq->result'
> is unsigned so the 'if (preq->result < 0)' check is a no-op, and
> __io_poll_add() already completes the request when it returns
> non-zero, leading to a potential double-completion.
>
> I would suggest to revert the patch from these trees because there
> appears to be no real bug to fix.

Agreed. I've reverted both the original backport and the followup
"fix backport" commit on 5.10 and 5.15.

--
Thanks,
Sasha
