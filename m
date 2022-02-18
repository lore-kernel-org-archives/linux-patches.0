Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F992F2D
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 19:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF58C340E9;
	Fri, 18 Feb 2022 19:23:02 +0000 (UTC)
Date: Fri, 18 Feb 2022 14:23:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jakub =?UTF-8?B?TWF0xJtuYQ==?= <matenajakub@gmail.com>,
 linux-mm@kvack.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 vbabka@suse.cz, mhocko@kernel.org, mgorman@techsingularity.net,
 liam.howlett@oracle.com, hughd@google.com, kirill@shutemov.name,
 riel@surriel.com, peterz@infradead.org
Subject: Re: [RFC PATCH 4/4] [PATCH 4/4] mm: add tracing for VMA merges
Message-ID: <20220218142301.0b5731e1@gandalf.local.home>
In-Reply-To: <Yg/phVScjJCLsGuC@casper.infradead.org>
References: <20220218122019.130274-1-matenajakub@gmail.com>
	<20220218122019.130274-5-matenajakub@gmail.com>
	<20220218130920.5902d967@gandalf.local.home>
	<Yg/phVScjJCLsGuC@casper.infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Feb 2022 18:46:29 +0000
Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, Feb 18, 2022 at 01:09:20PM -0500, Steven Rostedt wrote:
> > Please indent the above better. That is:
> > 
> > 		__entry->diff_count = (merge_prev == AV_MERGE_DIFFERENT)
> > 				+ (merge_next == AV_MERGE_DIFFERENT)
> > 				+ (merge_both == AV_MERGE_DIFFERENT);  
> 
> I thought our coding style preferred trailing operators; that is:
> 
> 		 __entry->diff_count = (merge_prev == AV_MERGE_DIFFERENT) +
> 				(merge_next == AV_MERGE_DIFFERENT) +
> 				(merge_both == AV_MERGE_DIFFERENT);

I'm OK with either. I just can't handle the original.

-- Steve
