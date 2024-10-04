Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FAB1428F3;
	Fri,  4 Oct 2024 14:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728052543; cv=none; b=AirkROyUoMiCaYtWTth+omR+Noa1EA8bQ9DP+hsIrsQkgJ8NuqMfJ2+gZtdItRjdFL+q/50iOL1IrXsmmqEm/lPUTATGCJKSu5LhtFs/aW4SKyWV8Es1TqnV4C3L+MyfLGRwUBDSwcW/xNlghbomIFQqGnDsk7bdxHDa/ssKkQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728052543; c=relaxed/simple;
	bh=XAV2wyVHXcdbPz7MkyDprxMm5jUn1mb8lM9kLkuLPl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IS1PPtgtNnFqUa6YkNNRvyiRL6wrDvD77Zfr7SDHZtGWSmFRORIQfUzh3vkCtuGwB749bTA+MtKQFS8MvkVXApA42BF2OGzDRBalo0qDabKXEGbmNOXEybDdYIlCQVkL7vKntaBVCqHAVir3sbceiQeDZVHCguvLNvTaQQFhKrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+XL4Nw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+XL4Nw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B34C4CEC6;
	Fri,  4 Oct 2024 14:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728052543;
	bh=XAV2wyVHXcdbPz7MkyDprxMm5jUn1mb8lM9kLkuLPl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H+XL4Nw0/RWdHgC7404jEmz3gJEgPm4K07IAG1V52LoX3cYWddbxupm8mF4iZLLWP
	 iCodCGBmFBn4Z1cYiGKO4+ST3gvTEFuLtAFATp6LXv0WOsDirZx0getQUpzUwCKOIg
	 tba6XzjdBlehNxP5p2P6zjUOZeSUHJrVj000XMUE=
Date: Fri, 4 Oct 2024 16:35:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Youzhong Yang <youzhong@gmail.com>
Cc: Chuck Lever III <chuck.lever@oracle.com>,
	linux-stable <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Jeff Layton <jlayton@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
Message-ID: <2024100416-dodgy-theme-ae43@gregkh>
References: <20241002125822.467776898@linuxfoundation.org>
 <20241002125838.303136061@linuxfoundation.org>
 <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>
 <2024100330-drew-clothing-79c1@gregkh>
 <A8D6C21F-ACAD-4083-900F-528EB3EB5410@oracle.com>
 <CADpNCvbKGAVcD9=m_YxA6qOF6e0kohOfVsKOqJeVmrYaq0Sd8w@mail.gmail.com>
 <2024100420-aflutter-setback-2482@gregkh>
 <CADpNCvYn9ACkumaMmq7xAj6EQuF6eYs174J+z81wv5WqzdWynA@mail.gmail.com>
 <2024100430-finalist-brutishly-a192@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024100430-finalist-brutishly-a192@gregkh>

On Fri, Oct 04, 2024 at 04:26:39PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Oct 04, 2024 at 10:17:34AM -0400, Youzhong Yang wrote:
> > Here is 1/4 in the context of Chuck's e-mail reply:
> > 
> > nfsd: add list_head nf_gc to struct nfsd_file
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8e6e2ffa6569a205f1805cbaeca143b556581da6
> 
> Sorry, again, I don't know what to do here :(
> 
> 

Ok, in digging through the thread, do you feel this one should also be
backported to the 6.11.y tree?  If so, how far back?

thanks,

greg k-h
