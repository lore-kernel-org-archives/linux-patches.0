Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7B71C8627
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 20:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743106971; cv=none; b=QJUw4ZgmsTvl3Ve7EewlKx0bWW0klFNErUInlvZDlWmgNIHw7noMsE/g40tlpvis8chtWRYQn0Pfpb+JR/8M1s/4wkuRLvFOeLmCfEF3WNVpVMC+5u4HTOSqYdBjqH3fTeK2V6A78JMZkV35JT8nO486uv6Yoii6nuPoDrYKKwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743106971; c=relaxed/simple;
	bh=hWsoNvNHVfFmyq/J/uqEJxexZfkLwaAkkAF8jkhLaLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W67SuTvkupryqavQTfMZvRbFlAZUhn0o2vXLtNSH3IACefpQf7QV2/rmzr/vSkaEidON8/B2pI7rSNFcm+B2KtkKhzFxSFrr62TPfqxz4hjbm68OUinBtrsDF9uh+1GHtToF72WG0hhVbr1iuwrqlsmyISQM4zCbvRwfNjOfX+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=TeMUUGf2; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="TeMUUGf2"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ff69365e1dso1900076a91.3
        for <patches@lists.linux.dev>; Thu, 27 Mar 2025 13:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1743106969; x=1743711769; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f36YSwLPJ313+jNbvLdd5CTUY7LI4BTt4o8yr4k9tM4=;
        b=TeMUUGf2Xp/ao2J8RdwuQu/rlO+J9sYv00/yxw369Vym/CF8rir48loH2+ZguWZIyQ
         fuFt9a8+aJRPjtfviSLhtbeAZNk3NSHzY0Dld7CgYIA3LrbgAqQbUFz8bWebdyF5GGBO
         VuKFTp2w0mhOxMhEgAd6jfEIt7eOKyH3MoXKfZgkYFlIM+KGIs8uTaDnfrRdYfyse3yn
         HC8T4Qi1iO/d+IOgUL4bWjveQ3U3BgKbXZMtS+lkNxcRVT5P25kY45n3DKMgkzvJir09
         FMkFkgYcZLyPeoUbccrySKTpxQGECR+/EmiLQmw8ujNPyer1hfoWUPVJQMOHrrA/k+ev
         +j6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743106969; x=1743711769;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f36YSwLPJ313+jNbvLdd5CTUY7LI4BTt4o8yr4k9tM4=;
        b=YajMZe7ycTvlXXlzsi5nsU3IIxtDkWQRjn4UqnliCAHop3s8FVygg+3wdfH2tkxwoA
         wkF+EgRlaRyjgaidx9fVQz738Y0hJ3KpiNvSOOUiIOIfImdj5gfZLdiiibY/AUuYOEMI
         sxxhuYLdznZ6JXquZx4Pb+BqOHY/DeJdr8/EUtpG2bDp04TOGtQ9Nrfp1POas3bIR8UD
         SMZnPVFup+qzgTDaQVv6CjWWhh1Y6Y8lAizy22A9tnTZxf6e8YX8yytjGOTI/Hl1Dmfq
         DH7oD4E/hmVh983MWuOYbiaXgrL7im5N5EpIEtaDRLc9G7AuyWVjqJ2Y/VXrZRIwIWK3
         1JzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlGQhmCT5ZYG7kZRfznY5nyoJJlJxnaL6KW5qR/Ve7ihr/Kw5gX8DmheWcSGDr2MOvdKZC2HUQ@lists.linux.dev
X-Gm-Message-State: AOJu0Yyirlj0FHkHPa2s+vwVbR6pUx1p2JYAIgjypTSNIL34CdzehpvW
	Qkr8LNEg3y2HsNX8tXfbzU5kHsqkQeUt5mfwaXA32+HIdOHzzN3gx+3bcwrjuEU=
