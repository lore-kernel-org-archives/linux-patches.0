Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1FE4E06CC
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 11:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792407640; cv=none; b=qGMeNsSJgtMGA/tRCIJDQ2VLr0z+rQcH8GnMe0F00GYqpfVBPgjlFFFH4o8mtBZGYqEQBO34O7Un442n66dTu4u8iwhK8bKaIr5cf975lgvnxyYVJJNdrIe8HEkUjCOTyNsh5ED0xqGZAO7jxyLLcz7rS1DjyTcPSShL2oxWPeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792407640; c=relaxed/simple;
	bh=DEeG+OVMM7oDWOAXVmwXanuReBLaFCkXTAgJYET078o=;
	h=Mime-Version:Cc:Content-Type:Message-Id:From:Subject:Date:
	 In-Reply-To:References:To; b=fWCm9Atr+WkosjT9RNCxwfrC5PwwzBy3XcHDXmlyxOr/1L/+K6j8m2gONV1MNnl3zeaB/5iOoxclxzm6hVhRz2ISWWn+FRNz0ZzeNyr5cBEbQF09KQ20qCP0fXSRz3pPMBgPzEThHv4t0KaKUsr2u296L1d3/7/EiJ7i2dO+Rd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=ZCXDas2z; arc=none smtp.client-ip=209.127.230.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="ZCXDas2z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792407631; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=aqCubf153Xb14OUZAVhvSybo4PNvwko2u4wMBzcpbD0=;
 b=ZCXDas2zUMX8Pg5jCxshqcCAUlYxiXOt2BZj6EHawlcqdU1EpVCEXOO+h2IafVyc3zz6wi
 UpwAxEwmu6H0wguzE0H6jeea1yvWTWAo+9+/yOxspJ/ywfDjnK3TNC79Ij0tIUrp0s5PPe
 q7q0374RS2jHvyCuoKQkWyc8lu7NmvODJRLfQ97X7vrc5duR8PxdrcW8sjIQ/2cieUDSbQ
 Hpy1ScG3bd6Es7JrJPAvcNJH+8AY4ItwbewGNvoDkeic0okC1nT4A9GeA+osRV/rdMuTUk
 AKwroIkdLPkm+KulcDWw5k7eASuYpLaZwbxZ18LjWTCBkwSG3sxQ+RC7YPBOqg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ad5f84d+e09f15+lists.linux.dev+zhengqi.arch@bytedance.com>
