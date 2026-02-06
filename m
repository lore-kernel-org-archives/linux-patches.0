Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E059362128;
	Fri,  6 Feb 2026 11:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770376192; cv=none; b=qGvcsjrRKjQRaDS8sSlKQBQFq+L95P5NwGtHV5C591elepJo+7XoDQAPEipqTOMEID6EifjJc8Ohrx/3LPW9D4zMiJvjNT3I0GiXOrAxS4ULZZHXjDy2dWu3nkEnx1Knc2m65Z7lUjVuJ4MRsMgPK+qP2TYeE6qj1odA0KNxz38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770376192; c=relaxed/simple;
	bh=NuZij6bd1aLQwa7nUP0F1qBKgfTU4ENmmVONN4IbSc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PVf+3RUZnueqmTRJot0O7im+Kn5wMK+mkvW3MSYsI0+Du7tbwJqs3K4aFqovLKugc3gFy/vMWvSW2GTTg1kPWG8exWcG3KI3Gg9op1BiHKjrkrozOvFgcp8kKe6nPNViE6hN2oC4ooJVtF/BL5CxGEqDFT/rnPu3LvyxhflkWfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSy7jiO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSy7jiO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DCEC116C6;
	Fri,  6 Feb 2026 11:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770376191;
	bh=NuZij6bd1aLQwa7nUP0F1qBKgfTU4ENmmVONN4IbSc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xSy7jiO//JXQxmD2TIVjKn10l1Y9rqK+kqHepoEkAT425PYMG0TvnJ2u7KpBm3IiE
	 nWuiv+nwmceGm40t/bj7xTXLT89qJhPMjiDtE/oOQEFrmaRzvLVRMeGL5ZsJfHIYMw
	 zis+VmfEh3f/1PzRILUxFIqpnMde8ALWp0VQhFsY=
Date: Fri, 6 Feb 2026 12:09:48 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 050/161] selftests/net: convert fib-onlink-tests.sh
 to run it in unique namespace
Message-ID: <2026020640-anchovy-gear-40e5@gregkh>
References: <20260204143851.755002596@linuxfoundation.org>
 <20260204143853.562371909@linuxfoundation.org>
 <ec318a7c1b9a06836b8694a1b63e187d3f53bd80.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec318a7c1b9a06836b8694a1b63e187d3f53bd80.camel@decadent.org.uk>

On Thu, Feb 05, 2026 at 06:04:57PM +0100, Ben Hutchings wrote:
> On Wed, 2026-02-04 at 15:38 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Hangbin Liu <liuhangbin@gmail.com>
> > 
> > [ Upstream commit 3a06833b2adc0a902f2469ad4ce41ccd64f1f3ab ]
> [...]
> > Stable-dep-of: 4f5f148dd7c0 ("selftests: net: fib-onlink-tests: Convert to use namespaces by default")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  tools/testing/selftests/net/fib-onlink-tests.sh | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/net/fib-onlink-tests.sh b/tools/testing/selftests/net/fib-onlink-tests.sh
> > index c287b90b8af80..ec2d6ceb1f08d 100755
> > --- a/tools/testing/selftests/net/fib-onlink-tests.sh
> > +++ b/tools/testing/selftests/net/fib-onlink-tests.sh
> > @@ -3,6 +3,7 @@
> >  
> >  # IPv4 and IPv6 onlink tests
> >  
> > +source lib.sh
> [...]
> 
> tools/testing/selftests/net/lib.sh doesn't exist in 5.10, so this can't
> work.

It doesn't exist in 6.1 or older either, so I'll go drop this from all
of those queues.

Thanks for the review!

greg k-h
