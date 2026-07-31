Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064AD3451CD;
	Fri, 31 Jul 2026 06:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785480410; cv=none; b=Xm6GlPoHONFp4Q35fdaI3g+DcrpRTqqnptijBc1KPZPdlNh4AUZN7ZalRrodAZ8MNaAJ94OhHOZijAESDk4VNsKH5X0qBQskwdVNwKhZ/p9OYnKsgQjPpwxrB73P3zt8QeVk2euIqqxUtRcL7HcIPw4vuiR+x+YXuFOBcI9OFG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785480410; c=relaxed/simple;
	bh=XvMF/TrXOhZ9ShaPhN/WskktZFZY6uD+T1uIGhnlZhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rKoxGIZZYf6Kdgdh9LBk4bu4vtO90b38YlkmGX8n4hwTxZTPrYSglQWR+vC0aqZsKRvh9I1r4BVH3kH3wQ3mditjbhQOEIv4KFKazHpWbUaaTDKQSnuoqGOyfIG+ewDsK1Mx3YU+LnivATNHHFgz+wgqTV2gFWTFG/DEt2Uo3To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rV539P/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rV539P/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7D91F000E9;
	Fri, 31 Jul 2026 06:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785480408;
	bh=gg0tbdcjXEWrpZ+ANcp/d+Tz0Mzi6/+aK+CDWi8hlEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=rV539P/qOSlsT96Lj0Jgz14IBzCAFD7Q59gNQvRqylkqlu3YMD7f5iHNVXI/ueLiL
	 jjq05Zjgd7O3Zt3qyhdr7WMxvZJ6ukhJJgsSljKNzMAspXoib+thUOpoZaQW4+tNt+
	 EnloLfRR8FpmMxajvPT0JeQrnizsJz86GD2i5Wus=
Date: Fri, 31 Jul 2026 08:46:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>, stable@kernel.org,
	Heiko Carstens <hca@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 7.1 667/744] ptp: ptp_s390: Add missing facility check
Message-ID: <2026073120-elm-purging-e006@gregkh>
References: <20260730141444.267951807@linuxfoundation.org>
 <20260730141458.442328931@linuxfoundation.org>
 <669b8e16-19a6-49bf-a1ef-a7bce5075a9a@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <669b8e16-19a6-49bf-a1ef-a7bce5075a9a@kernel.org>

On Fri, Jul 31, 2026 at 08:21:26AM +0200, Jiri Slaby wrote:
> On 30. 07. 26, 16:15, Greg Kroah-Hartman wrote:
> > 7.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Sven Schnelle <svens@linux.ibm.com>
> > 
> > commit e78f1ac37afcb16cb6fef8a2c92591eab6558956 upstream.
> > 
> > Only register the physical clock when facility 28 is installed
> > and PTFF QAF returns that PTFF QPT is available.
> > 
> > Fixes: 2d7de7a3010d ("s390/time: Add PtP driver")
> > Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
> > Cc: stable@kernel.org
> > Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
> > Link: https://patch.msgid.link/20260714130342.1971700-3-svens@linux.ibm.com
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   drivers/ptp/ptp_s390.c |    6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > --- a/drivers/ptp/ptp_s390.c
> > +++ b/drivers/ptp/ptp_s390.c
> > @@ -107,6 +107,9 @@ static __init int ptp_s390_init(void)
> >   	if (IS_ERR(ptp_stcke_clock))
> >   		return PTR_ERR(ptp_stcke_clock);
> > +	if (!test_facility(28) || !ptff_query(PTFF_QPT))
> 
> ptff_query() here needs:
> 9de445d8296a ("s390/ptff: Export ptff_function_mask[]")

Ah, good catch, now queued up.  How did you find that thing?

greg k-h
