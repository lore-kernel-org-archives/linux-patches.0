Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEAF27FD7D;
	Sun, 11 Jan 2026 10:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768127480; cv=none; b=YkM7O4Bio3nEeujWwvAAUGUQFbJFvIATem6EVGbpbE6G0LQ2oIylnUqQNExEvCAitTi9ty3+ekHzqcv0E+HjjcI2ulqH4EJr7jOzgC/ohDNQwAN4ozAL9lJHGFY5m3iQGBUOqwuH0GrxRfw3qwXVJamy9rAQQZ3BNUata/edbvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768127480; c=relaxed/simple;
	bh=B7fzFEMWfKPLrI7HpAcWmdwvOWpzP+NMgSymitdjl5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+eUfhnuepbUwoN+a5nhNrP7fdQgGwRy8xcK1x255YguHTgX5pZxdK6KJP7gtVBU2+moOybd1BRZaiPYFWwKXcRF8nXrStrp37i9vj7gjVj4seI250TIZTWmZFpNXRH+1EVR0+PmMqJQ85dOnsOGCPFB5cOw1zgdqeVxmPcsATo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=hE2sPa0w; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="hE2sPa0w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5Yrv835MvV0UB+bYy9pdcf/uSOvvXEkkY8sNhxEs8xc=; b=hE2sPa0whH8Fry6HT7jvLT3W0C
	0WaNJjro4YWtS5FJ9aBQbrvkA7rtcnTy8B9epqs0DpNBboJMxSD037E6+Rh6TEsSvc3mSf1F5G7AE
	4zsj3Omv7Kr3jFGpP/vzYmQBoOHnyRBMeX+GzyIMEUJznwLMp9c2NKxP0EAQna8hqnjlLbW4rpkOl
	0GmP3ZMRc1ZIlmicnWD5cSeMGJteWL+g2T3hTqbpCb/oRaF6wHnXXJfF8q+TZheImiVWGHgBheqNQ
	dUh4rY0c2UUhc0rXIb+luHLA29ycLBR16yeW/ajiZR/Q7LPJKfLXm78U9eZQIVPMBOdYhoNcAonoo
	qH+J6Jig==;
Received: from 179-125-75-246-dinamico.pombonet.net.br ([179.125.75.246] helo=quatroqueijos.cascardo.eti.br)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vesiv-0042Dl-K4; Sun, 11 Jan 2026 11:31:06 +0100
Date: Sun, 11 Jan 2026 07:30:58 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 6.6 731/737] ext4: filesystems without casefold feature
 cannot be mounted with siphash
Message-ID: <aWN74hQARUawYete@quatroqueijos.cascardo.eti.br>
References: <20260109112133.973195406@linuxfoundation.org>
 <20260109112201.603806562@linuxfoundation.org>
 <aWEFUlM6PsTMMXxr@quatroqueijos.cascardo.eti.br>
 <2026010942-overdue-repayment-b202@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026010942-overdue-repayment-b202@gregkh>

On Fri, Jan 09, 2026 at 03:13:55PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Jan 09, 2026 at 10:40:34AM -0300, Thadeu Lima de Souza Cascardo wrote:
> > Hi, Greg.
> > 
> > The followup to 985b67cd86392310d9e9326de941c22fc9340eec, that I submitted
> > in the same thread, has not been picked up.
> > 
> > 20260108150350.3354622-2-cascardo@igalia.com
> > https://lore.kernel.org/stable/20260108150350.3354622-2-cascardo@igalia.com/
> > a2187431c395 ("ext4: fix error message when rejecting the default hash")
> > 
> > You picked it up for 6.1 and 5.15 though.
> 
> It's in the queue, odd you didn't get an email.
> 
> thanks,
> 
> greg k-h

Ah, I see it now, when looking for the upstream hash and not my sign-off.
It was a different backport that ommitted the original fix and only applied
the fixup/followup.

The original fix adds a hunk that is then removed by the followup. So when
applying the followup that ignores that hunk and then the original fix with
that hunk, 6.6 queue now is carrying an undesired hunk message.

If you drop a032fc761cc3f1112c42732d9a2482f23acad5fc and apply
https://lore.kernel.org/stable/20260108150350.3354622-2-cascardo@igalia.com/
instead, it should be in the expected final state. I would rather do that,
as then 6.6.y would be carrying the original fix, avoiding it to be
backported again.

Cascardo.
