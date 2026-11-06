Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979772;
	b=fgrpQEIEDVhbI8520LBilUYVb8a/8B+tJbMliT8l1wqLtI5fSrNAoctW4XjVDH8Om7Le
	 CjBnnLDgZajlt0wHaIXL1X6H6y1aJm0pqG/3Vg0pK3iUHHnMnTM4jOU8RneW8aCHpv0ik
	 tiNmNl4MG+dW3H8WV3pCLDRr7c30LqtElJujXymuL7O5q6AI0V+6fCyO3ZfUHm5xh4r4n
	 bvwimjTVC5Xh45LpGAEF8qN4sbwCN2xEVBTtlGatVll6ZWicrWEeZPlH4bQyfQiugRoXU
	 iHSw45mHOBUnI+NP0yQcBZIc/Gb6O0VKzKGZ2WSQJ/hA85rLpHukxgNoMQNTQwt2ANw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979772;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BHVHqM3FwNxEkq+LkyngXjDb8qQTfpOcfE8/GuE9lWk=;
	b=eYmmxyRrPK7KVZDGEcD9w/OLTldN4TFtDugX8OlrcKj8CZR2OJe6snOYMvjt9FVvbKf1
	 ExIDeZEdmZXHN0QfjjmgBWVLcCwzFPClVmp6SiWCSic3BxBsgQdeUxXFHYaDlNBM1KWaN
	 BvTRMt/Q3+XMLxH6McorTMgn74vVTjpww/26YQWxX9k50LcT/G+d1dtjwElVMc/WcIIFl
	 G7hth/EKr3a/OZcf1eC8ntp51bMoByk8Dyu0Ggr4Cy71wYQL6V12ArVe89gvJohxWn0r1
	 U3CKBpxPeR8nAnoXQh02MzsgR6D7Dk6SHUme3xqjzUhkUz9etob+PLfYStyGq3bTHaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MjAUCI/b";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708E1606A331;
	Fri,  6 Nov 2026 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjAUCI/b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788631F008A6;
	Fri,  6 Nov 2026 15:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793979772;
	bh=BHVHqM3FwNxEkq+LkyngXjDb8qQTfpOcfE8/GuE9lWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MjAUCI/bu8iD0brP6pOW0mtienBwJqv4G2SG5q2ELo8+Dd57HkpKKjZmGc6TWKFBa
	 KBg707X/YKpxdPUf8n3YCppI3PCFCZxph9xsO4d4m9RhMoYqAm2RWU3zsi9YOd/Hyk
	 o1w7fB9uSKvDop7aA9yPrOwttU83+fsVoDy6H8Xo=
Date: Fri, 6 Nov 2026 10:42:49 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: burak.emir@gmail.com, ecourtney@nvidia.com, patches@lists.linux.dev,
	stable@vger.kernel.org, ynorov@nvidia.com,
	Alice Ryhl <aliceryhl@google.com>,
	Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH 6.18 0699/1005] rust: bitmap: restrict bitmap length to
 at most i32::MAX
Message-ID: <2026110641-lung-disarm-bd25@gregkh>
References: <20261104211103.174756107@linuxfoundation.org>
 <20261106070701.89282-1-ojeda@kernel.org>
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
In-Reply-To: <20261106070701.89282-1-ojeda@kernel.org>

On Fri, Nov 06, 2026 at 08:07:01AM +0100, Miguel Ojeda wrote:
> On Wed, 04 Nov 2026 16:07:12 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > +/// This also matches [`BitmapVec::MAX_LEN`].
> 
> This is a broken intra-doc link -- it can be fixed with a trivial
> one-liner I just sent here:
> 
>   https://lore.kernel.org/stable/20261106063745.87864-1-ojeda@kernel.org/
> 
> But another option (cleaner but a bigger change) is to cherry-pick:
> 
>   f5535d78e126 ("rust: bitmap: add MAX_LEN and MAX_INLINE_LEN constants")

Great, I'll do that now, thanks.

greg k-h
