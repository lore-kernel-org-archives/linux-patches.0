Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECDE322B;
	Sat, 29 Mar 2025 08:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743236906; cv=none; b=YCfs6mRSwM1BxPg6FhCkoMnHfUdKt7eDg0AP3U9wrEBcu7BZcC00k/mtrXbp97RLGG3QCcxjmXa4raop8Xdhapoabo0hakRsSiPFYqs3doK9QtMmI1A+ftiExOG2DG45dQ/nGtMml4geiafdNCtUO78FwQbwGfoKzt3W4GqGsg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743236906; c=relaxed/simple;
	bh=qvtcZ3DLHw2UJqgxO8LnIj2VFr+0l5f/5eErQLrDCQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cGpl4eqtgX/+SB1geNeXAn3XgRZSV2g51ikbMRuWKahe3jVk3ssoKPeHzwTfbr6/8jLwS07F5HQxzdscGvg/rrfEpj28IDu0SvsACX571BWRZv5s+iJs96pyEGxQ5NWPUTZFVOqGQrF4r5Aa+GbqPvtXqgPJsVIH9GSTH+rRrGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHaJghb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHaJghb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5DDC4CEE2;
	Sat, 29 Mar 2025 08:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743236905;
	bh=qvtcZ3DLHw2UJqgxO8LnIj2VFr+0l5f/5eErQLrDCQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nHaJghb6z5VMrzaTXaET/opbza2DCJ8aoYK9si+8nZ62FMJ0lJgFSLi0HB/zTuAAx
	 fsE6nBtMc29LDukO+i4z4+u07L8bN13syE+A1QOYT7lJcKo5xRFHBggcgaB83XsKZu
	 C1CNmLs4CmUOzRcoX7IMB9hiH32AFEBZcdFMXYzk=
Date: Sat, 29 Mar 2025 09:28:21 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.15 620/620] net: ipv6: fix dst refleaks in rpl, seg6
 and ioam6 lwtunnels
Message-ID: <2025032928-tassel-blunt-1308@gregkh>
References: <20250310170545.553361750@linuxfoundation.org>
 <20250310170610.006675223@linuxfoundation.org>
 <f104048adbff7eb54c913e488c516be45e404419.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f104048adbff7eb54c913e488c516be45e404419.camel@decadent.org.uk>

On Fri, Mar 28, 2025 at 10:52:01PM +0100, Ben Hutchings wrote:
> On Mon, 2025-03-10 at 18:07 +0100, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jakub Kicinski <kuba@kernel.org>
> > 
> > commit c71a192976ded2f2f416d03c4f595cdd4478b825 upstream.
> 
> This backport to 5.15 seems to be correct.  But why is this fix missing
> from the later 6.1 and 6.6 branches?

I really do not know, sorry.  I can't find it anywhere in my archives
and it looks like I did this backport?

Also, it looks like the CVE for this was revoked, so it really isn't an
issue?

I can try to backport it to 6.1 and 6.6 if you think it should go there.

thanks,

greg k-h
