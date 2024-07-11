Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F3584DE9;
	Thu, 11 Jul 2024 09:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720690544; cv=none; b=qlKFQuejueMomtTL2CQtpicUE7kNnUuojq7gFBK6MQfmJDKAa8jb+eubgqwumAiU8FeOduQc3wSX89F7J6zsctqL3SQXP4NeBAbnZd+kwFQgZwP9UQLl/j4RQl3yjw92/fE/js7tfwcqlrcb8BYZH0zfduPMxYzcZP/peFQbS5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720690544; c=relaxed/simple;
	bh=HeF1FWhP69kv9E1fMuc4FOLNyLItrBAvpmRXN57Uaho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L0Ug000ALwblaWKz5X41LZNNNybP1vDtnvkotkUVTvR4o+XJGcL9erMdgyIOx62F9WyWB0MNxMAHWE0e/hjROVBWvVz3/Y8bcyXk+bKxvaX2A9J8oOCWMudUddJd/C6QScVEh7OkU66bjhJ4FXj3tRysjmymoAocq0JM7A9TyV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UknATB7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UknATB7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCF5C116B1;
	Thu, 11 Jul 2024 09:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720690544;
	bh=HeF1FWhP69kv9E1fMuc4FOLNyLItrBAvpmRXN57Uaho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UknATB7w78ctXY/P8OTLsLo9lXZZBQ3gpL/2tS3iqkwSfQhJCxZbjwvdLfqA4OhVJ
	 CbR7P+o/sKA6/wTMUs7jSu6F6mSKGyer1K4ajK08cMjx1aw+2ELReaHPyRbBp1v+E2
	 /w33jK3NTWJEYzxiJzdnk0wQY178bWNFrU+7n+bg=
Date: Thu, 11 Jul 2024 11:35:41 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.9 057/197] powerpc/dexcr: Track the DEXCR per-process
Message-ID: <2024071133-jaws-customs-79ce@gregkh>
References: <20240709110708.903245467@linuxfoundation.org>
 <20240709110711.171129088@linuxfoundation.org>
 <87v81e6993.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v81e6993.fsf@mail.lhotse>

On Tue, Jul 09, 2024 at 10:27:20PM +1000, Michael Ellerman wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > 6.9-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Benjamin Gray <bgray@linux.ibm.com>
> >
> > [ Upstream commit 75171f06c4507c3b6b5a69d793879fb20d108bb1 ]
> >
> > Add capability to make the DEXCR act as a per-process SPR.
> >
> > We do not yet have an interface for changing the values per task. We
> > also expect the kernel to use a single DEXCR value across all tasks
> > while in privileged state, so there is no need to synchronize after
> > changing it (the userspace aspects will synchronize upon returning to
> > userspace).
> >
> > Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > Link: https://msgid.link/20240417112325.728010-3-bgray@linux.ibm.com
> > Stable-dep-of: bbd99922d0f4 ("powerpc/dexcr: Reset DEXCR value across exec")
> 
> This is listed as a dep, but I don't see that commit (bbd99922d0f4)
> queued up?
> 
> This series included user-visible changes including new prctls, it
> shouldn't be backported piecemeal.
> 
> I think this series shouldn't be backported unless someone explicitly
> wants it.

Thanks for the review, now removed.

greg k-h
