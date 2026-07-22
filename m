Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F83437B400;
	Wed, 22 Jul 2026 08:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709114; cv=none; b=QC/lUPeAywNLbPGnaLybFkMI7A5uJakEvrGnKv3gyO48ZCcjAMU40NVZw5BEa6F1PJ3K/jMNDi/6xgudREA8rXqCzzZwv7gfE3MiQz5s8pODY8taCwspicyJgH2D3amTuL+T+1FJz8zd6vBPGp+W7eE4s+fJ0WHETtADuD6p7yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709114; c=relaxed/simple;
	bh=KvUUJ1f3d7xwvnDPjlo12rzORSpijd86NVy9P6EZKf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1rnNkw9ZC/dyxZFu4faL0k/xM8XkJYF+rxe8bx89XXIjic1ZIhRRLyGp9lfTCes3IPGqUVklGyDczAPcBTtedvBxxuromIhZu+FSyi9E9MwPp8tz76IFqUHp+TeVEMmxNZnu+PSnYMEA1vFErysZiR3JAkxZbAE5h84rcc/WCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CP4vOLVm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP4vOLVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4A71F000E9;
	Wed, 22 Jul 2026 08:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784709112;
	bh=z+vJX/jFsNl3gPU++UID1IlSND1TBg8Wxkq+HkZ0nrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CP4vOLVmBtD2AW0wYbhIFo8zoXFVVFB071Rifp19poMdf5q4I251KVDg6lAPG0nTl
	 JHpCPDbo/pVChY/IsfbStu1KHZKshjvGXN27FEKCR32TNv7lCxLZqRYhtLk5JZINtV
	 rncSd//d+l6UmA4vWtQkueuVkMlJWHcMCGEyw0J8=
Date: Wed, 22 Jul 2026 10:31:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Gibson <daniel@gibson.sh>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH 6.6 1020/1266] platform/x86/amd/pmc: Add delay_suspend
 module parameter
Message-ID: <2026072216-essence-earlobe-9c5f@gregkh>
References: <20260721152441.786066624@linuxfoundation.org>
 <20260721152504.653512550@linuxfoundation.org>
 <980c483b-d3ed-41be-94e0-9b28fc42b482@gibson.sh>
 <2026072230-volatile-citric-73fa@gregkh>
 <dc1702d3-ed9e-418c-a4c4-35575b55670a@gibson.sh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc1702d3-ed9e-418c-a4c4-35575b55670a@gibson.sh>

On Wed, Jul 22, 2026 at 10:16:15AM +0200, Daniel Gibson wrote:
> On 22.07.26 07:28, Greg Kroah-Hartman wrote:
> > On Tue, Jul 21, 2026 at 11:07:35PM +0200, Daniel Gibson wrote:
> >> Hi,
> >>
> >> On 21.07.26 17:24, Greg Kroah-Hartman wrote:
> >>> 6.6-stable review patch.  If anyone has any objections, please let me know.
> >>>
> >>
> >> No objections, I just wonder why the commits
> >> 037f0b03c663a2 "platform/x86/amd/pmc: Dont log during intermediate wakeups"
> >> and
> >> a0738abd042f74 "platform/x86/amd/pmc: Avoid logging "(null)" for DMI values"
> >>
> >> are not added for 6.6 as well (they're added for 6.12, 6.18 and 7.1).
> > 
> > Because they do not apply to that tree, and there was no explicit
> > "Fixes:" tag on the commit so we just backported them as far as they
> > easily went.
> > 
> > If you want these patches in a stable 6.6.y release, please provide
> > working backports.
> > 
> > thanks,
> 
> Thanks for the reply!
> I'll backport the commits.
> Where should I send the backported patches?

As per the stable documentation at:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

Send them to stable@vger.kernel.org.

thanks,

greg k-h
