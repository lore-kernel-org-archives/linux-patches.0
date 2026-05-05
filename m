Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2232426EC7
	for <patches@lists.linux.dev>; Tue,  5 May 2026 12:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777985656; cv=none; b=F45zFFi+x01nTlhaJ/tAbfcirO5E8BupJciiY9YqFQls5vfcAoJI8NwJAZo4fRB4vIDZzTjzsByRhqIpCYB7bR2xc7iLsaqZYJv4mXS2LBUed0coJM7n4CLJ5EUYtdiIMIsp4UWIKjXvRdk7SPFLEIO2m/HAmp7sxjHFJh0dmgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777985656; c=relaxed/simple;
	bh=97dcqovbHD0hlxgjvuKPi4RQ7TGsWrKChMfLAXdeKSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o+5kXn1Vo57/8XEeJCmY6JNKyjxXJ71nhR5cOntoqx10N7fglfCff4JwJnffaHRy5jooY8VEJWnfj5ofsrRaquxyuy4rcxh5xSuDPLbPFE4fdvC0oEstF+MpFH5UbuilHd43ACIUUQbBquFsn35JCsY7AXFvQ7HGQyQemqwzlQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=minyard.net; spf=pass smtp.mailfrom=minyard.net; dkim=pass (2048-bit key) header.d=minyard.net header.i=@minyard.net header.b=aHoLJMc9; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=minyard.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=minyard.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=minyard.net header.i=@minyard.net header.b="aHoLJMc9"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-40423dbe98bso2288052fac.2
        for <patches@lists.linux.dev>; Tue, 05 May 2026 05:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=minyard.net; s=google; t=1777985651; x=1778590451; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ixHlQF/6N+sd7aWPsMAhIdhMfBiCGbCBVVjJcBst60=;
        b=aHoLJMc9dYxZgJK5OsAb6sE7zSaHXjmNLk3tBFelA36aZabPXF9GC8+Lla7Ze6uemS
         1hOksN6XeOwkYcjYUeq/JqMZcMCscHsXBO12aoBrWxt76YPb/uMo2fHsJzk6QXan+6xO
         j5NReNzss6XunzBJ9SWSyt8JmiSB59EAtzwz1QLlzB92YM6gbYLrOHc9rgP+LBpFhJYi
         5lMPcucrUAr0Q4oVSjOknr3x4BEdTNY8HvBmUL6xP77d4/hkd+xU6N1F9fidGwsbE/Qa
         UoTigiiqU/kKPlr57JvL0wrVOGjl8QOosoWrGzYZ9MKQG4sTuJg/LZndbLfFjAFbQ1xm
         WkoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777985651; x=1778590451;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/ixHlQF/6N+sd7aWPsMAhIdhMfBiCGbCBVVjJcBst60=;
        b=mCRMf3OrqqXWerY3Fx333H5yrZL/Fb0T2ztSU0aTJy22LgHuDSR0/ctRubcFxvxgAe
         tuSQ7phjm+DBG6YAdWKMP2LItierzVC/w13ZWQI3eWsoiD1u7pFUpCk9Fxkp0JseBuK3
         7ymLq3zDb04zqorhOj96cGSjwZQJXr8NqKiBBIBNDQBQohBJjIzrEUlhn723zKfR46Oj
         Rk6tuZMWiMq8y8GG5x2o0d9x0OhdbU2DrqK96Y5BPDhSqL6vdYiCRjCb99Yimug0o+cS
         zShJrBoMkIW2ZASJPbk4Xlo+odr02TmHj/mlYBZK4jNgikdg6gi1gnA2bwcLeXaMTKKB
         VuZw==
X-Forwarded-Encrypted: i=1; AFNElJ9NFVLBvuqiDx9ZIINxMruAB2tBiKnP/WbUDaJgeSG0apa3E73rb3JpVxIAB9fpAC8g3lWxplLe@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4UA1wumGbivaSMHZIStTPPAKhT23pz3zEJu6ZDK/Ui7o03IUB
	cGEjP9xK1mTAxIjVN3n5/xUhofSuqT2kb45oeXN4Lz92RTPozW2KJYbzqiJ+V4l7oro=
