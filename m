Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0023115B8;
	Mon, 28 Sep 2026 05:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790573643; cv=none; b=tJllJx1yXysLjaUlwx4/WNtX2LDiO84++x6BOZAfvnH55ktDoOvbICAfUdJeCD+oScfVcslZ9gtH6XHqkJXiZuZnSJN6JR5Rcxf2761bfNmGEuqAE/K+b336EGhX1GhFp9loAeoxwe0zx+stoKWDxTXroYIp2AKzWb9Lwk7Q3Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790573643; c=relaxed/simple;
	bh=0AO989I6Cpl24641XN7w8rAaSv6YQR8SrdsVBR0Hh68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9vBghEmzgDHP4nknBsiZDuX13wRxDckACJAsuh7RAtL933aQGSACmitX16d6FK7Dze4WdU/KF0AzohhKyR+07bXj9c8AMrUSFNnZT1VsTBfP2dZNQ3Sacjt4D09d+IMKCarLbDzWy9Hx/gggxvT4DanZ9z8MBRJmZBzcF8gMd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYNmppOa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYNmppOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE141F000FF;
	Mon, 28 Sep 2026 05:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790573641;
	bh=PyiEuNAuTyZH+3RYA3a+8iFBbA9qhiqzAokTb9HThOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=vYNmppOa3cc/fOZRvNRaRa0HXHCFDwKgfl0y5g58a35sbijRoHFdqxf/te8kOEXCl
	 iH2Wy71nKQ1fLLarr6prqJ33UTagKIHYws8FjlYsI6k7pmDfeZzm8SwlVNoozLBUBd
	 IC6j+4utyRCTUtZudVwkra5fxGd4yzGsIxQDK1ng=
Date: Mon, 28 Sep 2026 07:33:57 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "springbreeze@stu.pku.edu.cn" <springbreeze@stu.pku.edu.cn>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 6.18 210/398] rust: net: phy: fix off-by-one bit
 positions in device status accessors
Message-ID: <2026092811-fiction-glacier-2b02@gregkh>
References: <20260923140643.441954610@linuxfoundation.org>
 <20260923140648.864493062@linuxfoundation.org>
 <SEWP216MB9770116738884C46F156A686FAF98D2@SEWP216MB977011.KORP216.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SEWP216MB9770116738884C46F156A686FAF98D2@SEWP216MB977011.KORP216.PROD.OUTLOOK.COM>

On Mon, Sep 28, 2026 at 04:41:23AM +0000, springbreeze@stu.pku.edu.cn wrote:
> Hi Greg, Sasha,
> 
> Please drop the 6.18.y patch as it stands in this review series, or take the
> variant below instead.

This is already in the 6.18.54 kernel release.  Please either sbmit a
fix, or a revert and new addition like this.

thanks,

greg k-h
