Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2771843
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 22:34:24 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1a66911f5faso23687325ad.0
        for <patches@lists.linux.dev>; Fri, 21 Apr 2023 15:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682116463; x=1684708463;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WOBbV//TmE5/Vt+YNa7VvWoHjH617/cqrLHE/FuEqvo=;
        b=28YtcKiMKTyuPMVw5fu/SoweCi0BqDGeWt7RdFQrVk7PAU917keO+0FEYqTQ9/TsLB
         T1pzM9DhgsBLcc91My2Vu/2jTc0NKv/M54REjAUYDHXH1HKV9Z5I1WFYwId6vQM+JZTT
         E6n5vpXvzeV5sJVZPomczRMqHlEzbnPY63QdhqjDa6gftGLx/sPZUwv2JfprlGFlZtYf
         fkSebmqIvZEolZKw757enRENf4URiSoQqdGQEZOuckafZkYiGfcqGHFj/veTqOAh424T
         Sue6bk+H9d6MxTxRu5J8fCc9HsE6NtJ7Q9mZmdahhGSisRdkO3MgSWcLNMeFOEusAg5H
         JN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682116463; x=1684708463;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOBbV//TmE5/Vt+YNa7VvWoHjH617/cqrLHE/FuEqvo=;
        b=Olgvof7NGfQagKbZzgrZsLmkUHIsN1819f4cPdnDf2rGW/sRff6Vxp4NDp9YLxa8Zs
         saLOrz124JVdD4D923GCy6dRsgbPrmYjr1pwC5A3nrbRAbJmcBHb3bn5qnO4VagX2+eK
         /1odhXydX2RnRZgJNjyp297vITg/DDuupuzthxl8vywMatBM1x19GKf7sWywrx+XgRkZ
         KN++/+pT/DngPqzkGGmewOslZtNIfML6yy2FwuR/msF3xt85ByUoJB7PhcoAyi6VPzGr
         Susmy5E6aXvWF2nkP+nI1tLLFSEuiCf4HC/3WU1TNZ+/mN1e3AoKPvldGULircTubFR3
         s4tw==
X-Gm-Message-State: AAQBX9fPe3z3k9BOSLq6SyAR13/kbJZuI1PKOpHeUUo2WwgqlNWKSO8m
	QHKhKlxnYMEooitCAzaI/7kdsA==
X-Google-Smtp-Source: AKy350Yx4GjX3RRHXL1Mum+601m5ZkYo7MaItZI/8CPJsIZY6IZjMOJMo9Hbi+Mo8ymVreNZtCsXeA==
X-Received: by 2002:a17:902:d4c4:b0:1a6:6fe3:df91 with SMTP id o4-20020a170902d4c400b001a66fe3df91mr7801960plg.50.1682116463609;
        Fri, 21 Apr 2023 15:34:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id v7-20020a1709028d8700b001a6401189a6sm3138777plo.147.2023.04.21.15.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 15:34:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1ppzKe-006Dta-Ha; Sat, 22 Apr 2023 08:34:20 +1000
Date: Sat, 22 Apr 2023 08:34:20 +1000
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, axboe@kernel.dk, agk@redhat.com,
	snitzer@kernel.org, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
	hch@infradead.org, djwong@kernel.org, minchan@kernel.org,
	senozhatsky@chromium.org, patches@lists.linux.dev,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, drbd-dev@lists.linbit.com,
	linux-kernel@vger.kernel.org, hare@suse.de, p.raghav@samsung.com,
	da.gomez@samsung.com, kbusch@kernel.org
Subject: Re: [PATCH 3/5] iomap: simplify iomap_init() with PAGE_SECTORS
Message-ID: <20230421223420.GH3223426@dread.disaster.area>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-4-mcgrof@kernel.org>
 <ZELuiBNNHTk4EdxH@casper.infradead.org>
 <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>

On Fri, Apr 21, 2023 at 03:02:30PM -0700, Luis Chamberlain wrote:
> On Fri, Apr 21, 2023 at 09:14:00PM +0100, Matthew Wilcox wrote:
> > On Fri, Apr 21, 2023 at 12:58:05PM -0700, Luis Chamberlain wrote:
> > > Just use the PAGE_SECTORS generic define. This produces no functional
> > > changes. While at it use left shift to simplify this even further.
> > 
> > How is FOO << 2 simpler than FOO * 4?
> > 
> > > -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
> > > +	return bioset_init(&iomap_ioend_bioset, PAGE_SECTORS << 2,
> 
> We could just do:
> 
> 
> -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
> +	return bioset_init(&iomap_ioend_bioset, 4 * PAGE_SECTORS,

Yes, please.

> The shift just seemed optimal if we're just going to change it.

Nope, it's just premature optimisation at the expense of
maintainability. The compiler will optimise the multiplication into
shifts if that is the fastest way to do it for the given
architecture the code is being compiled to.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
