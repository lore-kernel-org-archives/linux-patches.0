Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA9428E1B
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 18:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AjLCn5Ao"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704393286; x=1735929286;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=/IOoJi/kpwpMvqRVAMsLZCyelmocIcqSjkHU5GiDvDQ=;
  b=AjLCn5AoZs1MGRMesw07Nq9AKb5yrgQrD5S6Ll8A6Repclk1gUUkagQc
   G2HcXN+v+10SWfbGdn2dpfmAwpHtKakzHgPML6tHuyei/dPbs62WqB094
   YMqEV9ZxO5UxE8Iruvw0GqUXCYEcCcCXOOpS5/5o2S6nEOkruyTrwkDxS
   ntg8RW0bYprLqn2GM2xzTweucINKw5Tb3Z3EwQV3VJJzEXX8F4YOJ2EZJ
   5t6IvWNU2/roP76xp9mlBxHj0CDr99H5mtiIJduwkO3JD26rL4YEhgfnY
   HKX2DWGLm7EavCw6F96JKuY22X/ajKPi/eLreS51BAaWZJ1PFqGoT8FCs
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="461634497"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="461634497"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 10:34:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="14998521"
Received: from asebenix-mobl1.ger.corp.intel.com ([10.251.210.215])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 10:34:43 -0800
Date: Thu, 4 Jan 2024 20:34:39 +0200 (EET)
From: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
    "stable@vger.kernel.org" <stable@vger.kernel.org>, 
    "patches@lists.linux.dev" <patches@lists.linux.dev>, 
    Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 6.1 086/100] platform/x86: p2sb: Allow p2sb_bar() calls
 during PCI device probe
In-Reply-To: <2024010422-wanted-diabetes-8e0c@gregkh>
Message-ID: <8cddadb4-fb1d-2fb0-115-69c3d2c0841@linux.intel.com>
References: <20240103164856.169912722@linuxfoundation.org> <20240103164909.026702193@linuxfoundation.org> <ikeipirtlgca6durdso7md6khlyd5wwh4wl2jzlxkqr2utu4p4@ou2wcovon7jt> <2024010401-shell-easiness-47c9@gregkh> <djjzvybh5z5q5ojn3isltl6g32gpvhcilzfr3rznb5hlijjavm@z3itpol7wec7>
 <5f97aaa-2d8e-498b-18d1-88e048443dcc@linux.intel.com> <2024010422-wanted-diabetes-8e0c@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1664549602-1704393284=:10531"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1664549602-1704393284=:10531
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 4 Jan 2024, Greg Kroah-Hartman wrote:

> On Thu, Jan 04, 2024 at 07:02:52PM +0200, Ilpo Järvinen wrote:
> > On Thu, 4 Jan 2024, Shinichiro Kawasaki wrote:
> > 
> > > On Jan 04, 2024 / 09:58, Greg Kroah-Hartman wrote:
> > > > On Thu, Jan 04, 2024 at 08:54:48AM +0000, Shinichiro Kawasaki wrote:
> > > 
> > > ...
> > > 
> > > > > Greg, please drop this patch from 6.1-stable for now. Unfortunately, one issue
> > > > > has got reported [*].
> > > > > 
> > > > > [*] https://lore.kernel.org/platform-driver-x86/CABq1_vjfyp_B-f4LAL6pg394bP6nDFyvg110TOLHHb0x4aCPeg@mail.gmail.com/T/#u
> > > > 
> > > > What about 6.6.y, this is also queued up there too.
> > > 
> > > Please drop it from 6.6.y too.
> > > 
> > > > And when is this going to be reverted in Linus's tree?  6.7-rc8 has this
> > > > issue right now, right?
> > > 
> > > Yes. I agree that revert action is needed.
> > > 
> > > Ilpo,
> > > 
> > > As I commented to the response to the bug report, fix does not look straight
> > > forward to me. I guess fix discussion with x86 experts' will take some time
> > > (Andy is now away...). I will post a revert patch later. May I ask you to handle
> > > it?
> > 
> > I've applied the revert and made a PR out of it:
> > 
> > https://lore.kernel.org/platform-driver-x86/1a6657ef8475862e4fc282efe832fa86.=%3FUTF-8%3Fq%3FIlpo=20J=C3=A4rvinen%3F=%20%3Cilpo.jarvinen@linux.intel.com/T/#u
> > 
> > 
> > I found it a bit disappointing to hear from Greg that patches can no 
> > longer be dropped from stable-queue (it certainly used to be possible 
> > earlier) but things are to be handled indirectly through commits in Linus' 
> > tree.
> 
> They can be dropped, yes, but it's easier to add the follow-on revert so
> that all of the scripts out there don't keep resending the original
> change as part of the "hey, you missed this patch!" sweeps that people
> run.
> 
> So taking both of them is better, right?

If you want my honest answer, I don't think fix + revert "cycles" really 
belong there but I'm not going to complain that much either, I understand 
managing / keeping track of all that is not so easy (and that scripts 
tend to be stupid).

> That also ensures that Linus's tree is fixed up, which is key for 
> everyone involved.

Yes, it's important but my main worry here is it introduces latency and 
I've no knowledge if this kind of notes are enough to halt the stable 
release until the revert also makes into the stable-queue?

> For stuff that is "this should not be in the stable tree at all", we
> always drop those easily, that's never a problem.

Okay, thanks for the clarification.


-- 
 i.

--8323329-1664549602-1704393284=:10531--
