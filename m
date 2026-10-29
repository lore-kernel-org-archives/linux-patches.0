Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793279390;
	b=S/dYTWMAhhEBMPWhcaiG3W4VXVEWCgBe2JbyyXFRre8wmfuXUR04AZvsf7vEuAwwWYK2
	 R+1NIs6qXqlSkxpAAlQTLSIGia/COod2mjuf7fja/emV8fHim15mYbMqDr3k0uZoXTLGF
	 ayT0dNFuGgTeQ7LVxTYHXNDfR5XDVljhGMtk9vhlP9W72VQHwC3UwMVeMt8vzzZ0lM7w4
	 ZatVL+9qw5ZH+DidcKjg729SBNhgkpneh//h1wFjCyXlTUfOrRSohlF/If+rPARdldY4i
	 TVFW/0ftuQz9swHXjyYdJ4o8rldysVZcdGKgY7jeN5oXUB0ifw2BT3XuRsZptrngpfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793279390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yf26uowMqLzQM5r0qmX7abj7WYZbV+4Wc2+DkpwyUt8=;
	b=kRYoJ/8rIZcqxHgQlJmGXKcjjDOo3bkkOgV/t3iuvzT60qCOel4lb1LBJRnZUT5mim+u
	 VLpMTzrcID/wr5g/Efa3yIPfENIMl7AGGoZ7HZ/qAfImC2Bj+Tt5UUJa0zhmXu52t+4zh
	 XM+vkp5GHCiupCdxHeQ0XRevQTz4xFBCBXPB+l3NYCwBQjokJ0JGB08+POQPbKVX1/kJO
	 gAym8RdnPIoVbq5lMsgWWoKbp0dQzaLpNtBoEAKHjFXOG5d8+8KeptOCyA3Vfs1gCMEOV
	 S16FQgrUDOKaa5UBCxxe7UDCFa5Qk+J3CxBWxV7qAVbSlXkVEf0kpKczE/85+mJPEFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nldm4T3E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78447606A31A;
	Thu, 29 Oct 2026 13:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nldm4T3E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77DF1F031E3;
	Thu, 29 Oct 2026 13:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793279390;
	bh=yf26uowMqLzQM5r0qmX7abj7WYZbV+4Wc2+DkpwyUt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nldm4T3EwfqGkbcsU71K8J6MXBgG1ndLJCmAJqGU/IcnijNIJbBovrP3WBUBPcYW/
	 Wk6l1aZpP4IsB/eYwZzsWsvfHy9h9nvlWLo3UEegsRPpFESb9BYvHOIAXh2B6IGnKb
	 7j8IW546lroHJyoG0wrmPkRhnFlACGQmtR649/fK6uGHFp+M4XKOcH/tmyeo4WwQw5
	 j664zEx06oyMT3qu+/k15sbmmF0yTSLC3hkKEmw+sPC29+Kl+ti1WobHpl34X4Wkx5
	 abw5l4HHUAq1UWlc9TMj1hKRWm2gvpYEBKFQ7C1fgOz0J7E1rfrrFxDr/LgYyr6cRT
	 3sEfmt/7SYAsQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 0000/1879] 6.1.191-rc2 review
Date: Thu, 29 Oct 2026 14:09:39 +0100
Message-ID: <20261029130939.23307-1-ojeda@kernel.org>
In-Reply-To: <20261029073135.159947193@linuxfoundation.org>
References: <20261029073135.159947193@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 29 Oct 2026 08:33:04 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.191 release.
> There are 1879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 31 Oct 2026 07:28:30 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
