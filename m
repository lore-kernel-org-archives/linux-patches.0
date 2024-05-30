Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C5045BE6;
	Thu, 30 May 2024 17:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717089836; cv=none; b=KDYmffzCkHVZGyqIfj/mlSEi+vpcNNKXfgNx2oyYHZX44OCWJ4WCimR9j3odftJ4BS8Qyb/IWgiYOVGBF1kirW3V6ttxA+Zvn8wEWPi6mqOyMjI9AYpTwGOowaPDVH2OohbhO3qcZ5xn//PJ8kyV0eL/ZJZtc3p4SQ/ySdgzpHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717089836; c=relaxed/simple;
	bh=cYB6EiiLkNAxIFoAwxrhbsyUrl0rJ+/K6flQe9CKBAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MFXVA7IvrIFTVv46P9YV1YJ+rQOnr8Yvq4Rt7RcxftM7a9zX8hr226qji0mq9jusvH+jnrIFJde1UN5EceKk2MfyCPp/4W7yXlAonpVQHetmTf1enbeEoTp1tdPs2kFha3kjWEgCOrd6/bITWFbApbXCmtub64EqIk+l4PECrsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tf0BEYNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tf0BEYNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD41C2BBFC;
	Thu, 30 May 2024 17:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717089835;
	bh=cYB6EiiLkNAxIFoAwxrhbsyUrl0rJ+/K6flQe9CKBAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tf0BEYNBi5ASvvcfPg4jBosiNwawOtumYHwK8AUfABputiwHAXCURv5C+S/+t7YcQ
	 POgxjmJQzBHO+27iGpTKZrWnXF8LNo683o83O4qJQ7yt68KYZEQ/YUjmEz840YvzKr
	 77Lj/i5+Qq9EHpH/FQGJRuj1jIJ9x9+wP33gwNQYUPmxQtsnSSzmBTUqDOe5K3opRh
	 Wg+/6wu3yE0JPIwNE8He/favJwqjD/dLZxDWSYMeJsT3NPksLjuRmdi6k0rWOi32SI
	 4tYRMfkDngtG+yuopgM44P/7++ItpELtuqzsYhVa+KR0px0l3E/CuzYunu8r1jUtAl
	 xzYcw0yNCMwbg==
Date: Thu, 30 May 2024 10:23:53 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: James Smart <james.smart@broadcom.com>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] nvmet-fc: Remove __counted_by from
 nvmet_fc_tgt_queue.fod[]
Message-ID: <20240530172353.GA3018978@thelio-3990X>
References: <20240529-drop-counted-by-fod-nvmet-fc-tgt-queue-v1-1-286adbc25943@kernel.org>
 <0b2b4a2a-83df-4b79-a295-4da91c841587@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b2b4a2a-83df-4b79-a295-4da91c841587@kernel.org>

Hi Jiri,

On Thu, May 30, 2024 at 08:41:18AM +0200, Jiri Slaby wrote:
> On 29. 05. 24, 23:42, Nathan Chancellor wrote:
> >    drivers/nvme/target/fc.c:151:2: error: 'counted_by' should not be applied to an array with element of unknown size because 'struct nvmet_fc_fcp_iod' is a struct type with a flexible array member.
> 
> The same as for mxser_port:
> 
> struct nvmet_fc_fcp_iod {
>         struct nvmefc_tgt_fcp_req       *fcpreq;
> 
>         struct nvme_fc_cmd_iu           cmdiubuf;
>         struct nvme_fc_ersp_iu          rspiubuf;
>         dma_addr_t                      rspdma;
>         struct scatterlist              *next_sg;
>         struct scatterlist              *data_sg;
>         int                             data_sg_cnt;
>         u32                             offset;
>         enum nvmet_fcp_datadir          io_dir;
>         bool                            active;
>         bool                            abort;
>         bool                            aborted;
>         bool                            writedataactive;
>         spinlock_t                      flock;
> 
>         struct nvmet_req                req;
>         struct work_struct              defer_work;
> 
>         struct nvmet_fc_tgtport         *tgtport;
>         struct nvmet_fc_tgt_queue       *queue;
> 
>         struct list_head                fcp_list;       /* tgtport->fcp_list
> */
> };
> 
> The error appears to be invalid.
> 
> > This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
> >      151 |         struct nvmet_fc_fcp_iod         fod[] __counted_by(sqsize);
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    1 error generated.

My apologies, I should have done the work to fully uncover the flexible
array member within 'struct nvmet_fc_fcp_iod' from the beginning and put
it in the commit message. I did not think of using pahole to make my
life easier until just now and I knew from the other examples that I had
and clang's code that it was not incorrect. Sure enough, it comes from
'struct bio' within 'struct nvmet_req'.

struct nvmet_fc_fcp_iod {
...
	struct nvmet_req		req;
...
};

struct nvmet_req {
...
	struct bio_vec		inline_bvec[NVMET_MAX_INLINE_BIOVEC];
	union {
		struct {
			struct bio      inline_bio;
		} b;
		struct {
			bool			mpool_alloc;
			struct kiocb            iocb;
			struct bio_vec          *bvec;
			struct work_struct      work;
		} f;
		struct {
			struct bio		inline_bio;
			struct request		*rq;
			struct work_struct      work;
			bool			use_workqueue;
		} p;
#ifdef CONFIG_BLK_DEV_ZONED
		struct {
			struct bio		inline_bio;
			struct work_struct	zmgmt_work;
		} z;
#endif /* CONFIG_BLK_DEV_ZONED */
	};
	int			sg_cnt;
...
};

struct bio {
...
	struct bio_set		*bi_pool;

	/*
	 * We can inline a number of vecs at the end of the bio, to avoid
	 * double allocations for a small number of bio_vecs. This member
	 * MUST obviously be kept at the very end of the bio.
	 */
	struct bio_vec		bi_inline_vecs[];
};

It sounds like it is already on Gustavo's radar to look into for
-Wflexible-array-member-not-at-end, so he said he would take a look. It
may not be a quick fix though (I'll let him comment on it further if he
is so inclined). It will be needed in stable because the patch that
added __counted_by to this structure is there, so considering this patch
for that sake may still be worthwhile, then it could be reverted with
Gustavo's changes.

I would really like to avoid leaving the build with tip of tree Clang
broken for a long period of time, as we qualify it against the kernel
continously so that any fixes needed on the kernel side are merged and
ready by the time the toolchain is actually releases (such as this one).
I am fine with waiting some time to see how this plays out but I don't
want it to be forgotten about.

Cheers,
Nathan
