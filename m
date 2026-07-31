Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B5D3FC5C3;
	Fri, 31 Jul 2026 14:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508175; cv=none; b=ECj8Vcv23Hzz+IHLQgwP5oBoChmiO9Py5c1WjcpaDCDbs5fkhrAE98Df1//G3bI3r/QFO5g81Sw5dt9u/xqfeHZ8mdT+K6Gl2pEeTWI6BSbWXJBRz7AoW59b9nFQz4m9D4zjboPcWfgJy1OFVVG2NVaeMCakNOCVx6mEcoXj9dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508175; c=relaxed/simple;
	bh=Yw3B7wU+czQKESZw8G426fhQMOKfXdB7fPCV5Zla/A0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vCEyoL7EpRASs3X1FFghOdO2i1PCWuTA5ASK56tsz2l+SXCeLZui0SKNBGsxpPxqE34gajFKmrHBY9R9BOOFJvtjanvS/UTSOoW4+VfdSx1EHq7U27tYQZk9aRuUS35ieT0HwEnw9l2j412srq6zHqdWQ4Zdhbv0HtRMIyLImZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6fRUHbr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6fRUHbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44DD1F000E9;
	Fri, 31 Jul 2026 14:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785508173;
	bh=kgiUawpvI1W98n0hQkUrW2O/OCGSUY9AN3W101wRDjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j6fRUHbrjOsitbZO0c1V/coq30F4PLsOeekI3EVMkekHldQiEkTFs/G6rIW2HrMQM
	 mA4tBAaje258e3RdLEJ1A0TFxgnOnxm2xHs1UzPsXhZcP1GCo1MgFx3d7MYlBMsyhK
	 Xd91Zq7RN7H9ur+p83M6cNHNwqejaVrumhkwKpHcZP+6eZj0+TIMMhg/PEKlXs35PB
	 Vmq8vZ2s70y44IEi9fhlUdgF4S/VelQqmDQG0VdHHYn2oWjt6698V5UzAVivUxlnZ3
	 IeRzt1IsYTbKkiqW0n3vTq6u5MwIShae8O9OGopzi4qTw3hNlPvz2bnimn1RpeTAue
	 vfTUhCUn1SsNQ==
Received: from johan by xi.lan with local (Exim 4.99.4)
	(envelope-from <johan@kernel.org>)
	id 1wpoEt-00000000X3D-1hOG;
	Fri, 31 Jul 2026 16:29:31 +0200
Date: Fri, 31 Jul 2026 16:29:31 +0200
From: Johan Hovold <johan@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Wentao Guan <guanwentao@uniontech.com>, patches@lists.linux.dev,
	stable@vger.kernel.org, ulf.hansson@linaro.org,
	zhoubinbin@loongson.cn
Subject: Re: [PATCH 6.6 456/484] mmc: vub300: fix use-after-free on disconnect
Message-ID: <amyxS1dyw49Rvsha@hovoldconsulting.com>
References: <20260730141433.390818444@linuxfoundation.org>
 <20260731033117.506282-1-guanwentao@uniontech.com>
 <2026073134-vindicate-kissable-e3e6@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026073134-vindicate-kissable-e3e6@gregkh>

On Fri, Jul 31, 2026 at 08:51:45AM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 31, 2026 at 11:31:17AM +0800, Wentao Guan wrote:
> > Hello,
> > 
> > The backport is wrong and not as is discribe in the title.
> > It just renames the goto and I don`t know what the backport fix not in the tree
> > for 'git log v6.6.147 --grep="mmc: vub300: Use devm_mmc_alloc_host() helper"'
> > not found it fixes for, so I see just drop the patch.
> 
> Odd, yeah, let me go drop this one, good catch.  something went wrong on
> my side...  I'll also drop it from the other queues.

Yeah, this fixes a commit in 6.17 so shouldn't be backported further
than that (unless that commit somehow ended up being backported as a
dependency somewhere...).

Johan
