Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083261;
	b=nBuOt8KCH0dw4VEfJKkzAoUAum6GmKLlYGl6llfJrKR4+inHm6svFHLKKeIW8jpAI189
	 r98IX6F+koLqJ9p/sOperIM896KY3WisJ6N2uPEwVUXQVYEA7WAdm+qmQNNmsqbU89W/q
	 HqPqJX78cVhBXePiyBThQuGgzlDGqABg0ddmrQF3atnilGufb4BFeWT4DSNqRCIdjvOmU
	 dMNF/ceYTslV4xAaZ/mhi2MqB9Av8wPLpPEytb1/XkhD7UAxAg60JbDcRwKiYFNMrkzk7
	 6NYOAKMstxx7WeMjIyQYRxP7yWts/BjaN/qgjR3FDJNwGpJvUHy9aQIV3P2ppfFiTeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+DUELhgEaqAYntYFp1DpQZLJYBain+UJS9q9wsG5xwM=;
	b=jhlpSDyRp6pSegL79ytDQokA6GHrYZz7Pe6QQWu6pwhUwg+3lsUn62BmRceSmkMCwNy6
	 lpNgjsPGEygu3DoprbeN7Otx3h69rn4d+lYgtwcvu2qpDxF22BO5vCErIvqFNLSUKwiHr
	 nak7/kWSlpEjAq6iQzHEjXqsqsh0BqUYbRd6WROWVnwsUo25gGLZAfhTFCME1RPGq4oZG
	 8hn4d4swx2Dx0YVYjkAI5HdP0dE6UyXjC21AjbqiYNDPhtkJ7Zn/vDGNdgP5wOZJpWWZu
	 Mki+2thvC+098BJxr31XBFF1OgOQGkQckueQdo9VBuvmdEfMdcofXXrt2KLV4JKurmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hw8Ig7N8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E7D606A32C;
	Sat,  7 Nov 2026 20:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hw8Ig7N8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273561F0089F;
	Sat,  7 Nov 2026 20:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083261;
	bh=+DUELhgEaqAYntYFp1DpQZLJYBain+UJS9q9wsG5xwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hw8Ig7N8ipyfZ3oLF7oLXIIZROi1iV2VlJcpQRKDu+rHlxJAzQELrbHXUg4YZpqRD
	 UV76H4ugRrTqydRRici07WNIQ/tX/4TS2nIEkIOlyvnsK277QeSwN9+8hGYsdFpYgL
	 U5pMd+DJp82x4qomj0SHutM6mLqvYF8rdurufBYAf038bETyufr2jLGEQl5c3ndEs+
	 H2tdwboDLY9XhTZ2Euj9vsT0snFGnkFuhUqFpi/ajjyNlqhnzge/RYgia14Ae6wZcd
	 tregYEgMbom2x6RbsmuavUlH3hHrRxpt0si+ySATU5xLB9x1JXYBf5CQQpUDlLGhlT
	 M2UNz6wQztZdw==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Sasha Levin <sashal@kernel.org>,
	damon@lists.linux.dev
Subject: Re: [PATCH 6.18 487/869] mm/damon/tests/core-kunit: test the size charged for a filter-trimmed region
Date: Sat,  7 Nov 2026 12:27:33 -0800
Message-ID: <20261107202734.231272-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107134910.088452714@linuxfoundation.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 7 Nov 2026 08:52:49 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 6.18-stable review patch.  If anyone has any objections, please let me know.

Please drop this.  This is not intended to be picked for stable tree, and
causing a DAMON kunit test failure.

The Cc:stable@ tag was wrongly added due to a mix of Cc:stable@ and
non-Cc:stable@ patches in a series.


Thanks,
SJ

[...]
