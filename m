Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1ECD284890;
	Thu, 18 Dec 2025 11:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766057108; cv=none; b=i6z9u3FGmIdNIDSocE2knqMJxBonzrpwtYNS8lz07a3jV12G5euHbEAzH/BRLzcPTCj0FM1c/sp6BpVvKnx+zNvPkt6RL8KQ/4FIHXi+dFlulCwOfByDgVAPS4A9AUqX/nSR/Byq4dPD7fX7ccGlUaj7lEy5l8UkbSkZLOafY3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766057108; c=relaxed/simple;
	bh=tdW8fnXupCOSsN96mXMeTs2wlT6YThU2zVhoHzFQylM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X/cJM7mq9U/zlDmINkOWaFf8AL4tHeznp4XgXyNDMKcmVYglytILzKwHxirFCfhgFKx/iLLQlrcbRjO9tdK7y3OgwygFDBb9piP40BfCVz5MvyNutiYb1WMGDajhvD39j+XOBwhX8o+JJI3kFAquWiPViHGljaSUwoOUXHenRCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTFcb/y4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTFcb/y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE73C4CEFB;
	Thu, 18 Dec 2025 11:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1766057106;
	bh=tdW8fnXupCOSsN96mXMeTs2wlT6YThU2zVhoHzFQylM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OTFcb/y4kotOZN5iBp3ALKSPNpdIyZhmnZvgDWLO6vJeRgu65fPgcMKmG1DmQUSkN
	 4KY0m2JnNCKghd1a7YvzcCymtBbgrKziuu/qJHcaA5zGnkVnery7agAyBQt4O4+mOM
	 OOqAtoeLvrB65XrpA85X4Oe9RhFYzoj3cEBIc0QM=
Date: Thu, 18 Dec 2025 12:25:03 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 280/614] perf vendor metrics s390: Avoid
 has_event(INSTRUCTIONS)
Message-ID: <2025121839-outbreak-handed-29bf@gregkh>
References: <20251216111401.280873349@linuxfoundation.org>
 <20251216111411.519418812@linuxfoundation.org>
 <4e90e4dc-e0d7-492f-a45f-30a53be3899b@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e90e4dc-e0d7-492f-a45f-30a53be3899b@kernel.org>

On Thu, Dec 18, 2025 at 07:16:06AM +0100, Jiri Slaby wrote:
> On 16. 12. 25, 12:10, Greg Kroah-Hartman wrote:
> > 6.18-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ian Rogers <irogers@google.com>
> > 
> > [ Upstream commit c1932fb85af8e51ac9f6bd9947145b06c716106e ]
> > 
> > The instructions event is now provided in json meaning the has_event
> > test always succeeds. Switch to using non-legacy event names in the
> > affected metrics.
> > 
> > Reported-by: Thomas Richter <tmricht@linux.ibm.com>
> > Closes: https://lore.kernel.org/linux-perf-users/3e80f453-f015-4f4f-93d3-8df6bb6b3c95@linux.ibm.com/
> > Fixes: 0012e0fa221b ("perf jevents: Add legacy-hardware and legacy-cache json")
> 
> Hmm, this ^^^ is also a 19-rc1 commit, not present in .18-stable. Why were
> these patches added?

Ugh, let me go drop this and then verify _all_ of the commits in the
tree are actually fixing something in the right branch.

thanks,

greg k-h
