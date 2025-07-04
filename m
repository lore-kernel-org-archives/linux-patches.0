Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BD928B7D3;
	Fri,  4 Jul 2025 09:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751620011; cv=none; b=mTaD4XJV9emlI/Jarf+cEdXWi6w137mhGMA0SnKumZ5fYuJyTsX+HwzPWI1bJPP4uo9KlfZXknglMrzKKowvmOPYVZMF9RZJIhJTOVSDPYGFNGeBe7z4ycTmetJsT/Bs3lMRtuLgEUAv4lli8RaOHYy2AkLFUnQ+xzSh1312b6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751620011; c=relaxed/simple;
	bh=3gH9AMhjiy87g4NbkPfiltwEef9AL+FWpxauagg1uLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SsNGGbqyvj8otq1AsqqhTj3ARKf6spsu2L75EO0wL6NXDDvyVmJyOLC68bPwHpXufl4/s+DzJWVWFf9ltkewo+iE+j40Ve44irwGJmBstl6ApNldqPumoOewSukf2nEZL1Ppi7Opl7F6jsGiWDbXGVjuAPeG644zjTvyic+7ovM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RH9RPp+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RH9RPp+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26091C4CEE3;
	Fri,  4 Jul 2025 09:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751620010;
	bh=3gH9AMhjiy87g4NbkPfiltwEef9AL+FWpxauagg1uLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RH9RPp+Fn8mkXZiQXtaO0hwytUN/cRymeEuSfyDVouxt9/jghmnLxXrWrZO/nMP0x
	 M6OlrAYlt0FN80YrqAb9X2aggGwqrsSzViUodSBzWYpiIqBIFdOvyFk3ws2B2q5wjh
	 aXQxfWbzHZVyi6e0Qd4R3F6Xy/NncRxr/UGwjGWY=
Date: Fri, 4 Jul 2025 11:06:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.15 250/263] drm/amd/display: Fix default DC and AC
 levels
Message-ID: <2025070411-trace-enrage-ac79@gregkh>
References: <20250703144004.276210867@linuxfoundation.org>
 <20250703144014.438570401@linuxfoundation.org>
 <c0e8caef-f8b8-433c-a697-9b808b2f87f3@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0e8caef-f8b8-433c-a697-9b808b2f87f3@kernel.org>

On Fri, Jul 04, 2025 at 07:00:06AM +0200, Jiri Slaby wrote:
> On 03. 07. 25, 16:42, Greg Kroah-Hartman wrote:
> > 6.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Mario Limonciello <mario.limonciello@amd.com>
> > 
> > [ Upstream commit 8b5f3a229a70d242322b78c8e13744ca00212def ]
> 
> This is actually 8b5f3a229a70d242322b78c8e13744ca00212def squashed with
> 4b61b8a390511a1864f26cc42bab72881e93468d -- why?

Ick, I don't know.  Let me go drop it now, good catch!  Let me go verify
these other drm backports too, the drm stable patch mess is never fun...

Yeah, something went wrong with Sasha's backports, some of these didn't
even have an upstream commit id in them :(

I've dropped this one, and the ones after this as they weren't correct,
thanks for the review!

greg k-h
