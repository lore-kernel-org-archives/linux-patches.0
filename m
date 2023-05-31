Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAEB14A92
	for <patches@lists.linux.dev>; Wed, 31 May 2023 00:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VEudGuTbI8GghvYngS74lz28bkiQJqXeUNzo7Tr5OoA=; b=BJgiRlz0je11Z1r1LNqL92W3fQ
	a5OOoj2ob+vV+XocxtjGdUPW5vnwZ9G9KKW/erh/BgetQknKnUYXdKE9iKx/6VxdrBnkm+FA7pWcg
	96O8PiVEQ3GgJ+CpXuxSW4KGZ+Dk9tBzllKTEwT7SFKXxVnzfUsoDoH+NjX1NxDkqs8fmzxmpz8tn
	Bi0sQDjGjh0jmgQxgE7/gGomNqwNm6Gk9Lg0ycVEMSyWn38xepB30Ihk/23dFfZNn5AqJRiSutzbX
	y1Pey7omE9jMXy+HjVL+Zirk0r5Pq08G3sR/z8nk83Vwtucla6f+jIuHA+EzW/G+Umep7qjBO5FuV
	8LOjjCpg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q49kG-00Fbuq-11;
	Wed, 31 May 2023 00:31:20 +0000
Date: Tue, 30 May 2023 17:31:20 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johan Hovold <johan@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Petr Pavlu <petr.pavlu@suse.com>, gregkh@linuxfoundation.org,
	rafael@kernel.org, song@kernel.org, lucas.de.marchi@gmail.com,
	christophe.leroy@csgroup.eu, peterz@infradead.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com, yujie.liu@intel.com, david@redhat.com,
	tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com,
	lennart@poettering.net
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
Message-ID: <ZHaVWJzFm0vuAxJv@bombadil.infradead.org>
References: <6gwjomw6sxxmlglxfoilelswv4hgygqelomevb4k4wrlrk3gtm@wrakbmwztgeu>
 <CAHk-=whu8Wh4JP1hrc80ZvGgVW4GV6hw1vwzSiwOo9-1=Y1dWw@mail.gmail.com>
 <ZG/a+nrt4/AAUi5z@bombadil.infradead.org>
 <CAHk-=whiXzqprmQNRui3LbKQwvM8fg4nyAzWcU5qZs+kxBVzrA@mail.gmail.com>
 <ZHRpH-JXAxA6DnzR@hovoldconsulting.com>
 <CAHk-=wh6sXSO63kka+EWEqq0tGwtOnXYFWMXPQ6T_wZa+Np3MQ@mail.gmail.com>
 <ZHSeOUpKtyc8VKx5@hovoldconsulting.com>
 <ZHTCK2_1pF61yWIr@hovoldconsulting.com>
 <CAHk-=wg7ihygotpO9x5a6QJO5oAom9o91==L_Kx-gUHvRYuXiQ@mail.gmail.com>
 <ZHYitt7P7W+8ZlSB@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHYitt7P7W+8ZlSB@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, May 30, 2023 at 09:22:14AM -0700, Luis Chamberlain wrote:
> The only thing I can think of is allowing threads other than the
> first one to complete before the one that actually loaded the
> module. I thought about this race for module auto-loading, see
> the comment in kmod_dup_request_announce(), so that just
> further delays the completion to other thread with a stupid
> queue_work(). That seems more important for module auto-loading
> duplicates than for boot finit_module() duplicates. But not sure
> if odering matters in the end due to a preemtible kernel and maybe
> that concern is hysteria.

I think I'm OK to accept this ordering concern as hysteria for now.

  Luis
