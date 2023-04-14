Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B7BA45
	for <patches@lists.linux.dev>; Fri, 14 Apr 2023 10:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4066AC433EF;
	Fri, 14 Apr 2023 10:18:56 +0000 (UTC)
Date: Fri, 14 Apr 2023 11:18:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v3 1/4] module: fix kmemleak annotations for non init ELF
 sections
Message-ID: <ZDkojSahbkCtSOTq@arm.com>
References: <20230414050836.1984746-1-mcgrof@kernel.org>
 <20230414050836.1984746-2-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414050836.1984746-2-mcgrof@kernel.org>

On Thu, Apr 13, 2023 at 10:08:33PM -0700, Luis Chamberlain wrote:
> Commit ac3b43283923 ("module: replace module_layout with module_memory")
> reworked the way to handle memory allocations to make it clearer. But it
> lost in translation how we handled kmemleak_ignore() or kmemleak_not_leak()
> for different ELF sections.
> 
> Fix this and clarify the comments a bit more. Contrary to the old way
> of using kmemleak_ignore() for init.* ELF sections we stick now only to
> kmemleak_not_leak() as per suggestion by Catalin Marinas so to avoid
> any false positives and simplify the code.
> 
> Fixes: ac3b43283923 ("module: replace module_layout with module_memory")
> Reported-by: Jim Cromie <jim.cromie@gmail.com>
> Acked-by: Song Liu <song@kernel.org>
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
