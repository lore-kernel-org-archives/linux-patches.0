Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358242D030;
	Wed, 24 Jul 2024 13:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721828884; cv=none; b=R/Y0B753FjFhiTs5xMw0yRksP4CkUhk5eCOrnEFJ7I90414ZAlcTmGQZifDnfLcwcqQM03qzueahgHoXg7g1oaqcgo4Xwb2/m5w1I04OswvOuaQUj3PPL8l5tNZOJSGicFod2JWvNEOlvRAOobcdQdaGKI4YxdTUUL9wr3ow5e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721828884; c=relaxed/simple;
	bh=zmdRnDgJrO3hj8CxshSw4lN9+dlK9Emt72yfKnZ6qSk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oJ/rxZQ49t+DA4RFL8SociBu0BBs34TRhH1VoMUgyeVFG/U+LtEzfhJjNpaVLKxEaerTZj9d8ZTeOP0oZW2x5KjkX7DbYXyZ2LGnihlm/hKBIAHCbWSYxw52HRSWwqS/Q99UHo5AyihlDw9OpWJFCLnxfQL1+pXiYVnriabuHcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bt/qQ44R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bt/qQ44R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814CFC32781;
	Wed, 24 Jul 2024 13:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721828883;
	bh=zmdRnDgJrO3hj8CxshSw4lN9+dlK9Emt72yfKnZ6qSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bt/qQ44RGpx0by+Pcu6eU50pMJZuszQ/jaZlU1ym/+Q08CENmMGiBxtkNeHqnkQ2B
	 ylFX/fwbIgj7DZedyumsCEqGbgsOIxIZjJVHR1hcpQAbDrBxE1Gsd22FGhVENuub+S
	 gyKTZbPn89066dBxEgLA3Tm2UsZhdiZ23N62/nzE=
Date: Wed, 24 Jul 2024 15:48:00 +0200
From: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
To: Simon Trimmer <simont@opensource.cirrus.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	'Takashi Iwai' <tiwai@suse.de>, 'Sasha Levin' <sashal@kernel.org>
Subject: Re: [PATCH 6.9 083/163] ALSA: hda: cs35l56: Select
 SERIAL_MULTI_INSTANTIATE
Message-ID: <2024072444-regulator-audible-4fe5@gregkh>
References: <20240723180143.461739294@linuxfoundation.org>
 <20240723180146.679529179@linuxfoundation.org>
 <000001daddac$e3525c70$a9f71550$@opensource.cirrus.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001daddac$e3525c70$a9f71550$@opensource.cirrus.com>

On Wed, Jul 24, 2024 at 10:35:57AM +0100, Simon Trimmer wrote:
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Tuesday, July 23, 2024 7:24 PM
> > To: stable@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > patches@lists.linux.dev; Simon Trimmer <simont@opensource.cirrus.com>;
> > Takashi Iwai <tiwai@suse.de>; Sasha Levin <sashal@kernel.org>
> > Subject: [PATCH 6.9 083/163] ALSA: hda: cs35l56: Select
> > SERIAL_MULTI_INSTANTIATE
> > 
> > 6.9-stable review patch.  If anyone has any objections, please let me
> know.
> 
> Hi Greg,
> Takashi made a corrective patch to this as there were some build problems -
> https://lore.kernel.org/all/20240621073915.19576-1-tiwai@suse.de/

Thanks, but that's already in this series, so all should be ok, right?

greg k-h
