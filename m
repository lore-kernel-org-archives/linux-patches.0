Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9723DAAD2;
	Sun, 18 Oct 2026 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792347264; cv=none; b=RqsuMnoS+q89uAsARZoksGJ2XHMjb3StJOTUUm3fnm6ksqRdrxISBFoO/Z/jbFzGYIDqdldoLlu9wKrelEnsuETtQQga8YnD4/QJlQwQFx+HQzgP2E7IrB0FscdYwdGZE3/wvVQugVcvAYTnmhH/FnbbJZhN0dK0YXKT7aJeqBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792347264; c=relaxed/simple;
	bh=hGNljsmlJ89RqpxxKO8aJD0+W4SCvw2zKOnRmkMoBls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJOdEOn8fCaOwjLYjnUjQPgd1L+S7A3lqvLtnF5zzWR7fRgZ7s/PFxngX1SrW4eHWpVd6Q9EP4Afn8gj1RyyMBvuYwA1lBbYQKUMj+7uKrUz7/BorIbI8ybnyXRgZqkiWccG/Dv+WK39zxEDMfwI8UZiSmJVCmn5iCB2nKha+7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NrJAIMVW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NrJAIMVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61791F000C4;
	Sun, 18 Oct 2026 18:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792347263;
	bh=aE+v/ITY/cV8pvLHmhsyDv97zOidMIbJEMK6i2OBrM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrJAIMVWv/VB03JqhiqwzX0stZbNcUh4oxeuIIcD64DS1Cf0lGmgl4qloa9FVOLlM
	 tzpclz+1AfZuhj0qIJl7b+qlAZWi0P6SX1/ndScSHn9QpyVpfzwlF39Ov+nIkujrU6
	 68/4JZAGewxCSeg4/ncSmWFA3Uo3l26fvI7Z7g4Qf47zkcaw1fpCc0j/UO/gv7JKYP
	 aPnd+kGEV6mJdJ6MNi9S6/cZ2dZw1LhWopPkA4c0DkGVq24QEQ499Kvg+c7RdVKVHl
	 50YdeR/nwOOMeXcg4GHIPHEWE48HxpYLacVB5SDo+sItcKiNqJwUqsCjFOvjwSHVqm
	 7AmkKJ2wzOTOw==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steven Price <steven.price@arm.com>,
	Theodore Tso <tytso@mit.edu>,
	Vlastimil Babka <vbabka@suse.cz>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Alasdair Kergon <agk@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Anna Schumaker <anna@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Bob Peterson <rpeterso@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Carlos Llamas <cmllamas@google.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Chao Yu <chao@kernel.org>,
	Chris Mason <clm@fb.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Coly Li <colyli@suse.de>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Airlie <airlied@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	David Sterba <dsterba@suse.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Huang Rui <ray.huang@amd.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jan Kara <jack@suse.cz>,
	Jason Wang <jasowang@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Juergen Gross <jgross@suse.com>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Nadav Amit <namit@vmware.com>,
	Neil Brown <neilb@suse.de>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Olga Kornievskaia <kolga@netapp.com>,
	Richard Weinberger <richard@nod.at>,
	Rob Clark <robdclark@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sean Paul <sean@poorly.run>,
	Song Liu <song@kernel.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tomeu Vizoso <tomeu.vizoso@collabora.com>,
	Tom Talpey <tom@talpey.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Yue Hu <huyue2@coolpad.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 1003/1674] mm: shrinker: add infrastructure for dynamically allocating shrinker
Date: Sun, 18 Oct 2026 11:14:12 -0700
Message-ID: <20261018181413.376492-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261017160456.871872142@linuxfoundation.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

On Sat, 17 Oct 2026 17:54:35 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> [ Upstream commit c42d50aefd17a6bad3ed617769edbbb579137545 ]
> 
> Patch series "use refcount+RCU method to implement lockless slab shrink",
> v6.
[...]

I just found this patch is causing below warning.

    mm/damon/../internal.h: In function 'shrinker_debugfs_name_alloc':
    mm/damon/../internal.h:1247:9: error: function 'shrinker_debugfs_name_alloc' might be a candidate for 'gnu_printf' format attribute [-Werror=suggest-attribute=format]
     1247 |         shrinker->name = kvasprintf_const(GFP_KERNEL, fmt, ap);
           |         ^~~~~~~~

Upstream commit f04eba134e59 ("mm: add printf attribute to
shrinker_debugfs_name_alloc") fixes the warning.  I confirmed the above warning
is also removed after cherry-picking it.  The commit message explains the issue
and how it is solved in detail.

Could you please add it, too?


Thanks,
SJ
