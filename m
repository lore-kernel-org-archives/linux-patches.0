Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337324315F
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 22:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772057357; cv=none; b=YUoby3QmS8PmyZWFdrpqLEQxy+rhpq7ISgTkI8iya0cKSN1hloYa4heMXXUbmcdZlcxSabITpVSHykSRVCd3/4Y+UPSHdZumK+od+kjg+jqdQ63tc/GR8JHrZsrnnIYFLgp2um1Ui1syasXvGcpry9VS+ROLt7v0tBCTIqvj/0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772057357; c=relaxed/simple;
	bh=N5lPeBLKGbKQWMabsoM/JPAxUBL569P1GsdOUpDyp/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBgBd3rhJVOGeOJyp0065wQ9ncyA04czByMmjIaO+AJnSa5LaGVgMWl+tYEdgwN9+pDw89MUss6xk3kBkCkTn1ffS9T8GmQsvNJB5Ep5md2O6+M0XEHwzVRd5jiVCxY9jF2m/UQkceuoUkF53vPnTE92DYR057+sGYKckvCV61g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=BdNywaxi; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="BdNywaxi"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2b6b0500e06so211441eec.1
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 14:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1772057355; x=1772662155; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ds0gipBRoW/ThY/jgKHJB5YMw8DYTRgz2R2rwxq8d60=;
        b=BdNywaxiSOOkxuDtfULxnamkfK+2v23O8de+PY4Tt67bWMcQzwWEtEKsysfH1NK78A
         YvlCjNxtaY2EIh4uChK3/D2IaYD5+ZrYG49dVij/6VhdKQff+n/zeQrU8TvLqUQ+Kvwu
         6DgZ1NmM3r6iAnClkm7rQzlqFfxprvbxkBgMs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772057355; x=1772662155;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ds0gipBRoW/ThY/jgKHJB5YMw8DYTRgz2R2rwxq8d60=;
        b=mXq4j/iyK3ZK8U1EgktkB7WucPsxROz8DbKaH4my9iq8/SWSa5eOGCX29ewsoRMAt5
         N4sweNo4LPi9M+Is/1wFILmkEDwoA11/wfZ27vZJL7qAq+9YSrBZHNBEXyX0oKhqCKsf
         We/ihL8d45hsOaoGBTmdF//1PYYUlPPOUy7KX8IFvuKAT5Egl7IOFWUX1D1sFFk7/iNL
         FNjV2z7aB6AeIYGOUPU4YLA1LtSg9Sbe2V47CU1fYlj4wbx5Rn0UCj9Ws7Q2AMBT1Ff7
         jSnXfZ6MkZ5L/CorOTAOeyur1MTszJrhrdP+6eJ0hnDbyI8uzLeipOHXlAgSbrfZrIr5
         3YHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBCpvqnRpdk3mYFFealR2bdFrIyqNptQ+0go8D913KrCaRUNizw+brcaK7PPZ4xVmqN1ifUQXb@lists.linux.dev
X-Gm-Message-State: AOJu0YxTMHD1JmC1DoiQwTZbldErABPgknCkyj8tot+4QnDZgs+eXaKp
	jnB6DHrysVvoI6IzI8/jGwNowc0W0k1KhTTmYzjULZMc2DE0cswLKfFPLqOkAEaWTg==
X-Gm-Gg: ATEYQzw3QMN6UYxe6CCvQDqmXQs1Q6wj0knTMWFRghqSCgHuHa0sTo8dfQLU1Q+YRVc
	sziSygZGvtFmMkXwtTFdJ0kc1wkn69rQpodNRbnVGDCr7/p8/Rm4uA3PQB2+aHVe/sucmiamrc9
	P9kazcHLqUamiPsz2leGDG2E/XkzK7Yi0XkXF3OfDHK9M2XsY57q9Mo1s5PYKYCtmSjdxw5gRmT
	NAZHq+gABE2asTivk2OV+6eBQFWp2lTtT85Pjlw6cXyyNAUZClU6u7DHd2FCzy5qpBgif+TQdei
	eu24l9MefAm4RuVylF8KswyUz/CnSmtQiVhNxEqKNJKkNsSrxU8iIQfCc0IZdfdhJXdPKME+9tx
	EaLzbrYnkd63N++iPPG936LcJ1/5Mb+YcYSx+68kkJ/CdBXg2kvOPyib5UNec0eof+w6Xm7Hupb
	YE6q4MM7nkRjIMigE7lyYLKlaJvMAvVaYA4GaXNOnAEr9In4uSVASJQio=
X-Received: by 2002:a05:7300:190a:b0:2ba:7617:eeb1 with SMTP id 5a478bee46e88-2bd7bafb2bdmr6639953eec.12.1772057350581;
        Wed, 25 Feb 2026 14:09:10 -0800 (PST)
Received: from fedora64.linuxtx.org ([216.147.123.146])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdd1f23c01sm268892eec.16.2026.02.25.14.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:09:10 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 25 Feb 2026 15:09:07 -0700
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
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc2 review
Message-ID: <aZ9zA7wkXn86cj8m@fedora64.linuxtx.org>
References: <20260225151847.709818960@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225151847.709818960@linuxfoundation.org>

On Wed, Feb 25, 2026 at 07:51:50AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.14 release.
> There are 641 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Feb 2026 15:17:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
