Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6181DA21;
	Fri, 18 Apr 2025 04:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744951722; cv=none; b=YNBd28xOWOI9YydVRSA5XKrGkyuDqtHEn/DFfarc60dteIBuUdTUur3jJmoEtFhLFFTtsBMQZ/pKrD0eq7fkiZ0t3iGzEauGsCD8gj8rECagXa4vvX4YYPB1yukkLV9kx92LNuc3k6a1JwfOWkH85dkg3Al8tedY2seUj55mJU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744951722; c=relaxed/simple;
	bh=Htlt5EWucHY26lNLwaoPzdYmE0EL7kJ8YEtF5BB0QSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHjGGUtfzroOKUf3HNAKjlKB21fBQBVwJSUsHRZ8Sz8BbLx3GP1RVMWW3YbVU0Og/1upiTfvPA3/SILUOSXKAt1BmRyYlqXuLosgq4DHF+iEnrrJOmPVd7ZiHrn5GtLXg+StFUNcYv1m6O22TFjPrV5SCOhk3kbHkJ6Arq1p3zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFZoi4P7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFZoi4P7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A3CC4CEE2;
	Fri, 18 Apr 2025 04:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744951720;
	bh=Htlt5EWucHY26lNLwaoPzdYmE0EL7kJ8YEtF5BB0QSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oFZoi4P70selAbxRFUsfoWF1RmFJbc1iPax9mLm70fyCM8SOPIAlzkQu1pzys8fJJ
	 hvAxaWU1/i0dN3PJOXYdK4Mgp9C2vi73qDGNljvx/nrGztPY4oG47G7+7XrC5Uh4Q3
	 AWVNHuYPOCBc5ucop1q6cIsMO2Bqj3B5klBeKy/E=
Date: Fri, 18 Apr 2025 06:47:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jules Noirant <jules.noirant@orange.fr>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tomasz =?utf-8?Q?Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?utf-8?B?TWljaGHFgiBLb3BlxIc=?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?iso-8859-1?Q?Crist=F3ferson?= Bueno <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 197/449] HID: pidff: Stop all effects before
 enabling actuators
Message-ID: <2025041849-eggshell-squishier-c14b@gregkh>
References: <20250417175117.964400335@linuxfoundation.org>
 <20250417175125.905571035@linuxfoundation.org>
 <763f6566-9806-4e09-a633-b27fe1767f38@orange.fr>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <763f6566-9806-4e09-a633-b27fe1767f38@orange.fr>

On Thu, Apr 17, 2025 at 08:47:05PM +0200, Jules Noirant wrote:
> Hi,
> 
> Thanks for the review. Technically, that patch should at least be Co-authored by me since it's a slightly reworded rebase of a patch I submitted last year: https://lore.kernel.org/lkml/20240304195745.10195-1-jules.noirant@orange.fr/t/

This is just a copy of what went into Linus's tree, sorry.

greg k-h
