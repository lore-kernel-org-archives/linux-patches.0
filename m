Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A824F18E1D;
	Tue,  5 Mar 2024 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709624217; cv=none; b=eLPX1pPBPvVT9CQuNM2b9ciKeCAAO7drtrYPbn4SV3fRV+3JHiTLUQukCLXqn1lOvheUiFCb3CwgHC99+1+MfLqROwZWfmW54k3Qsmr/Otgl4UCCYhjD90ALCHRT3NrAoYITpkTweaze5dg3iORCpDSv+7X5iF/60dXT4vgIPs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709624217; c=relaxed/simple;
	bh=s+r+n6khb9dc8vcDVSttjByqVJfb7qX3xr8f0lab+9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tec7aB8N/m3oEQp+F3y9tTrNp9cMGXYb8qU1g5NVg7X+Mqtx5063ZkV8OubjwmkNWHpG2AegWrooHj/w45SMxr6URUDIXY1cSoN39GwYJG2L+Csx9B/sugB5Ktx4LjIhECKZpoAluHRnv+YdAEoxcZkp+sTWTn/QaTOV1Pb1F4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbNBaaF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbNBaaF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE2BC433F1;
	Tue,  5 Mar 2024 07:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709624217;
	bh=s+r+n6khb9dc8vcDVSttjByqVJfb7qX3xr8f0lab+9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hbNBaaF9a1+Qexv7o+8/oIB61zz2rH5JMDCF8TFT6sCXAQEGLwC6df4ctk/i8Rqat
	 95kq75vpJPqNJNyXzLhhYn8o/bwZQK/WL9zQeox0w6Ml6jXaVwDu3iF9DllZ1/5/BR
	 bSPWsBUya1wzTIWnDHCRH+x6P+IoqJXovAIOYL+I=
Date: Tue, 5 Mar 2024 07:36:53 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Ingo Molnar <mingo@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6.1 128/215] x86/boot: Robustify calling
 startup_{32,64}() from the decompressor code
Message-ID: <2024030523-parted-situated-8749@gregkh>
References: <20240304211556.993132804@linuxfoundation.org>
 <20240304211601.130294874@linuxfoundation.org>
 <E57FF738-3527-45F3-891D-FD54E6E7E217@zytor.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E57FF738-3527-45F3-891D-FD54E6E7E217@zytor.com>

On Mon, Mar 04, 2024 at 02:42:35PM -0800, H. Peter Anvin wrote:
> I would be surprised if this *didn't* break some boot loader. ..

As this has been in the tree since 6.3 with no reported errors that I
can find, I think we are ok.

thanks,

greg k-h
