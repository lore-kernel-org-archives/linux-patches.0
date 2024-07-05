Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4110717995;
	Fri,  5 Jul 2024 06:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161493; cv=none; b=aMjL2v2x9+Du5MUeVwXhPONRZ69ISv7wNNhmVCCQFZ3eDzLYQzofIGfU2QBsWbYAsfKdly0KpoK4tzv4c8hEUkD6l4WuqE4PzroiY0SoEvXvbRtSfCw9DutzelqudZymvkLvEuo4OW0oIQ6psDlV52BWzhmGMawgo5RxdPjXepM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161493; c=relaxed/simple;
	bh=gWB8I+3VaK+hcGoZg6KfqMJDzECaoRSGgxR6y2SRpnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VoBPAktxwWBlQNM8vESPRhPvgwZSHMbGWyC2F1Rr5Mbbyd+zGz1PeGT7y3h8EimFLKtvbt5nvNG3xkErkdMgZRPZdMPEpvS2kS+6Gy3FKYCu/v6H+HiV7ffrea5W6onTuVI9lYlPv6Z/xuWZBjabTISJ5Mnabocb6B94hYUfXGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1dnZj18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1dnZj18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A73C116B1;
	Fri,  5 Jul 2024 06:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720161492;
	bh=gWB8I+3VaK+hcGoZg6KfqMJDzECaoRSGgxR6y2SRpnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q1dnZj18Qtly5hqJS7/HTFJCwGEr7d3VzgvQ1E0bpLivWk5KHOox9gLpeB56Pkrc8
	 URUyrOG11/0vQBr3nBl6hDfybxYtoxSiaKikUx0TBdfKE+EZym5FYGoWOlkEH2adO2
	 ME/Z1/4qHTvjcYfdP80BwmCAjxdzL0brsajkIIp4=
Date: Fri, 5 Jul 2024 08:38:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 093/139] scsi: mpt3sas: Add ioc_<level> logging
 macros
Message-ID: <2024070526-size-untaxed-dc0e@gregkh>
References: <20240703102830.432293640@linuxfoundation.org>
 <20240703102833.952003952@linuxfoundation.org>
 <f054ce9050f20e99afbed174c07f67efc61ef906.camel@perches.com>
 <2024070449-tarantula-unwieldy-9b51@gregkh>
 <0e3bf011f0b402f7913164deacd964f02db8ec7d.camel@perches.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e3bf011f0b402f7913164deacd964f02db8ec7d.camel@perches.com>

On Thu, Jul 04, 2024 at 02:23:40PM -0700, Joe Perches wrote:
> On Thu, 2024-07-04 at 11:38 +0200, Greg Kroah-Hartman wrote:
> > On Wed, Jul 03, 2024 at 04:10:43AM -0700, Joe Perches wrote:
> > > On Wed, 2024-07-03 at 12:39 +0200, Greg Kroah-Hartman wrote:
> > > > 4.19-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > Still think this isn't necessary.
> > > 
> > > see: https://lore.kernel.org/stable/Zn25eTIrGAKneEm_@sashalap/
> > 
> > It's needed due to commit ffedeae1fa54 ("scsi: mpt3sas: Gracefully
> > handle online firmware update") which is in this series and uses the
> > io_info() macro.
> 
> Swell, but the dependency chain is not correct
> 
> The patch says:
> 
> > Stable-dep-of: 4254dfeda82f ("scsi: mpt3sas: Avoid test/set_bit() operating in non-allocated memory")

That is correct as this is the commit we are trying to get merged, and
so it takes a number of different ones, in sequence, for that to happen,
including this one.

thanks,

greg k-h
