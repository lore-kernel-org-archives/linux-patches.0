Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F751A681C;
	Fri, 13 Mar 2026 16:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773417622; cv=none; b=UJ4sHvgki9v2jLNaAjYVs/w9/RyIL41SOzmaBqxMWc+T+yrZ59U2jeeH6w60n9Qpk8Aimx/rkUWJruTVjYwQ5jl/SApk2koKQu8XDWXha9gCydKGG3/O06S8jvnXGn2hZGsHoUDDI7+/Y5P3efVj1SDwkPcjmIdMlMo33kzDhso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773417622; c=relaxed/simple;
	bh=9r1DGrN4Wp7k0+2v2j1s4mFgt//Y95/VNdb0DFxmloE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GZpmCgp1ZxkE76e8l2r31VH74e7LKMX9erllqTIKYjXiuladViz32A1k8EvilAXYd7kx3TS7+9AlllwrMJZmmUXYSQd02Yu0l1yo+d5fvHzH4MNCtD8SdiO70uNb2BhpdfG92ZLbB63VCXaWsT2UP42BeUov120KGgDcfxLzNjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxJwZ94l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxJwZ94l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC199C2BC87;
	Fri, 13 Mar 2026 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773417622;
	bh=9r1DGrN4Wp7k0+2v2j1s4mFgt//Y95/VNdb0DFxmloE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OxJwZ94lvqY6ffAp18U3f37OXqw/ZJv/7AfUhQjvm4DwwhE8Fg1HFDoIHGPe8MZTB
	 39W4SzIABGpHNiq8LWEMXBUidy/I8oLoCXde1L6HIEgJts+Y+uJ4lVAviEvgnHw1yj
	 9QglAFS01jhjg0Cx8wdI1zzAhm+vS0B+S8XjnGpY=
Date: Fri, 13 Mar 2026 17:00:18 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aditya Garg <gargaditya08@live.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Kerem Karabay <kekrby@gmail.com>, Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 175/265] HID: multitouch: add device ID for Apple
 Touch Bar
Message-ID: <2026031310-neurology-bring-8342@gregkh>
References: <20260312201018.128816016@linuxfoundation.org>
 <20260312201024.625617672@linuxfoundation.org>
 <MAUPR01MB1154696D5379AECBCD87ED89CB845A@MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MAUPR01MB1154696D5379AECBCD87ED89CB845A@MAUPR01MB11546.INDPRD01.PROD.OUTLOOK.COM>

On Fri, Mar 13, 2026 at 12:27:14AM +0000, Aditya Garg wrote:
> This patch is not needed to be applied to 6.12 as necessary drivers for the touchbar to work are starting from 6.15.

Now dropped, thanks.

greg k-h
