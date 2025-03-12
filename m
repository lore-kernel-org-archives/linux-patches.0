Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E284D8632E;
	Wed, 12 Mar 2025 07:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741766063; cv=none; b=fJUxsrdB/LFAFZRMex23ar9yZJYMe1ORnweYVF1NSPB5h/XbKjOm6m3ucRJyk/M2lsZxgIZnHtEF0hfCcvVtT3taTdQoR9EzZQA50/3o1Z3+EsAgCgGgO13m1rIED5xrF2gA2gy1W3Jwc9eX2/vBgIUoP/DeOfLxiYY20bm8dkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741766063; c=relaxed/simple;
	bh=S/SBE+8RrvOMrBjInACSSPSEeMBtXuz5ily2pxtD5qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AbAt32CYSYmwE0y73avpOZ9ZyXUOUJGwlCrPMe1trKBKLrIX1NwC5tqwgbJq8JTYqv55xsQYdQcTTXbR6atipTbrhkNu3zNmTm/r4eFGEvG5oYxKFPFxEUw3WN7R2XIdl3c+z7L6pV22NXUYcW85EP++4W1HYoi5wBM6721c2kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Af0LPa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Af0LPa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12EDC4CEE3;
	Wed, 12 Mar 2025 07:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741766062;
	bh=S/SBE+8RrvOMrBjInACSSPSEeMBtXuz5ily2pxtD5qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0Af0LPa5w7YaNVBMshyODSFF2/aG3FKeIMcUWUxJZLEe+QSgsy0np0m7hOm3Tkhug
	 cNz5dlK5CtSvQSyNrrjgRnIAj4+Mh9p0e+dRUOwXbLhlHImgehMg0AobvsAVyp5UZF
	 tjsEJ8M+ZTX8UJR61Kcyt/IECMxLnBQf/vFSGM5w=
Date: Wed, 12 Mar 2025 08:54:19 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin Berg <benjamin@sipsolutions.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 088/207] wifi: iwlwifi: Fix A-MSDU TSO preparation
Message-ID: <2025031200-iphone-citizen-9083@gregkh>
References: <20250310170447.729440535@linuxfoundation.org>
 <20250310170451.257508843@linuxfoundation.org>
 <5d129bda966b7a55b444f4d48f225038361e9253.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d129bda966b7a55b444f4d48f225038361e9253.camel@sipsolutions.net>

On Mon, Mar 10, 2025 at 06:40:31PM +0100, Benjamin Berg wrote:
> Hi,
> 
> if you pick this patch, then please also pick "wifi: iwlwifi: pcie: Fix
> TSO preparation" which was submitted recently. Otherwise there is a
> regression in the n_segments calculation that can lead to packet loss.
> 
> 
> https://lore.kernel.org/linux-wireless/20250306122425.8c0e23a3d583.I3cb4d6768c9d28ce3da6cd0a6c65466176cfc1ee@changeid/

I don't see that commit in Linus's tree yet.  I'll go grab it from
linux-next, thanks.

greg k-h
