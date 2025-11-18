Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3362F2610;
	Tue, 18 Nov 2025 23:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763507041; cv=none; b=WepPE61WG1wkB+EZQknB7rMZJCzd+navR7EtLFqEsf1vtkKDUPSjsjD3IOLjP9G3RfmX08pirgp91+6vCmM6Yi6o3r3G1h3TC5mRVdsq+lWNT7tOeVpbQd3mPYzwdzdn2aPkQAqbmr1Mppb01KjE196adfQQOMGFqQLZhLIsfR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763507041; c=relaxed/simple;
	bh=OzeEMMupTpBXm+b3AephF9qtKZmpEbkMdaXCTK+TZE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=byKZbzITOzpkfF2GwcmlPL3OEtLSgWdUzLo24cpP628FPwp/6INsLidFGgQafxcSAZU1I0BowNIFRH6srYd/vNEdwGqJ87TiWR8MIvd6tIG0Dag4Tiw143AClwwfjLYRrbcQA60pYeUk9V8q72KpSw9SMBo+AbZUK3vOMxF72WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qeiUtW0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qeiUtW0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E462C4CEF1;
	Tue, 18 Nov 2025 23:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763507039;
	bh=OzeEMMupTpBXm+b3AephF9qtKZmpEbkMdaXCTK+TZE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qeiUtW0H6pQHJUVCwpYXdTmGeR+CQSm6hMlazEbWCwWeG0CWTM4QVCnL5YN6Nmzrk
	 2OQ2YqWEdf0WnlWy+v8LqShMS1oPJWhcLfHL362zarinT94FccQOtf1j/lseR9Ia4w
	 KP3xo/8ZEfolFcwZySiIIE14/LqVVTAn5dCzLnZfF3RrGS6TfdnFtH2Hl+vljhO01i
	 auFR409fHwHJJSwvvTHqF4XvWu5Nt+t55DquQ8k+yPmerIXlzQXjfr2j3+x8dNjV83
	 4QB7Ya3n4NSLFGFfVJsu4XCN7nSVoJz8A/E5lD30ZNTM+PsKC7XRomq9N1yEFHGHgU
	 qHBAul005cOBQ==
Date: Tue, 18 Nov 2025 15:03:56 -0800
From: Drew Fustini <fustini@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Drew Fustini <pdp7pdp7@gmail.com>, Fenghua Yu <fenghuay@nvidia.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Message-ID: <aRz7XF1ikjcA89Rx@x1>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <aRoLSz6or2UK4tDu@x1>
 <SJ1PR11MB6083B1C8D6D9EF5B44AFE2DCFCC9A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6083B1C8D6D9EF5B44AFE2DCFCC9A@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Mon, Nov 17, 2025 at 04:52:09PM +0000, Luck, Tony wrote:
> Drew,
> 
> Telemetry monitoring based on RMIDs is only present on Clearwater Forest
> systems today. Those haven't been released into the wild yet.
> 
> -Tony

Thanks for letting me know. Do you know what Xeon parts I should look
for if I want to try out the SNC support?

Drew