Cc: <stable@vger.kernel.org>, <patches@lists.linux.dev>, 
	"Muchun Song" <songmuchun@bytedance.com>, 
	"Christian Brauner" <brauner@kernel.org>, "Chuck Lever" <cel@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, 
	"Dave Chinner" <david@fromorbit.com>, "Kirill Tkhai" <tkhai@ya.ru>, 
	"Paul E. McKenney" <paulmck@kernel.org>, 
	"Roman Gushchin" <roman.gushchin@linux.dev>, 
	"Sergey Senozhatsky" <senozhatsky@chromium.org>, 
	"Steven Price" <steven.price@arm.com>, "Theodore Tso" <tytso@mit.edu>, 
	"Vlastimil Babka" <vbabka@suse.cz>, 
	"Abhinav Kumar" <quic_abhinavk@quicinc.com>, 
	"Alasdair Kergon" <agk@redhat.com>, 
	"Alexander Viro" <viro@zeniv.linux.org.uk>, 
	"Alyssa Rosenzweig" <alyssa.rosenzweig@collabora.com>, 
	"Andreas Dilger" <adilger.kernel@dilger.ca>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Anna Schumaker" <anna@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>, 
	"Bob Peterson" <rpeterso@redhat.com>, "Borislav Petkov" <bp@alien8.de>, 
	"Carlos Llamas" <cmllamas@google.com>, 
	"Chandan Babu R" <chandan.babu@oracle.com>, "Chao Yu" <chao@kernel.org>, 
	"Chris Mason" <clm@fb.com>, 
	"Christian Koenig" <christian.koenig@amd.com>, 
	"Coly Li" <colyli@suse.de>, "Dai Ngo" <Dai.Ngo@oracle.com>, 
	"Daniel Vetter" <daniel@ffwll.ch>, 
	"Daniel Vetter" <daniel.vetter@ffwll.ch>, 
	"Dave Hansen" <dave.hansen@linux.intel.com>, 
	"David Airlie" <airlied@gmail.com>, 
	"David Hildenbrand" <david@redhat.com>, 
	"David Sterba" <dsterba@suse.com>, 
	"Dmitry Baryshkov" <dmitry.baryshkov@linaro.org>, 
	"Gao Xiang" <hsiangkao@linux.alibaba.com>, 
	"Huang Rui" <ray.huang@amd.com>, "Ingo Molnar" <mingo@redhat.com>, 
	"Jaegeuk Kim" <jaegeuk@kernel.org>, 
	"Jani Nikula" <jani.nikula@linux.intel.com>, "Jan Kara" <jack@suse.cz>, 
	"Jason Wang" <jasowang@redhat.com>, "Jeff Layton" <jlayton@kernel.org>, 
	"Jeffle Xu" <jefflexu@linux.alibaba.com>, 
	"Joel Fernandes (Google)" <joel@joelfernandes.org>, 
	"Joonas Lahtinen" <joonas.lahtinen@linux.intel.com>, 
	"Josef Bacik" <josef@toxicpanda.com>, "Juergen Gross" <jgross@suse.com>, 
	"Kent Overstreet" <kent.overstreet@gmail.com>, 
	"Marijn Suijten" <marijn.suijten@somainline.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, 
	"Mike Snitzer" <snitzer@kernel.org>, "Minchan Kim" <minchan@kernel.org>, 
	"Nadav Amit" <namit@vmware.com>, "Neil Brown" <neilb@suse.de>, 
	"Oleksandr Tyshchenko" <oleksandr_tyshchenko@epam.com>, 
	"Olga Kornievskaia" <kolga@netapp.com>, 
	"Richard Weinberger" <richard@nod.at>, "Rob Clark" <robdclark@gmail.com>, 
	"Rob Herring" <robh@kernel.org>, "Rodrigo Vivi" <rodrigo.vivi@intel.com>, 
	"Sean Paul" <sean@poorly.run>, "Song Liu" <song@kernel.org>, 
	"Stefano Stabellini" <sstabellini@kernel.org>, 
	"Thomas Gleixner" <tglx@linutronix.de>, 
	"Tomeu Vizoso" <tomeu.vizoso@collabora.com>, 
	"Tom Talpey" <tom@talpey.com>, 
	"Trond Myklebust" <trond.myklebust@hammerspace.com>, 
	"Tvrtko Ursulin" <tvrtko.ursulin@linux.intel.com>, 
	"Xuan Zhuo" <xuanzhuo@linux.alibaba.com>, "Yue Hu" <huyue2@coolpad.com>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Sasha Levin" <sashal@kernel.org>
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Message-Id: <1822c44e-60d1-4df3-81c5-f6720dfbcbce@bytedance.com>
Content-Transfer-Encoding: 7bit
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 6.6 1003/1674] mm: shrinker: add infrastructure for dynamically allocating shrinker
Date: Mon, 19 Oct 2026 18:59:27 +0800
In-Reply-To: <2026101913-unicycle-fancy-0adc@gregkh>
References: <20261017160431.119607952@linuxfoundation.org> <20261017160456.871872142@linuxfoundation.org> <68c00b4f-d74e-4e2d-a7bc-9af44beeb25e@bytedance.com> <2026101913-unicycle-fancy-0adc@gregkh>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>

On 10/19/26 5:44 PM, Greg Kroah-Hartman wrote:
> On Mon, Oct 19, 2026 at 05:01:07PM +0800, Qi Zheng wrote:
>> Hi Greg,
>>
>> Backporting just this patch alone doesn't seem to fix any actual issue.
>> Why was it backported to v6.6?
> 
> Because:
> 
>>> Stable-dep-of: d227786ab111 ("fs/mbcache: cancel shrink work before destroying the cache")
> 
> this.  Is that not ok?

Got it. But I don't think it's necessary to introduce new shrinker
infrastructure just for this fix patch.

If we do end up backporting this, please also note the following:

 >    * Add a shrinker callback to be called from the vm.
 >    */
 > diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
 > index fcdef821147c1..694acc2b63740 100644
 > --- a/mm/shrinker_debug.c
 > +++ b/mm/shrinker_debug.c
 > @@ -239,9 +239,6 @@ struct dentry *shrinker_debugfs_detach(struct 
shrinker *shrinker,
 >
 >   	lockdep_assert_held(&shrinker_rwsem);
 >
 > -	kfree_const(shrinker->name);
 > -	shrinker->name = NULL;

This was mistakenly dropped in this patch.

If the entire patchset isn't being backported, this shouldn't be
included either.

Thanks,
Qi

> 
> thanks,
> 
> greg k-h
