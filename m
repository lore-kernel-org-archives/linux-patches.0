Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E5E2820B3
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 15:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745423102; cv=none; b=ody8vBt6s1PIHCZWIH2YacJMRSBwxz4MF5IFdp3fZ8W5K6RjGKjjsLqNL14PMXH/Jwm0FGvgMNTryvflBVk/VybohMoVd8jbN/+8hJSAhN3Znq38gTdvHHkkp65C2SrO5T6GH/I7BEiBGRhZJos9v0gBdhlblrnfrfUkTOeBEQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745423102; c=relaxed/simple;
	bh=pT6G/womgkvlbEao+vsgaLYsmOlgLbiLQNwpJcq6v/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F6x94uCcqgr6a7ZhHE6uF4wewxKnvikHDDyM25Na6lCxjeDGCMxQF90KH19bxSLPbGTnLoHZAnswwbtnThP15ftCPVLK09TcYuBQoQgI0dQGX3P95SGFYDYavcDBFp548pNSTwD6O4bjEg7OstbDOmEe7b2nrZUw7II2mHbEY7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B052F68BFE; Wed, 23 Apr 2025 17:44:55 +0200 (CEST)
Date: Wed, 23 Apr 2025 17:44:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 122/241] fs: move the bdex_statx call to
 vfs_getattr_nosec
Message-ID: <20250423154455.GA31750@lst.de>
References: <20250423142620.525425242@linuxfoundation.org> <20250423142625.563593359@linuxfoundation.org> <20250423151540.GK25700@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423151540.GK25700@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 23, 2025 at 08:15:40AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 23, 2025 at 04:43:06PM +0200, Greg Kroah-Hartman wrote:
> > 6.14-stable review patch.  If anyone has any objections, please let me know.
> 
> You might want to hold this patch (for 6.14 and 6.12) until "devtmpfs:
> don't use vfs_getattr_nosec to query i_mode" lands, since (AFAICT) it's
> needed to fix a hang introduced by this patch.

Thanks, I was just going to say that.

