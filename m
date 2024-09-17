Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD61117838F;
	Tue, 17 Sep 2024 16:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726589055; cv=none; b=KldnMdmkuM0Xk5xh8cpTrfXvPGU/Esmm/UBH5YPS+PvfHFhCftVr+ODpL2XPK5NAQtsxdgyTo+RRglVEeSDoh1mxE6gNC0kQYCG7/moaMOwk7c4bjpB+j1rCGTb3KUvJFtN/bksCSYGhgm6QG32O7u8zjugHbGYRsG7Up0AqdkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726589055; c=relaxed/simple;
	bh=LuR1ANNZH8escrqY6PxNCxW7+kznQJOfxLhSgvt8Vi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmIZ0Gcv3JDCemxC9dr2kPuOITQb2Yawps/rjSP7qEAqTdFYzUssJOQDMQGUAjFBo2cCp2jrtTFdaTw5L0EvtcI9DrihNhbqHxN3TA2on/JTHA4tCHcdnOOWcjA4JASaB0mwTQ7fxUlnGal5cha7Pp5KSAzQA5wuEmoze+9pwW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jpqk2Qiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jpqk2Qiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EEDC4CEC5;
	Tue, 17 Sep 2024 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726589055;
	bh=LuR1ANNZH8escrqY6PxNCxW7+kznQJOfxLhSgvt8Vi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jpqk2QiqZTNcLPj5QJ5f7LOamR6axMNR6DYg7wmB4ZwWBARgcZryqDUJZgSVBXG1F
	 neSSMDqRlph+eBIreJNrQNo1niH2IIGGI+hBucFAXyjcw6BS6lh5+8uYPHuWqRigJ8
	 M1R4Nn2fDQw7Zy6xzHRet+ZKeWZz8OENs5qMOcS7JV7ZQF9wGhiMu81xCwotcQRBl1
	 s04kIVn1PmgJUkw4inp/QbQUOrv3ihYTLYV7LVHEjyeqxOagBsngWMue/EZbDwPp+u
	 DJsUmiGOxkaIWbQh10X8+MoyWbIiDhquNumnRa8BjVBzLRMGE68drMNI/mCbYycH63
	 RtOu9IWfGYi3g==
Date: Tue, 17 Sep 2024 09:04:13 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH v2] x86/resctrl: Annotate get_mem_config functions as
 __init
Message-ID: <20240917160413.GA2865863@thelio-3990X>
References: <20240913-x86-restctrl-get_mem_config_intel-init-v2-1-bf4b645f0246@kernel.org>
 <8e34346b-9703-48e5-8923-15800fa78899@intel.com>
 <20240917133520.GA2360164@thelio-3990X>
 <c4175ca2-6551-4255-ab5c-0840f2b43008@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4175ca2-6551-4255-ab5c-0840f2b43008@intel.com>

On Tue, Sep 17, 2024 at 08:14:17AM -0700, Reinette Chatre wrote:
> Hi Nathan,
> 
> On 9/17/24 6:35 AM, Nathan Chancellor wrote:
> > Hi Reinette,
> > 
> > On Mon, Sep 16, 2024 at 02:42:09PM -0700, Reinette Chatre wrote:
> > > Just one nit in the subject ... this area has the custom to use "()" to
> > > highlight that the name refers to a function, so rather:
> > > 
> > > 	x86/resctrl: Annotate get_mem_config() functions as __init
> > 
> > Thanks, I am aware of this custom since I do it in the commit message
> > but since get_mem_config() is a function in this file and it is not
> > exactly touched by this change, it did not really feel appropriate to
> > add the parentheses there.
> 
> hmmm ... I understand that () is used to highlight that the text is
> referring to a function independent from how the function is impacted
> by the change.
> 
> > 
> > I can send a v3 with this fixed if so desired or perhaps whoever is
> > going to apply this can just do it then?
> 
> Could you please send v3? That will make its inclusion smoother (pending
> any other feedback from next level maintainers).

Alright sure, done: https://lore.kernel.org/20240917-x86-restctrl-get_mem_config_intel-init-v3-1-10d521256284@kernel.org/

Cheers,
Nathan
