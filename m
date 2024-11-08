Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B081D07A7
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 07:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731050469; cv=none; b=jgp7MfVb+idfYSKvioYzCGXFsyH67vNPcBRwAznAQKJj0vZ594EZoGDzpCmDFRbHmjx3azjflqdoWfmBoxztmFLaZdmfaQXwAym78aZMlNEK3nSeTMqvP3Wv8jOblDG6ocE/71GIUy1DAdE0d7y/GupXNyE9WLaXJ/5yIDfRUSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731050469; c=relaxed/simple;
	bh=23tATNDA+iMUE4C2pCRwp33Op7BC0dmSavYfH4GpOvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WO7JyXljYavd2Z2b93Cjy5R4G+VOdF8mDc31XjFm/LcSYrXU1uUsAVqU4ZZQ9tbBFAq7gnY+8vDBHyQUIOfBf1RXXK3wSyhJtZhSpNbCjAoXIqIFMvGBu+EEo701pxN0pbmMSe3vqj9lGYr9B7rj8k6dZMTsjPr62XW/lvs9cvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Ds08UC5s; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=4dS/fdsr; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Ds08UC5s";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="4dS/fdsr"
Date: Fri, 8 Nov 2024 08:21:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1731050465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e54qp4gQIl1mGHYFjl2FQL12XUiO7bGeMiKlRC5hwdc=;
	b=Ds08UC5swG4xtuE1x9NYUtwyOQxcirN+RT7qR6bOpsPx1l/t6KKPT96pesnGEp4eY4L97E
	jPwiDFDAQhcgxejPwfQEEHBFLlbiC1iRDNBpgQ5UraGrNVFFa5ikvX/9P9eVaHgXgJ81yl
	xkjdnaHf0Y7XSq8HwsXnZZUMivlHA6I8wYSBCktI5vrlwfcgoZsVY0q9RoUZax02jvdE+5
	70B9bEZHVXGO9GdTsZXaQlWNaNs/Un8oY+NAMZ6iKnoZFB6eLVjDBGtVMd/poazRnH1u3l
	Pv6A/AUWUemy4f0RIaYWGQk8GAlUJAEvdRu37yek/xZ985RhAIvhka1A8U5Qfw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1731050465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e54qp4gQIl1mGHYFjl2FQL12XUiO7bGeMiKlRC5hwdc=;
	b=4dS/fdsriADavjlgWWJQBgwFyovBdPTsd9tyXgz2C2c9BYoJfaJ6ABcOA/yy0KD8HLNOrK
	QU/rtgNfbWKoHfDA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Wander Lairson Costa <wander@redhat.com>,
	Yuying Ma <yuma@redhat.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Florian Bezdeka <florian.bezdeka@siemens.com>
Subject: Re: [PATCH 6.11 030/245] igb: Disable threaded IRQ for igb_msix_other
Message-ID: <20241108072104.SfHZzo4P@linutronix.de>
References: <20241106120319.234238499@linuxfoundation.org>
 <20241106120319.970840571@linuxfoundation.org>
 <358ba32f-99f6-4a60-a25f-922a9b2273d2@siemens.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <358ba32f-99f6-4a60-a25f-922a9b2273d2@siemens.com>

On 2024-11-08 08:01:12 [+0100], Jan Kiszka wrote:
> 
> This is scheduled for being reverted upstream [1]. Please drop from all 
> stable queues.

The wheels are in motion
	https://lore.kernel.org/20241106111427.7272-1-wander@redhat.com

> Jan

Sebastian
