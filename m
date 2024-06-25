Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020D8156678
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 12:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319296; cv=none; b=P4++CLqi2GLzC5lJTN0gIQTgcDN8ikUH9cRNc9AZGQRdfIx2ZJnYDhRFyiBxjOA50+NizA6PgNwA+Am8YoE6XfDg2t11dpsfs1wywsnDRTtQfddW/7ndHFZ6RS8DotBZ8bLDmB3ohuyKZKIuZxP3WrN/pLmoX8WqZAFzzEHFQ8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319296; c=relaxed/simple;
	bh=rErwAB/yDP/ScvFCv9QajsyI5lEofdcb4+290cPkayo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FKtMHMXWcO4fHGWfrxp/cbrx3zBJNhXzC8/0mP/i1rFDeULImYQ2qA/nNCkP5UWmZCJbNP9erIrHd3OH/PaLQfArBgrZuB9tO0S8XMsdKihIAEw4kH7LvDp/cq0BLvPZ6210WOx122/iKizwVm+pd1CqHRa7WBCpT3a2nG5s/J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mzVVcD11; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mzVVcD11"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719319295; x=1750855295;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=rErwAB/yDP/ScvFCv9QajsyI5lEofdcb4+290cPkayo=;
  b=mzVVcD11/s7MLNd1VRqjGIXKhyNMcf+CiT1W+YjDw7RLCZNg9MR0l7eS
   rNqkE/JtmfgkQJCmjCMdZELDsuR1szojXlOmwUfeqHh9U4/O9FsfceoDt
   jw/ls5C5TQ1qIC2OcRQ1hhj2osmGprC6xn240AM6dQPd4RFq4E0sg/Rs5
   iYXjWCIXMdtCr/exr/qljRh8CDgFP2vPq75G4FICl4Yh4VYMjrJpyMhV4
   OS8z609ZuLug6RYzzZKw9a7LmZw8c1PSeB6oQGPElbwc7tDuIItBsnHhC
   lBt3NOmonREiOvKynktdOuZY5jl/qtwIFZfzX37WbjziKZcz2B2s+vX5H
   w==;
X-CSE-ConnectionGUID: iEGr3pJxTCKBr7WGjf1eew==
X-CSE-MsgGUID: B3+AEXXAQsmmvUl1ycI8TA==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="20211627"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="20211627"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 05:41:35 -0700
X-CSE-ConnectionGUID: 5K/L/kv0TNKnqqH9laa3FQ==
X-CSE-MsgGUID: j2p1l4thQ2y7KKGStziH1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="43615450"
Received: from mwiniars-desk2.ger.corp.intel.com (HELO localhost) ([10.245.246.19])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 05:41:30 -0700
From: Jani Nikula <jani.nikula@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>
Cc: Dave Airlie <airlied@gmail.com>, "Vetter, Daniel"
 <daniel.vetter@intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, tursulin@ursulin.net, Francois Dugast
 <francois.dugast@intel.com>, stable@vger.kernel.org,
 patches@lists.linux.dev, Matthew Brost <matthew.brost@intel.com>, Thomas
 =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Sasha Levin
 <sashal@kernel.org>, Lucas De Marchi <lucas.demarchi@intel.com>
Subject: Re: [PATCH 6.9 073/281] drm/xe: Use ordered WQ for G2H handler
In-Reply-To: <2024062502-corporate-manned-1201@gregkh>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20240619125609.836313103@linuxfoundation.org>
 <20240619125612.651602452@linuxfoundation.org>
 <ZnLlMdyrtHEnrWkB@fdugast-desk> <2024061946-salvaging-tying-a320@gregkh>
 <ZnqyFRf9zPa4kfwL@intel.com> <2024062502-corporate-manned-1201@gregkh>
