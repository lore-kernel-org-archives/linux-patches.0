Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792428916;
	b=hkOctAcbqyucVOHMcq5ItBjSP627uQKdfFu0zbJ0SOrLg7v2NDXDru0uBc473ct39Odl
	 QD+21HfabuCHwqK7JXjQcRrHvO9EINTH2KgpOYOVVxSnqfxgyIj9M26cJpGOUgl3Fq73w
	 6QJjvmN8FgR+uArosIE/WwggMXWIHSxJJHioA9nAXgAYUud+mqB0LAHfsf5ti+J/C+i4J
	 AcaQsB62qrB8w9zmRylJuRx7uI/U4izramvnAtFxtOiSsnbX7xJYTeDDtocmWQ+x1sIIn
	 EfTi2dG2SiMKyJCkY6ofoBtdLKRYgjYCBngVQuULtmdcNg3iyidYsi7+9tWV/S6Foew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792428916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=QpMt80QArSQLv91EWkqxnwoaOgkJo5H18EiXikv2N/E=;
	b=kUQ3qwNGXOFoTZMeeF/9GvLib0prPmlhCA+cllg3i8WShMYpY7MzAh5pMapeG2e73T1D
	 2w/8JmihcnylUw/QnE4cBsMDF7SZPfefXdd1XZAHniM7bFrqIy5f7vFKUWeJnEORb645M
	 cMtnaMc/PbVocS81GTkienXWjiSB2WaGGWFu/DjPv52qBejWo+pMhqLlMT7YX3LpcvQLN
	 1+AXM2cYloEfoZInJVGtUjE9fAQcQg0Yt8RmFVANDNHFXJgaCCvfHv0Y+0Wo0IMhc85cN
	 vH/LJq5qly3j2TH1cholZE6m0d7qCXLN6GcqbblYwaAguSsy1k6Nryrzx86NdycPS6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hLW07yTe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2A8606A319;
	Mon, 19 Oct 2026 16:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hLW07yTe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC8C1F000C5;
	Mon, 19 Oct 2026 16:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792428915;
	bh=QpMt80QArSQLv91EWkqxnwoaOgkJo5H18EiXikv2N/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLW07yTeTBTQOC2SNWIkG1F52YiU1xBZp5jnIQFdbYZkmQUHc7vAsQndW1JuP7hWR
	 kCyyp3S3QmwEQCxm4wLPaoaRYjaAzpBeU2rpyZa19rQoUJCJzOpaKacnbLIGR5F2oL
	 k70YyIQEvNe8Ed1OpSA/eksW5qG08YmGkEaGHR87vrjpzlGWsSdlXLGIFyjvDd99rM
	 i1nmkgeQOhTpghmJT1jWxl540//rOyJVJ8TjwecTNwv8UCGebb+xhQbyXEah+G9bGq
	 THkREuBid0FjByre/01Sa03l6hDMWPxc6ittkyxS1Py52xPgiPa9maz8NDV5semfOJ
	 pGKXrd+pla0QA==
From: Sasha Levin <sashal@kernel.org>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
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
Date: Mon, 19 Oct 2026 12:54:35 -0400
Message-ID: <rc-reply-0007-1cecc6e57462@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1822c44e-60d1-4df3-81c5-f6720dfbcbce@bytedance.com>
References: <20261017160431.119607952@linuxfoundation.org> <20261017160456.871872142@linuxfoundation.org> <68c00b4f-d74e-4e2d-a7bc-9af44beeb25e@bytedance.com> <2026101913-unicycle-fancy-0adc@gregkh> <1822c44e-60d1-4df3-81c5-f6720dfbcbce@bytedance.com>
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

On Mon, Oct 19, 2026 at 06:59:27PM +0800, Qi Zheng wrote:
>>> Backporting just this patch alone doesn't seem to fix any actual issue.
>>> Why was it backported to v6.6?
>
> Got it. But I don't think it's necessary to introduce new shrinker
> infrastructure just for this fix patch.

Agreed. I dropped the four infrastructure patches from the 6.6 queue:

  - 3ee0aa9f0675 ("mm: move some shrinker-related function declarations
    to mm/internal.h")
  - 96f7b2b9bbb1 ("mm: vmscan: move shrinker-related code into a
    separate file")
  - c42d50aefd17 ("mm: shrinker: add infrastructure for dynamically
    allocating shrinker")
  - 714e5bde00a5 ("mbcache: dynamically allocate the mbcache shrinker")

d227786ab111 ("fs/mbcache: cancel shrink work before destroying the
cache") is kept as a standalone backport, like 6.1.

> If the entire patchset isn't being backported, this shouldn't be
> included either.

Right, it is dropped from the 6.6 queue along with the other
infrastructure patches. Thanks for the review.

-- 
Thanks,
Sasha
