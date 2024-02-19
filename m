Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019904417
	for <patches@lists.linux.dev>; Mon, 19 Feb 2024 03:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708313898; cv=none; b=XcITAp69KQg7/A1EsaJX02cXrvZqdX5jYm4c9dz/ErUyC3kltzDWGpYLpJxNmaSgl16PJ8D8B9MwgJC6By3hztgkY42v6tNF0agCT0i627aN/Tsied2CdXCb98L+XF1X80z6KnGGyeu/G64YFPmOz597y5f6+X2k8D+zi7ITjIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708313898; c=relaxed/simple;
	bh=dv6zeaFrRvbAqGuha6VsK0ygAyWi2WBXbRGFN+cxJJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uf3eI3p+GD2L/mYgyZdLmlJqmhNIvPuXtfU9ecMSolTsSgUIEyuH7w9Ezdz0Y1DeBBqR5K2TDhJ3lyH3HRmFvO6adHrs7qJFpnEZ2PRKWPLsefBXYLuFflzArVQMOSAYAA7mY6uhRUhKa4+UN02nhjCJDRksgUGB7+ozyUOyodw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=iK2cyeTB; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="iK2cyeTB"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-299846d6ccfso132150a91.0
        for <patches@lists.linux.dev>; Sun, 18 Feb 2024 19:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708313896; x=1708918696; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=snkAwXlGmKMGPxH6OPqiR7B5ATkC+pV6nS/zNfbY9Vc=;
        b=iK2cyeTBt07xEQRiOB8KQHy0IKqj/ji8db50c1MPuzt7xT4MJe1zhmYqxKgqI3IH3A
         6FUUuI2zv6c6Iw2AFA+lbYixKkq0wF0QGvBJydGIS4xXe3RMFdMXwddD0Iwn6v6aN0UZ
         lJZ3b5G/s9CsfGvy12SoeD+gp/6KwCTXMHlKFVUgr1WdtHgUIyIg/sMvZTzwdycipm/v
         VeKasNQ3+6K82yHGiIqYFwqJ+lDXdEqRh/cC3kdeYCRTzk8lIgEgZSojDEBZqzZYc/JH
         T/jktPPbw/b0v7MpX0Shcet9aByAIUEqjJyjKAr9owMpeezWZrINDQhg729EbJEqCUm4
         DKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708313896; x=1708918696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=snkAwXlGmKMGPxH6OPqiR7B5ATkC+pV6nS/zNfbY9Vc=;
        b=aHSV3jJKLZzj0DacCVEVurzqrhzABNeicrWAqgDFiGBq2qKVYuztvxfTxewuPAQZUl
         97nfmmtvFHBTkr/o8PcbmPEcEsKsPAb/M1Tk1QrnX+qjQdh8F2c3nSRTq46hHg2utnqC
         +YivCTrIkWyC+KUcuy0TQ0h/MVFDgGa9ujU6uQvVuYtTQ5ItDWTQUhiCD2wXjVSZXt9A
         TAOfTPpDboNOSVouGCdfo3kX+O4aoFphU0ffi8pSIe9qIuq59WzlTH9xkoXo88+6N+Qu
         OIqgU2py6jBsR4RTC/xBhel3sBSjpUhkXbHai8yBHN1AOUb1HUGzzWz5tKCIbu9DlGKU
         g1SQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQIXT7D9IHrTKL1LoyWU/dx5EATKo4J6gZozHr3BI3P/1ueHl4c+738Bh5133EpSAAXrVtH4TkzMhZOA017rB54bqZ3z62ew==
X-Gm-Message-State: AOJu0YyRDuDasVLEgjobUVYA4HqGcDVLi6lRUzkdb3rzlS23KYMrzJA8
	6B2hbZzdfpFu+w4mIUntTPKufgTIYdZqruxQUI0hv+M5/u20GCXy0BYwi5fQcUw=
X-Google-Smtp-Source: AGHT+IFD58ZsKpdgAYSoAuHc6zxmZ42otJO9CrU80mux2WyOXUdV/N1NvIgiKkl34xRS9rvGCNiplg==
X-Received: by 2002:a17:90b:2306:b0:299:489f:a126 with SMTP id mt6-20020a17090b230600b00299489fa126mr3293858pjb.41.1708313896144;
        Sun, 18 Feb 2024 19:38:16 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id c24-20020a17090ad91800b0029948cb4367sm3954944pjv.23.2024.02.18.19.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Feb 2024 19:38:15 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rbuTs-008S7J-2H;
	Mon, 19 Feb 2024 14:38:12 +1100
Date: Mon, 19 Feb 2024 14:38:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, anand.jain@oracle.com, aalbersh@redhat.com,
	djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	kdevops@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 2/3] check: add support for --list-group-tests
Message-ID: <ZdLNJD5pYaK84w3r@dread.disaster.area>
References: <20240216181859.788521-1-mcgrof@kernel.org>
 <20240216181859.788521-3-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240216181859.788521-3-mcgrof@kernel.org>

On Fri, Feb 16, 2024 at 10:18:58AM -0800, Luis Chamberlain wrote:
> Since the prior commit adds the ability to list groups but is used
> only when we use --start-after, let's add an option which leverages this
> to also allow us to easily query which tests are part of the groups
> specified.
> 
> This can be used for dynamic test configuration suites such as kdevops
> which may want to take advantage of this information to deterministically
> determine if a test falls part of a specific group.
> Demo:
> 
> root@demo-xfs-reflink /var/lib/xfstests # ./check --list-group-tests -g soak
> 
> generic/019 generic/388 generic/475 generic/476 generic/521 generic/522 generic/616 generic/617 generic/642 generic/648 generic/650 xfs/285 xfs/517 xfs/560 xfs/561 xfs/562 xfs/565 xfs/570 xfs/571 xfs/572 xfs/573 xfs/574 xfs/575 xfs/576 xfs/577 xfs/578 xfs/579 xfs/580 xfs/581 xfs/582 xfs/583 xfs/584 xfs/585 xfs/586 xfs/587 xfs/588 xfs/589 xfs/590 xfs/591 xfs/592 xfs/593 xfs/594 xfs/595 xfs/727 xfs/729 xfs/800

So how is this different to ./check -n -g soak?

'-n' is supposed to show you want tests are going to be run
without actually running them, so why can't you use that?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
