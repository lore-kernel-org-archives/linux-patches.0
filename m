Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F7818CC08;
	Fri, 15 Nov 2024 09:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731662491; cv=none; b=R7re1ML6NF/kPQzDPyetxalLyRQSkW/i5vulRCbkZT88AuPx+Hw/HqLwudDUQYiceP8Yp5dDU+umiB/qPIZforaCWVLwwqN7vXJtCJUxZfywX3h04idJcB6dxsQEXDTT9tBfyYoFAh3ADbQU42Wm10jq9kgtmMDIa+CsPfXmoAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731662491; c=relaxed/simple;
	bh=fM8DCchYLsuUoA7lty4iGTtXrehOpHFvbvcxOtHI6vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GSzhyyGJnClEpCCgiiEROZsvpYOyFixajcNU0sbisK6wOtSCNvdqLazLGkPqAyrVDrSQRQ0BemmjptXyYkkDnigXjtOhbVjdVVTlR6J1HnSahxJXdYAicvB9KwGce3K58Z8UczNWuZzKFquuE54LuHDs46XbkPEOmRkPb1YVGmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHTO5tZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHTO5tZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7350C4CECF;
	Fri, 15 Nov 2024 09:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731662491;
	bh=fM8DCchYLsuUoA7lty4iGTtXrehOpHFvbvcxOtHI6vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tHTO5tZMV9aTRFr3Tp8w3CASGzmLFJh2A5pAjWy+zsJSd4ngzvT+ukcYwH+Vz8jBK
	 u06JpjoflXAl2/AoNFaW0N9APiPxReh8S7bc6E0E3hQ+YW08wMp1R0tdH+zuyAVT/U
	 KI8hxlJ4BR3ELnSq1fcZlFmbWsysDhT1SkM0pUGI=
Date: Fri, 15 Nov 2024 10:21:28 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	WANG Wenhu <wenhu.wang@vivo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5.4 62/66] mm: clarify a confusing comment for
 remap_pfn_range()
Message-ID: <2024111515-follow-falcon-ba9b@gregkh>
References: <20241115063722.834793938@linuxfoundation.org>
 <20241115063725.079065062@linuxfoundation.org>
 <4537b145-3026-4203-8cc4-6a4a063f4d96@oracle.com>
 <2024111556-exterior-catapult-9306@gregkh>
 <003c7218-ba88-4457-9175-b6901318bc1c@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003c7218-ba88-4457-9175-b6901318bc1c@oracle.com>

On Fri, Nov 15, 2024 at 02:03:36PM +0530, Harshvardhan Jha wrote:
> 
> On 15/11/24 1:58 PM, Greg Kroah-Hartman wrote:
> > On Fri, Nov 15, 2024 at 12:30:47PM +0530, Harshvardhan Jha wrote:
> >> Hi Greg,
> >>
> >> The patch series is fine but I missed one final patch of the patch
> >> series. I'd like to send a v2 if it's possible. The series is missing
> >> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=35770ca6180caa24a2b258c99a87bd437a1ee10f__;!!ACWV5N9M2RV99hQ!Jjv9Q-SraAFRWb-CchHiy6wbnrShMziEurtSW12w68rZFsd5FNRhQcNyXIoCxB3oCw2J7dFCD3VnmB-poyn9n9xKb-xjvg$ 
> >> unfortunately which is the fix itself. These patches were required to
> >> get a clean pick when backporting this patch but I forgot to send the
> >> final patch itself. Sorry for the inconvenience caused.
> > So can I just cherry-pick that one commit now?  Or just send it on and I
> > can add it to the end of this series and do a -rc2 with it, which ever
> > works.
> 
> Whatever you feel should be the easiest way forward. I have a v2 for the
> entire series ready. I could send the entire series or simply just the
> patch to you and you can add to the end of the series. Please let me
> know whatever is fine by you.

I just grabbed it, no need to resend anything.

thanks,

greg k-h
