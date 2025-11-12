Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E19A2D29AC;
	Wed, 12 Nov 2025 11:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762945260; cv=none; b=gORGtUQPVQ8HcNR1fiqaX+/X1IazVhJX1Ogrp9Ggn5Nb2yjDG0DcDA8S8sjFglSfmtgYx5F6zG4M0VB3wGLF0IoR6MEfYgy4zhhMlJHWbmVr3xBBOS5e7/wTBkaV5eVOTAf1+Scb9Uta0GLW5lWctPEuwmZYTXlYPOT4bHnbI6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762945260; c=relaxed/simple;
	bh=waDhuLi7iiTBrtHmfrhYgknk3A+dtVSlg4CbuYM6l2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRmUHSUDPzVNzeiGsX642wB516O+VgBRFVBKEPgGt8NFICM9GELWcqFXM2Nd+rCtcRiEXWVULHWsghNg7V2mPpjaCfIcFbPFsbeYBlv+Eua2DPDnpvRjXuzwHcEcPhHjXEJWqHJproJrzIZyIKnTt06eVrSmrlI74/gzCOdye9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyWwAkRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyWwAkRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E60C4CEF7;
	Wed, 12 Nov 2025 11:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762945259;
	bh=waDhuLi7iiTBrtHmfrhYgknk3A+dtVSlg4CbuYM6l2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MyWwAkRHNDoLkAI0jcXsdc7D+vZ41XghZsf+l+UjdFtlzTg6Cfx2USviipSndOqnZ
	 C1lZSHAtQV/cyIx3njy7YHxUUBy44XMPtc9xXwqTrPh1sOluD2v+QZ61d75y5jJ/5P
	 gTPuk63EGNnvTcxFAzMMJDtFS3pbohCyLGt75z68=
Date: Wed, 12 Nov 2025 06:00:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Justin Forbes <jforbes@fedoraproject.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <qmo@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.17 145/849] bpftool: Add CET-aware symbol matching for
 x86_64 architectures
Message-ID: <2025111231-dislodge-snort-d834@gregkh>
References: <20251111004536.460310036@linuxfoundation.org>
 <20251111004539.911440769@linuxfoundation.org>
 <aRN-Y5tjf6v5AtSf@fedora64.linuxtx.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRN-Y5tjf6v5AtSf@fedora64.linuxtx.org>

On Tue, Nov 11, 2025 at 11:20:19AM -0700, Justin Forbes wrote:
> On Tue, Nov 11, 2025 at 09:35:15AM +0900, Greg Kroah-Hartman wrote:
> > 6.17-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Yuan Chen <chenyuan@kylinos.cn>
> > 
> > [ Upstream commit 6417ca85305ecaffef13cf9063ac35da8fba8500 ]
> > 
> > Adjust symbol matching logic to account for Control-flow Enforcement
> > Technology (CET) on x86_64 systems. CET prefixes functions with
> > a 4-byte 'endbr' instruction, shifting the actual hook entry point to
> > symbol + 4.
> > 
> > Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Acked-by: Quentin Monnet <qmo@kernel.org>
> > Acked-by: Yonghong Song <yonghong.song@linux.dev>
> > Acked-by: Jiri Olsa <jolsa@kernel.org>
> > Link: https://lore.kernel.org/bpf/20250829061107.23905-3-chenyuan_fl@163.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I am guessing this is missing the other patch that went with this
> upstream 70f32a10ad423fd19e22e71d05d0968e61316278. Without it, this
> patch breaks the build.

Ah, thanks, I'll just drop this entirely from the trees as if people
really want this they can use the tool from the latest release instead.

thanks,

greg k-h
