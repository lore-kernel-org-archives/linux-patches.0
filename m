Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793877664;
	b=fjxSnkbP6UK2rrs1F7dhEzge2k9FmaRONO5HmIqbzdxmdhjOVoAXExq/HLld3CdF7zNg
	 m1z8yGERNxmjNNQt/sKxPjEKDdUQJGEGYD8zMvVArb22QazSrVevf89x6IDFxmwoJl6X2
	 KqnFpMTViCUhgcRGQmOfDdFAZd+5uago6LPl0JGrPraOrwm8nX30Oqgfl6J/4zVoc6MEi
	 0EtEiFgGCL1z8PYBERWMqC+lM92WjIZ3/Qi+vC+i4sYOZBuniWkEgwVlMH0bCaRVsaK49
	 N8na1Z8+k9vJ0KLBzXlFuGc+V7CEsSdlu8wDJAQit/4VBGAptbht4lKOQ6fANya/asg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793877664;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ThJhfIe/RoF81mS3SA/yvhXJhwlYugcyCcxUCUQIdeQ=;
	b=sEvxTXpcgkGO+zvZ7t8KwEGRVjpaRvZPwofERf6O3wTzxgZKRDLaiXIpz9QohEGTjpQ4
	 X3/rbUA1ZUkPsgjBAFNVc3G/tiKBbtYzz2y2CjFDDdVonhTqfJS2+U2pukTONqkV//LSW
	 1xAW9647G/E3m3cMv1qFSvXSmQz774TLt0aCnhYaUJWJbxFJKTy4JMC5KGiQDwBU0+JQ8
	 m+SknA/9scsmTI+9HhlfxiVtgQKw0d44ihKXPlcj6Drz/KqGh9UZmSVJOZNwaXuF7KORT
	 /ap32/FFqAKYNYpoeTsI4MD+5/dIwcZJCJuupd3ZrDPeOD+pMTe5NlxgZ3xqC4LvlHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2DYGjUG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26377606A32F;
	Thu,  5 Nov 2026 11:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2DYGjUG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808681F0093A;
	Thu,  5 Nov 2026 11:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793877663;
	bh=ThJhfIe/RoF81mS3SA/yvhXJhwlYugcyCcxUCUQIdeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P2DYGjUGKPNHM4NZ/eHgqzqKfKJOGODY21xGTmTCFWhm+XB0ZnIziUDEDYk4o0ogp
	 R8pwdbcg81nFd3N6fIHfw/AZ8/+ux1hI3+t/OR4jr+Sy3QmCcuiEgB/iroAoj+ruVI
	 OfznDT72auuax6fVK5lDIahdAfWD1mZBctpHV6TY=
Date: Thu, 5 Nov 2026 06:21:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH 6.18 0942/1005] KVM: TDX: Enable Bus Lock VM exit
Message-ID: <2026110539-lived-blast-ef64@gregkh>
References: <20261104211043.516122098@linuxfoundation.org>
 <20261104211109.504581890@linuxfoundation.org>
 <dac4e304-98e6-4e61-93f4-8d971069d936@intel.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dac4e304-98e6-4e61-93f4-8d971069d936@intel.com>

On Thu, Nov 05, 2026 at 03:04:56PM +0800, Xiaoyao Li wrote:
> On 11/5/2026 5:11 AM, Greg Kroah-Hartman wrote:
> > 6.18-stable review patch.  If anyone has any objections, please let me know.
> 
> There are some dependency patches failed to be backported [1][2][3]. What is the
> preferred way to handle it? prepare a separate series for 6.18-stable with all
> the necessary patches?

Yes please.

Do you want me to drop this one for now?

thanks,

greg k-h
