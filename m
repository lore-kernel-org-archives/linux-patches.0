Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F6C18630
	for <patches@lists.linux.dev>; Sat,  7 Oct 2023 11:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+CdNouz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1295C433C8;
	Sat,  7 Oct 2023 11:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696677782;
	bh=oVut5drEvky7Iw6+ulamagFWRxF9tJ4Wqzj9wYreJNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s+CdNouzLYJrC2hyDn6HmZZ8Rx8I6vSMBbeHBycf0Q+GSgC2ct/Nb51BZpu1vc6YQ
	 mF3TTNk9K/COaRWLx0JIJnkqvZ2QDGtCf/zQg5DiJpMr7LLAxzoAvktj8Tee6zT+Vb
	 eRb1QRZLwwE/fFavy7+NrAwtjnK9VJlu9oqHGEp0=
Date: Sat, 7 Oct 2023 13:22:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Joe Perches <joe@perches.com>,
	Brennan Lamoreaux <blamoreaux@vmware.com>
Subject: Re: [PATCH 4.19 322/323] drivers core: Use sysfs_emit and
 sysfs_emit_at for show(device *...) functions
Message-ID: <2023100722-carload-district-f291@gregkh>
References: <20230809103658.104386911@linuxfoundation.org>
 <20230809103712.823902551@linuxfoundation.org>
 <95831df76c41a53bc3e1ac8ece64915dd63763a1.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95831df76c41a53bc3e1ac8ece64915dd63763a1.camel@decadent.org.uk>

On Mon, Sep 25, 2023 at 12:40:47AM +0200, Ben Hutchings wrote:
> On Wed, 2023-08-09 at 12:42 +0200, Greg Kroah-Hartman wrote:
> > From: Joe Perches <joe@perches.com>
> > 
> > commit aa838896d87af561a33ecefea1caa4c15a68bc47 upstream.
> > 
> > Convert the various sprintf fmaily calls in sysfs device show functions
> > to sysfs_emit and sysfs_emit_at for PAGE_SIZE buffer safety.
> 
> [...]
> > Signed-off-by: Joe Perches <joe@perches.com>
> > Link: https://lore.kernel.org/r/3d033c33056d88bbe34d4ddb62afd05ee166ab9a.1600285923.git.joe@perches.com
> > [ Brennan : Regenerated for 4.19 to fix CVE-2022-20166 ]
> 
> When I looked into the referenced security issue, it seemed to only be
> exploitable through wakelock names, and in the upstream kernel only
> after commit c8377adfa781 "PM / wakeup: Show wakeup sources stats in
> sysfs" (first included in 5.4).  So I would be interested to know if
> and why a fix was needed for 4.19.

It should not be needed there.

> More importantly, this backported version uniformly converts to
> sysfs_emit(), but there are 3 places sysfs_emit_at() must be used
> instead:

Ick, ok, I'll go revert the commit, thanks.

greg k-h