X-Gm-Gg: ASbGncsLw2huPnZlxR1IP2al/0nD7DrUATlwixSR9I5mQjBlegmqmVhQeCpgYRaCdLb
	1WqB20hsIugcmPNCbVINZHs+0xSvIgCwjZ1kAEzC5ZdJfTKyNuZnq3JVk+Fjv7lUwoHMD+gzli5
	lALG39tLv4kEPBlMbyZkuu7JI/y314HNXCdkG4V9SgcD7ia7va7YM0oEiLecX8w9uZYfVLJtnc1
	fZJnSmAAQKmuFbEXufgeA/ZVpdw0G8JWZ6KXjNCeNg3Sj+nMpTgcleUEi6HhGialFBpDPzwrhhg
	xd9Dlao8ffraPxqUgg6n8X/VoeZ9HTEwY8Afw63lu7nasDW2HBnwvNscmkW93ONwNlawjH5nU5I
	Pc6vou+mCIS9jkURA5w==
X-Google-Smtp-Source: AGHT+IE04slap1s8okAKEtulK560I8Pk5y4yI9BiST5ZRxIXZ4EDqBdpcK7KvdffOC2kSZ2m8M/JJw==
X-Received: by 2002:a17:90a:c2cd:b0:301:1bce:c252 with SMTP id 98e67ed59e1d1-303a8d81d2bmr7055953a91.27.1743106969072;
        Thu, 27 Mar 2025 13:22:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3039dff0529sm2964573a91.16.2025.03.27.13.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 13:22:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1txtkT-000000016eh-2SQ3;
	Fri, 28 Mar 2025 07:22:45 +1100
Date: Fri, 28 Mar 2025 07:22:45 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Luis Chamberlain <mcgrof@kernel.org>, patches@lists.linux.dev,
	fstests@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	oliver.sang@intel.com, hannes@cmpxchg.org, willy@infradead.org,
	apopple@nvidia.com, brauner@kernel.org, hare@suse.de,
	oe-lkp@lists.linux.dev, lkp@intel.com, john.g.garry@oracle.com,
	p.raghav@samsung.com, da.gomez@samsung.com, dave@stgolabs.net,
	riel@surriel.com, krisman@suse.de, boris@bur.io,
	jackmanb@google.com, gost.dev@samsung.com
Subject: Re: [PATCH] generic/764: fsstress + migrate_pages() test
Message-ID: <Z-WzlUN6fSciApiC@dread.disaster.area>
References: <20250326185101.2237319-1-mcgrof@kernel.org>
 <pociwdgfqbzw4mjass6u6wcnvmqlh3ddqzoeoiwiyqs64pl6yu@5ad7ne7rgwe2>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pociwdgfqbzw4mjass6u6wcnvmqlh3ddqzoeoiwiyqs64pl6yu@5ad7ne7rgwe2>

On Thu, Mar 27, 2025 at 12:53:30PM +0100, Jan Kara wrote:
> On Wed 26-03-25 11:50:55, Luis Chamberlain wrote:
> > 0-day reported a page migration kernel warning with folios which happen
> > to be buffer-heads [0]. I'm having a terribly hard time reproducing the bug
> > and so I wrote this test to force page migration filesystems.
> > 
> > It turns out we have have no tests for page migration on fstests or ltp,
> > and its no surprise, other than compaction covered by generic/750 there
> > is no easy way to trigger page migration right now unless you have a
> > numa system.
> > 
> > We should evaluate if we want to help stress test page migration
> > artificially by later implementing a way to do page migration on simple
> > systems to an artificial target.
> > 
> > So far, this doesn't trigger any kernel splats, not even warnings for me.
> > 
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Link: https://lore.kernel.org/r/202503101536.27099c77-lkp@intel.com # [0]
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> 
> So when I was testing page migration in the past MM guys advised me to use
> THP compaction as a way to trigger page migration. You can manually
> trigger compaction by:
> 
> echo 1 >/proc/sys/vm/compact_memory

Right, that's what generic/750 does. IT runs fsstress and every 5
seconds runs memory compaction in the background.

> So you first mess with the page cache a bit to fragment memory and then
> call the above to try to compact it back...

Which is effectively what g/750 tries to exercise.

When it's run by check-parallel, compaction ends up doing a lot
more work over a much wider range of tests...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
