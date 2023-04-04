Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678F77C
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 12:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680610999; x=1712146999;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YIxPVV74jrYRfkOZDeh8wMhARh9e3pNboTGTsGxQLVQ=;
  b=YTiOgKaDDo3XKvfiyM9zPdbLfQs8zpVbXY9IDONqLkep8uPlmA8tMnRy
   xYYAkWegi7hgCazs2/BwNK+EXscZqRyKWxc7IoX+IiuTpcicOEML6M4hL
   LRw/hpdJLs760x0R7WBnT/rOxbqRUECiOx4/XNhRzjoFIVmLQRQiedVWE
   edzRvNNItUwO6NikJQ5qOpNZXhQWZz5Vu9Z6MP0ZhNQZPstez6F6/8tKk
   EguZz89qZCea0ZI2ExDBnTv2WcJFcEJR5i1xUBA4HnmiLWLmyjjF95Jjh
   OKF/xuMP2xTWolyE1HVPNfKz86om7BmNno1BwpQyrsP9fZLitntFOAivE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="343862787"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="343862787"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 05:23:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="750895933"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="750895933"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 04 Apr 2023 05:23:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
	id D30C613A; Tue,  4 Apr 2023 15:23:02 +0300 (EEST)
Date: Tue, 4 Apr 2023 15:23:02 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Sanju Mehta <Sanju.Mehta@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: Re: [PATCH 5.10 063/173] thunderbolt: Use const qualifier for
 `ring_interrupt_index`
Message-ID: <20230404122302.GQ33314@black.fi.intel.com>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140416.499791738@linuxfoundation.org>
 <ZCwKBSQSbj3Ka4on@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZCwKBSQSbj3Ka4on@duo.ucw.cz>

Hi,

On Tue, Apr 04, 2023 at 01:29:09PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Mario Limonciello <mario.limonciello@amd.com>
> > 
> > commit 1716efdb07938bd6510e1127d02012799112c433 upstream.
> > 
> > `ring_interrupt_index` doesn't change the data for `ring` so mark it as
> > const. This is needed by the following patch that disables interrupt
> > auto clear for rings.
> 
> Yeah, nice cleanup. But do we really need it in -stable?

Yes, it was followed by a fix patch that needs this:

468c49f44759 ("thunderbolt: Disable interrupt auto clear for rings")

I marked both for stable but perhaps the latter did not apply cleanly
for v5.10?
