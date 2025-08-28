Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D23C52F99;
	Thu, 28 Aug 2025 14:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756390572; cv=none; b=NHv0YbgMn0pT1GJqKcCQ+Z5wJMKkOa+4j5UoFPqRgMSeayKSxJU/9QwFZpvlvLSFGF8D9ZNAVo8AFt2xG+w2+bYjsLNUtn+xGuSp7ti9PZlqxDyJj34nIe7YA5elNWEoZXK22fBTjg9x22o8Y8EhV9MnB8Wt+k4Ekb4F/tcr6tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756390572; c=relaxed/simple;
	bh=ztHm231HgxoYUCSZHZGMAWRHSf2wFhE8cSp7VQmb1G0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WwFJxqZmEvacwHy5spnbQQYCLIt8O5zmiH+L0zknGBBp04oCh1KpCzPTHWa+MpntoN0+/u5UlP6z4Z4lsVy3Iyvs2jm+8E72ZdGIQVpUog6DydpjcfsmB+gBx4C9X92vdT7eo/N8ogxBFYhAsn8v1wt6nQ3h5c4ckY+RUGV1mxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGprmO3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGprmO3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29743C4CEED;
	Thu, 28 Aug 2025 14:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756390571;
	bh=ztHm231HgxoYUCSZHZGMAWRHSf2wFhE8cSp7VQmb1G0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fGprmO3zSBkvpjj+cAi5MRVqjQHycRuaMb7fW3uo7ckL1a6gSl8CzO2HRDjDQey3f
	 iGh/ECQrYmZnc16RF/Fc9uPBoOO/Ss4ZFX3/YnlUCUjV5jW+BzC4bAjFr5bqG33CyP
	 u8hdpLQLO6J9deri4d8EQDDLN/RJpWzSFDXXjx9g=
Date: Thu, 28 Aug 2025 16:16:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Mkrtchyan, Tigran" <tigran.mkrtchyan@desy.de>
Cc: stable <stable@vger.kernel.org>, patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH 5.10 168/523] pNFS/flexfiles: dont attempt pnfs on fatal
 DS errors
Message-ID: <2025082830-repulsive-written-dc45@gregkh>
References: <20250826110924.562212281@linuxfoundation.org>
 <20250826110928.612854620@linuxfoundation.org>
 <1930989002.4608779.1756385283630.JavaMail.zimbra@desy.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1930989002.4608779.1756385283630.JavaMail.zimbra@desy.de>

On Thu, Aug 28, 2025 at 02:48:03PM +0200, Mkrtchyan, Tigran wrote:
> 
> Hi Greg,
> 
> I just got a report that the proposed fix has a bug in one of the error paths. I am
> trying to fix that, so you might want to wait with the backport.

As it's already in many other released kernels, we are going to have to
apply whatever fix you come up with to them, so this should be ok for
now.  Being "bug compatible" with other stable kernel releases is a
feature :)

thanks,

greg k-h
