Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9685B2CA4
	for <patches@lists.linux.dev>; Tue, 18 Jan 2022 21:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642539801; x=1674075801;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=P1yWwiO+/KLc5Fnql+MlQCaBmw+U58qRYKjO6YVvVEc=;
  b=epyHdBuh3RL771s6JJStOWH+YQTLkO+UToTMHGyUms9E3gnUL0QJl+qF
   mQ064pXc/+hGMZRWInwPxG0HJk/tEh4uv+AiTGh1OTyBXFjr4QALH/leM
   7OZcYOSetEuxS4/mcJ9f3EOZiUBpiB/PjEEmavNMDpjH3HKP5Nd+pAObI
   Hc+4LEcRnG31bln27YYjd+jC93AndDx9aux96hJqWfAjFFVTVi0wh/VWC
   LfNoarXpZ0yW6qFIZL8LfQmQZBM1CxA33QIOkiL5KfdKlm0VfK+Sq2DDD
   g3gDgG9LQg+GuUkZcw1hoJFTXy9gjhKdSQbZJJJaUs1ulkjfWABXGsl+z
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="244709993"
X-IronPort-AV: E=Sophos;i="5.88,298,1635231600"; 
   d="scan'208";a="244709993"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 13:03:20 -0800
X-IronPort-AV: E=Sophos;i="5.88,298,1635231600"; 
   d="scan'208";a="531956820"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 13:03:20 -0800
Date: Tue, 18 Jan 2022 13:03:19 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, patches@lists.linux.dev
Subject: Re: [PATCH 1/5] x86/ras: Merge Intel and AMD ppin_init() functions
Message-ID: <YecrF15C0d0tudUN@agluck-desk2.amr.corp.intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220107225442.1690165-2-tony.luck@intel.com>
 <YecY/Ri6hvJGqNTT@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YecY/Ri6hvJGqNTT@zn.tnic>

On Tue, Jan 18, 2022 at 09:02:41PM +0100, Borislav Petkov wrote:
> On Fri, Jan 07, 2022 at 02:54:38PM -0800, Tony Luck wrote:
> > +} ppin_info[] = {
> > +	[X86_VENDOR_INTEL] = {
> > +		.feature = X86_FEATURE_INTEL_PPIN,
> > +		.msr_ppin_ctl = MSR_PPIN_CTL,
> > +		.msr_ppin = MSR_PPIN
> > +	},
> > +	[X86_VENDOR_AMD] = {
> 
> X86_VENDOR_AMD is index 2 not 1 so ppin_info[1] is empty.
> 
> I wouldn't mind swapping the numbers here in a pre-patch:
> 
> #define X86_VENDOR_CYRIX        1
> #define X86_VENDOR_AMD          2
> 
> nothing would depend on those naked numbers, right? :)

You are much braver than I :-)  How confident are you
that nobody implicitly depends on those? Is it worth the
risk/churn just to save 12 bytes in the ppin_info[] array?

I'll fix up all the other stuff you found and post a V2
soon.  Thanks for the review.

-Tony
