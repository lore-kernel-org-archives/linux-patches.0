Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F96F509
	for <patches@lists.linux.dev>; Tue, 19 Sep 2023 08:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A285C433C9;
	Tue, 19 Sep 2023 08:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695112495;
	bh=QpajV1PeBnPAdnf7ameyYmcl97VZ+w2I1GuQpWvpu+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TbQEm7sAyxi23fp31KLGDy/VfAIdYAEGn5ivqlSZI3bVaj56YgIo5aEFXc+sFbFQE
	 ll4nZ2/n2jrmYFRyCGX1Lqw6ddReV5HptWa9FmyuVVMuu84PcmAosWDmd4fu2vHDdq
	 6PPDmdjWk0cS7luFAc15cskcM4PTkUtpsXkjtH2A=
Date: Tue, 19 Sep 2023 10:32:16 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: gerhorst@cs.fau.de, alexei.starovoitov@gmail.com, ast@kernel.org,
	eddyz87@gmail.com, laoar.shao@gmail.com, patches@lists.linux.dev,
	stable@vger.kernel.org, yonghong.song@linux.dev, hagarhem@amazon.de,
	puranjay12@gmail.com, Luis Gerhorst <gerhorst@amazon.de>
Subject: Re: [PATCH 6.1 562/600] bpf: Fix issue in verifying allow_ptr_leaks
Message-ID: <2023091959-heroics-banister-7d6d@gregkh>
References: <20230911134650.200439213@linuxfoundation.org>
 <20230914085131.40974-1-gerhorst@amazon.de>
 <2023091653-peso-sprint-889d@gregkh>
 <b927046b-d1e7-8adf-ebc0-37b92d8d4390@iogearbox.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b927046b-d1e7-8adf-ebc0-37b92d8d4390@iogearbox.net>

On Tue, Sep 19, 2023 at 08:26:28AM +0200, Daniel Borkmann wrote:
> On 9/16/23 1:35 PM, Greg KH wrote:
> > On Thu, Sep 14, 2023 at 08:51:32AM +0000, Luis Gerhorst wrote:
> > > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > From: Yafang Shao <laoar.shao@gmail.com>
> > > > 
> > > > commit d75e30dddf73449bc2d10bb8e2f1a2c446bc67a2 upstream.
> > > 
> > > I unfortunately have objections, they are pending discussion at [1].
> > > 
> > > Same applies to the 6.4-stable review patch [2] and all other backports.
> > > 
> > > [1] https://lore.kernel.org/bpf/20230913122827.91591-1-gerhorst@amazon.de/
> > > [2] https://lore.kernel.org/stable/20230911134709.834278248@linuxfoundation.org/
> > 
> > As this is in the tree already, and in Linus's tree, I'll wait to see
> > if any changes are merged into Linus's tree for this before removing it
> > from the stable trees.
> > 
> > Let us know if there's a commit that resolves this and we will be glad
> > to queue that up.
> 
> Commit d75e30dddf73 ("bpf: Fix issue in verifying allow_ptr_leaks") is not
> stable material. It's not really a "fix", but it will simply make direct
> packet access available to applications without CAP_PERFMON - the latter
> was required so far given Spectre v1. However, there is ongoing discussion [1]
> that potentially not much useful information can be leaked out and therefore
> lifting it may or may not be ok. If we queue this to stable and later figure
> we need to revert the whole thing again because someone managed to come up
> with a PoC in the meantime, then there's higher risk of breakage.

Ick, ok, so just this one commit should be reverted?  Or any others as
well?

thanks,

greg k-h
