Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B10755C30C
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 22:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791930429; cv=none; b=VGPwStH8f/kleXkYLkVSS7cN32XiwnEch1AirfoLLonFya1fFmc6dctIPIqAujJ03OBI1VKIIVHXyv/izYGd8+V9364av6uExeBifRemxtKDab3LyEvZmd4PJGF9pYJFG7fOXl3L2+ZWWroBaGfpSoaW/EVB0wUKtoWAo3z0mAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791930429; c=relaxed/simple;
	bh=T1NSf2MNr7yY5v6FmworM5XrTcAJ/g6Wc19lr7YWcBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g3JrAQ7EUtrjHOmDEOn8tnM0Se8CkFlPmbn19g1C52/+IbghSHNiARX7JdXVZ+thyWy4G9x2fQMHfKtCrTTr9gKsbqyGTwHeQp2XlahKkWKP2IXD5uf6d+1aryBIh1IxvX9iv433njDL3vAV3GeTe8cQvflUvm1BU7KGJkId/LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=Cg/Gcbps; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="Cg/Gcbps"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-9144e8021d3so49111336d6.3
        for <patches@lists.linux.dev>; Tue, 13 Oct 2026 15:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1791930426; x=1792535226; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RMXzZganarlsailXkTlaGadOuYOoIKZ53AhRSXcitJk=;
        b=Cg/GcbpsvyXrBsCBztn7RoszZzRu/OxIYNO0818VGn0RNB1UecZVHY8ch5Q741ZN2u
         m2le0gnNs8spRXu3nkOkfEaPgY6CRrTQKuaaPux8HRktEYcLr8KSFK5sA26odku2io8P
         qAnwRhxxc9qN1PfeemaYfha9O1hBIevqTXgdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791930426; x=1792535226;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RMXzZganarlsailXkTlaGadOuYOoIKZ53AhRSXcitJk=;
        b=B8l1NRBNK0hvAhA+z07tvkWaPMgSwIEtr1lcqcoj7GoapiIIJG9+l/cb+aixPisBGa
         NDNj8dMQfN4a/M1MPhhTdE1qahxHgCGRD0kRmdX3JFuNBTamudQwuAxMsykWolmTo4gU
         kys+4VNmwGfBNsW7ZDcTSaPl1RQz/IDt/AjWI8tfg0xqXEswgTWBHjeZdAJXFVO2g62L
         0T5UPyofRDFrpH1byiI1x/X64vTTs4er8MbAK8pnWL3WAwqQ/O1dNMsDIdbv6SpjcAom
         3ilWNvn5TVoWFWPT0LaDVrVla8S45Sx+j/tJZ+pkogSiZLP1jrdY4Dwz6t78IKdDVyo5
         eqeA==
X-Forwarded-Encrypted: i=1; AKwUvByVGl0xBvynssAf52TLiRzHuysAvCWg5mPHp0vZjboV0se8WeqF9JjKBP1Lm7XmrFH/hGlq98HC@lists.linux.dev
X-Gm-Message-State: AFq9FYInLo1kFyqmuaqGeImHfDV2YXrwGoP9av1nfW5ul5BC7FW0Gcr/
	kslc/6TGOxjTGH4QJLDSe9NQeZ7xTwW/d6odhidhkGO/0UtzeJmJI4PR45kEbpKgIA==
X-Gm-Gg: AYBFou3K6MQay/tdEB/KAkfxFIj2jBEeuO+8vLPRhOOFiCttkzdG50izCaUK7ajsZn7
	oE1NNlVieLrWiXj2rzpDP/kFgqXi6ouG7nUkSzz3lT2bnpc6UsE1wcbTCCyAG5Z+G9r0587x992
	f1wfk49YBPDtTVsMU4GFQz+wssISICGC7lzRjvyuaAwuHQr/H6BxV1zUKD6VMDmLGWvO01zzEzg
	N7D7SKP23vZ6M0Xwu0+C3OP7axnAJS9zD119BrFXJ+x/+tbKCtg2N6zjkD6XhKCiyB+Fv/1rQSb
	ePZdvvXGBFXdIIPHSIHWICIw9dK26E/g9OVClTYPCB3+OvdCZVM61/o7yqZ5L1rBfd7VkSSRV31
	vAiNssmGT12xyvO/GLKKwAPZnMZGImJSt+ajiIzkxAot59y4UrnEnkufMLIW8MbxqVf7iVeJGju
	m/vkvO3HqXrdSpI7qNkFgTQK0yKUO/ioY3EH0LW0lcTG9fXIC1fadJ8qGdIbN0yX9EZ0dpkSwlB
	hEF1cKoWjzdZr0=
X-Received: by 2002:a05:6214:4906:b0:917:8b9f:d62 with SMTP id 6a1803df08f44-91b554f1babmr266315986d6.18.1791930425999;
        Tue, 13 Oct 2026 15:27:05 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.1.126])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b62240sm36637126d6.23.2026.10.13.15.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 15:27:05 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 13 Oct 2026 16:27:02 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/281] 7.2.11-rc1 review
Message-ID: <as6wNjHH7u-zmUBN@fedora64.linuxtx.org>
References: <20261013112855.045212108@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>

On Tue, Oct 13, 2026 at 01:35:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.11 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
