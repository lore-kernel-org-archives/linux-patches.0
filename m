Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A443FB06
	for <patches@lists.linux.dev>; Tue, 19 Sep 2023 09:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616FFC433C8;
	Tue, 19 Sep 2023 09:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695115564;
	bh=dIX7K4nq2k96aQ9nFRVRlz0BG7mlTcFR0KgMSO2smsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eiIKkVYTmUZKgX4koOKCuQJnfkZHGD3BIvdIi+Rluo5Usjh8Kl++JxDPeevpXFU8v
	 16U4ED6+eSENcM6MjDSHA5fD1bIIRhNqUX7wWaFa3ELiAyT+sKG3mbzsBr1UIVzuUO
	 FcgdK33Ezlw81DLyrs9+StgeZBBtXEDu/whmDw2w=
Date: Tue, 19 Sep 2023 11:26:00 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>,
	Luis Gerhorst <gerhorst@cs.fau.de>,
	Alexei Starovoitov <ast@kernel.org>, Eddy Z <eddyz87@gmail.com>,
	Yafang Shao <laoar.shao@gmail.com>, patches@lists.linux.dev,
	stable <stable@vger.kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Hagar Gamal Halim Hemdan <hagarhem@amazon.de>,
	Puranjay Mohan <puranjay12@gmail.com>,
	Luis Gerhorst <gerhorst@amazon.de>
Subject: Re: [PATCH 6.1 562/600] bpf: Fix issue in verifying allow_ptr_leaks
Message-ID: <2023091934-frequency-unloader-7cd7@gregkh>
References: <20230911134650.200439213@linuxfoundation.org>
 <20230914085131.40974-1-gerhorst@amazon.de>
 <2023091653-peso-sprint-889d@gregkh>
 <b927046b-d1e7-8adf-ebc0-37b92d8d4390@iogearbox.net>
 <2023091959-heroics-banister-7d6d@gregkh>
 <CAADnVQKXqaEC3SOP9eNQH1f3YF0E3A_54kSEsU2LvCL_4Awe8g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQKXqaEC3SOP9eNQH1f3YF0E3A_54kSEsU2LvCL_4Awe8g@mail.gmail.com>

On Tue, Sep 19, 2023 at 01:39:44AM -0700, Alexei Starovoitov wrote:
> On Tue, Sep 19, 2023 at 1:34 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Sep 19, 2023 at 08:26:28AM +0200, Daniel Borkmann wrote:
> > > On 9/16/23 1:35 PM, Greg KH wrote:
> > > > On Thu, Sep 14, 2023 at 08:51:32AM +0000, Luis Gerhorst wrote:
> > > > > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > > > >
> > > > > > From: Yafang Shao <laoar.shao@gmail.com>
> > > > > >
> > > > > > commit d75e30dddf73449bc2d10bb8e2f1a2c446bc67a2 upstream.
> > > > >
> > > > > I unfortunately have objections, they are pending discussion at [1].
> > > > >
> > > > > Same applies to the 6.4-stable review patch [2] and all other backports.
> > > > >
> > > > > [1] https://lore.kernel.org/bpf/20230913122827.91591-1-gerhorst@amazon.de/
> > > > > [2] https://lore.kernel.org/stable/20230911134709.834278248@linuxfoundation.org/
> > > >
> > > > As this is in the tree already, and in Linus's tree, I'll wait to see
> > > > if any changes are merged into Linus's tree for this before removing it
> > > > from the stable trees.
> > > >
> > > > Let us know if there's a commit that resolves this and we will be glad
> > > > to queue that up.
> > >
> > > Commit d75e30dddf73 ("bpf: Fix issue in verifying allow_ptr_leaks") is not
> > > stable material. It's not really a "fix", but it will simply make direct
> > > packet access available to applications without CAP_PERFMON - the latter
> > > was required so far given Spectre v1. However, there is ongoing discussion [1]
> > > that potentially not much useful information can be leaked out and therefore
> > > lifting it may or may not be ok. If we queue this to stable and later figure
> > > we need to revert the whole thing again because someone managed to come up
> > > with a PoC in the meantime, then there's higher risk of breakage.
> >
> > Ick, ok, so just this one commit should be reverted?  Or any others as
> > well?
> 
> I don't think revert is necessary. Just don't backport any further.

Ok, thanks, it's not backported into any other kernels at the moment, so
I'll not worry about this anymore :)

greg k-h
