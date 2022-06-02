Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DDC29B4
	for <patches@lists.linux.dev>; Thu,  2 Jun 2022 18:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A6AC385A5;
	Thu,  2 Jun 2022 18:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1654193622;
	bh=TQCbTyESjzKocFJ0uHcl7XKEvJfqI5iTnWmUWKSmWA4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VlRGNEn0vm1qYmNdTZwu0UeX/BSvILFmfMDNz9L4PZ/bALKOqVpDL0oO8pFJdbZQf
	 cKZA/bh8Z3c0J40YeuyBxy+ybLwWLcTveg2HEA2IJp/RH/N4noxBrMhcF9wWygH9mr
	 pWkk0wGpvr3sHR9J37QbaWnrW313/TarOb3saYzI=
Date: Thu, 2 Jun 2022 11:13:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jakub =?UTF-8?B?TWF0xJtuYQ==?= <matenajakub@gmail.com>
Cc: linux-mm@kvack.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
 mgorman@techsingularity.net, willy@infradead.org, liam.howlett@oracle.com,
 hughd@google.com, kirill@shutemov.name, riel@surriel.com,
 rostedt@goodmis.org, peterz@infradead.org
Subject: Re: [PATCH 1/2] [PATCH 1/2] mm: refactor of vma_merge()
Message-Id: <20220602111341.6674e4d862d6d925b0eebcb3@linux-foundation.org>
In-Reply-To: <20220602145642.16948-2-matenajakub@gmail.com>
References: <20220602145642.16948-1-matenajakub@gmail.com>
	<20220602145642.16948-2-matenajakub@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu,  2 Jun 2022 16:56:41 +0200 Jakub Matěna <matenajakub@gmail.com> wrote:

> Refactor vma_merge() to make it shorter and more understandable.
> Main change is the elimination of code duplicity in the case of
> merge next check. This is done by first doing checks and caching
> the results before executing the merge itself. The variable 'area' is
> divided into 'mid' and 'res' as previously it was used for two purposes,
> as the middle VMA between prev and next and also as the result of the
> merge itself. Exit paths are also unified.
> 

Thanks, but unfortunately the code you're working on here has changed
greatly in Liam's mapletree patchset.  Could you please take a look at
the mm-unstable branch at
git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm and decide if you
want to tackle it?

