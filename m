Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793350069;
	b=pHAG2wlaVfqq88XiSzzdvHK7gM3Cj7DlD2CWEUCvLXdbdSTVfAhi7bp99WqLzZG0iN4H
	 I6xTzw62gE9cNpDJnLanQNudULN1kcVMNVBZd4BWPNNtciNHTNFm9xfBD7kYbWxh4cN4y
	 GyzNIlniaN0AagRqbiqzCy78rkeAu/SMzUTcT2X3YxaVDJHao+JRGga9bUxXEFafsaWeE
	 wFqBJJxQUgu6RLhS5pLM/Di+AKZbIZVhxWqt1zXQxs6H/tVOoRCNnzixR8xxTrvMfFqu9
	 +o6FIpx9JDrid/VqElB+NiiJeyQ7LvV1kRLGKlkwmaFb/AnboNTHS7Ksk/UOQBcf6Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793350069;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=7YaKGspHB5GS35jplRQRbcvZMjoY3F4PRMoOVWpJOkE=;
	b=VGBlVXV0fXAwCVGeOjHW9mFRzt6hpLVW/WMWQ7M9cjQRMXhXsp3+AYxTuFf3u3Hb02Zx
	 WICgUPVuqN9xDfowJ4r/PAp+2lmCYe65JGXBaj0ptYgRzd/mmXOIrWv4aLKfVIr1gCmzi
	 7PEqG5d9kb8Kkkg08WCctD/S9NKXcQoAiaKg/f7Aiozfy5+pZUvPTKlolgQE7T6WGOVGc
	 2TjWcTG55Rzme2m6Oermogye/xOAiwY6qoYQGtLWBf0gFTbVUCDr0xKB0j4Tgf5Rcbt8K
	 rBsq+oUPlS58RJnO4zoFeEcSsmgoXbqtHVBfa4BDsaFS6yjmF2tbiWeYdOZYfD8y36A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzT5IG1Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BEB606A31A;
	Fri, 30 Oct 2026 08:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzT5IG1Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12DB1F0093A;
	Fri, 30 Oct 2026 08:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793350068;
	bh=7YaKGspHB5GS35jplRQRbcvZMjoY3F4PRMoOVWpJOkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IzT5IG1ZtTFp1qfqwn/zoJZ3CHZh6dqnkMBuk/K6fbBVGfRF6FSYykp/zho3bPTAf
	 wkJw2N3s7YK7ggewbIQlDm6b46t02u1WVgoa9UHvgpxVr3+9xl4qaM8WmNhLJ8c+K7
	 8YCm5+UdMK0lcWDz7NQ9I3HCpvwvwCF6IDWo4Rwk=
Date: Fri, 30 Oct 2026 09:47:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
Message-ID: <2026103040-pursuit-pacifism-87c9@gregkh>
References: <20261029073135.159947193@linuxfoundation.org>
 <654c7978-3771-4c09-89f8-c5d23bba42de@gmail.com>
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
In-Reply-To: <654c7978-3771-4c09-89f8-c5d23bba42de@gmail.com>

On Thu, Oct 29, 2026 at 11:16:41AM -0700, Florian Fainelli wrote:
> On 10/29/26 00:33, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.191 release.
> > There are 1879 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 31 Oct 2026 07:28:30 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.191-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> There is a problem with the SCMI fixes that have been back ported:
> scmi_device_request_notifier()'s REQUEST/UNREQUEST cases are empty and
> scmi_probe() never calls scmi_device_create() for DT protocol nodes, so no
> SCMI protocol devices get created and clock consumers defer forever.
> 
> We are missing ee5dcedaf72d ("firmware: arm_scmi: Introduce a new lifecycle
> for protocol devices"), with that one cherry picking cleanly, the boards
> work as expected.

Now queued up, thanks!

greg k-h
