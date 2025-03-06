Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55551946C;
	Thu,  6 Mar 2025 13:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741267980; cv=none; b=BNr58BMGiA2fnPG6cX9dH8I/o5f0Txz03DLW6csCn+B2ys/+ehsKz5DYdrnZP17+6eeRoik/TVm60338fME6xwa5A7IpOB9O2y100S9N5A2huX5zwVyDZCZXeuFtlZ5IJZBUaP+r8SGs446cre0k9UBFP+OyWIiMMfSvjAYuSKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741267980; c=relaxed/simple;
	bh=run5yGBKWfr9Umyhbc1xOv/ticuecsos8WTvKbqE0F8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WwoHSB2tm9rLHkrDmfk2ZDRir2N86Q29JpLvIhF4cM1AXBsSjVAnHTgTXyj0zfmEDrImru++UnRVlDFvE+U7jjjAu+XIKbso/0apK1jJgA0d1j4JepajlXu2jmeH8Iy3YwzoXS8uYwSXXBS5lPSXYGoXETGPtwk2hYgkNh87X9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knaJFfx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knaJFfx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CFEC4CEE8;
	Thu,  6 Mar 2025 13:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741267979;
	bh=run5yGBKWfr9Umyhbc1xOv/ticuecsos8WTvKbqE0F8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=knaJFfx38cFN0stfjswFmGiwnRteTbfchZvHkfhZN0YAclbI6IZ6BFryIg+qUlDr/
	 dz8T+2MArNF9Y1pmlT7TgHJ6vbkOFLe+A92o9TFxU0i2Dm+PRpf5JZJ5GgyG+YhT+m
	 NUm0sO1cs3xnhaoHpdoniGOSx61qT8YjLT3iY0i8=
Date: Thu, 6 Mar 2025 14:32:56 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 058/150] drm/xe: cancel pending job timer before
 freeing scheduler
Message-ID: <2025030621-fame-chastity-0bbd@gregkh>
References: <20250305174503.801402104@linuxfoundation.org>
 <20250305174506.154179603@linuxfoundation.org>
 <Z8kklJj90JKGPCHC@lstrano-desk.jf.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8kklJj90JKGPCHC@lstrano-desk.jf.intel.com>

On Wed, Mar 05, 2025 at 08:29:08PM -0800, Matthew Brost wrote:
> On Wed, Mar 05, 2025 at 06:48:07PM +0100, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> 
> We just got CI report on this patch, can you please hold off on backporting this.

Ok, but note you all better revert this upstream as well soon, otherwise
our tools have a tendancy to want to drag stuff like this back into
stable kernels to remain in sync with Linus's tree.

thanks,

greg k-h
