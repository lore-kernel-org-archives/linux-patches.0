Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65077265CBE;
	Thu, 18 Jun 2026 11:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781781633; cv=none; b=eKe5sJ7Z7c0rcozyMqFJmwGnPRY4CH7Om8J/RkUaj235uDrtRlkHIjpqJvEOvV8eWXuaKcS3oCVoNQEEIlyYen8JhgaKSRsewgXZLmBny5ghDy0my98LgGIjTyPO0wBFwZfTfvTAWdBUqHuJ5hJv+9h29/fX/VcLruimO4N1G5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781781633; c=relaxed/simple;
	bh=ks50TxYMSxMRM8wUKloTgHvkJJQEjLkZU/WUoJiK+e4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ly6ELv/MS1vj9TwMrRvVYXHnNqwrOz9g5B+n4wSrTsu4Lxo3BmcFQJim7ojmstRZ0cFSy3UXb68e8JshQXlhPMZOv/qRuDSSxWdN1S88hFTQ9+XL5sPwsh+GHR9iusrCK/BjuFImbw+hCoYnWGNxkAcrQhe686eVxANLeNoXiGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxP/qbiJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxP/qbiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4F41F000E9;
	Thu, 18 Jun 2026 11:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781781632;
	bh=EWSIIP37qnPXUzIkLqgyKX32fF2/um37o8Gqq2SO02I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZxP/qbiJ7+fdZaZrifStdxn7r0b78WZfAQRmctJZdDbiWhrJ4/aTxvpbDQJ0q+QQM
	 fcPK6aobDbZTRb/6M94zg+PlgFCjwtOpn95I5AkdqwiBQ+R5yHbbkD32EDr1Dkt+ZH
	 TvseuMXmWwt6HH4ElkGVytwfgFRt7Th/xXsxS5sM=
Date: Thu, 18 Jun 2026 13:20:45 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Ben Hutchings <benh@debian.org>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 411/411] x86/CPU/AMD: Move the Zen3 BTC_NO detection
 to the Zen3 init function
Message-ID: <2026061822-alike-goal-6765@gregkh>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145122.972422457@linuxfoundation.org>
 <a323b095-78fe-4c6a-9804-221dc37be3fc@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a323b095-78fe-4c6a-9804-221dc37be3fc@oracle.com>

On Thu, Jun 18, 2026 at 04:42:11PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> 
> On 16/06/26 20:30, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Borislav Petkov (AMD) <bp@alien8.de>
> > 
> > commit affc66cb96f865b3763a8e18add52e133d864f04 upstream.
> > 
> > No functional changes.
> > 
> > Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> > Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> > Link: http://lore.kernel.org/r/20231120104152.13740-4-bp@alien8.de
> > Stable-dep-of: 7c81ad8e8bc2 ("x86/CPU/AMD: Rename init_amd_zn() to init_amd_zen_common()")
> > [bwh: Adjusted to apply after backports of the above commit which actually
> >   depended on this]
> > Signed-off-by: Ben Hutchings <benh@debian.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> I am a bit confused with this, this is a stable-dep-of something that is not
> being pulled in ? Asin, 411 is the last patch of this series, hence the
> confusion.
> 
> Can you please help me understand this.

That commit is already in a previous release, so this is needed to make
that commit work properly :)

hope this helps,

greg k-h