X-Gm-Gg: AeBDiev+N2TYQPqq+8hnmcnRSNbuS/k1U9teXfOBE4xIFB3pyWucjPznboqZyJ5Vy+1
	YnIMDOiMqsYc1lrPXuALAPkQjbzNgPwXdRrni9EYmy+tkcLyAyl7vukre51xelYbdYNsqwuzRAM
	vXwVesf4knvCloHqtxlk/10bxf3SisAejUQZeVSZtjDGzejSF6BbD0VXMJI7sc/P2FUCXLaRgf3
	yGexggS77mGlYkzuNDebKnS88iPXXB0t6I7+TPDxEMhNfHCmwAUdFPfKUVDhhb8+ZjJvsU1kPND
	fuQXmE2wsLpcZ/2/InL3vm1HDFAIQRBinSIcXxKRwassUQDYomkruaZC1oknYfvoj+o80dQKfPD
	ldofrDpP1i2zfeWX4KUF4l9/UMU607UyLowqEMGl+0Ugk8YkFW5nRdVKA4ZZxUwwnkON/XibBwV
	qiaMCQrTlc2FH2vu0euTmNJdLrNBsXNSnDAipQpHYKFzHd4IE5++FG7WYAnkioKKp8HO0aAMAgN
	uGExPd7juOPU8Lu+psRiQCe45OYuDHAqw==
X-Received: by 2002:a05:6870:8197:b0:41b:c797:5953 with SMTP id 586e51a60fabf-434d412d2e7mr1588313fac.24.1777985651507;
        Tue, 05 May 2026 05:54:11 -0700 (PDT)
Received: from mail.minyard.net ([2001:470:b8f6:1b:4a29:1d2:a1fb:6ae])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-434548ccb52sm13616431fac.1.2026.05.05.05.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 05:54:09 -0700 (PDT)
Date: Tue, 5 May 2026 07:54:06 -0500
From: Corey Minyard <corey@minyard.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Li Xiao <252270051@hdu.edu.cn>
Subject: Re: [PATCH 7.0 073/307] ipmi:ssif: Clean up kthread on errors
Message-ID: <afnoboEQIXI0aQSk@mail.minyard.net>
Reply-To: corey@minyard.net
References: <20260504135142.814938198@linuxfoundation.org>
 <20260504135145.562837603@linuxfoundation.org>
 <2bdd7732-e20d-4d67-8f3e-2b9a9a791edf@kernel.org>
 <2026050523-blandness-calibrate-93c5@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026050523-blandness-calibrate-93c5@gregkh>

On Tue, May 05, 2026 at 12:06:29PM +0200, Greg Kroah-Hartman wrote:
> On Tue, May 05, 2026 at 11:10:29AM +0200, Jiri Slaby wrote:
> > On 04. 05. 26, 15:49, Greg Kroah-Hartman wrote:
> > > 7.0-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Corey Minyard <corey@minyard.net>
> > > 
> > > commit 75c486cb1bcaa1a3ec3a6438498176a3a4998ae4 upstream.
> > > 
> > > If an error occurs after the ssif kthread is created, but before the
> > > main IPMI code starts the ssif interface, the ssif kthread will not
> > > be stopped.
> > > 
> > > So make sure the kthread is stopped on an error condition if it is
> > > running.
> > > 
> > > Fixes: 259307074bfc ("ipmi: Add SMBus interface driver (SSIF)")
> > > Reported-by: Li Xiao <<252270051@hdu.edu.cn>
> > > Cc: stable@vger.kernel.org
> > > Reviewed-by: Li Xiao <252270051@hdu.edu.cn>
> > > Signed-off-by: Corey Minyard <corey@minyard.net>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >   drivers/char/ipmi/ipmi_ssif.c |   13 ++++++++++++-
> > >   1 file changed, 12 insertions(+), 1 deletion(-)
> > > 
> > > --- a/drivers/char/ipmi/ipmi_ssif.c
> > > +++ b/drivers/char/ipmi/ipmi_ssif.c
> > > @@ -1268,8 +1268,10 @@ static void shutdown_ssif(void *send_inf
> > >   	ssif_info->stopping = true;
> > >   	timer_delete_sync(&ssif_info->watch_timer);
> > >   	timer_delete_sync(&ssif_info->retry_timer);
> > > -	if (ssif_info->thread)
> > > +	if (ssif_info->thread) {
> > >   		kthread_stop(ssif_info->thread);
> > > +		ssif_info->thread = NULL;
> > > +	}
> > >   }
> > >   static void ssif_remove(struct i2c_client *client)
> > > @@ -1916,6 +1918,15 @@ static int ssif_probe(struct i2c_client
> > >    out:
> > >   	if (rv) {
> > > +		/*
> > > +		 * If ipmi_register_smi() starts the interface, it will
> > > +		 * call shutdown and that will free the thread and set
> > > +		 * it to NULL.  Otherwise it must be freed here.
> > > +		 */
> > > +		if (ssif_info->thread) {
> > 
> > This 'if' reportedly needs:
> > commit a8aebe93a4938c0ca1941eeaae821738f869be3d
> > Author: Corey Minyard <corey@minyard.net>
> > Date:   Tue Apr 21 06:50:22 2026 -0500
> > 
> >     ipmi:ssif: NULL thread on error
> > 
> 
> Thanks, now queued up.

Thank you Jiri and Greg, this is correct.

-corey

> 
> greg k-h
