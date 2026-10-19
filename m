Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E1A4A8FCE
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 09:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792400562; cv=none; b=ai0bHnJrTXZRc7TfD/7zHUH9ev7gFcFya4YfbYII+NtK3BwHAQ1gSDg3Ixq7+rilBSw2V45UTNb26mDU44hzCrUsjKk+HUpf1Cv8lokokXhi7ggFAbsFGI4IbzFbDPkFJczXgBNh9gEz8iGg1X4/2k/ibwItg0BFSHj1QFEyxyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792400562; c=relaxed/simple;
	bh=bSM4HoroKm2wzXVgjsibQKnm8RO82wZ9nCOxHZ6R49o=;
	h=Content-Type:To:Cc:Mime-Version:References:From:Subject:Date:
	 Message-Id:In-Reply-To; b=AAbIg7eHT4SB7onT7RaID3jf6x0I05vsuF9riEqyQoHDNW6tr6jyK7YzbHZvD8WUtDw/KX+xdxzHwraHEo68R4xYbSJuLym3q3Tn7GMVPwNM0SaHOQbaIert+aSS/wD4VGWOVVkO5FA1wQc23SY7xKxIESq6BANrlEtcLosFmWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=BOyRqGdY; arc=none smtp.client-ip=209.127.231.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="BOyRqGdY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792400539; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=xl7YYXnV5Xywxpqa6ugXhpCUqmkFVlB2dYJk8WksNig=;
 b=BOyRqGdYXskan/LELc5VzLUdpAeZ4CXgB9CGcXwdoRXn5tkynCNG/B8ndTLcnnLLx+kSFh
 GjOTt/HmD0UcMp0ul6YZ3ufWH+tkXbtSImkAT60y+DIEUq2q5aqXrVXAxCurPxOykohBpS
 CitRA0zBFnux3SjMj3koWvppkVtR/f4mtdCGXpgzBAJLv4DVhFwfsLp8Auv6DTxODz4TIW
 BsQpGj1aggYfDK58M0dMVS2GV64nLSi18szuSigqIpyd+P0SF4W4B6r8CFQFrS9JgKP3vI
 e+ZshUnooZD/mx8/ovlCC56jqSth1FedhIDfzmmkW+YEMAuNxF4iL8dCbbVigg==
Content-Type: text/plain; charset=UTF-8
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, 
	<stable@vger.kernel.org>
Cc: <patches@lists.linux.dev>, "Muchun Song" <songmuchun@bytedance.com>, 
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
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261017160431.119607952@linuxfoundation.org> <20261017160456.871872142@linuxfoundation.org>
X-Lms-Return-Path: <lba+26ad5dc94+a174e6+lists.linux.dev+zhengqi.arch@bytedance.com>
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 6.6 1003/1674] mm: shrinker: add infrastructure for dynamically allocating shrinker
Date: Mon, 19 Oct 2026 17:01:07 +0800
Message-Id: <68c00b4f-d74e-4e2d-a7bc-9af44beeb25e@bytedance.com>
In-Reply-To: <20261017160456.871872142@linuxfoundation.org>
Content-Transfer-Encoding: 7bit

Hi Greg,

Backporting just this patch alone doesn't seem to fix any actual issue.
Why was it backported to v6.6?

