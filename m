Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793364687;
	b=EtoLiHtKg+2OGIe9FklB8qk+gM9MTrKorhNjEPbS8DS6rMm6acCl9JTsu7F2Zv3xUrc/
	 GzPTgvVH9NMfpadGHUxz3P6vfdCb2JnSmnLicRth3bvKWRvDiaeUgzA9hTgvQRe7jHz9d
	 URfLPMwmaEdgiBHCdBLf6X5iroVmueFuTPm8VDZ3onsc9hRZ4rfXhLjzXY7L6T+TPATDO
	 03nyVg7AnSoq+P9oiWie1PY7MKIODcAGdgX7i/Zx1QGt/14QoSp/OmmBsgKs3VvpaSWEL
	 M2ucndxP4HoXlSKnRFHoxvsfogYr5vhBmM7l3sF5+PU1VAaa8ZwnksAM69igo2dxPwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793364687;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=pA9rfDOneSvqKwc6dTuw9/r4XLRowQlGBQj7kyGlyzM=;
	b=Szprr0v2rf3mD4TAxnx9CFyyLJqTsa/EuQs0xztLK1O6zmHBNss9TMZg41Na2hwchlED
	 a0mjBnGP3CQZcyAOPmcNfDzSBSMPPJi44Zyn35FSQHMBLqHrsh/IP/XuvsMlDPToJEtwG
	 nj6JYPDHv9JGjXrEAKlFPfAA/7HYTBuPzQcd7rTLN/PWP+e2eCsXbP9nREDgg4BrPoRu+
	 5Dt5H/0BG7GpGaymlM2AWBtvxi+vRKR9nKNSSe0eV5NglooZkQGOCJBwRalWpJ5OMxh2f
	 f28MQvDfyTiTXVL1QjGWKUBwAgVQUWWRMYKYRV+KPzmkhE606/Hvrb1YpSNzqeoHf4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jGRsfSnX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA419606A326;
	Fri, 30 Oct 2026 12:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jGRsfSnX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930961F00A1A;
	Fri, 30 Oct 2026 12:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793364686;
	bh=pA9rfDOneSvqKwc6dTuw9/r4XLRowQlGBQj7kyGlyzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jGRsfSnXmDGFeb50hFqvNP0jgf6zQKwM63qJnV2ewQtv5q+O2U+ornwdTzO+pAblh
	 HnepeOoc49K1VnES8kBtHxTRf5NRxtMuAw+9bHu5eyDUQTrT4UNBzpU02sQ+a/Do4Z
	 f5DDFixkoLTjiiihhRCXplhIrhyY8ct/R1tDzDtI=
Date: Fri, 30 Oct 2026 13:51:23 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.2 00/10] 7.2.15-rc1 review
Message-ID: <2026103019-badge-android-5e34@gregkh>
References: <20261030121255.257615100@linuxfoundation.org>
 <e24362cb-bce4-4a9f-b9f5-040aaa2823e0@googlemail.com>
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
In-Reply-To: <e24362cb-bce4-4a9f-b9f5-040aaa2823e0@googlemail.com>

On Fri, Oct 30, 2026 at 01:20:49PM +0100, Peter Schneider wrote:
> Am 30.10.2026 um 13:15 schrieb Greg Kroah-Hartman:
> > This is the start of the stable review cycle for the 7.2.15 release.
> 
> Three minutes after the release of 7.2.14? Really? That's, well... ambitious.

Yes it is :)

I want this to be the last 7.2.y release, and everyone move to 7.3.y
after it is out in a day or so.  We have just too many stable kernels
"in flight" right now, and too many pending patches based on the huge
number of bugfixes flowing through the system right now.  This is an
attempt to keep on top of that by reducing our release load (and your
testing load).

thanks,

greg k-h
