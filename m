Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFE37E
	for <patches@lists.linux.dev>; Wed, 24 Aug 2022 06:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w6RhqyoqH6BSTeN6EShgE/XnFp7pNDPLZa4RD6/f7dw=; b=GJMb3dG/Q8z7tbsQvPKgCaHpj+
	3/Wa5M1XSAsoxnEI74GDYyeJM0Qtv3DE/395kqzsylb/BtZqEHry6XqzKn91elwR4KAFzalLHFuf9
	8ioeEHXrYN4VSgxBE1W5pXIkz1iRIShRshEfmGhgOAEwHseBGa2Dd0SVou0HS1db9qnULsoTSTTDd
	nGvrPeVJyP7th+PzF2xqeassDFy58GkCl02eLuo4Gw1aDY81MTmalGUhzPnL4Xi3KhAsAwQ+Y/PbB
	eHrWq+wyP7LwMy4s4KxBK0WlPFzEgGD5KtYRNnxXRuRtJ818fOz+7ynMDcJHvCOTlYwa80nIm1Y/M
	uG+cwkgg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1oQkIU-00G5bF-Hj; Wed, 24 Aug 2022 06:55:30 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4AABF980403; Wed, 24 Aug 2022 08:55:29 +0200 (CEST)
Date: Wed, 24 Aug 2022 08:55:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] x86/cpu: Add new Raptor Lake CPU model number
Message-ID: <YwXLYced9p6OCJae@worktop.programming.kicks-ass.net>
References: <20220823174819.223941-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823174819.223941-1-tony.luck@intel.com>

On Tue, Aug 23, 2022 at 10:48:19AM -0700, Tony Luck wrote:
> Note1: Model 0xB7 already claimed the "no suffix" #define for a regular
> client part, so add (yet another) suffix "S" to distinguish this new
> part from the earlier one.
> 
> Note2: the RAPTORLAKE* and ALDERLAKE* processors are very similar from a
> software enabling point of view.  There are no known features that have
> model-specific enabling and also differ between the two.  In other words,
> every single place that list *one* or more RAPTORLAKE* or ALDERLAKE*
> processors should list all of them.

Note3: Except when they should not: https://lore.kernel.org/all/Yv9Kw21Wl/f6KJTk@worktop.programming.kicks-ass.net/?q=Alder+Lake+N
