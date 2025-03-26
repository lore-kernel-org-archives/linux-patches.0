Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920B31FBC8A
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 20:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743021970; cv=none; b=YiG17o2DStJ/J8ZYua1v/lYvZE+c6e3QUaPAEkUlm2wqmP2quOH77b4nhQ/ie298k8ZHtaGcXsxqj9+eIsX/DRbGbq6XEx7EbGzx3daF0f1JpG4DopqBbJIJPSiaAX2Pb9ZIcISlFfCi8W6qq9qi9qZN+fcITzWzCJOMumRzppw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743021970; c=relaxed/simple;
	bh=0fffkpb2/dTnrDBMgXFpfQbnuIh9s/gxDQH3AhTGbzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EZ7ck9PUjMijquHZnFLyuFZR5w6CTe13TmtrWVq0hDPXkGuO/T+/tI9Z12n7IJ/OtN74N3/TRjLXecf8mDXrWafPUG9yPHCVeMnzQGBrnTx8kYwOqtb9pOUqCMNSj4G63G3zuvqZPwbPtivy/dvxXj879P6Cbewt7NXJFGUK4LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Z700/nD+; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Z700/nD+"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-224341bbc1dso6353715ad.3
        for <patches@lists.linux.dev>; Wed, 26 Mar 2025 13:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1743021968; x=1743626768; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l0DxjNG0t0sEawU75w2W9OviEBnYSuXggXRVCOAy4Bs=;
        b=Z700/nD+K5X4V2s5HZPsvKDiGlTa5ZvKzycTFSTGY++Fy8ZVZNfs864vCddWxxLa/b
         n952WxKu5o+YVwrSX1BG3GuJkaYJfS9jcN58jbHD+E4afIoWQqbav43v/Wq8+eTTJrCl
         M5f7FbKhYGyd0P40JVnhNQpC8KPduwgRdVWD8i2TUfkQo2HinA/SLIH5oQylkba+zYkH
         AQaVyHlZKWYLCzDF/nCNgV2Rcwnh2GGtUyhkc7SKGtYVCu778EbHViApSwl7N8xuvrNu
         rrF2mM70Va3X8hZE0bGy2jIZehjd2kdDbJvsCjbOQ2hGVl53FLg3LxNWt4rUerAoTQGd
         EVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743021968; x=1743626768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0DxjNG0t0sEawU75w2W9OviEBnYSuXggXRVCOAy4Bs=;
        b=JcEwnyigr6izaCfULNgXEcuOyXuiVkfPyjYWApwEoS0VgXtf7eb5mbo4b7wgzla759
         Q+2IW1YjTiE3Dd3+IocgeTF//A5/jKqg6Lh7lvRJFYw6aCq7u295DhZ+3uUH4hyEzNSG
         ItXUOgjohKFAi2dpMKfxpIHj+WarcGebiPLyzs/wmgHx40erCNxrMHLK1Ha5SXWJilGG
         R46BsEnMuodR1CSkVuybJgyh+vnR4/VMdwy4VH/ruUF/4bix6a1fWM0/DE1vhVzyVkXJ
         ebPBBXrNCj1BCf8Iy1lsG1wG1NHb5trKeNvysbHX7GgWl22hZ6dKhyzjoVlP6+dc31EN
         tsuw==
X-Forwarded-Encrypted: i=1; AJvYcCX34kYr4fhjZ0REmar1RXp3l0JuNwfGxSfiuUqRo45FW60ugRyKeMfS5MHY765jnZ1uATZvgTDh@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5d+wMl9ryCoE//Fmoi4od01IokM5e8LnvZ9a0Lwm7N2WH8K2l
	bHgPbq9+JnVUwgteMsU3tg6zgkiIK32iDBI8tLxCdDPxVpBnhKfDucX/+SnDu6E=
X-Gm-Gg: ASbGnctr2zXqfvBHNfKAKQpqZTzrW/Ww/AldeHKGjmd0MCFaWmb7NfwOw60wRi2sUy/
	x/3bUmstyd0UnvBiHGBodcca5obT2BfR+A7KHe3KXSIHqk1ho1JAWy8lt/4eFrj9FqI8G/oPvjT
	nLdEeu7LzzIQEdkomPv3m2QH4kD8lN49HUHOTZAYVNOLakEcr+g2MludeldgJE9IMQ9VfhDEULv
	l0AxyaTDnnvQ6K4ykLlyCsw25nUtXlmZiDDXq8zEexpw1zvFhl7vNCyMpGC6yA3r8ZJ7JPp7DhQ
	lLRbv1xuv8fIsJBgeXDlIt8ma1HHk/T1R46Ya2lOJUFKsKCuNN4ZeXHzVjrjtTjs9CZtl4Npra9
	px+SaxHxUx7LMTV/yhQ==
