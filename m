Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC10743CE46;
	Mon, 14 Sep 2026 10:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789382369; cv=none; b=FXe1UBPDRlf6r+C0cMwqAnF94D0bDiQ/wgBtbk0nxhaha2Vp364SRblPTILr1MCcldawneTk9febpuk3JN5KduiO05uPY7ZXpHsT8GCD5kAsFp6HCysoNNe/FCyNjaotZstDs22PGQhLaoMlCYKXsB0I8G1S0XuQUay++4S47KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789382369; c=relaxed/simple;
	bh=udttGQHcPlZyKy7kvpZ/13VdtswYWMOizFWTXd5rPGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jbt15YEoA8Vy1MrfL3gPBrStQMR/Ik8f6uxC9yBqb3MEH4/em0VLzVh4DILAMJvzngf0TqDCeBbS0ZYiKDaQ/qz1NOiN8JA8a2XwJQNNmIme2kckJemrIQAmnkE7a4bBKAMu+H8wMoVh7qoEaw58OdHDlyLNHHRD8AOOZ08q52E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQOR5Rnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQOR5Rnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE851F00893;
	Mon, 14 Sep 2026 10:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789382367;
	bh=shhrBcw7UkV0vuZnZ6b5DO1mFKNhU4EQFdVDU8kenvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aQOR5Rnju8Ey72bmnJYOZlherotc9bDnNMG2OcSVfJS+Qt+d2Icnfbep6DqZUkcDW
	 5xeZ2mSrAd7fDuKQlPvHIIgHcWCRMn0A7PyfvhZNicyi1OzNTnnnsi1kZQC8pa6WtL
	 w4aUblhuZMoJcmItgnwmjuemb6pPCO0V5idw1vQ8=
Date: Mon, 14 Sep 2026 12:39:18 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	tianshuo han <hantianshuo233@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 836/935] ksmbd: limit repeated connections from
 clients with the same IP
Message-ID: <2026091407-outright-avert-3296@gregkh>
References: <20260912065526.833703348@linuxfoundation.org>
 <20260912065545.998510042@linuxfoundation.org>
 <20260912201946.77500-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912201946.77500-1-kmehltretter@gmail.com>

On Sat, Sep 12, 2026 at 10:19:46PM +0200, Karl Mehltretter wrote:
> Please hold this patch unless a 5.15 backport of upstream commit
> 98a5fd31cbf7 ("ksmbd: close accepted socket when per-IP limit rejects
> connection") can also be included.
> 
> The new -EAGAIN path continues after kernel_accept() without releasing
> client_sk.
> 
> I reproduced this on 5.15.221-rc1 in QEMU: with one connection
> held open, five rejected connections from the same address left five
> server-side port-445 sockets in CLOSE_WAIT and raised "sockets: used" from
> 4 to 9.
> 
> With only the applicable 98a5fd31cbf7 hunk applied, the same test
> left no sockets in CLOSE_WAIT and the used count stayed at 4.

Now dropped as it really wan't needed here.

thanks,

greg k-h
