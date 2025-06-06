Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8472857DE;
	Fri,  6 Jun 2025 09:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749200875; cv=none; b=XYBJW9kOuV0yv/eBbnoc5ThOXO/CtfZ7pNdfVPul5D0GymT6NpSl97qdizJBNSQbXEzTZ7t9fPzoOnhufc1sR0iidH3kl+gFamc/NK1MMv1yuHXgH43RkTF+ZR5bzokmI2ptkQMMHgsQdd2g+l9yH/65Eu7ztzgqmnUgXvR93R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749200875; c=relaxed/simple;
	bh=PzbyzavS0vAnEI3N7Krprs1J/dlUJN7T07X0H6BB15Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FkMm1Mj70IHjuUQgyyVCroSdobsbruUsm5Tkzp1YmekxVEJM1oVtdR5ad4c7UYBQgaai2gUNq7c3pwJl3XM9WjT8gXu2doB1QPdhFodKmpCvtBWFDpz0kIJdmWQeUr4cQWQcVMeW3ATrP80c1YFxoziEvSoMgLZQN0u7fm3PfIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=listout.xyz; spf=pass smtp.mailfrom=listout.xyz; dkim=pass (2048-bit key) header.d=listout.xyz header.i=@listout.xyz header.b=1Mw/DqwW; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=listout.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=listout.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=listout.xyz header.i=@listout.xyz header.b="1Mw/DqwW"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4bDFp82kW2z9tDX;
	Fri,  6 Jun 2025 11:07:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=listout.xyz; s=MBO0001;
	t=1749200864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IwZh4tgJeU7mDJUmLAaJCQX7F8qKWKkkGdb8BNXbqV4=;
	b=1Mw/DqwWdWmKsdE0lds9tVR6sKsCB1/EXeclypXJmX60APe1L3wonhsoSKBi2T68oDQ2BA
	hJN6/fwoEN2uQyFi/16i1NB7nm4PB+/BOOysYnyOCRwi0/mok0pVuc0R+wydmdCb+s4xFG
	SHJi9HJ0pcNjLWNolU7DFUqFw2EMb5l06adchqQxkyW5l6PEgc3GpKIL5HGta4ZO/zcioP
	wWALJw472eziQO64OYZaa1AiuXIe2KPpf4aXyLRsdg02lMjZUQdG1TyGs08yVBq6PBbOrK
	vVyj/o7AcTXcTXD8fCpDC+gxWs3qN4GJmxVEJGh0bm4KnPGkQgshlHI3xUX7iw==
Date: Fri, 6 Jun 2025 14:37:39 +0530
From: Brahmajit Das <listout@listout.xyz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@kernel.org, linux-kernel-mentees@lists.linux.dev, 
	skhan@linuxfoundation.org, mpatocka@redhat.com, stable@vger.kernel.org, 
	patches@lists.linux.dev
Subject: Re: [PATCH 1/1] dm-verity: fix a memory leak if some arguments are
 specified multiple times
Message-ID: <hjq5krfufwdsgenn4klusi72pour22llg2marqhdmv7wisa6de@23w4z5dp7fs4>
References: <20250605201116.24492-1-listout@listout.xyz>
 <65ci7zvx3kr5qfq2ioadzzd4ghrtrtrc3pxefosexxpbup63kb@4jkc6e6usols>
 <2025060654-semisoft-prevent-351a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2025060654-semisoft-prevent-351a@gregkh>
X-Rspamd-Queue-Id: 4bDFp82kW2z9tDX

On 06.06.2025 08:04, Greg KH wrote:
> A: http://en.wikipedia.org/wiki/Top_post
> Q: Were do I find info about this thing called top-posting?
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
> 
> A: No.
> Q: Should I include quotations after my reply?
> 
> http://daringfireball.net/2007/07/on_top
> 

Thank you, I'll keep this in mind from next time.
> On Fri, Jun 06, 2025 at 02:00:52AM +0530, Brahmajit Das wrote:
> > Greg, Shuah, Mikulas,
> > This is my first attempt at backporting an upstream patch (Part of Linux
> > kernel Bug Fixing Summer 2025). Please feel free to correct me, I'm open
> > to feedback.
> > I see I've added two From section, if that requires me to
> > resend a v2 of the patch, please let me know.
> 
> Yes it does.
> 
> But you provide no information as to why this needs to be merged _now_
> and not through the normal stable backport process that happens.  What
> is different here that required you to send it to us?
> 
> And you forgot to mention what kernel branch this is for.
> 
> There is a stable kernel rules file that explains most of this.
> 
I see, got it. Thanks a lot again. I'll also take a look at the stable
rules.
> thanks,
> 
> greg k-h
> 

-- 
Regards,
listout