X-Google-Smtp-Source: AGHT+IHYC9faJMfvw3S3nDn2V7wFInikoEkVJnJUgRfyAHRL+/TjLMdCvBBuENH2adHdN+PgG4A1eA==
X-Received: by 2002:a17:90b:2c84:b0:2ff:6e72:b8e2 with SMTP id 98e67ed59e1d1-303a8e76448mr1592314a91.31.1743021967688;
        Wed, 26 Mar 2025 13:46:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3039e60f81fsm752510a91.48.2025.03.26.13.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 13:46:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1txXdT-00000000gYk-3LF2;
	Thu, 27 Mar 2025 07:46:03 +1100
Date: Thu, 27 Mar 2025 07:46:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, patches@lists.linux.dev,
	fstests@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	oliver.sang@intel.com, hannes@cmpxchg.org, willy@infradead.org,
	jack@suse.cz, apopple@nvidia.com, brauner@kernel.org, hare@suse.de,
	oe-lkp@lists.linux.dev, lkp@intel.com, john.g.garry@oracle.com,
	p.raghav@samsung.com, da.gomez@samsung.com, dave@stgolabs.net,
	riel@surriel.com, krisman@suse.de, boris@bur.io,
	jackmanb@google.com, gost.dev@samsung.com
Subject: Re: [LSF/MM/BPF Topic] synthetic mm testing like page migration
Message-ID: <Z-Rni3UhAF4RB7AY@dread.disaster.area>
References: <Z-ROpGYBo37-q9Hb@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-ROpGYBo37-q9Hb@bombadil.infradead.org>

On Wed, Mar 26, 2025 at 11:59:48AM -0700, Luis Chamberlain wrote:
> I'd like to propose this as a a BoF for MM.
> 
> We can find issues if we test them, but some bugs are hard to reproduce,
> specially some mm bugs. How far are we willing to add knobs to help with
> synthetic tests which which may not apply to numa for instance? An
> example is the recent patch I just posted to force testing page
> migration [0]. We can only run that test if we have a numa system, and a
> lot of testing today runs on guests without numa. Would we be willing
> to add a fake numa node to help with synthetic tests like page
> migration?

Boot your test VMs with fake-numa=4, and now you have a 4 node
system being tested even though it's not a real, physical numa
machine.  I've been doing this for the best part of 15 years now
with a couple of my larger test VMs explicitly to test NUMA
interactions.

I also have a large 64p VM with explicit qemu NUMA configuration
that mirrors the underlying hardware NUMA layout. This allows NUMA
aware perf testing from inside that VM that responds the same as a
real physical machine would.

$ $ lscpu
....
CPU(s):                   64
  On-line CPU(s) list:    0-63
    Thread(s) per core:   1
    Core(s) per socket:   16
    Socket(s):            4
.....
NUMA:                     
  NUMA node(s):           4
  NUMA node0 CPU(s):      0-15
  NUMA node1 CPU(s):      16-31
  NUMA node2 CPU(s):      32-47
  NUMA node3 CPU(s):      48-63

This is also the VM I'm doing most of my performance testing and
check-parallel development on, so I see the NUMA scalability issues
that occur when trying to make use of the underlying hardware NUMA
capability...

> Then what else could we add to help stress test page migration and
> compaction further? We already have generic/750 and that has found some
> snazzy issues so far. But what else can we do to help random guests
> all over running fstests start covering complex mm tests better?

Use check-parallel on buffered loop devices - it'll generate a heap
of page cache pressure from all the IO, and run a heap more
tests at the same time as the compaction is running from g/740. This
often overlaps with g/650 which does background CPU hotplug, and it
definitely overlaps with other tests running drop_caches, mount,
unmount, etc, too.

One of the eventual goals of check-parallel is to have all these
things environmental variables like memory load, compaction, cpu
hotplug, etc to be changing in the background whilst the tests
running so that we can exercise all the filesystem functionality
under changing MM and environmental conditions without having to
code that into individual tests....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