On 10/17/26 11:54 PM, Greg Kroah-Hartman wrote:
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
> 
> 1. Background
> =============
> 
> We used to implement the lockless slab shrink with SRCU [1], but then kernel
> test robot reported -88.8% regression in stress-ng.ramfs.ops_per_sec test
> case [2], so we reverted it [3].
> 
> This patch series aims to re-implement the lockless slab shrink using the
> refcount+RCU method proposed by Dave Chinner [4].
> 
> [1]. https://lore.kernel.org/lkml/20230313112819.38938-1-zhengqi.arch@bytedance.com/
> [2]. https://lore.kernel.org/lkml/202305230837.db2c233f-yujie.liu@intel.com/
> [3]. https://lore.kernel.org/all/20230609081518.3039120-1-qi.zheng@linux.dev/
> [4]. https://lore.kernel.org/lkml/ZIJhou1d55d4H1s0@dread.disaster.area/
> 
> 2. Implementation
> =================
> 
> Currently, the shrinker instances can be divided into the following three types:
> 
> a) global shrinker instance statically defined in the kernel, such as
>     workingset_shadow_shrinker.
> 
> b) global shrinker instance statically defined in the kernel modules, such as
>     mmu_shrinker in x86.
> 
> c) shrinker instance embedded in other structures.
> 
> For case a, the memory of shrinker instance is never freed. For case b, the
> memory of shrinker instance will be freed after synchronize_rcu() when the
> module is unloaded. For case c, the memory of shrinker instance will be freed
> along with the structure it is embedded in.
> 
> In preparation for implementing lockless slab shrink, we need to dynamically
> allocate those shrinker instances in case c, then the memory can be dynamically
> freed alone by calling kfree_rcu().
> 
> This patchset adds the following new APIs for dynamically allocating shrinker,
> and add a private_data field to struct shrinker to record and get the original
> embedded structure.
> 
> 1. shrinker_alloc()
> 2. shrinker_register()
> 3. shrinker_free()
> 
> In order to simplify shrinker-related APIs and make shrinker more independent of
> other kernel mechanisms, this patchset uses the above APIs to convert all
> shrinkers (including case a and b) to dynamically allocated, and then remove all
> existing APIs. This will also have another advantage mentioned by Dave Chinner:
> 
> ```
> The other advantage of this is that it will break all the existing out of tree
> code and third party modules using the old API and will no longer work with a
> kernel using lockless slab shrinkers. They need to break (both at the source and
> binary levels) to stop bad things from happening due to using uncoverted
> shrinkers in the new setup.
> ```
> 
> Then we free the shrinker by calling call_rcu(), and use rcu_read_{lock,unlock}()
> to ensure that the shrinker instance is valid. And the shrinker::refcount
> mechanism ensures that the shrinker instance will not be run again after
> unregistration. So the structure that records the pointer of shrinker instance
> can be safely freed without waiting for the RCU read-side critical section.
> 
> In this way, while we implement the lockless slab shrink, we don't need to be
> blocked in unregister_shrinker() to wait RCU read-side critical section.
> 
> PATCH 1: introduce new APIs
> PATCH 2~38: convert all shrinnkers to use new APIs
> PATCH 39: remove old APIs
> PATCH 40~41: some cleanups and preparations
> PATCH 42-43: implement the lockless slab shrink
> PATCH 44~45: convert shrinker_rwsem to mutex
> 
> 3. Testing
> ==========
> 
> 3.1 slab shrink stress test
> ---------------------------
> 
> We can reproduce the down_read_trylock() hotspot through the following script:
> 
> ```
> 
> DIR="/root/shrinker/memcg/mnt"
> 
> do_create()
> {
>      mkdir -p /sys/fs/cgroup/memory/test
>      echo 4G > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>      for i in `seq 0 $1`;
>      do
>          mkdir -p /sys/fs/cgroup/memory/test/$i;
>          echo $$ > /sys/fs/cgroup/memory/test/$i/cgroup.procs;
>          mkdir -p $DIR/$i;
>      done
> }
> 
> do_mount()
> {
>      for i in `seq $1 $2`;
>      do
>          mount -t tmpfs $i $DIR/$i;
>      done
> }
> 
> do_touch()
> {
>      for i in `seq $1 $2`;
>      do
>          echo $$ > /sys/fs/cgroup/memory/test/$i/cgroup.procs;
>          dd if=/dev/zero of=$DIR/$i/file$i bs=1M count=1 &
>      done
> }
> 
> case "$1" in
>    touch)
>      do_touch $2 $3
>      ;;
>    test)
>      do_create 4000
>      do_mount 0 4000
>      do_touch 0 3000
>      ;;
>    *)
>      exit 1
>      ;;
> esac
> ```
> 
> Save the above script, then run test and touch commands. Then we can use the
> following perf command to view hotspots:
> 
> perf top -U -F 999
> 
> 1) Before applying this patchset:
> 
>    33.15%  [kernel]          [k] down_read_trylock
>    25.38%  [kernel]          [k] shrink_slab
>    21.75%  [kernel]          [k] up_read
>     4.45%  [kernel]          [k] _find_next_bit
>     2.27%  [kernel]          [k] do_shrink_slab
>     1.80%  [kernel]          [k] intel_idle_irq
>     1.79%  [kernel]          [k] shrink_lruvec
>     0.67%  [kernel]          [k] xas_descend
>     0.41%  [kernel]          [k] mem_cgroup_iter
>     0.40%  [kernel]          [k] shrink_node
>     0.38%  [kernel]          [k] list_lru_count_one
> 
> 2) After applying this patchset:
> 
>    64.56%  [kernel]          [k] shrink_slab
>    12.18%  [kernel]          [k] do_shrink_slab
>     3.30%  [kernel]          [k] __rcu_read_unlock
>     2.61%  [kernel]          [k] shrink_lruvec
>     2.49%  [kernel]          [k] __rcu_read_lock
>     1.93%  [kernel]          [k] intel_idle_irq
>     0.89%  [kernel]          [k] shrink_node
>     0.81%  [kernel]          [k] mem_cgroup_iter
>     0.77%  [kernel]          [k] mem_cgroup_calculate_protection
>     0.66%  [kernel]          [k] list_lru_count_one
> 
> We can see that the first perf hotspot becomes shrink_slab, which is what we
> expect.
> 
> 3.2 registration and unregistration stress test
> -----------------------------------------------
> 
> Run the command below to test:
> 
> stress-ng --timeout 60 --times --verify --metrics-brief --ramfs 9 &
> 
> 1) Before applying this patchset:
> 
> setting to a 60 second run per stressor
> dispatching hogs: 9 ramfs
> stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s
>                            (secs)    (secs)    (secs)   (real time) (usr+sys time)
> ramfs            473062     60.00      8.00    279.13      7884.12        1647.59
> for a 60.01s run time:
>     1440.34s available CPU time
>        7.99s user time   (  0.55%)
>      279.13s system time ( 19.38%)
>      287.12s total time  ( 19.93%)
> load average: 7.12 2.99 1.15
> successful run completed in 60.01s (1 min, 0.01 secs)
> 
> 2) After applying this patchset:
> 
> setting to a 60 second run per stressor
> dispatching hogs: 9 ramfs
> stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s
>                            (secs)    (secs)    (secs)   (real time) (usr+sys time)
> ramfs            477165     60.00      8.13    281.34      7952.55        1648.40
> for a 60.01s run time:
>     1440.33s available CPU time
>        8.12s user time   (  0.56%)
>      281.34s system time ( 19.53%)
>      289.46s total time  ( 20.10%)
> load average: 6.98 3.03 1.19
> successful run completed in 60.01s (1 min, 0.01 secs)
> 
> We can see that the ops/s has hardly changed.
> 
> This patch (of 45):
> 
> Currently, the shrinker instances can be divided into the following three
> types:
> 
> a) global shrinker instance statically defined in the kernel, such as
>     workingset_shadow_shrinker.
> 
> b) global shrinker instance statically defined in the kernel modules, such
>     as mmu_shrinker in x86.
> 
> c) shrinker instance embedded in other structures.
> 
> For case a, the memory of shrinker instance is never freed. For case b,
> the memory of shrinker instance will be freed after synchronize_rcu() when
> the module is unloaded. For case c, the memory of shrinker instance will
> be freed along with the structure it is embedded in.
> 
> In preparation for implementing lockless slab shrink, we need to
> dynamically allocate those shrinker instances in case c, then the memory
> can be dynamically freed alone by calling kfree_rcu().
> 
> So this commit adds the following new APIs for dynamically allocating
> shrinker, and add a private_data field to struct shrinker to record and
> get the original embedded structure.
> 
> 1. shrinker_alloc()
> 
> Used to allocate shrinker instance itself and related memory, it will
> return a pointer to the shrinker instance on success and NULL on failure.
> 
> 2. shrinker_register()
> 
> Used to register the shrinker instance, which is same as the current
> register_shrinker_prepared().
> 
> 3. shrinker_free()
> 
> Used to unregister (if needed) and free the shrinker instance.
> 
> In order to simplify shrinker-related APIs and make shrinker more
> independent of other kernel mechanisms, subsequent submissions will use
> the above API to convert all shrinkers (including case a and b) to
> dynamically allocated, and then remove all existing APIs.
> 
> This will also have another advantage mentioned by Dave Chinner:
> 
> ```
> The other advantage of this is that it will break all the existing
> out of tree code and third party modules using the old API and will
> no longer work with a kernel using lockless slab shrinkers. They
> need to break (both at the source and binary levels) to stop bad
> things from happening due to using unconverted shrinkers in the new
> setup.
> ```
> 
> [zhengqi.arch@bytedance.com: mm: shrinker: some cleanup]
>    Link: https://lkml.kernel.org/r/20230919024607.65463-1-zhengqi.arch@bytedance.com
> Link: https://lkml.kernel.org/r/20230911094444.68966-1-zhengqi.arch@bytedance.com
> Link: https://lkml.kernel.org/r/20230911094444.68966-2-zhengqi.arch@bytedance.com
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Chuck Lever <cel@kernel.org>
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kirill Tkhai <tkhai@ya.ru>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Andreas Gruenbacher <agruenba@redhat.com>
> Cc: Anna Schumaker <anna@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Bob Peterson <rpeterso@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Chandan Babu R <chandan.babu@oracle.com>
> Cc: Chao Yu <chao@kernel.org>
> Cc: Chris Mason <clm@fb.com>
> Cc: Christian Koenig <christian.koenig@amd.com>
> Cc: Coly Li <colyli@suse.de>
> Cc: Dai Ngo <Dai.Ngo@oracle.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: David Airlie <airlied@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: David Sterba <dsterba@suse.com>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
> Cc: Huang Rui <ray.huang@amd.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Marijn Suijten <marijn.suijten@somainline.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nadav Amit <namit@vmware.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
> Cc: Olga Kornievskaia <kolga@netapp.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Rob Clark <robdclark@gmail.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Sean Paul <sean@poorly.run>
> Cc: Song Liu <song@kernel.org>
> Cc: Stefano Stabellini <sstabellini@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: Yue Hu <huyue2@coolpad.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Stable-dep-of: d227786ab111 ("fs/mbcache: cancel shrink work before destroying the cache")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   include/linux/shrinker.h |  19 +++++--
>   mm/internal.h            |  22 ++++++++
>   mm/shrinker.c            | 106 +++++++++++++++++++++++++++++++++++++++
>   mm/shrinker_debug.c      |   3 --
>   4 files changed, 142 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 8dc15aa374107..062e9fe5de15d 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -70,6 +70,8 @@ struct shrinker {
>   	int seeks;	/* seeks to recreate an obj */
>   	unsigned flags;
>   
> +	void *private_data;
> +
>   	/* These are for internal use */
>   	struct list_head list;
>   #ifdef CONFIG_MEMCG
> @@ -86,15 +88,22 @@ struct shrinker {
>   };
>   #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
>   
> -/* Flags */
> -#define SHRINKER_REGISTERED	(1 << 0)
> -#define SHRINKER_NUMA_AWARE	(1 << 1)
> -#define SHRINKER_MEMCG_AWARE	(1 << 2)
> +/* Internal flags */
> +#define SHRINKER_REGISTERED	BIT(0)
> +#define SHRINKER_ALLOCATED	BIT(1)
> +
> +/* Flags for users to use */
> +#define SHRINKER_NUMA_AWARE	BIT(2)
> +#define SHRINKER_MEMCG_AWARE	BIT(3)
>   /*
>    * It just makes sense when the shrinker is also MEMCG_AWARE for now,
>    * non-MEMCG_AWARE shrinker should not have this flag set.
>    */
> -#define SHRINKER_NONSLAB	(1 << 3)
> +#define SHRINKER_NONSLAB	BIT(4)
> +
> +struct shrinker *shrinker_alloc(unsigned int flags, const char *fmt, ...);
> +void shrinker_register(struct shrinker *shrinker);
> +void shrinker_free(struct shrinker *shrinker);
>   
>   extern int __printf(2, 3) prealloc_shrinker(struct shrinker *shrinker,
>   					    const char *fmt, ...);
> diff --git a/mm/internal.h b/mm/internal.h
> index d4ad62bead2e1..b00fa5df33b5f 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1241,6 +1241,20 @@ unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
>   			  int priority);
>   
>   #ifdef CONFIG_SHRINKER_DEBUG
> +static inline int shrinker_debugfs_name_alloc(struct shrinker *shrinker,
> +					      const char *fmt, va_list ap)
> +{
> +	shrinker->name = kvasprintf_const(GFP_KERNEL, fmt, ap);
> +
> +	return shrinker->name ? 0 : -ENOMEM;
> +}
> +
> +static inline void shrinker_debugfs_name_free(struct shrinker *shrinker)
> +{
> +	kfree_const(shrinker->name);
> +	shrinker->name = NULL;
> +}
> +
>   extern int shrinker_debugfs_add(struct shrinker *shrinker);
>   extern struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
>   					      int *debugfs_id);
> @@ -1251,6 +1265,14 @@ static inline int shrinker_debugfs_add(struct shrinker *shrinker)
>   {
>   	return 0;
>   }
> +static inline int shrinker_debugfs_name_alloc(struct shrinker *shrinker,
> +					      const char *fmt, va_list ap)
> +{
> +	return 0;
> +}
> +static inline void shrinker_debugfs_name_free(struct shrinker *shrinker)
> +{
> +}
>   static inline struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
>   						     int *debugfs_id)
>   {
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 043c87ccfab41..0234628ac16a9 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -550,6 +550,112 @@ unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
>   	return freed;
>   }
>   
> +struct shrinker *shrinker_alloc(unsigned int flags, const char *fmt, ...)
> +{
> +	struct shrinker *shrinker;
> +	unsigned int size;
> +	va_list ap;
> +	int err;
> +
> +	shrinker = kzalloc(sizeof(struct shrinker), GFP_KERNEL);
> +	if (!shrinker)
> +		return NULL;
> +
> +	va_start(ap, fmt);
> +	err = shrinker_debugfs_name_alloc(shrinker, fmt, ap);
> +	va_end(ap);
> +	if (err)
> +		goto err_name;
> +
> +	shrinker->flags = flags | SHRINKER_ALLOCATED;
> +	shrinker->seeks = DEFAULT_SEEKS;
> +
> +	if (flags & SHRINKER_MEMCG_AWARE) {
> +		err = prealloc_memcg_shrinker(shrinker);
> +		if (err == -ENOSYS) {
> +			/* Memcg is not supported, fallback to non-memcg-aware shrinker. */
> +			shrinker->flags &= ~SHRINKER_MEMCG_AWARE;
> +			goto non_memcg;
> +		}
> +
> +		if (err)
> +			goto err_flags;
> +
> +		return shrinker;
> +	}
> +
> +non_memcg:
> +	/*
> +	 * The nr_deferred is available on per memcg level for memcg aware
> +	 * shrinkers, so only allocate nr_deferred in the following cases:
> +	 *  - non-memcg-aware shrinkers
> +	 *  - !CONFIG_MEMCG
> +	 *  - memcg is disabled by kernel command line
> +	 */
> +	size = sizeof(*shrinker->nr_deferred);
> +	if (flags & SHRINKER_NUMA_AWARE)
> +		size *= nr_node_ids;
> +
> +	shrinker->nr_deferred = kzalloc(size, GFP_KERNEL);
> +	if (!shrinker->nr_deferred)
> +		goto err_flags;
> +
> +	return shrinker;
> +
> +err_flags:
> +	shrinker_debugfs_name_free(shrinker);
> +err_name:
> +	kfree(shrinker);
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(shrinker_alloc);
> +
> +void shrinker_register(struct shrinker *shrinker)
> +{
> +	if (unlikely(!(shrinker->flags & SHRINKER_ALLOCATED))) {
> +		pr_warn("Must use shrinker_alloc() to dynamically allocate the shrinker");
> +		return;
> +	}
> +
> +	down_write(&shrinker_rwsem);
> +	list_add_tail(&shrinker->list, &shrinker_list);
> +	shrinker->flags |= SHRINKER_REGISTERED;
> +	shrinker_debugfs_add(shrinker);
> +	up_write(&shrinker_rwsem);
> +}
> +EXPORT_SYMBOL_GPL(shrinker_register);
> +
> +void shrinker_free(struct shrinker *shrinker)
> +{
> +	struct dentry *debugfs_entry = NULL;
> +	int debugfs_id;
> +
> +	if (!shrinker)
> +		return;
> +
> +	down_write(&shrinker_rwsem);
> +	if (shrinker->flags & SHRINKER_REGISTERED) {
> +		list_del(&shrinker->list);
> +		debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
> +		shrinker->flags &= ~SHRINKER_REGISTERED;
> +	}
> +
> +	shrinker_debugfs_name_free(shrinker);
> +
> +	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
> +		unregister_memcg_shrinker(shrinker);
> +	up_write(&shrinker_rwsem);
> +
> +	if (debugfs_entry)
> +		shrinker_debugfs_remove(debugfs_entry, debugfs_id);
> +
> +	kfree(shrinker->nr_deferred);
> +	shrinker->nr_deferred = NULL;
> +
> +	kfree(shrinker);
> +}
> +EXPORT_SYMBOL_GPL(shrinker_free);
> +
>   /*
>    * Add a shrinker callback to be called from the vm.
>    */
> diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
> index fcdef821147c1..694acc2b63740 100644
> --- a/mm/shrinker_debug.c
> +++ b/mm/shrinker_debug.c
> @@ -239,9 +239,6 @@ struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
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

> -
>   	*debugfs_id = entry ? shrinker->debugfs_id : -1;
>   	shrinker->debugfs_entry = NULL;
