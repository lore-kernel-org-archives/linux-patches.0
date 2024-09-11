Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90622191F8C;
	Wed, 11 Sep 2024 12:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726058057; cv=none; b=As3RbZX1qqxNJaoW+YzM2Us3r2tb/LePP+oM34OCkH6KmxumVirxtp8D8mxo90L781VWZAKOsPTi+bQY6LbtOBRKimVNWPifvQhjMYs2OcR3WhoQku8yZeM7NvmVUD9Y7K1luH+voUB97SEhFOlgNI+KJlQti1p1ee4cBImchn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726058057; c=relaxed/simple;
	bh=El9EBVR5VJb9yBt/saLzynlOMJnkzHJ7B6zPMidHyvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=srrQLEDlRR7Gu/csOI4//PNYLITyyZs8kTFmHp89gafPKL7FfQDxW/+9nK6xMeV0XhNQwMIB/2xkmq7hMDgKwQLM2IpQQkdreY5cgknEVIqPVDPI/PQJjSUkI1d8bw/9hgX4JRQTXOYOGik3IAQ6rMwncWB3Jn/6uOmqDX3I1PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcDWZyt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcDWZyt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF0DC4CEC6;
	Wed, 11 Sep 2024 12:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726058056;
	bh=El9EBVR5VJb9yBt/saLzynlOMJnkzHJ7B6zPMidHyvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZcDWZyt1qR3iEB2oO/mtxdSd47OOXRjLRsvl5KWXP637B299OfGCsI8IX0U4vYI3k
	 ah6DZYK3yUz/UX4WjKcZI/Q0iHKKR5PgpeOc0OPFOb8jzjx+gAZ+Zc0amYVWmusAld
	 mPHFpcP0teqaWaqUzo6px8Il2glZsuck52JuC6bE=
Date: Wed, 11 Sep 2024 14:34:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 250/375] tcp: Dont drop SYN+ACK for simultaneous
 connect().
Message-ID: <2024091153-husband-stipend-a444@gregkh>
References: <20240910092622.245959861@linuxfoundation.org>
 <20240910092630.944770087@linuxfoundation.org>
 <abd39210-9abf-4dc5-a2f9-6c9304cf2a52@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abd39210-9abf-4dc5-a2f9-6c9304cf2a52@kernel.org>

On Tue, Sep 10, 2024 at 12:51:01PM +0200, Matthieu Baerts wrote:
> Hi Greg,
> 
> -Cc netdev devs for this issue, not to create confusions.
> 
> On 10/09/2024 11:30, Greg Kroah-Hartman wrote:
> > [ Upstream commit 23e89e8ee7be73e21200947885a6d3a109a2c58d ]
> 
> I just noticed that your scripts stripped the simple quotes from the
> subject: "Don't" -> "Dont". It's not a big issue, because the commit
> titles are correct in the Git tree:
> 
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-6.10.y&id=5b05b62f9376
> 
> 
> The subject is also correct in the queue:
> 
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.10/tcp-don-t-drop-syn-ack-for-simultaneous-connect.patch
> 
> 
> So it is only an issue in the emails, just confusing not to find this
> patch in lore when looking at the subject with the quote :)
> 
> 
> https://lore.kernel.org/stable/?q=s%3A%22tcp%3A+Don%27t+drop+SYN%2BACK+for+simultaneous+connect%28%29.%22

Thanks for pointing it out.  Given that we are taking raw patches,
turning them into commits using 'git quiltimport' and then exporting
them using 'quilt mail --mbox' and then splitting them apart using a
perl script, it's amazing it all works at all :)

Something somewhere along the line is doing the cleanup, if I get a
chance I'll try to figure it out.  If you are curious, here's the horrid
script that does it all if you are bored:
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/scripts/quilt-mail

thanks,

greg k-h
