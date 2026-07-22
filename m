Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B3D352025;
	Wed, 22 Jul 2026 13:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784727519; cv=none; b=iIuCYqmNEdGqnxcFQEm7ckSxxnRuFhHcUgmVMt+OvEVXNmsNDcKJhwzBkk1OBKI6kWbZHtK/+MCf64Hu6bHV2jwB26FXlvWxC8Yy+8ofHwanJlF4TIAunO1tHGbRNSDpT11GmI1lR4P6jOg45mCeqIGEdn89Alo8LX9fIFZrFR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784727519; c=relaxed/simple;
	bh=y2z9DODEk7bCjyJpzgDqX1QE2rBeKmc4iv4/cuiTTl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FtHrx8ynBTX6ZQBK8y9mpkpAAx8676jzs7cFDsOSVaXBb0FRGwIzS7Mz1qz5oveRvuLTs2J8s84usn6yTu+6Rina8ea5gU6OQteAzWauxGUJh0uGc8rgdZ79J/gPCemtk03bl1CrBaPqqIzNWGvq3tYflQY77X2ac7j+ab7y++U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEVEFwrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEVEFwrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E821F000E9;
	Wed, 22 Jul 2026 13:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784727517;
	bh=BJ2UXTYO94meoenL3SZoM0byQ/rokzlTMQ49xPikWT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NEVEFwrPjstPe3AsnJcysRHVfw/titnPsHm5nGRFeSU8kk77elNqB+Xr376bCnoUA
	 9Q/v7uE2oT9/m3hVhSwqUtp7mMZz7QU6VHv+y90Omnfo3sRrT5Xmrwtw4xYbJwl1HQ
	 jGBwaULvsLjvsnr+fNLsJOfeTinV1acDjObb3TQE=
Date: Wed, 22 Jul 2026 15:38:27 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 0048/1067] rust: Kbuild: set frame-pointer llvm
 module flag for CONFIG_FRAME_POINTER
Message-ID: <2026072216-overture-negative-77ee@gregkh>
References: <20260721152424.521567757@linuxfoundation.org>
 <20260721152425.635542881@linuxfoundation.org>
 <CAH5fLgjeGuBf3DBSwRDXbWCCc1__ZmkZ4W+5F1iwhAFCc2A25A@mail.gmail.com>
 <CANiq72m5=5xL5tLMKJsxu_RS-606fA0TZUtX3urvdd_4ijBcxw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72m5=5xL5tLMKJsxu_RS-606fA0TZUtX3urvdd_4ijBcxw@mail.gmail.com>

On Wed, Jul 22, 2026 at 09:18:54AM +0200, Miguel Ojeda wrote:
> On Wed, Jul 22, 2026 at 8:23 AM Alice Ryhl <aliceryhl@google.com> wrote:
> >
> > We shouldn't backport this to 6.1 because -Zllvm_module_flag does not
> > exist on the rustc version used by the 6.1 kernel.
> 
> Yeah -- please see the instruction above:
> 
>   # 6.12.y and later (flag not available in pinned Rust in older LTSs).
> 
> More details I wrote back then at:
> 
>   https://lore.kernel.org/all/CANiq72kek9NoFe2PCFnND1p6BRbuzgv6kT2o5jw09sWg+wau_Q@mail.gmail.com/

Sorry for missing this, now dropped from 6.6.y and 6.1.y

greg k-h
