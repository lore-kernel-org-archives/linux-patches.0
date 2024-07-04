Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980F2FBF6;
	Thu,  4 Jul 2024 07:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720077625; cv=none; b=CnSvXcDtTN5DXH98Z7Cza8KEgm/CsrbceyMnZw5cIFCEftMiO+OAU2mGWJ6kqI/oeYpgSD/wI5mAfBPFsdLzqr0mQd3SaDp0HMhVNsnZSmPdkfRzZbU6saKVVylW9VNtdJm1hRj03nx2tC2FGmS9TquEL1Hixg0P7nCUGMst1oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720077625; c=relaxed/simple;
	bh=MfDH1BzJEULCy9JB8I9/QpHlhvwA4blOe6gg/saAUMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ik8ZutSPffwUgZuamiR2XSr7YI+wiX1mwmJkMGqWO5KItjmpQi+0SpeVXC+ygHbl1/gTNXm8799UhWKAj8rOai16htSoWRMlrFxk8MwTJKc7ggAsU80WbgQ5SZfc7dEfdPJPyWZMzznKlJNpROQNtHbeu+7pDu6Sy6rCtNBXDEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZtUmT/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZtUmT/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16C5C32781;
	Thu,  4 Jul 2024 07:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720077625;
	bh=MfDH1BzJEULCy9JB8I9/QpHlhvwA4blOe6gg/saAUMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1ZtUmT/ShDlUTqNSLSmIv4qI4xK2YhFT0hbmuub/Z5HLyd4Kw+dX75aPIoQycpltW
	 cF69cqR52h88R+zTMiZnCekT2OHETTKVweak0vJuEfhE0qW5VnWwdyHFQgwyblfXYh
	 Co0ZmgCDDP1V/rudZpPyLAO23KMAW4WHek0MePMA=
Date: Thu, 4 Jul 2024 09:20:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Narasimhan V <Narasimhan.V@amd.com>,
	Jan Beulich <jbeulich@suse.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 255/356] x86/mm/numa: Use NUMA_NO_NODE when calling
 memblock_set_node()
Message-ID: <2024070412-choice-glare-2041@gregkh>
References: <20240703102913.093882413@linuxfoundation.org>
 <20240703102922.763942486@linuxfoundation.org>
 <ZoVJvsHESDvXZ413@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoVJvsHESDvXZ413@kernel.org>

On Wed, Jul 03, 2024 at 03:53:18PM +0300, Mike Rapoport wrote:
> On Wed, Jul 03, 2024 at 12:39:51PM +0200, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jan Beulich <jbeulich@suse.com>
> > 
> > [ Upstream commit 3ac36aa7307363b7247ccb6f6a804e11496b2b36 ]
> > 
> > memblock_set_node() warns about using MAX_NUMNODES, see
> > 
> >   e0eec24e2e19 ("memblock: make memblock_set_node() also warn about use of MAX_NUMNODES")
> > 
> > for details.
> 
> This commit was a fix for e0eec24e2e19, it's not needed for kernels before 6.8.

Thanks for the review, now dropped from all queues.

greg k-h
