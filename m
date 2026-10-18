Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279B737DEA8;
	Sun, 18 Oct 2026 13:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792330537; cv=none; b=iIWwuyBD/pBl4qwe/ZqemzWNPgwenjhB/ekEVaoMg5sONouSu8rkLOG8Caxr4Qpi1l5cdIBBNmh6nWtCBnaQJZP5dXZVyioQ9XGoxjtCvbexjlfGpZ8q1RHDa77gRWwO6N+OP33QPRvoqNhE08/6ECsXBdk/TN89IX6JpC874rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792330537; c=relaxed/simple;
	bh=m4EkBgarajkiFxcHIFX/fmFZ6UCAwXdt87wRv9iOUn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYBv2H9k+rAjoLdEFXEWLhYynPzbXQtF51P5WRf8rRGnla9ii8OyDrpnk1ev+A7P4IJBeVvlwt0LOXA+F71KRpiaEB5iODBqecWfFl3M+Eu0VElF1g9bpNMQFeUmlNvJ5Nv1fZ4ZrHuZD6RChSIAW5Nz3iKlldYHiN1r4ldAbJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dh/te4yo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dh/te4yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5829C1F000C4;
	Sun, 18 Oct 2026 13:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792330536;
	bh=jkFEHutrPpfHQHinfTWm69mADl45S+7QqSFw1PYFIAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dh/te4yobeGq+Zejau80v4O4hKqiLd+NA+tmH+wfzV4v6Hu2ER7fD3NDtCiJgm4aL
	 sjUBBk+YQNBYJqqynnGjOwYLnGPbnlDwvhDvJ88v+Spk427ZrfICfuaZQxXpT5Ddcc
	 SzafcRjcIWINWszbc/zTOYCGC5tgZvEstiUYbDq8=
Date: Sun, 18 Oct 2026 15:35:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Anderson <kernel@ametros.net>
Cc: Wolfgang Walter <linux@stwm.de>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: regression 6.18.57: acpi power button vanished in machines
 running in qemu
Message-ID: <2026101813-doorstop-hyphen-614c@gregkh>
References: <5fe757e7aa54c38df3525d313598db99@stwm.de>
 <2026101834-parchment-reps-0bee@gregkh>
 <atSdI7buRErdF1jZ@ametros.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atSdI7buRErdF1jZ@ametros.net>

On Sun, Oct 18, 2026 at 11:19:15AM +0100, Bob Anderson wrote:
> On Sun, Oct 18, 2026 at 08:48:03AM +0200, Greg Kroah-Hartman wrote:
> > On Sat, Oct 17, 2026 at 07:26:54PM +0200, Wolfgang Walter wrote:
> > > 
> > > since 6.18.57 there is no acpi power button any more in virtual qemu based
> > > machines (as far as I can see model doesn't matter).
> > 
> > Can you use 'git bisect' to find the offending change?  Does this also
> > happen in the latest 7.2.y and 7.3-rc releases?
> 
> Reverting 38c79dacc8063ff8a0d75ce2a900fbaff82ad94c makes the problem
> go away.
> 
> Reverting cleanly required reverting c85f325d9ec3116b0d4ee9d5b76c26aea0ad5ce0
> and 78677084cd09001c3c815aab80c59708130a65d7 too.
> 
> FWIW we also have this problem on hardware (various Dell servers): the
> power button and "graceful shutdown" via iDRAC no longer work. We're using
> a custom ACPI daemon that looks specifically for ACPI power button events.

is this an issue in 7.3-rc as well?
