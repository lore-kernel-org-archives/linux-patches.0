Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792428886;
	b=ETX/PoLVXsZqH4TDOPGLVBz6ek9U4mjWIDhmEU4MTatop/+SfvGytOOTUCCGlGF0bo4Z
	 gRGb1TfLm52qe2IgZGxNnnsv+4obakLgaE+O4moT0o51G42vFvXpdHHWS8GBhjzY9EABR
	 Gxk3qaCxsXFo16LCg+m5JGnbc92BD20QNuEG1ogShcvnwQlB9IRNVRr9OvL/75kOOy36R
	 269PojApSonb1N+TCMzUGuUpZUjwYabs+OV6PbuPbyRonH6RkQeRWeF7O4J3cULrwpZLQ
	 zdDBGlueN7FIJrueLT31IQrsnnqzoDZR+4GUcftyA7P/15yWoTuXtkl8FIr6OpmBWAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792428886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=mw/YN7QprLCeeR01eTmOl8h4o6QKEAmu0NdhWRuwULE=;
	b=47+Ks4hN2wZLXRIlDo5mKcy6+h4K2vH87/8XGG6FXuydX9MnaHA1vjZdGi/MQ6GbE4pd
	 aS3yeBZJz/lZ7ZIfdYJ0QdkEXD0w6oGIBKwHJD0D/s89e2VsKo4ozTJts/5gxQayXbrab
	 b2uUrzXKiqyuaEiKiOp48ZOp2M5JZ6B5Mfoa6i1cVTcotJ/5PgkHtl6VKmJFOnvsSQNMP
	 O8GQwEYoglzCuHEMeMkOFLhxR31K7IrkxeXs9xkNl+A810TVRlNeepgLwzbe8X9tvzGVW
	 Ps1QMI48Li+iDG/hPbFUEHxQsTMLuv+fpJzauf5jjutXBwgK1j7y7VUgLCMVYVb6p3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KkyGwT4b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEFE606A31F;
	Mon, 19 Oct 2026 16:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KkyGwT4b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9925F1F000C4;
	Mon, 19 Oct 2026 16:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792428885;
	bh=mw/YN7QprLCeeR01eTmOl8h4o6QKEAmu0NdhWRuwULE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KkyGwT4b9e4KbNqEkLA6I9Ac6sTn2+C6OHTBOlvq/as7G5XjOhjfimYDgaEx63YvM
	 eLSLxjDWpOhXZ77vYs60szKv7Woj9ySQFwTOuelfCvvMtmKjcaI9pxvJcQt59AP4A+
	 wH6T04KE+q/x3yuWLAftcFAB/W72ML2kno7M/1+7+g7yyH5SdDC3nrBl0B+UaotTwo
	 3Kb3Qor66KZuTHN5HsySDYB3phouX8+j3Ipg61qYv5i0jTBI59+jcwcHbdZU0CYAph
	 lEzy30vG8HGObIkWSgUYBnjgpch7ROoGWe8pY/ypUZ97rNBP6KMZqHwqp0NWeJdMnB
	 XK7/FwxPIVj8Q==
From: Sasha Levin <sashal@kernel.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 6.6 0000/1674] 6.6.160-rc1 review
Date: Mon, 19 Oct 2026 12:54:29 -0400
Message-ID: <rc-reply-0001-6f27dc9abcab@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <7201018c-20e8-4187-832a-aeb0e5db98ca@googlemail.com>
References: <20261017160431.119607952@linuxfoundation.org> <827e9f8d-5654-4964-a999-5ce94bd98fd4@googlemail.com> <7201018c-20e8-4187-832a-aeb0e5db98ca@googlemail.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, Oct 19, 2026 at 06:02:37AM +0200, Peter Schneider wrote:
> # first bad commit: [7c1e132b0967210526de05e7af6f1c26ad0c1516] sysfs: Introduce a mechanism to hide static attribute_groups

Thanks for bisecting this.

> I think the problem is, that if you take this patch for stable, you need to also take the patch which is upstream [
> cd69fedf58f8ab1ab511f7c6ac1969cebf1c935f] sysfs: Fix crash on empty group attributes array. It addresses the exact crash
> that I've run into.

Rather than adding cd69fedf58f8, I dropped d87c295f599c ("sysfs: Introduce a
mechanism to hide static attribute_groups") and its dependent c7fbb8218b4a
("sysfs: check visibility before changing group attribute ownership") from the
6.6 and 6.1 queues.

-- 
Thanks,
Sasha