Date: Tue, 25 Jun 2024 15:41:24 +0300
Message-ID: <87ed8ldwjv.fsf@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, 25 Jun 2024, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Tue, Jun 25, 2024 at 08:03:33AM -0400, Rodrigo Vivi wrote:
>> On Wed, Jun 19, 2024 at 04:16:56PM +0200, Greg Kroah-Hartman wrote:
>> > On Wed, Jun 19, 2024 at 04:03:29PM +0200, Francois Dugast wrote:
>> > > On Wed, Jun 19, 2024 at 02:53:52PM +0200, Greg Kroah-Hartman wrote:
>> > > > 6.9-stable review patch.  If anyone has any objections, please let me know.
>> > > 
>> > > Hi Greg,
>> > > 
>> > > This patch seems to be a duplicate and should be dropped.
>> 
>> Please also drop the 6.9.7-rc1:
>> 
>> https://lore.kernel.org/stable/20240625085557.190548833@linuxfoundation.org/T/#u
>
> Done.
>
>> > How are we supposed to be able to determine this?
>> > 
>> > When you all check in commits into multiple branches, and tag them for
>> > stable: and then they hit Linus's tree, and all hell breaks loose on our
>> > scripts.  "Normally" this tag:
>> > 
>> > > > (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
>> > 
>> > Would help out here, but it doesn't.  
>> 
>> I wonder if there would be a way of automate this on stable scripts
>> to avoid attempting a cherry pick that is already there.
>
> Please tell me how to do so.
>
>> But I do understand that any change like this would cause a 'latency'
>> on the scripts and slow down everything.
>
> Depends, I already put a huge latency on drm stable patches because of
> this mess.  And I see few, if any, actual backports for when I report
> FAILED stable patches, so what is going to get slower than it currently
> is?
>
>> > Why not, what went wrong?
>> 
>> worst thing in this case is that git applied this cleanly, although
>> the change was already there.
>
> Yup.
>
>> But also a timing thing. The faulty patch was already in the master.
>> At the moment we applied the fix in our drm-xe-next, we had already
>> sent the latest changes to the upcoming merge-window, so it propagated
>> there as a cherry-pick, but we had to also send to the current -rc
>> cycle and then the second cherry-pick also goes there.
>> 
>> This fast propagation to the current active development branch in general
>> shouldn't be a problem, but a good thing so it is ensured that the fix
>> gets quickly there. But clearly this configure a problem to the later
>> propagation to the stable trees.
>
> Normally you all tag these cherry-picks as such.  You didn't do that
> here or either place, so there was no way for anyone to know.  Please
> fix that.
>
>> > I'll go drop this, but ugh, what a mess. It makes me dread every drm
>> > patch that gets tagged for stable, and so I postpone taking them until I
>> > am done with everything else and can't ignore them anymore.
>> > 
>> > Please fix your broken process.
>> 
>> When you say drm, do you have same problem with patches coming from
>> other drm drivers, drm-misc, or is it really only Intel trees?
>> (only drm-intel (i915) and drm-xe)?
>
> Intel trees have traditionally been the worst, but normally you all give
> me some cherry-pick clue on the commits so I can weed them out.  That
> didn't happen here.
>
> But, I will note that the AMD drm tree is now starting to do this, in
> much worse ways than the Intel tree because there is NO cherry-pick
> information anywhere, so again, I have no idea what to do and massive
> conflicts happen.
>
> So AMD is copying your bad behavior, please, both of you stop and fix
> this so that it isn't so broken.
>
> Again, I understand the need/want to have multiple versions of the same
> patch in different branches to get fixes merged quicker, but when you do
> that, please give me a way to determine this, otherwise we have no
> chance.

To be fair, this one seems to have been an accident. The same commit was
cherry-picked to *two* different branches by two different people
[1][2], and this is something we try not to do. Any cherry-picks should
go to one tree only, it's checked by our scripts, but it's not race free
when two people are doing this roughly at the same time.


BR,
Jani.

[1] https://lore.kernel.org/r/Zjz7SzCvfA3vQRxu@fedora
[2] https://lore.kernel.org/r/c3rduifdp5wipkljdpuq4x6uowkc2uyzgdoft4txvp6mgvzjaj@7zw7c6uw4wrf

-- 
Jani Nikula, Intel
