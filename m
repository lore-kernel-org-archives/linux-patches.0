Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097EC35A933
	for <patches@lists.linux.dev>; Wed,  8 Apr 2026 05:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775627044; cv=none; b=fDJMx81cH/51cQbCou14BhqxS1o6lAsaCtKFScOi0LYR/GOzlvhZN05vzo1LYngGSLWa81v1FOjk9mrB9UdDjV/546gpUch9lQMdpXdVwo3K05W+cAYEEs6YsDGFERvhg37V3FjCaX2M4c6SUh8T6AA57SKjxhzMMtt3VYFcE2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775627044; c=relaxed/simple;
	bh=BDT7Qm2fqqnYPI3dSRtcTXDHcWY+5BksXvBw2+moe+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiaFI197F+Q0xSg4Hj021HsbwkQ5pDnmZe9zzwgYy4ll3HUJa2hZGj7v23x8xJnWqRho9ZPQHw9EQOQZnE/wYXGyg7tH5zOvkXf6EzNPVtFyU46hI8Ip/UGNXunMu9Vs12CZhH6BcG6540z+Jqt5wAAbQPLE+wMTEnCyBjxYKC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cFF8wkIk; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cFF8wkIk"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso36190965e9.2
        for <patches@lists.linux.dev>; Tue, 07 Apr 2026 22:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775627041; x=1776231841; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f4CTw1zZ+1g6N8RAuGXFjoPZ4xIpArIKPStEduXE09Q=;
        b=cFF8wkIkpHJynmIX+7sGjHi4PDZ7jS2QbDLB3NyHtdRb8MbYWslBSUhtDVrPTmj75a
         PCRQbLBZzxjlBCyjDwXlDiH36IwUQWGtrmweAgTOs1qdb/hG3sHysNeerLENFXvayeW+
         FbmYoE8nSLG0SB1hjitX0ky49L8ogbzJo5CuNvA5G9MiINTE5mFF5lDRiNTcnCqxiDaw
         MqigScIALibp+Ju+wvHrGIf5BBlFScmU40Ha6ko6tJlCthXnVZW/03aYHmSM8VfgV5be
         FaXnG+C0O4BE/o+5tVGiwwGCSdoTwo4AeKEWhNTUfMbjrjaclQoskVgk+afURT+Fn8Ei
         x4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775627041; x=1776231841;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f4CTw1zZ+1g6N8RAuGXFjoPZ4xIpArIKPStEduXE09Q=;
        b=rSd/t+mEVrJoRk/mkyU+wk8HxdtNvJ0YIWn8RKz+HdP9mbJC930mW3g+6D099y15bA
         Y7lnUZGB37kxjOohUGGkeEILbj4FnDKpSo+ZIGYWZTt8elZmtKtG4uu+l2mHwFulHDKY
         LyISVcTPFEO0zBEDs0iHFKuIgIcO/76L8hjEgB9Z64KWdN8dJCsq0KitOQxTLMPGpqfm
         E9F3ODdG0tN/etp3VLuNzOag6uzQcgcjGQNfQYQ8JZmApMbtRvb30hx1hV431kkxtrOX
         SErOxDB7w9rtUoWMonCY7Z/g/oNZwWtLCONU6xIbTopoClZ/EBQ7acRJSbnFsNewZqO5
         fTwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXasYxIykM5lYcozFzHV9oSjSzrVsRb6SOCWr8WGQz8CIS0zjH9X1QBGgzxDtrvA28XBDZzd9hL@lists.linux.dev
X-Gm-Message-State: AOJu0YyvG1ZqO2voVBkAPKoxTBtIFIuJdJByMQ1gKawQQ3LcrjRffmk3
	vrcA7zYVsY0kGIKWMxePuwbcnBv5zWz4AgVOgcBGCaIYyFm8pCvftRC2ifpqI4+E3xM=
