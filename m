Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01976268698;
	Fri, 18 Apr 2025 06:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744958427; cv=none; b=bRhYROR9AeE0dh3iJaxB1L3gYVqA6R+GjKZo6SOTSiRoiCSl9JwhFK+YrQqAiLT85XS3g1OqF7hCC7Wf2b90l366I5yF6TJB5e08n+R1dHpIg/ciNqCT1XZXzkFbKo0jyA1WsR9FzY3M5OW2Y74XElHGr7SD6yk4gfutUT4M7+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744958427; c=relaxed/simple;
	bh=LTQb0pZNs3sDMd31nLjQvHI10rlPCkCEpiwK4oiqXvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7s3Yqlnp51zz423JZhDOf1nDs1obTqrhnLwvMGAJfVXkhU9Z6R+4s9ABxzo3umYn8xbx5yeWRelwB75BWdlQ2RiTNg/8+ewinJjzeCpoViPeOY3iZOrCc6lYVf08PqgcMvyrUKw/7yP9n4ScakR4T7O//EkNBL3EidsNWkxJvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PrjU8H8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PrjU8H8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD7BC4CEE2;
	Fri, 18 Apr 2025 06:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744958426;
	bh=LTQb0pZNs3sDMd31nLjQvHI10rlPCkCEpiwK4oiqXvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PrjU8H8sXGR698Ym2TENEAlpa5/5U4r21BGkg/b+txKybc7ThB3B48HnP610Bp4Qq
	 eRbTz/cjABZUJUJ/BDTfi1NIM5/t2pYr+lEtgvr+xbbeXStDtQZUVafOS14bIEE1LR
	 TeTpFLRVpQjbWEGqgEk92o3Oh/5QJDyUC5HCywNXNc2PuIjbJFJW6IrPvyR6E0PcL8
	 8XRDL5Z+9XFwnnkmHf7C19cN2IfLKw8Qrym58GbCvX1I3kAd91r7uzQdqv6coUZhgz
	 bp7xQEdC7J/4nVOichzIFGw4OH3Mz1U2ZI2cRlK2mMvav6y81jBNwBA2lKopv/gxgc
	 wwhw7s1A+ba2g==
Date: Fri, 18 Apr 2025 08:40:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Luck, Tony" <tony.luck@intel.com>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/cpu: Add two Intel CPU model numbers
Message-ID: <aAHz1tru8GT9ET9j@gmail.com>
References: <20240923173750.16874-1-tony.luck@intel.com>
 <c8545ed5-b822-43a0-a347-d077bccf9d6f@citrix.com>
 <SJ1PR11MB6083F36D7C68AE8DF5AAA39DFCFC2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20250214130205.GK14028@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214130205.GK14028@noisy.programming.kicks-ass.net>


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Feb 12, 2025 at 04:09:11PM +0000, Luck, Tony wrote:
> > >> +/* Family 19 */ +#define INTEL_PANTHERCOVE_X IFM(19, 0x01) /* Diamond
> > >> Rapids */
> > >
> > > Is it intentional that this is not INTEL_DIAMONDRAPIDS_X like
> > > Sapphire/Emerald/Granite ?
> > 
> > Andrew,
> > 
> > PeterZ wants to name based on core, not SoC (at least for mono-core CPUs ... this
> > doesn't work for hybrid).  Argue with him.
> 
> Argh :-)
> 
> So yeah, its a trainwreck.
> 
> We used to use uarch, and that worked until skylake.
> 
> I'm not sure what exactly we continued as, but Kaby Lake was a Skylake
> uarch.
> 
> The Atoms are uarch and still are, they weren't messed up.
> 
> But if you want to do DMR as PANTERCOVE then SPR should've been
> GOLDENCOVE and we didn't do that either.
> 
> 
> Also, since DMR is the direct continuation of GRANITERAPIDS, it should
> also come below it.
> 
> Therefore, I'll concur with Andy that this is all highly irregular and
> would propose we do the below.
> 
> Isn't the only reason we're doing a new Family because we can out of
> module number space? It's not magically different from Fam6.

Mind sending this with a changelog, or at least a SOB? :)

Thanks,

	Ingo
