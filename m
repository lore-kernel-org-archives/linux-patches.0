Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC2A221578;
	Thu, 24 Apr 2025 10:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745490579; cv=none; b=lXbTEtU2wd8CWJrUUUpW4IuQYXfriRJwtFGcnTFNsdCs2VsQeyum0grvIWSsXhzvSmK9JKDXJkgsza+1WmUTICGIpc5wMYB9AOtyTzdzSKJKPYph4xsqjex11VX/kmJ2kdWjFUJqcqqRoe/gES8SL2ihzwBcEkCTRL9OwSHmOiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745490579; c=relaxed/simple;
	bh=GpPAam8sx8Fwhc1TYFoXYv/OWCx+kkItaCIPFmPWgUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmvX08qpZ8HUokXtu9cBQUIN/AnVmnzBsUcnz1lCHczi0I0E50RkZOQYt9jaZ/PxD83i43yBQGlYnH42jFeBwwY/h65a+DZxMgGdVlqM4JCDF/aNAFAYVgCNs/HZGpHILPCjTThmKX2oZ9CR6Vh8cu76y9OAgSTceHVOJR5tCtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5jAz33o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5jAz33o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F1DC4CEE3;
	Thu, 24 Apr 2025 10:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745490578;
	bh=GpPAam8sx8Fwhc1TYFoXYv/OWCx+kkItaCIPFmPWgUI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v5jAz33oInu7T5Dt4ZrRsMq1KN38OkWmdEAac4ZbpBM21SXL5jFpFPVSUhuWR9gP1
	 Ir7RsmAntZGIUgS7olHTdo5pY8o0KxKJ2i8xCFECw0T/04K7dEgrcqgPp/kRdj76sz
	 YUkc610cAOeyja9oWyq20uZ3ujio7aV6QSGxCn/o=
Date: Thu, 24 Apr 2025 12:29:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Thorsten Leemhuis <linux@leemhuis.info>, stable@vger.kernel.org,
	patches@lists.linux.dev, Donald Hunter <donald.hunter@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 065/241] tools: ynl-gen: individually free previous
 values on double set
Message-ID: <2025042428-haziness-obstruct-5f9b@gregkh>
References: <20250423142620.525425242@linuxfoundation.org>
 <20250423142623.257470479@linuxfoundation.org>
 <d478c0b9-2846-496d-b345-429d98f93d38@leemhuis.info>
 <20250423094031.16664cdd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423094031.16664cdd@kernel.org>

On Wed, Apr 23, 2025 at 09:40:31AM -0700, Jakub Kicinski wrote:
> On Wed, 23 Apr 2025 18:27:46 +0200 Thorsten Leemhuis wrote:
> > [note, to avoid confusion: the problem mentioned below is independent of
> > an ynl problem I ran into with -next today:
> > https://lore.kernel.org/all/59ba7a94-17b9-485f-aa6d-14e4f01a7a39@leemhuis.info/ ]
> 
> Thanks for the report, these 4 need to be backported together:
> 
> 57e7dedf2b8c tools: ynl-gen: make sure we validate subtype of array-nest
> ce6cb8113c84 tools: ynl-gen: individually free previous values on double set
> dfa464b4a603 tools: ynl-gen: move local vars after the opening bracket
> 4d07bbf2d456 tools: ynl-gen: don't declare loop iterator in place
> 
> 

Great, all now dropped instead :)
