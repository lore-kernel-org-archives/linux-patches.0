Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B4117583;
	Thu, 22 Feb 2024 08:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708590808; cv=none; b=LJTeaU1s0hjabLoqD2eSOmdSry7CVFJHLoet2rWEapYSqaDlOxqDI704SgPCYq6isHGfiTVZQlgd/WYRiCCkzCzBZoeZJoWiUHzXe05jihax0v+6CSbaRRfAau4zhq4QE5uGMxjWaqA3D81KTJiV+rVWlby2y4hdKGJRXBQxY0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708590808; c=relaxed/simple;
	bh=3cRB/wiw5sSUbtayguqoIl+VUtblANuWlPvFvvGVKIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DEBMJSqV4KWsI9KOsPIWnAKy/dwS0p7iyCxpfCvhBnUwIeccLXZ6HS7GZeIp01iRzKFkW2syDE/3rwhYO2dr9lVWm7d8ISX11GPzodn9iYFZWoazZWPCb17L9s21uhgmFQ1ZJxODYwIgKCytKlmD+GVxgrLgBzGAkQVRvpNT02E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5AUg+yB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5AUg+yB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8213C433C7;
	Thu, 22 Feb 2024 08:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708590807;
	bh=3cRB/wiw5sSUbtayguqoIl+VUtblANuWlPvFvvGVKIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R5AUg+yB7F8ZHdPUI6WHjvX5V/JmSIC3mFSkW2q/hgtLHIaEYIGbNKJA8+Lwq4rwh
	 aQLgpgqJK7nhdiRxo91MS+ACjBuiVurCbCpPC1AbAjqX+/LrPotaFmQvU1NFRgFMNN
	 q6sTRPgKbhW8VSfvV4feJ65U4sOEYP3mEaqkoBXA=
Date: Thu, 22 Feb 2024 09:33:24 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
	Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 427/476] mwifiex: Select firmware based on strapping
Message-ID: <2024022209-gray-skinhead-30d9@gregkh>
References: <20240221130007.738356493@linuxfoundation.org>
 <20240221130023.815110111@linuxfoundation.org>
 <mylyn55f4ao6ri542viscz6sybvhlsjcfzgg5amroj5ggv7abf@gqstvogzkyce>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <mylyn55f4ao6ri542viscz6sybvhlsjcfzgg5amroj5ggv7abf@gqstvogzkyce>

On Wed, Feb 21, 2024 at 02:17:48PM +0000, Alvin Šipraga wrote:
> Hi Greg,
> 
> On Wed, Feb 21, 2024 at 02:07:58PM +0100, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> - [PATCH 5.15 427/476] mwifiex: Select firmware based on strapping Greg Kroah-Hartman
> - [PATCH 5.15 428/476] wifi: mwifiex: Support SD8978 chipset Greg Kroah-Hartman
> 
> Both of the above are marked as stable-deps of this one:
> 
> - [PATCH 5.15 429/476] wifi: mwifiex: add extra delay for firmware ready Greg Kroah-Hartman
> 
> but they are not at all relevant, so I think patches 427 and 428 should
> be dropped.

But if they are dropped, then this commit does not apply!  Which is why
they were added.

> But patch 429 is OK for stable as long as 431 is included:
> 
> - [PATCH 5.15 431/476] wifi: mwifiex: fix uninitialized firmware_stat Greg Kroah-Hartman

I'll just drop all of these and if you think they should be applied,
I'll take some working backports please.

thanks,

greg k-h
