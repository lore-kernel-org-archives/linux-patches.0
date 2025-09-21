Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C284EEDE;
	Sun, 21 Sep 2025 17:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758474372; cv=none; b=sAXi5Cyk5EzO4cZ35xcro7MU6JKdSq7uuC9Qi1tA5zwJBUv0V5f934QPzbUsIiJMc+a4+IozXQOvl6vnPFDAsObVoZeU/l5NZo/YQJMa0tPvDtMWc7OgfmR2XqLEOEyswUsPsUkKU5lAKX3vdDkgE7Z6VjO8wi+VY99CkrlW1+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758474372; c=relaxed/simple;
	bh=jE++GcEJKHzjbheXTse5OXPaZt2ZqOZoEo5m7/XYTOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7Ofyb47kLPiLGBcMQF2GGNm00bu/i8n7LP11pGPclgT+GsaxsXrUfXex9r6iYJDLX0S68tWQjpVw3UzlkfZNNvW7QXUusTihNUe3KivVQ53yrxeeOpS3tTblfLC3gZeIYxHf0PdlQ8T89Ajv9Ix8alao/lh4Od17Ml4i0FRAwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuuhgqGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuuhgqGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0B4C4CEE7;
	Sun, 21 Sep 2025 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758474371;
	bh=jE++GcEJKHzjbheXTse5OXPaZt2ZqOZoEo5m7/XYTOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cuuhgqGbSI7SRbyP6B6U6j3Dwv6CLDsPdjNdUrpo7UugDQFgHCUJmcXR4kU+AiyVN
	 +TdSoKADiKwOxYYMy/cH410diCHLH65eFwslGUgNEIrxfhe0U5irVzg4U+/axadArT
	 P5pJotiGz+siEy1qRlrzUwj2lsXtzwF6xgxAeK0o=
Date: Sun, 21 Sep 2025 19:06:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Phil Sutter <phil@nwl.cc>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 113/140] netfilter: nf_tables: Reintroduce shortened
 deletion notifications
Message-ID: <2025092148-unsheathe-gooey-9836@gregkh>
References: <20250917123344.315037637@linuxfoundation.org>
 <20250917123347.067172658@linuxfoundation.org>
 <C2AE0418-CB38-4660-80F8-238FEF0D47E4@nwl.cc>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2AE0418-CB38-4660-80F8-238FEF0D47E4@nwl.cc>

On Sat, Sep 20, 2025 at 09:12:21AM +0200, Phil Sutter wrote:
> Hi Greg,
> 
> please skip this one, it's a pure feature which requires user space modifications.

It's already in a release.  And why would a kernel change need userspace
changes, that sounds like a regression.

thanks,

greg k-h
