Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795676428;
	b=mnu0V/ibXCxhrx1hlfZN0etJ7DATHW5WrbGZwNPStPaeDjZiZB9KnSN/wJERvQOVXiFg
	 HKEDuArJvaS6LW228xk2/H9aiw4YaKxfth1c0aN2PJjvfT3Sf/FPPC3TgMJ+4H55Bp54y
	 nCYn5s1msYixpWZdLYp1diDqWP4dQ/rYpHULNdvv1fG0WKTqeFYIfsIRNDl2sVY+gAY09
	 LIKA+cRvbh0zY2XS+ZcEtkNWCyWi4tyAqatYIxo553srHyIZsOTsuPdW0VhB4k3/Dc/w9
	 Tt0twYpn/XGMPlRG2hXbX1xsMvzOXlXt2acAfwFrDQbSuqbwK9KF+VCgClPu3AWHFOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795676428;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=vI8Dtewh7cpw7qojEsKSDErI8koZv7qVzvweK8bWYpo=;
	b=NR0COUCHlonOdAJVnxdjFXlGFIiJqtpfbfRPb3RbCPFiq6hU/QaRCXXQkvOM7EiaAoFo
	 OMn0dnBoPY1GmWLz5c6UwJKE9E2gu96EdD57ZI14TKZnoLUupaKNmZzT2xXllVdk3ypUP
	 EJPFUHrVsZ3DiTKuJsBGa2MsofYYGhm8smzZBcPmpjcOH5vhm8qYbkC48off5xUKm6ZW8
	 2cTgNSM5+9/SMj9nSSBRVDrX+7cytBzFsF41zpC+O8ZgwSGyZfyHrTLTqNqkFxOBL5w/S
	 /VGHUEN9e757TM1eZoGN9sNpEFYohdqtYOzZ/TD4iiZpGrYYxVnYJJklRk/oMSjIQeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dCNXXbVc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571B7606A31E;
	Thu, 26 Nov 2026 07:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dCNXXbVc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7812B1F000D1;
	Thu, 26 Nov 2026 07:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795676428;
	bh=vI8Dtewh7cpw7qojEsKSDErI8koZv7qVzvweK8bWYpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dCNXXbVcJSXLN5oB2GN/3hFGt9R6SFDzEdBRfQHMYdbSjvLGb/80cegFny/pj2cyd
	 No1XEVDieNNN6aUiaRqHBN6x3W98pODw0M8asEactH7XLfpzHOhoiox2J2s2h7Y6Wh
	 XLAmn60T0YbfTrZ2jGxZP1ZEGxygiOXGVwGNMnQY=
Date: Thu, 26 Nov 2026 08:00:24 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Rahad Bhuiya <rahadbhuiya2021@gmail.com>, Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.3 0361/1005] sched_ext: Reset task fields on exit of an
 SCX_TASK_READY task
Message-ID: <2026112625-skittle-retouch-c4bd@gregkh>
References: <20261125143821.729802100@linuxfoundation.org>
 <20261125143830.189554233@linuxfoundation.org>
 <0782adf7-20af-45a3-a09b-2a34c76afbac@kernel.org>
 <2026112640-recite-tipping-891f@gregkh>
 <dc5dc970-d7d5-46e4-8b2e-327c7e31a90b@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dc5dc970-d7d5-46e4-8b2e-327c7e31a90b@kernel.org>

On Thu, Nov 26, 2026 at 07:53:04AM +0100, Jiri Slaby wrote:
> On 26. 11. 26, 7:36, Greg Kroah-Hartman wrote:
> > On Thu, Nov 26, 2026 at 07:19:47AM +0100, Jiri Slaby wrote:
> > > On 25. 11. 26, 15:28, Greg Kroah-Hartman wrote:
> > > > 7.3-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Rahad Bhuiya <rahadbhuiya2021@gmail.com>
> > > > 
> > > > [ Upstream commit 564405c424f49d70b13debe7fe5b550234ad6b84 ]
> > > ...
> > > > --- a/kernel/sched/ext/ext.c
> > > > +++ b/kernel/sched/ext/ext.c
> > > > @@ -4198,6 +4198,7 @@ void __scx_disable_and_exit_task(struct scx_sched *sch, struct task_struct *p)
> > > >    		args.cancelled = true;
> > > >    		break;
> > > >    	case SCX_TASK_READY:
> > > > +		scx_reset_task_fields(task_rq(p), p);
> > > 
> > > This fails to build:
> > > ../kernel/sched/ext/ext.c:4223:17: error: implicit declaration of function
> > > ‘scx_reset_task_fields’; did you mean ‘scx_set_task_sched’?
> > 
> > Ugh, I wonder why this code never hits my build tests...
> 
> We seem to have:
> CONFIG_SCHED_CLASS_EXT=y
> maybe you don't?

I don't, and 'make allmodconfig' doesn't select it due to the
CONFIG_DEBUG_INFO_BTF dependancy which does not get set either for some
other reason perhaps.  That explains it, and we've tripped over this
before...

thanks,

greg k-h
