Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FC42BD1C;
	Tue,  2 Apr 2024 07:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712044511; cv=none; b=b/lw04Lhtk7mrpWyjssG2bAAYGJ8NadYc5yfb7tWndXxmTQzBO5e1JNToF5v3Iw0XYGidOffjpmsj5Z7o9izBd/ahT+D8bVhdjdzw5lw65TowPEEjNQtTsugQv7G92Vg+2UcToantXvN3QxSvfZbSOGM5LFuO9uSV0u4zIgHilQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712044511; c=relaxed/simple;
	bh=10U4+yFju8Dqq6Dbw4RyRPSS2JSMgc7aCRbWUvAXGYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yxgp3vBgmBmeQhRdWBp+9p4sGGvbCo7rkC/bfMCYvrwXiimnYjw8yelet2q+DSIXiMSP58U3s6ODHCx/LLv1ybm/tom3P6SrtvT4pp0Es8927To8WiysMvh/KywR6xpeuaqbgWaOIaITDDInng6MAnr/3zJfNzGJFFs5btKesmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwTpM7Om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwTpM7Om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0E1C433F1;
	Tue,  2 Apr 2024 07:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712044511;
	bh=10U4+yFju8Dqq6Dbw4RyRPSS2JSMgc7aCRbWUvAXGYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CwTpM7OmCGMKGSx2iG+kL9/N7pAEakz/TqXSUDPhai+jg6DUzUfH/BCDd1o/cMc56
	 6Mgk9IdNWjamQVHcFpsJbOKsuPXxjsdn2/qS24QVDh/0JvH0gMlXaOxpi2paIciad+
	 3LA1naiqQzMfUY77EeYw7Ze7ILaPNwpTiQNJCz7A=
Date: Tue, 2 Apr 2024 09:55:07 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jarred White <jarredwhite@linux.microsoft.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.8 102/399] ACPI: CPPC: Use access_width over bit_width
 for system memory accesses
Message-ID: <2024040235-clutter-pushing-01e2@gregkh>
References: <20240401152549.131030308@linuxfoundation.org>
 <20240401152552.230440447@linuxfoundation.org>
 <4fabd250-bfa8-4482-b2f2-b787844aeb0b@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fabd250-bfa8-4482-b2f2-b787844aeb0b@linux.microsoft.com>

On Mon, Apr 01, 2024 at 10:16:46AM -0700, Easwar Hariharan wrote:
> On 4/1/2024 8:41 AM, Greg Kroah-Hartman wrote:
> > 6.8-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jarred White <jarredwhite@linux.microsoft.com>
> > 
> > [ Upstream commit 2f4a4d63a193be6fd530d180bb13c3592052904c ]
> > 
> > To align with ACPI 6.3+, since bit_width can be any 8-bit value, it
> > cannot be depended on to be always on a clean 8b boundary. This was
> > uncovered on the Cobalt 100 platform.
> > 
> 
> Hi Greg,
> 
> Please drop this patch from all stable kernels as we seem to have a regression reported
> on AmpereOne systems: https://lore.kernel.org/all/20240329220054.1205596-1-vanshikonda@os.amperecomputing.com/

Ok, all now dropped.  Please let us know when the fix gets into Linus's
tree (and also properly tag it for stable inclusion as it is fixing a
commit that was tagged for stable inclusion.)

thanks,

greg k-h
