Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11852EE285;
	Wed, 13 Aug 2025 08:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755072888; cv=none; b=f24Dt3LEYBKWrneanWUmWVBCpjovHIex2jWCZyNsHTtAhc1sCHg4FnrIGtmnMiibGyQXPZZFhUGvL38H3FjUyLuOmf0dEk4aLfUOYLDrwvfj3/uiAtJdK2/jBU4AOd2eYgwjzo0YOe366vzkB+l1L7e1hYP9iKHmPSznuty8p1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755072888; c=relaxed/simple;
	bh=nmoRKzWqhAxBnObDJT9f560/b9Q1WGvLlJstA21p2H0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aKyBKw8YahvvabLUVXwRY6fxj+/Yxll7UzDPN8pnukP5RhnvmnKcmDEUrqki8rDdxWUOKCjUtYvXHcP+e9IXlN6ULfnr2lSooT/XpiOBjcblbtRJ7oRQcbZ6LideNhsbBE0ZZyjOWVZpVfln7+ZKROQiRR01H71i16RNvaX74F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qow3BGt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qow3BGt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71F4C4CEEB;
	Wed, 13 Aug 2025 08:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755072888;
	bh=nmoRKzWqhAxBnObDJT9f560/b9Q1WGvLlJstA21p2H0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qow3BGt6adDF9IBiL6RpetrcuP0VFo+G9TFCu6V6pul6aRSYIYNCiLlTTAYxxMSZH
	 WCbfM90fnWLK+y+89tEOWmtDToi/ueKFHya8k24qUO4r6YVAIrbdONchur5bTZaRQD
	 0l5HoOeZYXRRzBfrg32XvW0nDAtmgeBfw4JwNAKs=
Date: Wed, 13 Aug 2025 10:14:44 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Csaba Buday <buday.csaba@prolan.hu>, Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 519/627] net: mdio_bus: Use devm for getting reset
 GPIO
Message-ID: <2025081340-refreeze-upstream-92f7@gregkh>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173450.953470487@linuxfoundation.org>
 <73f6a64b-89b5-412a-94d7-07cdfa07cfb5@prolan.hu>
 <2025081305-surround-manliness-8871@gregkh>
 <2025081337-reprise-angling-7cb8@gregkh>
 <44d15997-2c16-436e-b1f5-fc2de7afe29b@prolan.hu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44d15997-2c16-436e-b1f5-fc2de7afe29b@prolan.hu>

On Wed, Aug 13, 2025 at 10:10:07AM +0200, Csókás Bence wrote:
> Hi,
> 
> On 2025. 08. 13. 9:56, Greg Kroah-Hartman wrote:
> > > > This was reverted and replaced by:
> > > > https://git.kernel.org/netdev/net/c/8ea25274ebaf
> > > 
> > > That's not in Linus's tree yet, so I can't take it :(
> > > 
> > > So I'll just drop this commit for now, thanks.
> > 
> > Oops, nope, we took the revert also, so all is good, I'll leave this one
> > in.
> 
> Sure, although I'm not sure what the rationale is behind taking a commit and
> its revert also, in the same release. Anyways, for the rest of the backport
> versions, drop this commit and pick 8ea25274ebaf instead (it should land in
> Linus' tree in the coming week or so). And when you do, don't forget to read
> its notes at:
> 
> https://lore.kernel.org/all/20250807135449.254254-2-csokas.bence@prolan.hu/

Taking a commit and a revert keeps us from adding back the original
commit in the future when it is triggered again in our scripts.  This
just mirrors what's in Linus's tree :)

thanks,

greg k-h
