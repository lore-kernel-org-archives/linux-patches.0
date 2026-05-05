Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ECB31E838
	for <patches@lists.linux.dev>; Tue,  5 May 2026 18:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778005863; cv=none; b=Pi3xmR+lmPAnXGc0NVmnDcN7jFsn1E0V42Ksy/X5LAuOq63J//2JPazzk6br+OkfwjBfFluBW3A0XGQGUV+QFaNe9LtCMcud2MRQo6mVCHd6X08kaOoq38e73aPsCeN6vKIJL8Vu1wRPVRwvUrVDtVuK8HbLv6lz7f+tvL0g01s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778005863; c=relaxed/simple;
	bh=HyvXmKvXcCIH/j7y9sAxGypJ7gizPLxt/CU9hE5hs50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AmeS4PD8hCqahOtgYyofCyCj5xTByR49fWN9k57W/2M+flr/+Tsu894wV7cpPSWzx0W1/+fM6N0S3rA2bZpAwizMetEoRa524JbAOQdIis1aJWOSGImXNNjcg5y5M1jZ6y2rp+DKvGOLgv5i6yL6h1nzb669irWSV/cicF4vR70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=GhYvId71; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="GhYvId71"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-12c8f9846c8so7563246c88.0
        for <patches@lists.linux.dev>; Tue, 05 May 2026 11:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1778005859; x=1778610659; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uNOGLCaPzdiM71DvHqXrQsZiPrli1oJKLKFgCE+g9tQ=;
        b=GhYvId71XFb8hgfw8RC27j5pTub9gan0gszV2wR6LwwlLJkuXLKPNIndkNFIRC6YYf
         zIj6DmxvsndThEY+rs6pJUaJ1Rx/BmwiBhWvjZNv7oD18350NJd6NaxVd3sUG7Czb4Yw
         4KTse1ql6Eu1l3pvxmx8TGmsOmKnmGDrhm57M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778005859; x=1778610659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uNOGLCaPzdiM71DvHqXrQsZiPrli1oJKLKFgCE+g9tQ=;
        b=J5+voeRn8YRAOyhyWIxaCPvk1JFkd1xN/ro4mz7uEnvrLhRKDiwEfksR9xWI5JeDQl
         XkPxS19kCXzsPhQZtpvoT7krqqDYoEo1aafWn5wWKiyxb1K8x5NSd1QxOUKh1dGZV0iG
         kbWxBVtyYYx0E8z8q2U29+dYW9kZmWMT9vm6oLKG1bAe45grIESvk32M3JfaJT+2j/J4
         tuuGDacAeZ8VMkam4HB8t3LcvhV0BM5m6qQ2SR/UBv3KRrLFBPYCJRGKUy+rT0sr0iX9
         FeKgIKGzekZhWtQjC0uqe4cJcDKh6YpzfKhHyZBiQ0nnHtIEmPPL5x8T2QDxKZSqk+0W
         5WVA==
X-Forwarded-Encrypted: i=1; AFNElJ9WSOr8enyb/tWhxBTJhR/QEkP3Ec5fGy7J3Evw3N1HhBQdtxbAtJBy77kqoA58lc6yMtsPZQh0@lists.linux.dev
X-Gm-Message-State: AOJu0YyVtXX96oFeL7fI9mwdOf+u6ksyZlEwzg7RRJIEugaBwOp/UvO5
	r62eLmNBmJF3qp2IwXLzX/NAnlE21P4hopotXUnRucrErTf9TKoxfyf3d38To2GQUA==
X-Gm-Gg: AeBDietdOcuJ41Dmf07BNpovgpynjqgdZh5XMTb3lCJzNd1FrT1KmRDBqBBAZQDnX8q
	F+H+YaW1oPPJCP2zrA4F8d7VGpEDbKWvpb7yNNSKACgExderknt5iFpnMFjxkGOvf+pEb9dtbLa
	Qz/6gDIB9ZxrjmA/ku5UEmEwJymu2Xm1cOiqYYYmwWI/xEMI+y0IIwSGSdWQ2lxUVL936C9+gpz
	w680K4/LJHa5REAxgYXoimuThx9apsgo11K9wcYazyRS95bSVy+11E0elkisot3IOfChQV46Gfs
	I8PlGEpYgzKn5irBQBUM5T209AbITunfF3iZdLejAvTFHmne94ugjBQaZA1urLnXPE5kRo2I+yP
	Rp1wdSfk8kLzSTWst0DGw4+UfI5QCPpKS08sMhvd/rxwlPyED2WMlBK6BwIQbEFxGO/G3ercf4R
	8BSyDkwOyjLBKluufS+FZkIUMxfNQ8O8iEIC9BYf9z8bT+r5/GInA=
X-Received: by 2002:a05:7022:fa9:b0:12d:ed19:e6cb with SMTP id a92af1059eb24-1318eb3a351mr192117c88.29.1778005859233;
        Tue, 05 May 2026 11:30:59 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.104.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12df8278e7dsm20174952c88.2.2026.05.05.11.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 11:30:58 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 5 May 2026 12:30:55 -0600
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
Subject: Re: [PATCH 7.0 000/307] 7.0.4-rc1 review
Message-ID: <afo3X4uMpuiVC2ih@fedora64.linuxtx.org>
References: <20260504135142.814938198@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>

On Mon, May 04, 2026 at 03:48:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.4 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2026 13:50:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
