Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EB91772E
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 18:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE03CC433EF;
	Wed,  7 Jun 2023 18:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686160840;
	bh=dbJGvnpAAU3aNlhh+mNF60HQIDtPKqzissUhYAtP7yg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i0ZsxEJNVvQJKCFUGXgYasJ5OSEnQCFlmOQWeNdB+ABqmM7J5vU9q143ew0LukHrL
	 ok58iU3GGDkUACOsX/XIyBjytpvyi1MV7aEbYYfQGhEAydsbk7aWribqikHwbeN1Fs
	 eh0csQtisXPX93tR52+ZUFj+QFfEHq7U7yX4VYAY=
Date: Wed, 7 Jun 2023 20:00:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Philipp Hortmann <philipp.g.hortmann@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.3 145/364] staging: rtl8192e: Replace macro
 RTL_PCI_DEVICE with PCI_DEVICE
Message-ID: <2023060719-smasher-deluxe-e339@gregkh>
References: <20230522190412.801391872@linuxfoundation.org>
 <20230522190416.389735437@linuxfoundation.org>
 <aa0d401a7f63448cd4c2fe4a2d7e8495d9aa123e.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa0d401a7f63448cd4c2fe4a2d7e8495d9aa123e.camel@decadent.org.uk>

On Fri, Jun 02, 2023 at 08:35:31PM +0200, Ben Hutchings wrote:
> On Mon, 2023-05-22 at 20:07 +0100, Greg Kroah-Hartman wrote:
> > From: Philipp Hortmann <philipp.g.hortmann@gmail.com>
> > 
> > [ Upstream commit fda2093860df4812d69052a8cf4997e53853a340 ]
> > 
> > Replace macro RTL_PCI_DEVICE with PCI_DEVICE to get rid of rtl819xp_ops
> > which is empty.
> 
> It is not empty (except in 6.4).
> 
> This needs to be reverted from all stable branches.

{sigh}  You are right.  I'll go revert it from everywhere, thanks for
the review and letting me know.

greg k-h
