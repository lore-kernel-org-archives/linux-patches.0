Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795720419;
	b=471acatulq1rR0j1z05TxT+lyf+u4w+C3rPZHW0crJU7V5a/M6IgH48oV4G3h/4r2ECS
	 HiAAqinP2ddq6TmyaiWhyB6L9Wyky/tZO+GSOsWZm5gnEmSaBtveRwjzHVLdvRXuK1tuX
	 rMvnko/2N7Lz1uIigSnE9DGN/7KLatCt2XQD8B3bmANR56DSnaHnYP6xcnotys/4m7XBS
	 c1KIj6cdRTMkJiUij0GgyiFSizHcv5L7oo/XA2rsIeA0BSdLiMGujooYQDnAYnVcsJmer
	 uVSmHL9lwPkSaA3bzxOlFRbPXCaOdMq5qSDlG3JkS8zDhYGLXrm5SF5zyU/DBYpP7DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795720419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=xW8jcuCcbYf5B8+VQmm96KAS4O5E3fuRMoEAayJarso=;
	b=uacgbnWjQTDvOj6V/dYVIlQ65/QG3UWCfd5qrRFvHN4rmeZmSmJeATqIYWovQVYwgQSh
	 +rDEvoCd3ly0IFrqwDa/2yHoDt1Sfh5hyGJy7anqbEZWs9K77vKRgiibjYxJOYtNuqNuh
	 ReZZJsF7iyB171aS+GmVJ8i8YKx+C3kPOtw3ynvzaSDkXd7Dsg19B5KYhk4Oc/wcywkau
	 ZlBmkrwch32SjQOrVqpgSxQzZlLuIPPRHkGs33KTPB28oGEH41ciTlQO0wnPu5pJYSR4z
	 OlWcqr+YsYKSVCL36SSCFp7ScJdx+jbEWBYT9h6uDxaZGJaBYsLDf/Ew1Bas0peUTTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LraC1R52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97E3606A31C;
	Thu, 26 Nov 2026 19:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LraC1R52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F221F000C6;
	Thu, 26 Nov 2026 19:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795720419;
	bh=xW8jcuCcbYf5B8+VQmm96KAS4O5E3fuRMoEAayJarso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LraC1R52mV4WDup3X7RpWbxsRCDvFObqMHylHyfNo3u7BS2DymjdMzhxOB2TJUGhY
	 TgYCwo2vM/t4daRyBvnS977gOf5v6OYR6OFhmI25pmBqU3s1NAiQa2TIHX4FqzJbTC
	 EucEsvHQzxHftI+ygsWj6uk2pkiT0reic+Y8Ojw4GeoRLmDNj7m2FNtJ+YZiaJc6D2
	 Cv4NKnDW6KfZZSlZJ96Zly6qc/69Oba46JzRXOgNmghSn/Bm1xdGH8Jq/cC12DOK12
	 401XWQhdXN27xFKa64tdzf4mBC7F9S+mJ+gjUt4Ieg6ajHMKYVfFRW1kmQ8cs+15TS
	 8iaoKQkiK659A==
From: Miguel Ojeda <ojeda@kernel.org>
To: ojeda@kernel.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
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
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc2 review
Date: Thu, 26 Nov 2026 20:13:27 +0100
Message-ID: <20261126191327.96044-1-ojeda@kernel.org>
In-Reply-To: <20261126190437.95251-1-ojeda@kernel.org>
References: <20261126190437.95251-1-ojeda@kernel.org>
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

On Thu, 26 Nov 2026 20:04:37 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
>
> I don't see Peter's `offset_readdir` warning in my QEMU boots, though
> they use a minimal userspace.

And the NFS build error is also gone (I saw it too on x86_64 in -rc1).

Cheers,
Miguel
