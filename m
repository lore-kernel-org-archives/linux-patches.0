Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2264D3B2FF8;
	Fri, 17 Jul 2026 06:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271192; cv=none; b=TKl87W1y0+wEpcsO5xW1ISZxJVgcV8to587GN1q3Y6enAQgtvLQUtEc8wO937ykZ3OaHK5CJKysxIh8Vm7ARDRgsGUObNkgsppXyNt+qhG+41txUsQ4xPsvUNMLiyeSaBdOMuvb68b1ush+svLMRQeHcNRSgMWGCx4G9rrGIhTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271192; c=relaxed/simple;
	bh=DEeUGkPwHTGpV0fjzPXj9aLIGJHB3aWvj3gdjRvI1Rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UzdKIRmJsNapZnCsEazjMSJqD8S1YQDIslkgRiBiRgms2Z4N+xLKaRZCbu6E/E2DHZGx8xmxnn6JffEVFiFbwdsJe1M6A4mnKU0Qy3+p+jgBS2RhfmNucuaDqJHSCuay64h7XxrXqiPaSMZzeerTc3eJfQ4y/Cl7zszxDlZOrnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wy38+JtE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wy38+JtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AED1F000E9;
	Fri, 17 Jul 2026 06:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784271190;
	bh=CuB1tVLbHxuXY7AT9F/TC+R0pRQO7FI/bBBqBYrLuz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wy38+JtEwsxh+2Vlql5DMY9zapHupBIHU5Ix5XX+YhDbOjtSsP9wE5ct42lyMDFTI
	 eY/IAFJpdnL5lW5BdrVeEWrihPeqJssSzWetvlkBl7DuxHdRMlgw9ijyD25Yq3eLYZ
	 Ls0JARzotfVQ2XEeW86onAAxb/unltev40k9sxa0=
Date: Fri, 17 Jul 2026 08:53:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 7.1 153/518] smb: client: restrict implied bcc[0]
 exemption to responses without data area
Message-ID: <2026071745-kindly-everybody-c37b@gregkh>
References: <20260716133047.772246337@linuxfoundation.org>
 <20260716133051.194668994@linuxfoundation.org>
 <d97f8874-9281-4e33-abea-1a1df695fc0a@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d97f8874-9281-4e33-abea-1a1df695fc0a@kernel.org>

On Fri, Jul 17, 2026 at 08:34:07AM +0200, Jiri Slaby wrote:
> On 16. 07. 26, 15:27, Greg Kroah-Hartman wrote:
> > 7.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>
> > 
> > commit 53b7c271f06be4dd5cfc8c6ef552a8355c891a7f upstream.
> 
> Note there is a fix for this upstream:
> 8986c932905e smb: client: reject overlapping data areas in SMB2 responses

Thanks for the hint, this hadn't shown up in a release yet so I hadn't
noticed it.  I've grabbed it now.

greg k-h