X-Gm-Gg: AeBDievDxC+1iOv6rMWBC5IIkZWDiskMhy8wpxoDt87tdnIlyi6HzTAarmXKET/f3If
	n0FnaueUynZoxky7TrHcbgztWNjLrAaGPPurNySXM2dPFYsZnDKM2EWUTvY5dVXMylnx+EBc0tb
	bBlNePqtSSLZlwTJWaWghqNjgXyd1gxLbXbp44Bel3i4L5+x2Og/XnphXIYajnsQupUaSzYnHNW
	+nTvkrKUEMuGQC++2RhUNcQvE1ZQLEQXZ5RMWN0cW5R4/zyh1viQ36eo6tPqOFIh0uVedrLfzHg
	2zhTJXOHKb1qOJTkpdeFFjP1+0U4Laq4Ai9n4c1rhtWptezatWurT3vI+CAiNWFXZeGOH4r3AWr
	/sm3WrSyfcMISTU1NnH7Q7MlwW+5rFj8O0IFQPpY7cXgdxaI1L6+lmmlOsQwGCOKUtHmDufuMdH
	jCmgJxRqc1C3BCBACYufv1m5SIDaXqCCIAaAq4UAvkfxVShw==
X-Received: by 2002:a05:600c:4e86:b0:480:4a8f:2d5c with SMTP id 5b1f17b1804b1-488997c9b69mr259346165e9.29.1775627041321;
        Tue, 07 Apr 2026 22:44:01 -0700 (PDT)
Received: from u94a (27-240-66-218.adsl.fetnet.net. [27.240.66.218])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-6058304af93sm19968010137.7.2026.04.07.22.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 22:43:59 -0700 (PDT)
Date: Wed, 8 Apr 2026 13:43:46 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Paul Chaignon <paul.chaignon@gmail.com>, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, stable <stable@vger.kernel.org>, patches@lists.linux.dev, 
	Andrea Righi <arighi@nvidia.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 034/244] bpf: Fix u32/s32 bounds when ranges cross
 min/max boundary
Message-ID: <uhk2bpssg5mm4u4mgxqa236rzvzph5e6r45i2dwxidiywk6qrp@62v35ebjwya2>
References: <20260331161741.651718120@linuxfoundation.org>
 <20260331161742.960922011@linuxfoundation.org>
 <i4c753x3y67ek3r7dp774pcmaaaid3gvxcsvdssosdingre4in@od45qzitwtrf>
 <2026040115-dose-aerobics-7c6d@gregkh>
 <CAADnVQLSfDtqeLFw=DjG-dG=xD_qS7p2LHsT9jAxO5aAK0YJig@mail.gmail.com>
 <ac1LCTbV5ZnqUgG0@mail.gmail.com>
 <2026040240-friday-gurgling-7088@gregkh>
 <ac5MrSA8VbSNdlG_@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac5MrSA8VbSNdlG_@mail.gmail.com>

On Thu, Apr 02, 2026 at 01:02:05PM +0200, Paul Chaignon wrote:
> On Thu, Apr 02, 2026 at 12:46:10PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Apr 01, 2026 at 06:42:49PM +0200, Paul Chaignon wrote:
> > > On Wed, Apr 01, 2026 at 07:32:26AM -0700, Alexei Starovoitov wrote:
> > > > On Wed, Apr 1, 2026 at 4:44 AM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > > On Wed, Apr 01, 2026 at 02:22:58PM +0800, Shung-Hsi Yu wrote:
...
> > > > I suggest ignoring the selftest failures.
> > > > The patch is necessary for stable and backports.
> > > > It's fixing a real issue.

Ack. I was only thinking about register invariant violation, but hadn't
thought about the scx_layered sched_ext scheduler load failure that was
reported by Andrea.

Come to think of it efc11a667878 ("bpf: Improve bounds when tnum has a
single possible value") probably should be brought in for similar
reason. I'll prepare and sent it to 6.12 (and earlier, if possible)
later this week.

...
> > Can you send the 2 patches needed here and I will queue them up.
> 
> Will do. Thanks!

Thanks!
