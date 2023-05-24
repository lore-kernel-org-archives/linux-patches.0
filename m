Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96A722627
	for <patches@lists.linux.dev>; Wed, 24 May 2023 22:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=/JToQHdkxgbDyu1xaJQwVWxSodxYnloGI/u4TaisGIw=; b=c9zMLElgRCGRia6SL8BuLKzB7B
	Mq+Qz2ZTPnhGMkg0GqFoMp8NImins+kYcs+UlKaemxvTM9avgqVIft1UaVmAM9iPgY6bsqW2N9UcD
	GitGvwsNHQxiFG9f8hEtykExK9rUUHyTd6y3HFt/7lsJPwgsvGCa2SPXxLfuONcbljL0O7kn/HK/a
	ujZGfNbX5tv7OqaDvhqDQ3rikEiwcj6GKTPRRcHz0XKhM/FS9p0K7wsuioA/p6BK5z/Kjw8r8SKhY
	NE6gzr+49AfB4wU6dqYtEyGR/xflH8FHzNBLCEoBJwdnh+rP+Y15Z/R63lCDLuDRK2sjFFjjui8Ga
	jgjZVgVw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q1weA-00Em4l-06;
	Wed, 24 May 2023 22:07:54 +0000
Date: Wed, 24 May 2023 15:07:53 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@redhat.com, tglx@linutronix.de, hch@lst.de,
	patches@lists.linux.dev, linux-modules@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, pmladek@suse.com,
	petr.pavlu@suse.com, prarit@redhat.com, lennart@poettering.net,
	gregkh@linuxfoundation.org, rafael@kernel.org, song@kernel.org,
	lucas.de.marchi@gmail.com, lucas.demarchi@intel.com,
	christophe.leroy@csgroup.eu, peterz@infradead.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com, yujie.liu@intel.com
Subject: Re: [PATCH 1/2] fs/kernel_read_file: add support for duplicate
 detection
Message-ID: <ZG6KueWpHnyPr6YV@bombadil.infradead.org>
References: <20230524213620.3509138-1-mcgrof@kernel.org>
 <20230524213620.3509138-2-mcgrof@kernel.org>
 <CAHk-=wjahcAqLYm0ijcAVcPcQAz-UUuJ3Ubx4GzP_SJAupf=qQ@mail.gmail.com>
 <CAHk-=wi9oPrxcMK469X0zAueKQ4tqX80SdFqCx9StcL82vuEkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wi9oPrxcMK469X0zAueKQ4tqX80SdFqCx9StcL82vuEkw@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, May 24, 2023 at 02:56:47PM -0700, Linus Torvalds wrote:
> On Wed, May 24, 2023 at 2:52 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Stop adding horrific code for some made-up load that isn't real.
> 
> Even if you trigger some "worst case 3x memory use", that is
> _temporary_, and will be free'd in the end.
> 
> The patches to "fix" this are worse than the disease.

Fine with me, we can punt back and wait and hope udev fixes this.
No one can tell me I didn't try. Now let's hope userspace will try
an alternative.

  Luis
