Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8762346A0
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 14:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694010756; x=1725546756;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=V5V26GejPVyOSxfUjPT2mOYUtjVt5U4tPwu4TvOFpFo=;
  b=AJ2FJxtXwRYZVxTl1JfB19M9GZ6KPycv+CdVlKMTJXFPx5hsIgzF23kb
   Ig66j3RMsAsGaPg7bl+W4l5lVq8IU6QR7Q4UMp//heAXf4/EYOvHYWbc2
   RndINb3lJAg1KYzv+F2cmF1NoDRXG/GrsUV7synuuLQzL25Rk/McXnzz4
   1QYOH7wX7NnU9UiDbD512KrOlp6bL5RHdrnBYtwyMU40t2f/9BKs6srPA
   AMk+QJs20XZx2PaDNNQXnt8n3Nn5vwoIArvd1pGjqgN+KDxdmZ6XmiWyu
   xdnMsRFg2DZK7WPzZcEpG7MzMfNXiceu52mknXa2O27xcHr2hb2lQJ4A/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="441055378"
X-IronPort-AV: E=Sophos;i="6.02,232,1688454000"; 
   d="scan'208";a="441055378"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2023 07:31:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10825"; a="811685411"
X-IronPort-AV: E=Sophos;i="6.02,232,1688454000"; 
   d="scan'208";a="811685411"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 06 Sep 2023 07:31:49 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
	id BCEB017D; Wed,  6 Sep 2023 17:31:47 +0300 (EEST)
Date: Wed, 6 Sep 2023 17:31:47 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stephen Boyd <swboyd@chromium.org>, Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: Re: [PATCH 1/3] platform/x86: intel_scu_ipc: Check status after
 timeouts in busy_loop()
Message-ID: <20230906143147.GD1599918@black.fi.intel.com>
References: <20230831011405.3246849-1-swboyd@chromium.org>
 <20230831011405.3246849-2-swboyd@chromium.org>
 <20230901055011.GT3465@black.fi.intel.com>
 <CAE-0n50XCw7ugkoTAUfb5Jrr6-Vh=bvXfTOSeHV_ymyOQfRB2g@mail.gmail.com>
 <ZPiCz6AaLc4mqGH8@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZPiCz6AaLc4mqGH8@smile.fi.intel.com>

On Wed, Sep 06, 2023 at 04:46:55PM +0300, Andy Shevchenko wrote:
> On Tue, Sep 05, 2023 at 05:27:23PM -0500, Stephen Boyd wrote:
> > Quoting Mika Westerberg (2023-08-31 22:50:11)
> > > On Wed, Aug 30, 2023 at 06:14:01PM -0700, Stephen Boyd wrote:
> > > > It's possible for the polling loop in busy_loop() to get scheduled away
> > > > for a long time.
> > > >
> > > >   status = ipc_read_status(scu);
> > > >   <long time scheduled away>
> > > >   if (!(status & IPC_STATUS_BUSY))
> > >
> > > How can the status bit change here as we are the only user and the SCU
> > > access is serialized by ipclock?
> > 
> > I don't know how the SCU works. I thought that IPC_STATUS_BUSY bit was
> > cleared by the SCU when it was done processing. With that assumption, I
> > tried to show that the status is read and then the process schedules
> > away for a long time and has an outdated view of the busy bit.
> 
> We probably have different versions of firmwares for the different SoC
> generations. But I _think_ that you are right, the SCU firmware should
> clear the bit when it's done.

Yes, IIRC it does. Okay I see the (potential, although quite unlikely)
problem now. Thanks!
