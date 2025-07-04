Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B639E20297E;
	Fri,  4 Jul 2025 09:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751620869; cv=none; b=uSOmyUGqawdVWzWYCrVGr95eAd5b4oAp0MzIdynlIgeG3cEsZq0mJ0U+byvWLaLaQ8swSJgsGgSk1NbUbOeS31F7skaFWu0iroSLeR9T/TxEl2bbHkD/Na2NvfKFWVDM9xccvF/ld6Y8Aip+vow84r9UbQX5r+ioVYyT7cgvq8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751620869; c=relaxed/simple;
	bh=kQLMxKHzhXC6Oi8Cza11eybSBJPVYiBn/Mo4rYI+I3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=acDGRuLtOrxI4SMX8qEcH1q2h2/dX05NIDVqXUlqnK4OUiHAMUecwWYnUidT9mCzanC+9aaLuh+5UpnqwSDHrWrHU1ffIh0vpygwDH/dydXPepRxwwEm4SjnzyxqRl8nWeYV8DP5XZKBFmQfjmXEeoO+PyijZ2ziT6nE43tFU5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqADlQpc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqADlQpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2723C4CEE3;
	Fri,  4 Jul 2025 09:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751620869;
	bh=kQLMxKHzhXC6Oi8Cza11eybSBJPVYiBn/Mo4rYI+I3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BqADlQpc92NfNd2cnz8pBsyvviBoRVoaZyJgYIKGmuBj3wThWFtC1sw1m66/rJ3F7
	 TEmoIMTOt/0Pt9/mWwg5Yt/09jEfz4nxEXWc70U4WepQ9YCsZPINxFqfKdRxspkgvN
	 vqkpp5X0XVH58Gcwf2pUWSH6kPtXFJVZV0yigP5I=
Date: Fri, 4 Jul 2025 11:21:06 +0200
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
Message-ID: <2025070409-ranking-sadness-bf4a@gregkh>
References: <20250703144004.276210867@linuxfoundation.org>
 <20250703144014.438570401@linuxfoundation.org>
 <c0e8caef-f8b8-433c-a697-9b808b2f87f3@kernel.org>
 <2025070411-trace-enrage-ac79@gregkh>
 <786942aa-3b8e-4b7c-90db-0e710e0674cb@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <786942aa-3b8e-4b7c-90db-0e710e0674cb@kernel.org>

On Fri, Jul 04, 2025 at 11:14:07AM +0200, Jiri Slaby wrote:
> On 04. 07. 25, 11:06, Greg Kroah-Hartman wrote:
> > On Fri, Jul 04, 2025 at 07:00:06AM +0200, Jiri Slaby wrote:
> > > On 03. 07. 25, 16:42, Greg Kroah-Hartman wrote:
> > > > 6.15-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Mario Limonciello <mario.limonciello@amd.com>
> > > > 
> > > > [ Upstream commit 8b5f3a229a70d242322b78c8e13744ca00212def ]
> > > 
> > > This is actually 8b5f3a229a70d242322b78c8e13744ca00212def squashed with
> > > 4b61b8a390511a1864f26cc42bab72881e93468d -- why?
> > 
> > Ick, I don't know.  Let me go drop it now, good catch!  Let me go verify
> > these other drm backports too, the drm stable patch mess is never fun...
> > 
> > Yeah, something went wrong with Sasha's backports, some of these didn't
> > even have an upstream commit id in them :(
> > 
> > I've dropped this one, and the ones after this as they weren't correct,
> > thanks for the review!
> 
> Actually, we have the two (8b5f3a229a+4b61b8a39) in our tree as they fix:
> https://bugzilla.suse.com/show_bug.cgi?id=1236415
> 
> So dropping them is not a good idea after all ;). Just desquash...

Ah.  Ok, I've applied them individually and that worked.  Let me try to
figure out what the ones that Sasha added that had no git id were
from...

greg k-h
