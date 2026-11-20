Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168803;
	b=LABGYG9UjFOsjVODlo9qFNdZakniugvElMUTDHSMTbVrYSuOx4qfp04lj+DYykPSOlau
	 bVLojigk+8K4yaC+uB/JTSZZFL3PFqlqBuMuDJLPzUk4oSkErWHtXp14nEmY1otSMP0xq
	 d+Dr8SFfMGwAjoTBnbKZCQ67vzrjPBskEo3JY1mdyNrdjizmdxpCgn98XR47MLRPBtUHR
	 tGcjs9a78ed9cgB7bnXB8CcTZKImGlIUadEwSJhNymtapUm7/2SpVMU8O5IYEQjXmYf9V
	 Hgz++pS8I/XrTwEqFdaYk2sRttgz+QUmLZY276D85zYchXImLn+0+4vNwt98cw8gc1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168803;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:
	 Organization:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=53IYgGn1hvZqbl/iv8n9HjV2+EPLGnQoxoloaQwl0lY=;
	b=BCR1Qh51vz/9W9+ddGQWw17IrWEyPQXVbeHKwCBWk0HeDZ2UWAEgWCRcr4Ici+dkWe7M
	 6SoNA0N4uTEepBVJYq0vvg750sF8Jiu12wLkCd/H4jbioSqIa2zJX++4U0ebyrevdkL2B
	 E/R9oDv6JlMzJsF1o2KW8NXoLOEH+TgTg5Y2IVpw6Vk8LHGUhsENiKAG7bEAecTXeWhCf
	 9ALBXMFkjwE4SF9Vhgk3t6sMwomiSv7b0dhKJlqkgcMubdqnKv1qOdgce1pecKgRM+6+C
	 NstMWykt9jizqej3UJ09psbT6C8QbwaDNrPN9EWRA4KylgHnMA08Ybp1P7H8x8unE0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RCc19Wqs;
	arc=none smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E244C606A326
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 10:00:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E244C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RCc19Wqs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795168804; x=1826704804;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Dgi6myinJZLo7hQda6QBDHER9GVUwzKuhB2DR3WDrdA=;
  b=RCc19WqsW236AMmdMNwAq7jx2lf1vW3nj6E5vOtnh5sRnmFuaBoGyXXj
   uoQODKhnioCHdN08iMOwKudklDFq0w2TigTuagDDKOXez2qQfU9kk+2gQ
   ggwJnQs7DG1Ds4wawHa0OmtfD6qRdLi0sRc5GZUChhJB6odVKsE+2vX7a
   vTuCAi+iJHgXtjeXy5653rDRPcahSfabs2jSI/26JlPYpbfvZE28msyo7
   d1MSc9z70l9S0QvghbQyPJeI6PVY3j3yk6fLUr77x/eYXVNC8oMZNSlxP
   bxlO8KT2vV+t6UuEVtEYc9PJ1ViWpAVPfwHAtQCD8GrBvszxBh2CXbrx6
   Q==;
X-CSE-ConnectionGUID: GqzThWqqScCnLdBvmt3HLw==
X-CSE-MsgGUID: yNRNHAZtR0uWWTVsNz8J9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="4085717"
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="4085717"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 02:00:03 -0800
X-CSE-ConnectionGUID: lo2pq+bMTrKi52+noe0mEQ==
X-CSE-MsgGUID: 3LqStTW3S42IF8/5fOYvUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="10803200"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.245.245.253])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 02:00:00 -0800
Received: from kekkonen.localdomain (localhost [IPv6:::1])
	by kekkonen.fi.intel.com (Postfix) with SMTP id 98A7011F8AD;
	Fri, 20 Nov 2026 11:59:59 +0200 (EET)
Date: Fri, 20 Nov 2026 11:59:59 +0200
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: Re: [PATCH 6.12 0810/1756] power: supply: bq24190: Remove redundant
 pm_runtime_mark_last_busy() calls
Message-ID: <awAaH1vUBq1Bhb9X@kekkonen.localdomain>
References: <20261118150007.957976754@linuxfoundation.org>
 <20261118150041.869799943@linuxfoundation.org>
 <4d03745f-1cd4-4280-965e-c6527f3f3c07@oracle.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d03745f-1cd4-4280-965e-c6527f3f3c07@oracle.com>

Hi all,

On Fri, Nov 20, 2026 at 02:51:48PM +0530, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> 
> On 18/11/26 8:18 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > [ Upstream commit 2453753f395e68af947d9ac6ce37bf0eb40f7123 ]
> > 
> > pm_runtime_put_autosuspend(), pm_runtime_put_sync_autosuspend(),
> > pm_runtime_autosuspend() and pm_request_autosuspend() now include a call
> > to pm_runtime_mark_last_busy(). Remove the now-reduntant explicit call to
> > pm_runtime_mark_last_busy().
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Link: https://lore.kernel.org/r/20250704075442.3221283-1-sakari.ailus@linux.intel.com
> > Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> > Stable-dep-of: e0844bd22a9f ("power: supply: bq24190_charger: don't reset registers across system suspend")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/power/supply/bq24190_charger.c | 14 --------------
> >   1 file changed, 14 deletions(-)
> > 
> 
> 
> Ai assisted backport review has found an issue for this backport. The
> finding looks correct to me.
> 
> Verdict: lets drop it until we have the prerequisite I think.

I agree. The pm_runtime_mark_last_busy() changes were merged for v6.17 so
these patches musn't be backported before that (and I wouldn't backport the
pre-requisites).

-- 
Regards,

Sakari Ailus
