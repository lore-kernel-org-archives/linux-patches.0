Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CB12F39A5;
	Thu,  4 Dec 2025 16:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764864898; cv=none; b=G/gb0pCXMYDHrAbpK5CnRW8jeMhziFgUHQoY13B4HhP+FJmzZQKxdmRWhG3Z7jJU8PctBqIiIsi3JBOYbFyvrASe+9/rtWuCGVPyK2GY9BemCvrJBnIu68IQHh8DIVXq+2JkkLtnQGjpNiebgpWqsBbc91ovAZIzR1NhqfFdtV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764864898; c=relaxed/simple;
	bh=DY3HwalwukNEw7FHv7CwvuRxFen5pupBk1Mw5rj1mhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RrPm/c6Pm/py37ZpRc4RHVgDy8Wq6I0WfCCZA1L8v5iiTaghvvQS0jpuT2ccz0TBQSmwaDVfp5wxnRRRK6T8cEjxJPAnj+rT5tJQ1jiURP3RwZ9u1tJnd2D3nCEELywUirvU4njX37xhF52z7DYuKGx4Qnfkh008+cwPrw71A20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGO2soOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGO2soOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8E3C4CEFB;
	Thu,  4 Dec 2025 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764864898;
	bh=DY3HwalwukNEw7FHv7CwvuRxFen5pupBk1Mw5rj1mhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aGO2soOvROXeDewk/KbkTZqnhE+R3f13XShkZ5Vu8FFFwoNFat4o1QX1sgPRSQwWd
	 NddPljn0OIQ/sbnMlgUU6xv6SawiseSsmL6sTxI9dRq9SkSkN4Dt0bjzUXGHyJXp9e
	 9WNvmKG51KvPklIvbeUoZnYzCZzDvcD4DC6YnTqo=
Date: Thu, 4 Dec 2025 17:14:55 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 6.17 129/146] drm/amdgpu: attach tlb fence to the PTs
 update
Message-ID: <2025120442-statute-finalist-49f9@gregkh>
References: <20251203152346.456176474@linuxfoundation.org>
 <20251203152351.182356193@linuxfoundation.org>
 <725a5847-9653-454e-a6f6-5e689825d64c@amd.com>
 <2025120333-earpiece-dragonfly-457d@gregkh>
 <0db8813c-f740-4890-8e29-f23ab232c393@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0db8813c-f740-4890-8e29-f23ab232c393@amd.com>

On Thu, Dec 04, 2025 at 09:07:32AM +0100, Christian König wrote:
> On 12/3/25 17:24, Greg Kroah-Hartman wrote:
> > On Wed, Dec 03, 2025 at 05:03:11PM +0100, Christian König wrote:
> >> Oh, wait a second, that one should clearly *not* be backported!
> > 
> > Why not, it was explictly asked to be backported:
> > 
> >>> Cc: stable@vger.kernel.org
> > 
> > Did someone add this incorrectly?
> 
> Yes, most likely.
> 
> The patch should be backported to 6.17, but not older kernels.

Ok, I'll go drop it from 6.12.y now, thanks.

greg k-h
