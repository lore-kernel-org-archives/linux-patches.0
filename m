Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297E5184
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 00:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uV74I/9ieyeYsB9xVMBXSkK+tKHYnF1X91Ya1L16VGY=; b=a9RTPe57R523L1tUVX9Dp64uoy
	pD2jJbsL3WlY1HiRHWFQgRtBnJMSlqT+Q2LAJfTLvjlWjmY6m38EuY8DsM04daB5hGfYyrj2lT5GI
	b96MEinePKNIq/CLTtV3fgCJ3yTxWBGG1vnOPonWtHJnj6Bbeg0qi1bfsuu8ukH9Okzye9aixAWSh
	O8YwwDPOkR9oD8iGZoNi5CWNwsjY+yKSV+4Zfufenn27yXT2H3QXRYtjZkiyXkKLK8NFzil15f1f/
	shof7o1fSkA4VWH5uygOslGZKurJONkkKL6RO6WQBD4qRE59KxCuStFjdT6tl03p6Yqqc9OQzTayr
	5+ohlDcg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qEfN3-00H7bf-0x;
	Thu, 29 Jun 2023 00:18:49 +0000
Date: Wed, 28 Jun 2023 17:18:49 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, song@kernel.org,
	Johan Hovold <johan@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Petr Pavlu <petr.pavlu@suse.com>, gregkh@linuxfoundation.org,
	rafael@kernel.org, lucas.de.marchi@gmail.com,
	christophe.leroy@csgroup.eu, peterz@infradead.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com, yujie.liu@intel.com, tglx@linutronix.de,
	hch@lst.de, patches@lists.linux.dev, linux-modules@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, pmladek@suse.com,
	prarit@redhat.com, lennart@poettering.net
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
Message-ID: <ZJzN6czfRSz2hj7O@bombadil.infradead.org>
References: <ZHd8bLPY4OQCb/Z5@bombadil.infradead.org>
 <ba60bca6-b682-4c27-3c54-2512b6f16151@redhat.com>
 <ZHoTFDkPIgglW0sU@bombadil.infradead.org>
 <fa3f1a1f-edc6-f13b-cc84-f3264b03b0b1@redhat.com>
 <ZH38lpTHZ/RISC1v@bombadil.infradead.org>
 <ZH3/KVCHhX4D4yh9@bombadil.infradead.org>
 <ZJyBhv6yrAfYvMh5@bombadil.infradead.org>
 <CAHk-=wiSRTEOgiDA5qUTPGcw=Fbk9Ou2i97kfSBcj3pey3X=fQ@mail.gmail.com>
 <CAHk-=wgPz4Fj9M_h7sRSHAK9QeJiTFaYMWX3fDyZ-Bj41HftmA@mail.gmail.com>
 <CAHk-=wh80e=+_6UrHLdXMbJJ58Jz2YtMidc95HBT8raNy325nQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh80e=+_6UrHLdXMbJJ58Jz2YtMidc95HBT8raNy325nQ@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, Jun 28, 2023 at 04:17:10PM -0700, Linus Torvalds wrote:
> On Wed, 28 Jun 2023 at 15:07, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Anyway, since I clearly didn't communicate clearly that I was throwing
> > the patch over to you, let me go and find it and just apply it myself.
> 
> Ok, I spent some time writing a better commit message for that change,
> tried to make sure I got everybody's comments and Tested-by's sorted
> out etc, and committed the end result.
> 
> I also did the actual module pull and your sysctl pull.
> 
> Can you please check that it all looks like you expected?

Looks good to me, thanks for doing that. It certainly was not clear
to me that you had expected me to merge your patch just because you
had previously merged your own and later reverted it. But now I know
in the future I may just pick up your patches, instead of expecting
you to shortcut it, thanks!

  Luis
