Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9470305684;
	Sun, 21 Jun 2026 19:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782068998; cv=none; b=I5Av6N7hBIzcrYnAkVxBC3bB5XuvNgQISYG5vH5pcJ1PzWQGvOaH7QYGRcMZHbR4M4MQdwRkX7fmz8kGbGwJMJi3Ivna7iTnD1fP4wGFf06lQ2nVuKYNbS/7hlJAeXAI7/B7uPoJVHI6xLv7R7MITT5ESN5tVd744/RZ4PABJEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782068998; c=relaxed/simple;
	bh=9M6/EZhFjrvseSERQnNrl2Rxu8Gt16x54QL3zfQ3CR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0NXBhCR9v3M+vP45/xx8l5wh+7x0glLfaogwOeaJs8/Z6bMKbXDnmoisnJGXxNCV4YIHoB3hlEbN2IYNzYEXu0Y4pGSTITwn5d5THKKc0izRDacQ5yUhCGeELT9LzGfTRbbNR9Nni24DFkGuiHF8APICjYR2ojv0vw8++p1oD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IbYjSYmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbYjSYmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5361F000E9;
	Sun, 21 Jun 2026 19:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782068996;
	bh=8EjJuiCle17v1bI761iV9pQg/1bmN0Ic6hAHb2LFFUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IbYjSYmFBrG9aUZAS0/FpdFFMCRtw6MpQe8XKwe6xj9YhOVTYsO+/ITfK684lQaoI
	 +FsPrTqFRd3MPkXPLCoqKN+VmZqOf6xuJbPm9V1SqL8QUcNdr0dzT6b/5oJumgfy/h
	 vVt4ITM4aj1jn9uEL92LAy8DyGitHLwKsIpHU9Xsz1s0aPusmTrE4iSbZnVPe6VcfW
	 4Sho7jDJoymqlfNZZ5Bg9lK+X7VxCS5mriDKIlhgEQQW1qwOCbJT8o639VTLSw0oqV
	 0spk4CWm1kP//yk5GJXSVTG4MepLhgPkHfFoIytOrkuuB60ap7l/dxUI5b7q1KKYTw
	 6jOfNyfUPR7kw==
From: Sasha Levin <sashal@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.1 208/522] net: Annotate sk->sk_write_space() for UDP SOCKMAP.
Date: Sun, 21 Jun 2026 15:09:53 -0400
Message-ID: <20260621190954.367456-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260621133722.0008.sashal@kernel.org>
References: <20260616145125.307082728@linuxfoundation.org> <20260616145135.793184452@linuxfoundation.org> <6f805abf1f8b058c1b1241e8568d7539185145df.camel@decadent.org.uk> <2026061944-vaseline-essence-0008@gregkh> <20260621133722.0008.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I'll either prepare a minimal hand-crafted backport of just the
> WRITE_ONCE() annotation [...], or we can leave the read-side
> annotation unpaired for now. Leaning towards the minimal hand-crafted
> version; will follow up.

I've queued a backport of 2ef2b20cf4e0 ("net: annotate data-races around
sk->sk_{data_ready,write_space}") for 6.1.

-- 
Thanks,
Sasha
