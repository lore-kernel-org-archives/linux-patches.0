Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B842E7BC0;
	Tue, 28 Oct 2025 09:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761642320; cv=none; b=sbNrYxX6XHKDRDJKAPUnnm6Jn3R4ibHedpVsQPICyzPHBupWNGlK4u2eM5oPZjaocqwtuzVv1T08lTYBDwo0QQjEhBuSeONBx5cvzVzDgV+4EwhuyU6eRgVz6JXu0soHrYRM4bksj0kQyUDebatbCST+y1o/yRrkdxgTaqUuwmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761642320; c=relaxed/simple;
	bh=2bDfEv9vTN9I+ahzcVMdIRFkrUamd0EmwFSbHJjVcdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aSy37DoTb9kxankjC1Dtpaj7t8mpU/MMLN49jOtmRbwYoxANu6ABIQXXgIgUVMUEwFf3iABLAGmslcF22w+D3VakajAhNr888+kP59tUBuotXRXKJnRI2DmV2SKp2wdsoL8x7sZCkV9eXgmQ9uajUuJas+kZigW33FG34ojTrzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9DNLOeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9DNLOeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F36C4CEE7;
	Tue, 28 Oct 2025 09:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761642319;
	bh=2bDfEv9vTN9I+ahzcVMdIRFkrUamd0EmwFSbHJjVcdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d9DNLOeO2Ohz76Tw/OAyU7LOYZfTAuxCT1Wydo2gA7z+8zYFieyk0sXuwx34s8kSV
	 4DyUS5eHBqL2qCAXgs4LxaLWd4l9S53bf09uXXbUJsuWW2Gp7ZPAc1JlvpNBfLn6Mu
	 kUGF8lZU038Y90W6QUG2XN4AASAfPImrlvW+zjqg=
Date: Tue, 28 Oct 2025 09:38:28 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 067/332] wifi: ath10k: avoid unnecessary wait for
 service ready message
Message-ID: <2025102817-appraiser-unshackle-bf06@gregkh>
References: <20251027183524.611456697@linuxfoundation.org>
 <20251027183526.385879492@linuxfoundation.org>
 <7f021277-2925-4fd1-a191-c7034d526e37@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f021277-2925-4fd1-a191-c7034d526e37@oss.qualcomm.com>

On Mon, Oct 27, 2025 at 12:01:00PM -0700, Jeff Johnson wrote:
> On 10/27/2025 11:32 AM, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> Same comments as 5.4
> Please do not propagate this. This had adverse effects on some platforms and a
> revert is already in the pipeline:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git/commit/?h=ath-current&id=2469bb6a6af944755a7d7daf66be90f3b8decbf9
> 
> The revert should hopefully land in v6.18-rc4.

Thanks, will go drop this from 5.4.y and 5.10.y

greg k-h
