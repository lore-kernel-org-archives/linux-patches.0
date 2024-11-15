Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739972B9B7;
	Fri, 15 Nov 2024 08:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731659327; cv=none; b=qc9t65L5yS/VBk3zzgGpkkFCTdBr68hr2JyXl0vRqTuvr0y8A1bRPzzeOOb8huCOyPbaA9QTtg1kz52dqNX0V8uZjqW3Be9/oB8oS82JKawd14M9eSvQVZh6uP03gauOT2VF7YuQd6nnEettauLDl6wiIrt+IcP3/tZH1riwk3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731659327; c=relaxed/simple;
	bh=UBcYi9Cvt3kn9l4SJ9MgYJD51gDlG3rba00d44agRBY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slPRaxUuFPwpTmIZ90liw/hFgOYojFYZprX4ZENfT4UbwZJlEUMvasr7J85pJF2I1fTnjlq+WsFxvSBctSYDJv/nSGSXM0TuGTFN1O93gAnpx24hMk92PUryY6oqe/pYLxd9KrUAPa96rUJSifv01clIHN7Lxcpu8A3jGM+Mm8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1W+gRBa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1W+gRBa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A050CC4CECF;
	Fri, 15 Nov 2024 08:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731659327;
	bh=UBcYi9Cvt3kn9l4SJ9MgYJD51gDlG3rba00d44agRBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1W+gRBa++wPAI+b3QT5zqutxK5uAuWVL8Mptpwq3s/UuxYtNg5pt0jq29NEnZgGnJ
	 gcI38oJjmh3K1rjM3DhHrx27RgREphCNlbzyW2QRy5SvOjxDb0DsIWsafs0i+ZBU+Y
	 kC2iBOKbS/OMSieoK9WtyR/q+NPgeER3uxgunuxw=
Date: Fri, 15 Nov 2024 09:28:24 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	WANG Wenhu <wenhu.wang@vivo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5.4 62/66] mm: clarify a confusing comment for
 remap_pfn_range()
Message-ID: <2024111556-exterior-catapult-9306@gregkh>
References: <20241115063722.834793938@linuxfoundation.org>
 <20241115063725.079065062@linuxfoundation.org>
 <4537b145-3026-4203-8cc4-6a4a063f4d96@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4537b145-3026-4203-8cc4-6a4a063f4d96@oracle.com>

On Fri, Nov 15, 2024 at 12:30:47PM +0530, Harshvardhan Jha wrote:
> Hi Greg,
> 
> The patch series is fine but I missed one final patch of the patch
> series. I'd like to send a v2 if it's possible. The series is missing
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=35770ca6180caa24a2b258c99a87bd437a1ee10f
> unfortunately which is the fix itself. These patches were required to
> get a clean pick when backporting this patch but I forgot to send the
> final patch itself. Sorry for the inconvenience caused.

So can I just cherry-pick that one commit now?  Or just send it on and I
can add it to the end of this series and do a -rc2 with it, which ever
works.

thanks,

greg k-h
