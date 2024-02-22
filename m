Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9F77A722;
	Thu, 22 Feb 2024 13:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708607212; cv=none; b=LSJE16qpeY9KrlD29d1SkRqGTQ9nzb/fjgPM7msyTjRewWJ1/57HKy3/Bq0OfhBmNrdU8kwtgRKVO+d9wXH9zySg1QivcM0Yfx7q/0jRmhsc+qlzf6EvZGN37JOhzqQ+D7P7F11rForSlLBH+oWbKBU1EBVfWkm8I7RPc2GdG44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708607212; c=relaxed/simple;
	bh=2UlY9J14QuVf01GXSbvFb1AcRgD6WwAfnIMlxam6Nm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u4NVbVzQlf6MxqehkxhANWTKZ3pXpvtmJfbkaxvcO/nRNYKSw9caLX6PC5TOAgQp9eFuVjO3gFTfFl0D31fBtirnCySzDLnwiHJGkkOyUMqG+6deBFYtGbSEOd9GMaAIdlR+g/t/AU5t+T3RpbHd+rKs7Mhe4b86Hv/jIvScmuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5d5bhrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5d5bhrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF43C433C7;
	Thu, 22 Feb 2024 13:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708607212;
	bh=2UlY9J14QuVf01GXSbvFb1AcRgD6WwAfnIMlxam6Nm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J5d5bhrVFcjQ0mMMHh4vJH98ceejWQBIRiu5mkac10tSrNdUspv2XiuRvYRCFstdJ
	 aRUSzcbrd5Qw1fuGQfsS054oKJ3LcryRL0AS8uv3oCZiRvBv/uiM2l+WkchzVCpL8s
	 qEa6I2+tmTiGlEr5zGwK/PF0xccS//NC7NKJtZns=
Date: Thu, 22 Feb 2024 14:06:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 111/476] NFSD: Modernize nfsd4_release_lockowner()
Message-ID: <2024022234-endurance-unlaced-e06c@gregkh>
References: <20240222061911.6F1A.409509F4@e16-tech.com>
 <2024022213-salami-earflap-aec9@gregkh>
 <20240222210204.4F83.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240222210204.4F83.409509F4@e16-tech.com>

On Thu, Feb 22, 2024 at 09:02:05PM +0800, Wang Yugui wrote:
> Hi,
> 
> > On Thu, Feb 22, 2024 at 06:19:12AM +0800, Wang Yugui wrote:
> > > Hi,
> > > 
> > > 
> > > > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Chuck Lever <chuck.lever@oracle.com>
> > > > 
> > > > [ Upstream commit bd8fdb6e545f950f4654a9a10d7e819ad48146e5 ]
> > > > 
> > > > Refactor: Use existing helpers that other lock operations use. This
> > > > change removes several automatic variables, so re-organize the
> > > > variable declarations for readability.
> > > > 
> > > > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > > > Stable-dep-of: edcf9725150e ("nfsd: fix RELEASE_LOCKOWNER")
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > 
> > > 
> > > "nfsd: fix RELEASE_LOCKOWNER" is yet not in 5.15.149-rc1?
> > > or I missed something?
> > 
> > Good catch, you are correct!  I'll go drop this, and the other nfsd
> > "dep-of" commit in this queue, and in the 5.10 and 5.4 queues.
> 
> Will we add "nfsd: fix RELEASE_LOCKOWNER" to 5.15.y later?
> 
> It seems that at least 5.15.y need "nfsd: fix RELEASE_LOCKOWNER".

If someone sends a properly tested and backported series, sure!

thanks,

greg k-h
