Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.227.220.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104648;
	b=YLEESgh5N9riBKoZp71euMYf/0Y4tFRSRSqs2VFDA7vEu1JrDTnMvNv0lobHQXQwn83v
	 NT/FB+LUUm1NhuagKhPpqzypbohR3A6rvvEaVl8s7MpAdGyVubha2ZRhHZVfsLrHFPsv7
	 gOZsCHL+Fzy4riEjLC1HLPkl4atzE0b653nn4yLBuuhNIwRxwtMw5iZFXvn77QHmzargv
	 0Kxye60EWR4aB8fZrewBNhuijoULpHotmmTVCvgqmkEjt0kPqU9l4NGDLWPFIm2iJOyH6
	 zK7bfS4qrSUGEkpJp3lXWfddZzLZHTfIMRcYyS//NL85BnSAGzYsqN9e2PCr01K4CAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104648;
	h=DMARC-Filter:Date:DKIM-Signature:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=P4KRygiVGTqaYVGOYZ6NQ76XpvnbOVicvEtssD5gvIU=;
	b=YlrHEES4yct6QqnKmAlqk6o5e/o8cKcdt0drvcev3PgykwsAIxcg9u/goB5Gbex3pfv9
	 7QuWuUCH4Mqh41suQQ844rMcmeXgjq2xHHGSTP17DtITS1B4kfOU0Fv+c4ez67G97RwsX
	 o3pa2sqzHDA+/yyD+TSsNFPICcpOaK8gTKgjMkoKBbM4oE+mzmrWyTOTWwvprEYT2dB9E
	 6dj2DjYJHZlOsZcGmpB0QkUltC6H00GcF/8129x/oDT5Iat51ES/idLa90xmwJ0jZ/3hX
	 5Zz7ODPiuxZMsnBSWjiXrj99CNhZYsOVQgUPb2ypjompRsIz6E3dgPHTlf4EwPl8BFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mareichelt.com;
	spf=pass smtp.mailfrom=mareichelt.com;
	dkim=pass header.d=mareichelt.com header.i=@mareichelt.com header.a=rsa-sha256 header.s=202107 header.b="p0rV/ply";
	arc=none smtp.remote-ip=91.227.220.155
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538F9606A32F
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 16:10:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 538F9606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mareichelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mareichelt.com header.i=@mareichelt.com header.a=rsa-sha256 header.s=202107 header.b=p0rV/ply
Date: Thu, 19 Nov 2026 17:10:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mareichelt.com;
	s=202107; t=1795104640;
	bh=P4KRygiVGTqaYVGOYZ6NQ76XpvnbOVicvEtssD5gvIU=;
	h=Date:From:To:Cc:Subject:Message-ID:Mail-Followup-To:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:date:
	 author:from:to:subject:message-id:in-reply-to:references:
	 mail-followup-to:openpgp:mime-version:content-type:
	 content-transfer-encoding:author:from:subject:date:to:cc:
	 resent-author:resent-date:resent-from:resent-sender:resent-to:
	 resent-cc:resent-reply-to:resent-message-id:in-reply-to:references:
	 mime-version:content-type:content-transfer-encoding:
	 content-disposition:content-id:content-description:message-id:
	 mail-followup-to:openpgp;
	b=p0rV/plyul+nJkoTnKFcQ1JNHjZMg7eRGKc5447xmF36qpY+dweeuaNAmO34UT46c
	 fPF8w2vQ1W0hyZtWk/CJB908d5lpMqD9XXk98kMKX3sgVYtdM5FLsMA0qdq7FB0Dq9
	 PCgq1hwUAPk24eJBP7qzPnb7n2jikp0UsU6z5LmgxNimJxwH0EpH5fgy/B0m0OUEfm
	 0JfxFce9lbVJJL8nrJFh/7pWXQmOdgKHZX5DSVUehFHPdHB1Df1zoNn848/S6I6N7F
	 +E4hYtvo71km2CzNRvIEgk3O1dt8PGSQn4UGVp0PZStAhUYspX2xuRwuddUG78n7pX
	 U04QqGTddOjvQ==
From: Markus Reichelt <lkt+2023@mareichelt.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.3 0000/2651] 7.3.6-rc1 review
Message-ID: <20261119161039.GA32322@pc21.mareichelt.com>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
References: <20261118150247.972732815@linuxfoundation.org>
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
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2651 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:47 +0000.
> Anything received after that time might be too late.

7.3.6-rc1 compiles on x86_64 (Xeon E5-1620 v2, Slackware64-15.0),
and boots & runs on x86_64 (AMD Ryzen 5 7520U, Slackware64-current).
No regressions observed during boot & my custom tests.

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
