Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126FEC94A
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JNM/PoaKdJVang9WqsbIURXjXnMB7kVw7Og7DK0+y/k=; b=NPvn3Y8PNf9X253zeDEbvUCEMD
	gOA4qUsYzuP/RiqVYByAU8E1tcWRLyrDDPdWBL2v8THrJaQ+ArmYTwIZCrdc3rlybWppKyco44g27
	QFkSMiHR1g8AawhfyR/Ml8/HpQFb0HmIsBORD9Zvl7rcHItkbCjppHyLtGMXUIFJOXlzxHZfJ7Wbz
	1RU2UUvmvKQ1i6jgfcMJpZkfh+3gwGio3Rvb8cNGtgnT8dG4OUU9W1iFB+fPux3x5L8cyO8a+UcOK
	W7ipP9jQvBItWBIlWS9iv18T59zhMe832aQac7NWnsBI93CCWPVOgtyv+4h66HRM4t2N4eJ7Kt6yy
	zBFnjF+g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1potC8-003RF5-25;
	Tue, 18 Apr 2023 21:49:00 +0000
Date: Tue, 18 Apr 2023 14:49:00 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, brauner@kernel.org,
	linux-mm@kvack.org, p.raghav@samsung.com, da.gomez@samsung.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v2 5/6] shmem: update documentation
Message-ID: <ZD8QTOsWQ0SscOYz@bombadil.infradead.org>
References: <20230309230545.2930737-1-mcgrof@kernel.org>
 <20230309230545.2930737-6-mcgrof@kernel.org>
 <a4afef5c-27e4-5e67-9771-374132db61f8@google.com>
 <ZD8JgfphE+HWCGve@bombadil.infradead.org>
 <6064b468-33fb-3693-54e-6f1f8d316f64@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6064b468-33fb-3693-54e-6f1f8d316f64@google.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, Apr 18, 2023 at 02:41:07PM -0700, Hugh Dickins wrote:
> On Tue, 18 Apr 2023, Luis Chamberlain wrote:
> > On Mon, Apr 17, 2023 at 10:29:59PM -0700, Hugh Dickins wrote:
> > > On Thu, 9 Mar 2023, Luis Chamberlain wrote:
> > > 
> > > > Update the docs to reflect a bit better why some folks prefer tmpfs
> > > > over ramfs and clarify a bit more about the difference between brd
> > > > ramdisks.
> > > > 
> > > > While at it, add THP docs for tmpfs, both the mount options and the
> > > > sysfs file.
> > > 
> > > Okay: the original canonical reference for THP options on tmpfs has
> > > been Documentation/admin-guide/mm/transhuge.rst.  You're right that
> > > they would be helpful here too: IIRC (but I might well be confusing
> > > with our Google tree) we used to have them documented in both places,
> > > but grew tired of keeping the two in synch.  You're volunteering to
> > > do so! so please check now that they tell the same story.
> > 
> > Hehe. Sure, we should just make one point to the other. Which one should
> > be the authoritive source?
> 
> Documentation/admin-guide/mm/transhuge.rst has been the authoritative
> source up until this patch, so I suggest it remain so; but good if you
> point to it from this Doc - unless in reading it you find that actually
> its account is wrong.  (Haha, it refers to fadvise too, never mind that.)

Yeah I'll make the tmpfs kdoc point to the transhuge.rst page. I think
that's possible.

> But the man page is more important than either, so it would be good to
> point to that too. 

Sure I'll have the tmpfs kdoc also point to the tmpfs man page.

> Mention the "huge=" option in this document, but
> point to elsewhere for the detail of its values.

Sounds good.

  Luis
