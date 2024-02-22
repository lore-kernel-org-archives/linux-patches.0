Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51436179A1;
	Thu, 22 Feb 2024 06:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708582371; cv=none; b=SFucWy24wrh2KV7/+THVquLsJCZJ509RLBwZuftSSn7ne2tKKbg14h6b3RlHD6RttLvFoTiFFdW7tW2uxJRuSitWLHRY0DZ9WtOce/kWQLCE/f9pNrGBO+WLHVvYqilgmA1KbOB8nsM/VndC+7OeUwGnQ4VC7kHGwU0FzJ5TFn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708582371; c=relaxed/simple;
	bh=NxA3BcJct0ZiXulu5W58vaSD8mjq0OW0GrBwFPaW/t0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VyLCwLXNejoj9/T/Npe6aqltsKGNk4wrUG7jIjM/oEL0aKvzwTDLtqap7+aH4RL4QnWcLLcw2B3cbFMfiEb8VvpSNeeOcmMiEzeRQFmgZeYNQoqdpX/4P1vj33TvYBE3h8TG8hYuUiPw4Gy4gjPEhjarABR5dNyDrECh9IwzPR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhqPykaS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhqPykaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58362C43390;
	Thu, 22 Feb 2024 06:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708582370;
	bh=NxA3BcJct0ZiXulu5W58vaSD8mjq0OW0GrBwFPaW/t0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hhqPykaSoq1/5kQfU2EtLOFdA5I2IH/0wm+Np4WikjVSA6QWMe6W/VN4uIgVlHbsl
	 ddmxWQOsAQ2B9LjsTcWB7VzsG+qy8wbnh1oDY+O+ofNkYc0jeI2BOF0S5EofsAVDDJ
	 WF9GrykSvCiTRRJ8Ci203hvrAFLx34Ush36fXHow=
Date: Thu, 22 Feb 2024 07:12:47 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 111/476] NFSD: Modernize nfsd4_release_lockowner()
Message-ID: <2024022213-salami-earflap-aec9@gregkh>
References: <20240221130007.738356493@linuxfoundation.org>
 <20240221130012.081046577@linuxfoundation.org>
 <20240222061911.6F1A.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240222061911.6F1A.409509F4@e16-tech.com>

On Thu, Feb 22, 2024 at 06:19:12AM +0800, Wang Yugui wrote:
> Hi,
> 
> 
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Chuck Lever <chuck.lever@oracle.com>
> > 
> > [ Upstream commit bd8fdb6e545f950f4654a9a10d7e819ad48146e5 ]
> > 
> > Refactor: Use existing helpers that other lock operations use. This
> > change removes several automatic variables, so re-organize the
> > variable declarations for readability.
> > 
> > Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > Stable-dep-of: edcf9725150e ("nfsd: fix RELEASE_LOCKOWNER")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> 
> "nfsd: fix RELEASE_LOCKOWNER" is yet not in 5.15.149-rc1?
> or I missed something?

Good catch, you are correct!  I'll go drop this, and the other nfsd
"dep-of" commit in this queue, and in the 5.10 and 5.4 queues.

thanks,

greg k-h
