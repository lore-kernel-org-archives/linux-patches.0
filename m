Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC818F66;
	Fri,  6 Dec 2024 05:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733464117; cv=none; b=UqQ/D4MzDwfnQF0U2+tIeWz/ai9gan4LcfGAIJV0QRCKkbevAD2J/Fi8FBtUkw/wHmCzk4YSNbmi8dOvsUIrd19D0ZKIeLhws1eILMxxcmjQ0nA9ZO3HCKzanYRaqT7Wa6at87FqO3lalcCATF0GOVsxpfcOll1tJ6qls/txTik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733464117; c=relaxed/simple;
	bh=xg+DjJQ6I/sDSJBKmNObSmFLmoCZN9/zPk0XlV4Qdcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNLsSumGg6wXGt4ZJP+0ggev3hlQfcStBhq8AEfXm0e0s/Bg4EyINi5euw+dwqsKwDPj4wWhi7DU0BUNS+OTocXsHGouJ0ToBpXLAUnkqOozGQl12qUptYXEYVBoFB6abnxE67u+Xw/Zqj85J8YrSupHMrZ0yLMfwqI0hm6Gd2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOxfhTIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOxfhTIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F80C4CED1;
	Fri,  6 Dec 2024 05:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733464116;
	bh=xg+DjJQ6I/sDSJBKmNObSmFLmoCZN9/zPk0XlV4Qdcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YOxfhTIQWFNl58TEBIWVcCzwi4s5jqgKk0on1pIzMHDCjBb8rEGAu8U+eZ2F1/kNl
	 TDwIYlfSDv1m39CD8uDE3cDqwRHeGG47QHtU+EKPFKItYmBNW8F/ZqM3wq2pFzlPhE
	 C4BGVGdGjx2+o5tMOHaJ9ZHpcniamJ65UV9bkfwU=
Date: Fri, 6 Dec 2024 06:48:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Jung <ptr1337@cachyos.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
Message-ID: <2024120657-corsage-agonizing-2ec6@gregkh>
References: <20241203144743.428732212@linuxfoundation.org>
 <efbda6ac-9482-4b37-90b7-829f2424f579@cachyos.org>
 <CAHk-=whGd0dfaJNiWSR60HH5iwxqhUZPDWgHCQd446gH2Wu0yQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whGd0dfaJNiWSR60HH5iwxqhUZPDWgHCQd446gH2Wu0yQ@mail.gmail.com>

On Thu, Dec 05, 2024 at 09:51:37AM -0800, Linus Torvalds wrote:
> On Thu, 5 Dec 2024 at 07:46, Peter Jung <ptr1337@cachyos.org> wrote:
> >
> > Reverting following commits makes the machine again bootable:
> > acf588f9b6fb560e986365c6b175aaf589ef1f2a
> > 09162013082267af54bb39091b523a8daaa28955
> 
> Hmm. Thet commit
> 
>     091620130822 ("sched/ext: Remove sched_fork() hack")
> 
> depends on upstream commit b23decf8ac91 ("sched: Initialize idle tasks
> only once") and does not work on its own.

Ugh, missed that, odd that it didn't trigger in my testing here either.
I'll go add that and do a new release right now, thanks.

greg k-hj
