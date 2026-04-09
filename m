Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BC33CB2D9
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775757319; cv=none; b=IvTdp73mjNzFopApfmP3tG5H4M1un9sOpwynPYwRZ4dMD6xgR/exr9YTURAQ2/wU0wZr1UbCemokIEi6C682s4qDePLuFQ1AWdMTfS+fKS62bJU12MtQxzYrtSdO1BUeCr2cU5gn83/1NrGmvzo51ypL8sfgRQiFAfNbcatPp2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775757319; c=relaxed/simple;
	bh=f5PyRVbJZI//kUwko+7eCqrINzwuavbpM+Zd8kr8jqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kcIwBx2Yk68+klIwZEYWEHqHHbAEqGVhR1gpnTJzHJYSAcH6k0KtTBPPDFru0kd3a5IFwsBeR7tAhBPurloG856x7bAOMZSgcyBat4yQT8jGq9jg/mbPDYWETZAk5xEDG+75Fxtgw6ROHpKZ+NLTlpOuuEP0lQ01WlPW4BO1nLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=BRa0lbOQ; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="BRa0lbOQ"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2d52c7f92b1so487486eec.0
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 10:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1775757315; x=1776362115; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nJhkquUSXHzHGdyZEwzkMnyXvUHdO+dXNf5X5Zxo4YY=;
        b=BRa0lbOQk7jOZyco205Nyx1ruFvdmt7QQ0qkopulwq1P5yIZjKHORd1/fzFapPwFIB
         KEyVVASLbeHIk6oetXIFWaHB0CO50p9pX14QEE9+hv40tlQJo9mZoqeGFcwqjEV81cKb
         /7hJauy0Q8Qvm5FwChGApyjRL4ucYRUKWc1Eo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775757315; x=1776362115;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nJhkquUSXHzHGdyZEwzkMnyXvUHdO+dXNf5X5Zxo4YY=;
        b=h6GjYYg7ONUDxOTITWBhmuldUXU9nqh9fU3jMpceCgMwlNzdrtfLx/ebza+uLNuCQd
         HA1+7agwt3tzmgq0SiSCyE0qmVClTzmfifQhvmoQnm2ZjdbJR59OLDLVZhqNGbf0mJqR
         k5n8dK/pfajsAhEM7DjJSml5KERF3+YnF9cZ6hXGCNwi6f3nTzNiz2CtyQ/VJc+Aspo2
         g37wsIYLrvVSvqr7KWQT4PveggG/4dZG9UP95VBFEqe7Ys3/bVvZAC6VY2uIGPCyzfTD
         QEeihNiHnb14NA9dOAJtEzrb0Ey4jw1Di3IYn09SRvmmeBRJwyUht0WONzK7oNXja+wR
         MJQw==
X-Forwarded-Encrypted: i=1; AJvYcCV/SMS0k8Q6NR/KsInMbY0vqH/hkElUY8iw/cdFk2qGiPTto41Pg6TKDlo4uQo9lHxn0IXV46pj@lists.linux.dev
X-Gm-Message-State: AOJu0YzKkcz/jp64vzMIhV4LxqBhI9CxVkIr7R5CcQfRmcqJc+ejOQgj
	DxbYhbNK4NqAlV/nm/zc8UNdldWkXlQZ44SB7+rhBHVFo3PUgdPvT9JA9PcTEpVqvw==
X-Gm-Gg: AeBDiesX97pBNatIqxqSIQq4fnLHDAllDdJG/oLQSSRLhXRCxzpQYwgDxSQuaVB27tS
	GSiVz62k9ZUrmUgm6RGippAgQyMt1goRufA/M7WQCKfTcd1Q+2b+v04pYRUAte07OPryrGoGTOm
	vuS+YsjKjmdndu9nvIiGybnxCMmw5JinHOQdjVqoy9MVKPT+RxE41/0mL1s6EQslMVXgnC12M4X
	9QuZZwOVvBhYwka9y+7w2JQRXEcQHKd6p0WX8vaE0mgAdlRNms+bE0VltyzI1HVvKyxWU4WD+y/
	b/M+RgI1UxAqFcpGq2JtJFmQR7TzlblLXnLWEfavx2lxCSUTsLi1en+G4wIjuLG9aFiUj2ghM0d
	Ll+z3J4o5wRE73CJp3yc5CqR2snqrISFs6QBN1h9t+5QE/SyySV8yYEcoEIi3mFFVHcNE6eKf7o
	cuE5UV61A+SSxL20kAieGbMotVO9xHe+oilZBjbqqIbQ==
X-Received: by 2002:a05:7300:8606:b0:2cb:88b5:a93e with SMTP id 5a478bee46e88-2d588e8584dmr21942eec.17.1775757315416;
        Thu, 09 Apr 2026 10:55:15 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.107.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d5629b31f5sm578108eec.24.2026.04.09.10.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 10:55:14 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 9 Apr 2026 11:55:12 -0600
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
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc2 review
Message-ID: <adfoAFwzb7xfh4NC@fedora64.linuxtx.org>
References: <20260409091742.514769762@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409091742.514769762@linuxfoundation.org>

On Thu, Apr 09, 2026 at 11:25:28AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.12 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 11 Apr 2026 09:16:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.12-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
