Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9325A4AD7F6;
	Mon, 19 Oct 2026 09:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792403084; cv=none; b=MGKaRJIGo0yfGttHcDyEsg/9vM7HsCmZ3P4MdW9dxZy0xj2myhwqx9M8tpdGG8dyeDJ9Br7E/9OOKkjXC+EQU3edOailZVg1WAegeUWFU6NaqEAvVfVc2wnCi6Wwj5xpCC//KDKI+YECMOU6PcK9e4KIHESlE+xH+W/SMVM64Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792403084; c=relaxed/simple;
	bh=pSXKSxezTvk2VOUeT0zN6S3csEqGn3iefHVtY4ZUGs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rC2KuG+kUOQSyIdl7goVUgRzo9VBMI1hmVXipjkyp6ahcfHErlwDPoodeO/UnXfU/TxCW9Gdi1G21mhj+4bHNFmIBnmxnidGUDM+dpfYBz6PLf9y3mgXv0sdQTpmc7Ru5siqj9tTCIrFAHKxyVxjcmd8X+oXAIRpFDWyaZbCZ28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMGXW7//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMGXW7//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2162B1F000C4;
	Mon, 19 Oct 2026 09:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792403082;
	bh=NVj3qVIVjj/Noq+geb2xGXoB3a1a0LYTHU/cvLo7+9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=pMGXW7//CqzKlUILcyEdGuwwaPqF9MnvjJ8/i5oAhpu9b0hbeE5TVrRDV+4EbEtb6
	 foG1sg8pN2Co8odqFQ+29M7WWvq4kmFzmLwG4matTIa2ofnWtk3KCZUtzrVJZET3Xm
	 g9yXhHmZ1jTbwqlFua4zUVN6W07vRf0Wld8c7YGw=
Date: Mon, 19 Oct 2026 11:44:39 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Kirill Tkhai <tkhai@ya.ru>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steven Price <steven.price@arm.com>, Theodore Tso <tytso@mit.edu>,
	Vlastimil Babka <vbabka@suse.cz>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Alasdair Kergon <agk@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Anna Schumaker <anna@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Bob Peterson <rpeterso@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Carlos Llamas <cmllamas@google.com>,
	Chandan Babu R <chandan.babu@oracle.com>, Chao Yu <chao@kernel.org>,
	Chris Mason <clm@fb.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Coly Li <colyli@suse.de>, Dai Ngo <Dai.Ngo@oracle.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Airlie <airlied@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	David Sterba <dsterba@suse.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Huang Rui <ray.huang@amd.com>, Ingo Molnar <mingo@redhat.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>, Jan Kara <jack@suse.cz>,
	Jason Wang <jasowang@redhat.com>, Jeff Layton <jlayton@kernel.org>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Josef Bacik <josef@toxicpanda.com>, Juergen Gross <jgross@suse.com>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, Minchan Kim <minchan@kernel.org>,
	Nadav Amit <namit@vmware.com>, Neil Brown <neilb@suse.de>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Olga Kornievskaia <kolga@netapp.com>,
	Richard Weinberger <richard@nod.at>,
	Rob Clark <robdclark@gmail.com>, Rob Herring <robh@kernel.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Sean Paul <sean@poorly.run>,
	Song Liu <song@kernel.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tomeu Vizoso <tomeu.vizoso@collabora.com>,
	Tom Talpey <tom@talpey.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Yue Hu <huyue2@coolpad.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 1003/1674] mm: shrinker: add infrastructure for
 dynamically allocating shrinker
Message-ID: <2026101913-unicycle-fancy-0adc@gregkh>
References: <20261017160431.119607952@linuxfoundation.org>
 <20261017160456.871872142@linuxfoundation.org>
 <68c00b4f-d74e-4e2d-a7bc-9af44beeb25e@bytedance.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68c00b4f-d74e-4e2d-a7bc-9af44beeb25e@bytedance.com>

On Mon, Oct 19, 2026 at 05:01:07PM +0800, Qi Zheng wrote:
> Hi Greg,
> 
> Backporting just this patch alone doesn't seem to fix any actual issue.
> Why was it backported to v6.6?

Because:

> > Stable-dep-of: d227786ab111 ("fs/mbcache: cancel shrink work before destroying the cache")

this.  Is that not ok?

thanks,

greg k-h
