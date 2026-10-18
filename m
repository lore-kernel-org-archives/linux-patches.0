Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3C940F732
	for <patches@lists.linux.dev>; Sun, 18 Oct 2026 17:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792345427; cv=none; b=IT7FxBtaC6k3G+lajKJNxNaPEyd5WmN83TuZBqn87yRhHb4gLjLRPHHLFQzglj3Xr31ICGoZmcQForXfh49p8TJkRb5aLj6u0R9J3xwMnQ/6ZJthw6576oLLD6oqBj8jB39uHfw8QaXIsVhjsyTKMRSJBWTGZ0k0d3J6G59/01Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792345427; c=relaxed/simple;
	bh=SEryhHEn2ByopfBRHkq9FPldXMMAcOdNRkbc6JOUSCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=laVPRR+0iglwrpO3/9OfFTqc3DR3U9gw1xpN5giOQPsKCQJFr4y5Z85DoRae9Ns29f44mwoblQNQoN+BfLMOBzlOftewu+AQhPwX+NsvhxJ5mVdIxUDpIi3eGHL+c96a89IaP2cQenJLYk5H1LGxvTgMPppmxC+uvUPQb6FPtk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HRawQOep; arc=none smtp.client-ip=91.218.175.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HRawQOep"
X-Envelope-To: patches@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=SEryhHEn2ByopfBRHkq9FPldXMMAcOdNRkbc6JOUSCU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792345423; v=1; x=1792950223;
 b=HRawQOepB1kKHztcUCHDA8+8UMQrGh3cskwa93r1S5nrlewfDAgEcYVoc31H3rYFS2YEbkoS
 NYMRR7JSPS988J5rkvqak2LpaOp0WEOZZRbT1eLppcRAb7qY+sxGiP5tdYMrCeSZWulXZqvb13X
 ZWqSwPgYnS+71kRIQgPYRWUs=
X-Envelope-To: patches@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2e23c358c62a656b;
	Sun, 18 Oct 2026 17:43:43 +0000
X-Mizu-Trace-ID: 2e23c358c62a656b
X-Migadu-Flow: FLOW_OUT
Date: Mon, 19 Oct 2026 01:44:24 +0800
From: Chen Yu <chen.yu@linux.dev>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, ben.horgan@arm.com, james.morse@arm.com,
	Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
	tglx@linutronix.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
	peternewman@google.com, yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 5/5] fs/resctrl: Drop unnecessary parameter from
 resctrl_io_alloc_parse_line()
Message-ID: <atUFeK4x_F1wcIwR@three-body>
References: <cover.1791406459.git.reinette.chatre@intel.com>
 <b01d58ebb13c6cadd68c0fb33f469fdb32dcb597.1791406459.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b01d58ebb13c6cadd68c0fb33f469fdb32dcb597.1791406459.git.reinette.chatre@intel.com>

On Wed, Oct 07, 2026 at 02:06:47PM -0700, Reinette Chatre wrote:
> 
> resctrl_io_alloc_parse_line() parses a line written to the io_alloc_cbm file.
> It receives both a schema and a pointer to the schema's resource. Its only
> caller looks up the resource from the schema just to pass both.
> 
> Passing the resource separately is redundant and allows a caller to pass a
> resource that does not belong to the schema. parse_line(), which parses lines
> written to the schemata file, already receives only the schema and determines
> the resource from it.
> 
> Pass only the schema to resctrl_io_alloc_parse_line() and have it determine
> the resource itself, matching parse_line() and in preparation for passing
> additional information when supporting multiple controls.
> 
> No functional change.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Reviewed-by: Ben Horgan <ben.horgan@arm.com>
>

Reviewed-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu 
