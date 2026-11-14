Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794670877;
	b=39Nl4s1QotkW5+m6yIVr8t/InKI/OdgGPoPc7M/5mkVT8/C0/T6Lm6PaJxly3+4mhvyA
	 mbGmKGOua1oFYc8BZsMY6JRLCNBoKVxi2/mOCu6cgNskD1jKg4p1ylVY0KLpGisIeHWCv
	 2ub4cMWO9IgbKclUR+SvjGP6DN2/3Yga/L7W8Tr/FjBW/M4oCk7dz8u+XDSUs/AS4AmHU
	 AUJ4PamCmJ2/WUk3Gk5ZBaCguAAt8jbWnYNXyGA+PtfJyqY7zonDs/UHwWUHr9LPsYeiF
	 8qhJtIoCusw2vdJW/h0QJWzsocAPNGePYennlOijnGBCKobVKgAXHlYSmGPsM/s6OzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794670877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lyjlnv4ZRBvs7zUFFyqEqs19DSFipCUMf6YtQsMhMYY=;
	b=U1gBZtjXIc7HhEQ1yjB4oJZgPTQsMK2oIWHrl1/eVxUtLpJTqVgloITQ2fzJdAndU9vh
	 yJO/5h2Z8ReX566ECxeoMuvxqoTN1ZxTCmA7ntxHRv4u5dG5aGMKnsQ3mvel7K4wQlAnT
	 6s74YYMF1rNau7FHwHmWKnQu3fXqB7VUyCKfuHYSCtwnbPMi+KuN1uZcxex6B04jAQgq3
	 zXiXeTqNtEJcsSboaES/N0XknkCzKKJ1eCz05Y1iw4plYPQrRTvSNcQo6N/J2KGdlh0/2
	 ydCMof+ePw4wXfDPTQ92SMF+eYiWs1gMBKpfvs+PtLjvAcgZrP9SiH1E7lD4T18gLeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MgvfdDjL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E546A606A329;
	Sat, 14 Nov 2026 15:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MgvfdDjL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDF21F000C4;
	Sat, 14 Nov 2026 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794670876;
	bh=lyjlnv4ZRBvs7zUFFyqEqs19DSFipCUMf6YtQsMhMYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MgvfdDjL5NtTgcxkBujbYg3Nqh1Jtk4GVjDfSBcHsyqH3kQmi567e4BKTVJHi7p04
	 5ZMx6TH0BjuKsZRhk9iqU7PTS6Kc3ktantVMFwlbCGlyRJwQjzhNkMYKIUAqMYTHOy
	 gQWVsVljXh6hIWu8gFMtRwOLRyN1UvManNJuve9be37iPZ2pQ2CsgCgBKJ7YZh8gR7
	 Mlu21r21HTp+KErkDsIQM8Smjujf91tutsIu7icjMxnODvEkMCIUilu65d6q3mTEzw
	 erG4L7ubDckkh0snhsIqa1/0srRvIPIadVclzLP3k6LKmtwVYDH0Tg8Ls2fcA0qQPv
	 JBtzCaEL5ogJA==
From: Sasha Levin <sashal@kernel.org>
To: SJ Park <sj@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	4ncienth@gmail.com,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	corbet@lwn.net,
	david@kernel.org,
	jannh@google.com,
	liam@infradead.org,
	ljs@kernel.org,
	mhocko@suse.com,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rdunlap@infradead.org,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	stable@vger.kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	linux-mm@kvack.org,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 7.3 463/507] mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows
Date: Sat, 14 Nov 2026 10:41:11 -0500
Message-ID: <20261114154112.3718615-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261114031943.192867-1-sj@kernel.org>
References: <20261113153812.408825269@linuxfoundation.org> <20261114003912.82206-1-ojeda@kernel.org> <20261114031943.192867-1-sj@kernel.org>
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

On Fri, Nov 13, 2026 at 07:19:42PM -0800, SJ Park wrote:
> On Sat, 14 Nov 2026 01:39:12 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
>> ./include/linux/mmap_lock.h:604:20: error: no member named 'mm_lock_seq' in 'struct mm_struct'
>
> I found same thing while running kunit.  I also confirmed both applying commit
> 47e725702b0b from Dave and reverting this patch fix the problem on my setup.

Dropped from the 7.3 queue, together with the prerequisite it pulled in.

Thanks to both of you for the report and the confirmation.

-- 
Thanks,
Sasha
