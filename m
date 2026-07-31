Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8C53C8700;
	Fri, 31 Jul 2026 08:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785486443; cv=none; b=cP6Gsni5JvPzkjA1CADlFAHSGfQYmYp0GLqiyjB//1ZmxBTC1Nvc7tth8d7pxsV1UzcqSgLSxTAU74c863Tmo3DJb3UE0g9UAig8qT+x18B44rvOPqmkHup1Z5dQD2jPo4/M+iPxabfF7I8XhbOVbaZKxBSZ3XaDUmmcaSxFATY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785486443; c=relaxed/simple;
	bh=qWHAPgdkGIaxr+gcu4fel1wU6XHmyRvNdvCngC2Dm1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uuGHg7/u+oMXe+gvRycdWQwK4GVBHt2yhWOkuJ2BpGMuoj3bIu3yu4cpLfp/UDt9sTeD5HqUNFK/ODbR9/nNvZEcoywwbvFWOYudYEV9msjCiI3lGlpLQcfGIUAYI5bswUsXj/Mnw0s1GJbF2ZO8sW7R+z8yxtxKJv7hFSBjwYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IF03ByHG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IF03ByHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD811F000E9;
	Fri, 31 Jul 2026 08:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785486441;
	bh=buVpILtYmrOXEJRr2Wxk9xbiAar/fXC7wLDBBYjaFOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IF03ByHG3HDSjt7SGIkz2sy2FMRk0Nw9JN2DXJ4+3jlJGPag1zvbmGChr0v/mpDqB
	 bJEzyBrZ04jnQW4d19k3lGqFRkmXOqWP46r0Nfp0KJ23BZRTGHV1U8bcOHDPK/RjAS
	 7jGGkhGz08nJ3a6437i+kRBZ8LoRJitps/gp2Z7U=
Date: Fri, 31 Jul 2026 10:27:06 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sven Schnelle <svens@linux.ibm.com>
Cc: Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, stable@kernel.org,
	Heiko Carstens <hca@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 7.1 667/744] ptp: ptp_s390: Add missing facility check
Message-ID: <2026073141-tibia-clean-e870@gregkh>
References: <20260730141444.267951807@linuxfoundation.org>
 <20260730141458.442328931@linuxfoundation.org>
 <669b8e16-19a6-49bf-a1ef-a7bce5075a9a@kernel.org>
 <2026073120-elm-purging-e006@gregkh>
 <yt9dzez7inbl.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yt9dzez7inbl.fsf@linux.ibm.com>

On Fri, Jul 31, 2026 at 10:18:54AM +0200, Sven Schnelle wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > On Fri, Jul 31, 2026 at 08:21:26AM +0200, Jiri Slaby wrote:
> >> On 30. 07. 26, 16:15, Greg Kroah-Hartman wrote:
> >> > 7.1-stable review patch.  If anyone has any objections, please let me know.
> >> > 
> >> > ------------------
> >> > 
> >> > From: Sven Schnelle <svens@linux.ibm.com>
> >> > 
> >> > commit e78f1ac37afcb16cb6fef8a2c92591eab6558956 upstream.
> >> > 
> >> > Only register the physical clock when facility 28 is installed
> >> > and PTFF QAF returns that PTFF QPT is available.
> >> > 
> >> > Fixes: 2d7de7a3010d ("s390/time: Add PtP driver")
> >> > Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
> >> > Cc: stable@kernel.org
> >> > Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
> >> > Link: https://patch.msgid.link/20260714130342.1971700-3-svens@linux.ibm.com
> >> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> > ---
> >> >   drivers/ptp/ptp_s390.c |    6 +++++-
> >> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >> > 
> >> > --- a/drivers/ptp/ptp_s390.c
> >> > +++ b/drivers/ptp/ptp_s390.c
> >> > @@ -107,6 +107,9 @@ static __init int ptp_s390_init(void)
> >> >   	if (IS_ERR(ptp_stcke_clock))
> >> >   		return PTR_ERR(ptp_stcke_clock);
> >> > +	if (!test_facility(28) || !ptff_query(PTFF_QPT))
> >> 
> >> ptff_query() here needs:
> >> 9de445d8296a ("s390/ptff: Export ptff_function_mask[]")
> >
> > Ah, good catch, now queued up.  How did you find that thing?
> 
> Maybe we should change the documentation. I was wondering whether I have
> to mark that as a dependency, looked up ./process/stable-kernel-rules.rst
> which says:
> 
>   Note that for a patch series, you do not have to list as prerequisites the
>   patches present in the series itself. For example, if you have the following
>   patch series::
> 
>     patch1
>     patch2
> 
>   where patch2 depends on patch1, you do not have to list patch1 as
>   prerequisite of patch2 if you have already marked patch1 for stable
>   inclusion.
> 
> Which lead me to believe that I don't have to add stable@ to the the
> other patch, but looks like this was wrong?

The issue is that was no link that I could find between 9de445d8296a
("s390/ptff: Export ptff_function_mask[]") and e78f1ac37afc ("ptp:
ptp_s390: Add missing facility check")

i.e. no "Fixes:" tag, or dependancy info, so if I took the "add
missing..." patch, I didn't know that the export patch was required.

Not a big deal, happens at times, just if you know a commit fixes an
older patch, a "Fixes:" tag is helpful.

thanks,

greg k-h
