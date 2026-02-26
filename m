Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B6F36EA93;
	Thu, 26 Feb 2026 14:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772116486; cv=none; b=CyHn9QUR7ULBHWTd3unSW+MBEK1QyKmojk6VVYEi7FLSHsSq+y8l88rhNGFE0STxd9Izbgqi6Hq0N80qpqQYU8T8JKEffdISvQ+afqIdOK+x66aNi5quCTDfszSog30hf7tFQCs2m6uHLxQQjVftdo7V4oNrWBTkjlpUYrHNAqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772116486; c=relaxed/simple;
	bh=T/crL0LfDiKdTYndOewz3cqteqv7pFC6DWl7pd7orOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kezSpHeWGwVMrt0b8Cbha1F/DrXTvItD0FU1v3d3Gv+bpMnNsnH5Tr+u/K2Aw8XDSvFACArp7gdDO2sC6yzaRLcP0hze6i/KgI2Fjvdj6+RlOwLt9vgyZaOaVXnfttTgPLx5us6A2ViDokUi4vNZrz+gCamibqVww0juBhA6e5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grTwbtZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grTwbtZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8C5C116C6;
	Thu, 26 Feb 2026 14:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772116486;
	bh=T/crL0LfDiKdTYndOewz3cqteqv7pFC6DWl7pd7orOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=grTwbtZrIP8acC9MtaVeIfCEmaIDGh0XJEjwUORdtY1rdZ+eNTo9znf94Xy0dwKrm
	 twVeyI5y1DDI0oDtB/8olsHZA2M96iUheDt7rqEJpDNfQxP9UC3RTrqcrDkVkv9Ps2
	 f/1loIHWRDdaz3NGrFFng7lbCnSQFucGOinLS4FM=
Date: Thu, 26 Feb 2026 06:34:37 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 6.19 767/781] ata: libata-scsi: avoid Non-NCQ command
 starvation
Message-ID: <2026022641-enzyme-atonable-ae2b@gregkh>
References: <20260225012359.695468795@linuxfoundation.org>
 <20260225012418.528826275@linuxfoundation.org>
 <4bbeb69d-698f-4fe7-86d0-67c6f7e2ebdf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bbeb69d-698f-4fe7-86d0-67c6f7e2ebdf@kernel.org>

On Thu, Feb 26, 2026 at 08:45:23AM +0100, Jiri Slaby wrote:
> On 25. 02. 26, 2:24, Greg Kroah-Hartman wrote:
> > 6.19-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Damien Le Moal <dlemoal@kernel.org>
> > 
> > commit 0ea84089dbf62a92dc7889c79e6b18fc89260808 upstream.
> 
> Hi, this one is broken and needs (very fresh) fixes according to our
> tooling:
> 
> eddb98ad9364 ata: libata-eh: correctly handle deferred qc timeouts
> 55db00992663 ata: libata-core: fix cancellation of a port deferred qc work

Ah, good catch.  My tooling doesn't catch "fresh" stuff like this very
well, I need to revisit that and dig in Linus's and linux-next better
for this type of thing.

Now all queued up, thanks!

greg k-h
