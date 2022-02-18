Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EFE4C69
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 18:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tx5f0UJcnj4R4TQ9Q7WxhcrF/JhIh7OvVd5/el1oJq8=; b=ey0q4gnDN4OAF8aBKVU9l6rjjr
	SrFhHlNWfk+cJDXcEuK4fKsOj3WawdGMMseCJOjiKTJ5jRGKcWNSnmD+LjeKbgGcgkXWzUARq2tjr
	ph6jmD0I8IIjefo+toFeEoo+1isV3SavZG/j7vTRZcBE6b8xWFJFmnWVVZ1ONQuEghbzYsjMg7uM3
	bBuHy1zb+Rmrp+xa8pj1Y2cR7or9Nroof+zEaVCzm8w84Xy+1fvD+tEDFREbdSx7jY/x/uhgDqP8h
	KE1g9nBEtg6E3VAx0tMSIRhvFMfCb+vBrpAiPh0ERnNNXwt1U9KPowUk/lcBMa2DsN/M/neeuOOe4
	i/J1cHwg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nL8Gz-00Gq2v-9i; Fri, 18 Feb 2022 18:46:29 +0000
Date: Fri, 18 Feb 2022 18:46:29 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jakub =?utf-8?Q?Mat=C4=9Bna?= <matenajakub@gmail.com>,
	linux-mm@kvack.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
	mgorman@techsingularity.net, liam.howlett@oracle.com,
	hughd@google.com, kirill@shutemov.name, riel@surriel.com,
	peterz@infradead.org
Subject: Re: [RFC PATCH 4/4] [PATCH 4/4] mm: add tracing for VMA merges
Message-ID: <Yg/phVScjJCLsGuC@casper.infradead.org>
References: <20220218122019.130274-1-matenajakub@gmail.com>
 <20220218122019.130274-5-matenajakub@gmail.com>
 <20220218130920.5902d967@gandalf.local.home>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218130920.5902d967@gandalf.local.home>

On Fri, Feb 18, 2022 at 01:09:20PM -0500, Steven Rostedt wrote:
> Please indent the above better. That is:
> 
> 		__entry->diff_count = (merge_prev == AV_MERGE_DIFFERENT)
> 				+ (merge_next == AV_MERGE_DIFFERENT)
> 				+ (merge_both == AV_MERGE_DIFFERENT);

I thought our coding style preferred trailing operators; that is:

		 __entry->diff_count = (merge_prev == AV_MERGE_DIFFERENT) +
				(merge_next == AV_MERGE_DIFFERENT) +
				(merge_both == AV_MERGE_DIFFERENT);

