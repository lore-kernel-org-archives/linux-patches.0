Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFDC17DE36;
	Wed,  9 Oct 2024 08:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728461153; cv=none; b=YepjjPiPTX7YGRG6Nc9GEx3coJlUbWOh3cKs0xZtW+Ra2EChS3ByGzaKd3Yx1oQJHlthRArDXyhGq0qv942HalZlDzDKALernGhsGZsL2EWDVGKFMiWtfrGG0ofJ8H6m8LRn0KkI1vYV232mvNbKur05zqWpotg+wCBVRXec4lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728461153; c=relaxed/simple;
	bh=h3QKfQI/p/XCORuCz6TddGpGcJEKpDOursIbsP2K85M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OOlNq4hHvJEJCbyzD3XCGqhb6y40KL3CqoiPUxZs0MbZ3ZOvNm/PxB8/X4dvD8U9oGrLQvHgAab0VEzagJHGYYtdGyzQBPT5zl/ywiWAa5z/ieXoj8KAiJwvEWJ8Qausu+6EYdE5tXgn4LWWUEnSeN4ji2INVIjIHD/MSuxe9c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boEYMET2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boEYMET2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16045C4CEC5;
	Wed,  9 Oct 2024 08:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728461152;
	bh=h3QKfQI/p/XCORuCz6TddGpGcJEKpDOursIbsP2K85M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=boEYMET2gXhWWV4AeUo9BM2yh0tna9tEkAowivUt5qbNI59XngvkM26I2ueKr2y7M
	 lvMBTOCiu7ozvt2FuIaGNjKssn1oOIJ3FF+FhoLVcLx1NXQaXW04JoI/JeBJhf5sI8
	 f0rvjB5HDNOsa+BUZP1Tt1tHMO4vP/4UN4tKvqSI=
Date: Wed, 9 Oct 2024 10:05:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karol Kosik <k.kosik@outlook.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.11 168/558] ALSA: usb-audio: Support multiple control
 interfaces
Message-ID: <2024100940-matrix-showdown-4bdb@gregkh>
References: <20241008115702.214071228@linuxfoundation.org>
 <20241008115708.966425966@linuxfoundation.org>
 <AS8P190MB1285D7871E746D824330F1C4EC7F2@AS8P190MB1285.EURP190.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS8P190MB1285D7871E746D824330F1C4EC7F2@AS8P190MB1285.EURP190.PROD.OUTLOOK.COM>

On Wed, Oct 09, 2024 at 12:35:28AM -0700, Karol Kosik wrote:
> 
> 
> On 10/8/24 05:03, Greg Kroah-Hartman wrote:
> > 6.11-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Karol Kosik <k.kosik@outlook.com>
> > 
> > [ Upstream commit 6aa8700150f7dc62f60b4cf5b1624e2e3d9ed78e ]
> > 
> > Registering Numark Party Mix II fails with error 'bogus bTerminalLink 1'.
> > The problem stems from the driver not being able to find input/output
> > terminals required to configure audio streaming. The information about
> > those terminals is stored in AudioControl Interface. Numark device
> > contains 2 AudioControl Interfaces and the driver checks only one of them.
> 
> Please postpone (or skip) merging my patch to 6.11 due to regression.
> 
> I've just learned that my change causes kernel crash when Apple USB-C
> headphones are connected and confirmed it's related to my change.
> 
> TL;DR: The general idea is correct, but I missed one variable initialization
> when specific USB 3.0 audio device connects, as none of the devices I tested
> were relying on it.
> 
> I'm sorry for the disruption caused by this commit. One line fix will be sent
> for review tomorrow after I re-run all tests, and I aim to get it into 6.12-rc3.

Ok, now dropped from all stable queues.

greg k-h
