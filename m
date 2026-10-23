Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792760390;
	b=awu2bT2Kb1b8AJv7lOqrsfq9tt2csf8lanFdVrM9lWwAJg1ZUZ37jerV6OCUEHjPv9G8
	 ljblgyOW+FA7YAYCZvJtSbIb7NetdDhj64iHigbrRl5C2PHeDUxrFbew/0vaXDj0TUzkW
	 zlKvs0JM05fvG6uZTmKE0PQTKboETAiG89ra06JyHAE6JV0w1NLomUyLG4Eo0H8BzXfcj
	 aa+0tiqFBKaTBUxW5VYClwGnoKlIN1gUW9Uon554A8WBOaArl8uaOHEPUkP01s80z2xpH
	 JIgsYBNGL7XztxC93j+zl74NbTWEm2B1BWyk/edybOg0J93RglCQHTHVT9sYBSu7h6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792760390;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=rAiKmaVO3T0YYXACSbh/1Kq1BVBbibX0bZPqKXi2tg0=;
	b=xFBs2fH8WPGxl2liK0A3SuGU8JLDofwpv5LO0MYBk7E12WuSa+gqp0ERD7G1iNeYcfTg
	 qVEFJyzZcO6S+DQePeheHX2pfcqeHpC8Ccxj1uDHWYuRXwKzK3JJkCMLHR9h4AWMFTJBr
	 AHOo3sZojiz9PKRs3hAmeGJCNuTQifq7pO0hCAR73miKP6WvdHPt+dx65RcAH/9pR2ui6
	 er3AqABlsHHxx8/jmXKJBEEHHAYLsAJA+tsPqjMny9iIKKqdzYdX26h6gkYmKk4tT+VWn
	 i1h/dJQ8/Ln3A8sDHqGSXSi3IFiJ01RvVJWTnDcpMhyWhRZpXWAqsfc2mhblgjUhIiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPK5isr4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C1A606A31E;
	Fri, 23 Oct 2026 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPK5isr4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048951F01825;
	Fri, 23 Oct 2026 12:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792760389;
	bh=rAiKmaVO3T0YYXACSbh/1Kq1BVBbibX0bZPqKXi2tg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BPK5isr41tMR1j2EeR9UvMg85nHFS95JQtsS5RPLlcjEnHUhXHkXudNRRhGciP/hc
	 AY/WjMR9izofvUTqpOLvhOiDgcJiW1nEHwLDXHxtYqBN4XK2sNZgA4DCeEsxNaPb/4
	 0N1ZRfeRm49HwT0nXLI+6vPvYP+xU39TY9WIxfEI=
Date: Fri, 23 Oct 2026 14:56:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jacob Keller <jacob.e.keller@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH 6.18 158/621] ice: drop page splitting and recycling
Message-ID: <2026102311-swan-heading-54cd@gregkh>
References: <fce25d6d-8fd7-4f83-8d8d-929871aff885@intel.com>
 <2026-10-14-1-daily-reply-0015-ice-drop-page-splitting-6-18@kernel.org>
 <atsythEG2rkGdc6Z@pcnci.linuxbox.cz>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atsythEG2rkGdc6Z@pcnci.linuxbox.cz>

On Fri, Oct 23, 2026 at 12:11:02PM +0200, Nikola Ciprich wrote:
> Hi,
> 
> Just a follow-up on this one, as I just got burned by it a little.
> 
> These made it into 6.18.58-rc1, which I was still testing (I wasn't
> aware that some patches had been dropped from the final 6.18.58
> without notice). After deploying it to a machine using the ice
> driver, I noticed a huge memory leak. It's easily reproducible:
> running a flood ping eats about 1 GB of kernel memory per second,
> effectively killing the machine within minutes.
> 
> So I just wanted to report that these cause more than just a
> performance regression.
> 
> Anyway, I'd love to see these in 6.18, as some users have reported
> that this series fixes some nasty memory corruption.
> 
> For some time I've been using the following ice commits, backported
> to 6.18.44, without any issues:
> 
> e314a3c525c91c1e918546f472585cdbd44fbd1
> 3a4f419f750946181e3d6a339a1ef1942c5b5685
> 93f53db9f9dc4a16b40ecd18e6d338ad57e4b670
> 436fa8e7d1a119ec90f39e7c2ce0f3a146652899
> a9c354e656597aededa027d63d2ff0973f6b033f
> 
> But since I was busy hunting the bug, and then found out that
> corruption was most likely caused by something else (a patch has
> already been posted for 6.18.59 by Yosry Ahmed), I never proposed
> submitting these to -stable. Later I saw them in 6.18.58-rc1 so
> I just scratched that..

I've queued up all of the above now, thanks!

greg k-h
