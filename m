Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC613A1C7;
	Sat, 27 Apr 2024 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714227875; cv=none; b=jkiaNvMp/At0CwTVJvbiClR7gFNblq4TDueqjM2E6AyaCgr++en+SQObhzF5GsLyrq4wlbi6qJ3d0Lth8q8phWmEG3e78V9YQZLmpwsz9XkVA5bvKUDC40ZMDOAxy4JJO4OZa03DX+4KjnbLvsJH7nYUjtQkp67ETfvgwTB06X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714227875; c=relaxed/simple;
	bh=ZhxxpYQai9D0M6XMQyQj4IkNVBclcRWnRfQ1j/gYhz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=evD/JAfyjzKxB60A7nPO0KatVNqp/YQwJsGpgC6XDjy8H4h+m3N6B26b+xEQl4OIaQdDDxlAMcGvC5JJQXIoDqaCpp+tKvRwiKEy+uBIM1dNSHruc8UPtFTSLTcjrL7hSLdFznKKmO3JLtS27oPKS6LW6o6R5JeKLx+Ds7BT3TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdiIJigI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdiIJigI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D056C113CE;
	Sat, 27 Apr 2024 14:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714227874;
	bh=ZhxxpYQai9D0M6XMQyQj4IkNVBclcRWnRfQ1j/gYhz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PdiIJigI7cdwZhdGEnUzhIfuQwRe0E25jQr4pQyItIxjnOXXPU74jyioKrQdSkDO2
	 jspH4xEf666rDE36yzjbJxcjR6VPxs9AOCcCDcn8G9KBB2WrntD1/ZalQ54+1A/A+l
	 IBXQaWRnZ/YS55O0uVPINEQihzwrC0aSy8FxL5MI=
Date: Sat, 27 Apr 2024 16:24:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Donald Buczek <buczek@molgen.mpg.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>, it+linux@molgen.mpg.de
Subject: Re: [PATCH 5.15 108/476] mm/sparsemem: fix race in accessing
 memory_section->usage
Message-ID: <2024042742--0602@gregkh>
References: <20240221130007.738356493@linuxfoundation.org>
 <20240221130011.965182720@linuxfoundation.org>
 <d3adab65-b962-4530-886a-631f0faf1107@molgen.mpg.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3adab65-b962-4530-886a-631f0faf1107@molgen.mpg.de>

On Thu, Apr 25, 2024 at 04:55:35PM +0200, Donald Buczek wrote:
> Maybe this is already known, but just FYI I wanted to drop the note that for some
> reasons I don't understand, this patch prevents me from compiling the proprietary
> Nvidia Unix driver with versions 510.108.03 and 535.104.05 in the 5.15 series.

For obvious reasons, we do not, and can not, care one bit about closed
source kernel modules or any other sort of kernel code that is outside
of our kernel tree.  The companies involved in doing stuff like this
take full responsibility for keeping their code up to date, all the
while forcing you to be the one that violates the license of the kernel.

In other words, please ask them for support for stuff like this, they
are the ones you are paying money to for support for this type of thing,
and the ones that are putting you at risk of legal issues, and there's
nothing that we could do about it even if we wanted to.

best of luck,

greg k-h
