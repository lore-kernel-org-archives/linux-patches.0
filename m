Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BE7433B3;
	Sun, 19 Oct 2025 12:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760876707; cv=none; b=rH5bJXne//H0AAvA9+F7TglXuANSFgRjy6Cn+UzK+5zgkFnXRNfEyDMmIYQQ2djv1lu1O/ANAUQ5jp5bwTW6N54Ytv7l6cCwNCwM9WXdFvcbucHIYNJPHU6wGWCL496SqnKFOuZgQfJUsIwCR2LGeuCfveVkpAqG/yY2KYntoRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760876707; c=relaxed/simple;
	bh=8IE0EzreFw146UdXE9W1G5AtsTXg70K0eiJZsBlnPhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtQKo8SlYnzLKpZVu6JpiXMK5XrcE1/uCWMKw/mmUJQpOJc50k/GP0kz8c6tHSX05D+BsKOzn8AymwXB6kLLxSlkPtgELtUB7cGjWzLnZjDCUMjK/tugtX+uWMfUyhsuvENBA3SrT5+I1qRnnLPBBuQaRyoRLeKRvTreP5ToOWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPUooXQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPUooXQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD33C4CEE7;
	Sun, 19 Oct 2025 12:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760876703;
	bh=8IE0EzreFw146UdXE9W1G5AtsTXg70K0eiJZsBlnPhk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fPUooXQRLIxcoMKz4+YLjROqD2h2jdYt7T3HjsmSYsOXTGlXzaABOwNGOEFgIlRa/
	 AhHKhkizJchGE8rwCQS/bTb34B6NnXXy26PGnunkPkcxKUzhNc5TmlV1pcfec4YtBq
	 xtcy8vVc02d5ZJcdjyKMPL0Bkc4TMErI6N7aSUw4=
Date: Sun, 19 Oct 2025 14:25:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	NeilBrown <neil@brown.name>, Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 6.12 276/277] nfsd: fix access checking for NLM under
 XPRTSEC policies
Message-ID: <2025101933-bobbing-eagle-5c82@gregkh>
References: <20251017145147.138822285@linuxfoundation.org>
 <20251017145157.237029632@linuxfoundation.org>
 <dbed118e-fbb1-4fed-adf2-cc6213aa93a9@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbed118e-fbb1-4fed-adf2-cc6213aa93a9@oracle.com>

On Fri, Oct 17, 2025 at 11:32:49AM -0400, Chuck Lever wrote:
> On 10/17/25 10:54 AM, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> No objection, but a question:
> 
> This set of patches seems to be a pre-requisite for  "nfsd: decouple the
> xprtsec policy check from check_nfsd_access()", which FAILED to apply to
> v6.12 yesterday. Are you planning to apply that one next to v6.12?

Ah, I didn't realize that was a dependancy here.  I've now queued it up,
but it looks like that commit still needs a real backport for 6.6.y.

thanks,

greg k-h
