Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3EE502AD;
	Fri, 12 Apr 2024 08:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712910348; cv=none; b=HxzstpxI4v+QV1Bh9tPNSWDoasWucSPFrwAN0A27oK970Z/YtE6F60F06ARfUpY+cw6YL3ebqaEQXYkEv/OvvmiY577LUomC4SE3BXB1NItJ/9WKYGBzqw9OmGY2jgchRO55Emn4/kbGmEc3GBchRavnkN6SOEWRYPkx+lkabt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712910348; c=relaxed/simple;
	bh=XgDIXudnzBjmOKKjeEc1800vtr+SGSDiJv2UFrOFRSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLgvRLEze9YKlEMbhFLThai3B9y+DkltGN+scc4JbyWhFqCNSSU/DheWJ+Y5iW9tSLdtDRePtBDaxaPigITjOwlM/dKh3GPcUYbP1Vn6j53A+87RVksD+i+WB+yZnlruWjQV7avpYfsWR/VJyasLpeuTVfuXNmHXWBS+PpGyOZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhZVRUAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhZVRUAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D32C4AF07;
	Fri, 12 Apr 2024 08:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712910347;
	bh=XgDIXudnzBjmOKKjeEc1800vtr+SGSDiJv2UFrOFRSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MhZVRUAK32Veaqa4hWd+BEaLRYwye5at5gfyeEaddLwDDkX4Zg7tM2Dy9Bc1Bbc/p
	 dE2nCXK+44TzgfHFwF3WZZg4q1I87GcnYwVZKQP23Ue1YoPxtf1AvgraTtEXKGtWoo
	 yFZL8XzsL8I42ptQxbywWpg5fJRtL1y8tfgpcjhM=
Date: Fri, 12 Apr 2024 10:25:44 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jarred White <jarredwhite@linux.microsoft.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Vanshidhar Konda <vanshikonda@os.amperecomputing.com>
Subject: Re: [PATCH 6.8 102/399] ACPI: CPPC: Use access_width over bit_width
 for system memory accesses
Message-ID: <2024041236-precision-consuming-945f@gregkh>
References: <20240401152549.131030308@linuxfoundation.org>
 <20240401152552.230440447@linuxfoundation.org>
 <4fabd250-bfa8-4482-b2f2-b787844aeb0b@linux.microsoft.com>
 <2024040235-clutter-pushing-01e2@gregkh>
 <97d25ef7-dee9-4cc5-842a-273f565869b3@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97d25ef7-dee9-4cc5-842a-273f565869b3@linux.microsoft.com>

On Thu, Apr 11, 2024 at 09:49:59AM -0700, Easwar Hariharan wrote:
> Hi stable team,
> 
> On 4/2/2024 12:55 AM, Greg Kroah-Hartman wrote:
> > On Mon, Apr 01, 2024 at 10:16:46AM -0700, Easwar Hariharan wrote:
> >> On 4/1/2024 8:41 AM, Greg Kroah-Hartman wrote:
> >>> 6.8-stable review patch.  If anyone has any objections, please let me know.
> >>>
> >>> ------------------
> >>>
> >>> From: Jarred White <jarredwhite@linux.microsoft.com>
> >>>
> >>> [ Upstream commit 2f4a4d63a193be6fd530d180bb13c3592052904c ]
> >>>
> >>> To align with ACPI 6.3+, since bit_width can be any 8-bit value, it
> >>> cannot be depended on to be always on a clean 8b boundary. This was
> >>> uncovered on the Cobalt 100 platform.
> >>>
> >>
> >> Hi Greg,
> >>
> >> Please drop this patch from all stable kernels as we seem to have a regression reported
> >> on AmpereOne systems: https://lore.kernel.org/all/20240329220054.1205596-1-vanshikonda@os.amperecomputing.com/
> > 
> > Ok, all now dropped.  Please let us know when the fix gets into Linus's
> > tree (and also properly tag it for stable inclusion as it is fixing a
> > commit that was tagged for stable inclusion.)
> > 
> > thanks,
> > 
> > greg k-h
> 
> Despite having dropped the backport of this patch from all stable kernels, the 5.15 backport seems to have snuck through.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.15.y&id=4949affd5288b867cdf115f5b08d6166b2027f87
> 
> Both the regression fix for AmpereOne[1] and a fix for another bug[2] we found while testing haven't been accepted into Linus'
> tree yet, so 5.15.154 has a known issue. Please revert this for 5.15.155 and I'll send an email when the full set is in Linus' tree.

Now reverted, thansk.

greg k-h
