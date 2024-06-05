Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B042F38DD6;
	Wed,  5 Jun 2024 02:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717554172; cv=none; b=OOusRFpTq4/mnt/bBCKZ5kx/3farF+pbgMu5/uHnPe87VBFNoHfFeFP60dux4SxOjRFlr44VKVpxDP3rlQFzeqBqaWkArS5uO6H2SelRObMuoLoh6csLI4YixMFsjr1bOFAOe8MkzIgiByZKbb59Papn/94/moCWbSWjDxhwQvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717554172; c=relaxed/simple;
	bh=khZkCot2gKSeVhq3dfEpjp594Yffphe1igUiFpwOzTw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=eH1Sztp7iB4ffL+he0Y43wIzapkmez4/oHU6LZI+o1QyX5o1XTiRG3qk5N0I7CltA2d5J1Zkmw3hgin/xRNVo3ZLB4Hc1C0RInxi9Dfxc0pGPy8XhKBIj3BWk4ie9CRCbR+hwTzZJgjObOz2PPS/OQE5+wpAIeELV5iCt6uMDgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fl+hp7r4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fl+hp7r4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B76C2BBFC;
	Wed,  5 Jun 2024 02:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717554172;
	bh=khZkCot2gKSeVhq3dfEpjp594Yffphe1igUiFpwOzTw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fl+hp7r4LJ5V6w1O/o/0cx2HEXGiwyuuHm4itf1t+DZC8yEUJEes6i0ChfBmgG6kV
	 LyP54OFNNlwWaw36NrlIpBO5C4yp3qVuuDjqX9Q2hzljYoxpDcQp/f92KbuUj/hqPH
	 0/8fgFoLwEnQSNn0WNuj+xIwxLcM98yyytIdJEQ4=
Date: Tue, 4 Jun 2024 19:22:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Reinette Chatre <reinette.chatre@intel.com>, Tony Luck
 <tony.luck@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Fenghua Yu <fenghua.yu@intel.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
 <peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
 <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
 <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 0/3] Add and use get_cpu_cacheinfo_level()
Message-Id: <20240604192250.38295ab7ac9c8b01a434153e@linux-foundation.org>
In-Reply-To: <20240603170106.GHZl320tVKXp2HyUfb@fat_crate.local>
References: <20240531195720.232561-1-tony.luck@intel.com>
	<22569491-1b29-4b3d-8e9c-a5d10b73b6ab@intel.com>
	<20240603170106.GHZl320tVKXp2HyUfb@fat_crate.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Jun 2024 19:01:06 +0200 Borislav Petkov <bp@alien8.de> wrote:

> > Could you please provide your guidance on how to achieve a smooth
> > upstream of this work?
> 
> I'd prefer if resctrl patches go only through tip so that there's no
> unnecessary headaches with merging and coordination.

No probs.  If/when patches turn up in a different tree (or get
convincingly nacked) I'll drop the mm.git copy.

I'll drop these now as things appear to be in hand.


