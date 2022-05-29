Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76792F46
	for <patches@lists.linux.dev>; Sun, 29 May 2022 23:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDBFC385A9;
	Sun, 29 May 2022 23:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1653868039;
	bh=ZxuH3VqJUJH1J3jzVH7bIwy/T6x2dAX8M/Zj5GnElfg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=e62CRT1/Y+gtGZ1y4URtOIZ0WumVsdH/AUKvCzgVQGbnBArb7wk9n2dKBBUUGB1Qx
	 a0rMQkZMXjy5Qw8HwejKBuhmH9mMWNJDVyHKfNoT7qt3N+bgevKg37xRCMuv2Zmp/E
	 hwV5Nr+aKY4j8QpCBocItMEat3kD80OyiG+GEJj0=
Date: Sun, 29 May 2022 16:47:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jakub =?UTF-8?B?TWF0xJtuYQ==?= <matenajakub@gmail.com>
Cc: linux-mm@kvack.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
 mgorman@techsingularity.net, willy@infradead.org, liam.howlett@oracle.com,
 hughd@google.com, kirill@shutemov.name, riel@surriel.com,
 rostedt@goodmis.org, peterz@infradead.org
Subject: Re: [PATCH v2 2/2] [PATCH 2/2] mm: add merging after mremap resize
Message-Id: <20220529164718.ed1eac7d614804c825fae9fd@linux-foundation.org>
In-Reply-To: <20220527211708.839033-3-matenajakub@gmail.com>
References: <20220527211708.839033-1-matenajakub@gmail.com>
	<20220527211708.839033-3-matenajakub@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 27 May 2022 23:17:08 +0200 Jakub Matěna <matenajakub@gmail.com> wrote:

> When mremap call results in expansion, it might be possible to merge the
> VMA with the next VMA which might become adjacent. This patch adds
> vma_merge call after the expansion is done to try and merge.

Thanks.

Would it make sense to add a test case for this in (I assume)
tools/testing/selftests/vm/mremap_test.c?  Maybe parse /proc/self/maps
and check that the merging occurred as expected?

