Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1719E35957;
	Wed, 12 Nov 2025 00:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762909168; cv=none; b=u9lH+tDmzPYG4Q1Yhw025ibkTJzuhxRCMj/mC1VlBVuxNOJxr5wXBzdRdTO6WA/pKtWYyXOUo1Gm3uH8nNFGR4mueZ5OLu2Lp/9xpYQ0qq4Ml1a+8jN+zlnhJzRDnVdLxnErfKxaAl6uo+bcOCehuHd54DQeFuDFfF+bkgFy0Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762909168; c=relaxed/simple;
	bh=zqeAXDrLxznNxB60JDMhr7dB4CjvCfnNzwTgFAT5Xyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AuLlbovO9dgWMJSuRXNuHOl0F1HJls1k0v3Oy2Q3mbf8RrRK3WzckiUlw2HvBFqysyKQSDxdhmp9pphqPlBrnRXk0018E7Unpq6wyMUzNmaKJC9lCWeAnQH0JwY6zv39XbV5fQ91T38WkFr4aSNvs73hCWRoxiaWn9A4uTWAmBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZC9UIyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZC9UIyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD77C116B1;
	Wed, 12 Nov 2025 00:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762909167;
	bh=zqeAXDrLxznNxB60JDMhr7dB4CjvCfnNzwTgFAT5Xyk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XZC9UIytZ8HikohCR2aDAIgFNDIJ9FVYDKPifAFmrOoLxUFJalg4Ul5PYqWcFzStR
	 jLSdEko+IHKWPxOJB2XOSrShxjOPpYy3F6xjzMTxV4bdikUc/7w2J2kx8A99CC5/YV
	 FypYOimJ1L3G9r7gNQW61L0prQ3s+4hUkvv42Dfc=
Date: Wed, 12 Nov 2025 09:59:25 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Philipp Stanner <pstanner@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Luben Tuikov <ltuikov89@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 084/565] drm/sched: Re-group and rename the entity
 run-queue lock
Message-ID: <2025111200-handoff-boxing-aa92@gregkh>
References: <20251111004526.816196597@linuxfoundation.org>
 <20251111004528.857251276@linuxfoundation.org>
 <b239f2abb28d4e5dfc36c67bb6b88975a63c11e6.camel@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b239f2abb28d4e5dfc36c67bb6b88975a63c11e6.camel@redhat.com>

On Tue, Nov 11, 2025 at 03:30:45PM +0100, Philipp Stanner wrote:
> On Tue, 2025-11-11 at 09:39 +0900, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> This and patch 83 are mere code improvements, not bug fixes.

But as the patch says:

> > Stable-dep-of: d25e3a610bae ("drm/sched: Fix race in drm_sched_entity_select_rq()")

That is a bugfix, right?  So this is needed here too.

thanks,

greg k-h
