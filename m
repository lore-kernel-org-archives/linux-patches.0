Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792428905;
	b=QvJ6ru0bgB7ps0enaTcwVKfBI58rsoguIuYGtDPWNxZc6e5I7zmQVDZV9wWbH7hnw0U4
	 kId6M586qlH67nD3xTe1XD64nTmzrH0ggUw5/8wHNOlQbG2g3bDbLMydNNwJPAV7feo4x
	 3Ma5Hp3F0J2hqESWwelBa0+pJTRt+RwXVHpU2xoybxRZqzve8vOemG4rtUImKY+eWgwfj
	 uNLxhKfrDII2AzUO13LsdL3JILGHcwq8KhwMvd5OOWHfrG9t1BnfWdi1TR/YU30w3j6K7
	 nkFr0+ofPy6cvYH4KXpT2uFjPw9sy82NeMeHqqxmrraHWYntlSpFn71rj0Pa4W9hEAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792428905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=VMwHHkZBQSemDFKq2z6XwRqgAQk+C/KTU/Y6PkEqgCk=;
	b=QK8RVLm4g/Cbt5dkRpWmi4/f0U7/l//pdx3BMOdaC1c/4l6cy+WikJl9ez2/Ek5Hvtnt
	 pRSF0093GlvMgDpm/+3HUdClmmc9+0SuJ1WQJkTdFMDOCQhouFvGupl5+fG1+XzcMiq58
	 CmAG7mRjeQOn1xnMCnrz27UEkydcmiC/F5NievYWPKrrpE3TWTmzgtS6CqaLA6Cmu7Rm3
	 aS9ocphAZbAlrsXEzdsv+OtlYCM1gvM7S8/t37+DltdF5ias2UU4/e6eKAXOfNCvOZPRC
	 8t1/5spaaJThABxbrHvEhIHopzio9GuMKPom/CbhEL+jD6oRZR63ePYHYXK4gOVHbLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LUsQuTC9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4094606A321;
	Mon, 19 Oct 2026 16:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LUsQuTC9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3561F000C6;
	Mon, 19 Oct 2026 16:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792428904;
	bh=VMwHHkZBQSemDFKq2z6XwRqgAQk+C/KTU/Y6PkEqgCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LUsQuTC9JWW/pCQmky//oFTW6NEPAe9Z/HzA8KdIjYWh1oICrChs351Mne8NjXo/s
	 pi/fDD03ROXlpTUMFL6EKnTV62mb767lS06SttU0nT9bV6uqhTi4RMgxCh4oyulDoL
	 HcaBBBiGfKuNqs7+2bIl2YBJDp/I+mHWzatezVANcx9w8hTrig8YKzteZWJ+a5jCeT
	 52Lr1mr/5vpzsTC1rFriMPs+5Ek2S8Huu64qcNIXqvCXSeTjws9ZpM2FB0Jlh/ZgNd
	 VWGZBmoeLxk8f3Lf1t8kxdMJAlOXPqG3rB7ssWH9sId1c9R6Z/kMVA90MAuuwqNJKv
	 k9ZNN4n4J52Xg==
From: Sasha Levin <sashal@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.6 1003/1674] mm: shrinker: add infrastructure for dynamically allocating shrinker
Date: Mon, 19 Oct 2026 12:54:34 -0400
Message-ID: <rc-reply-0006-61299cd9ea8b@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261018181413.376492-1-sj@kernel.org>
References: <20261017160456.871872142@linuxfoundation.org> <20261018181413.376492-1-sj@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sun, Oct 18, 2026 at 11:14:12AM -0700, SJ Park wrote:
> I just found this patch is causing below warning.
[...]
> Could you please add it, too?

Thanks for the report. The shrinker infrastructure chain was dropped from the
6.6 queue, so f04eba134e59 ("mm: add printf attribute to
shrinker_debugfs_name_alloc") is not needed there.

d227786ab111 ("fs/mbcache: cancel shrink work before destroying the cache")
stays queued as a direct backport without the infrastructure, the same as in
6.1.

-- 
Thanks,
Sasha
