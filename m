Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F4396B6B
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 16:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774368729; cv=none; b=JrA/b2ZSWroRFTw1L7efvCTCFn/0Unh52Bk2mHLNif6FDuhe9uIpjdPSa6gxl9u7trRHr8d14PkD7Jz1iRTmO5+cFtuOVkkC7VITESLdKtEgdqeTbQIlRz6uC+sLS9BvqkgF4eTsOdZgg3X5d10+Nii03ewgP2f1dArS6UD9nAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774368729; c=relaxed/simple;
	bh=FFak1H4vTrYODr6HytvqfvxQsQSUO+A72jkTFuEIXug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QqkAFLJembB1JDe6vy8bmstIZcMYSGi3/Q0+J8kUYTUOc/O+3RZMvIphvnv7vE4xQbzT7HFnX1eLm3FDjDRWO37ha8//8c7scp9yllm2N+A1RMYeK3SOPFcoVSKgnxL1JvCJ6s9GaCsS8eSRJL19+nGZbtl6nviu483PFrCts7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=CXGT5V7U; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="CXGT5V7U"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-12a80c36350so2937319c88.1
        for <patches@lists.linux.dev>; Tue, 24 Mar 2026 09:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1774368726; x=1774973526; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7jtDWzT09fCJ+yIjaQ2CpchtZ58KONQW/85NrqKfgrA=;
        b=CXGT5V7UatTuL03rhnhOxdcQyKHgCGNPdU1lLCXzgg2AaCaPpsRJb3t16f9x45T9Rg
         bun0j5QL3hCol45EUPa8bi76LLgxiLJhVI/4mmXiOuLIBjrPC5w7U6gS6vA35mT01NdI
         76CxX7DKXH/FJ4DATW9R0oDRrGWAClD34DIVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774368726; x=1774973526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7jtDWzT09fCJ+yIjaQ2CpchtZ58KONQW/85NrqKfgrA=;
        b=DEEjPZtPc8suCYVRqcewXSRs3utnwyBmHsYDNOCPlTHYI4D2Oi505VHJCPjD0WEh2C
         14OOs1mrDEpWeIKn+sYfFOmngtrd2Sp7AsqC3M5PHJjNmwBa8KMrnX/jAWED77izstP5
         hECTmh9GqxhFC7lqvP4IDZ7cxCjlCmO6jVgxGCRIgPRunyhRRw2oTN6hZZRnyGqf/Vja
         020t/wh6uNmHDQM/mSeDNJd3eM0WMB7qYonI3aFJ/nCpbL47Ozwb4vxienYOP53mp6XL
         gr5ZWaVnlwcsDKJ8yXk36RfxQRNlmitEAFIBSuJtRLw5aqQGPQ1Ax/+HyF40sHb32oII
         V7NQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/6uO/AFIY5LOnhyb1maT45dke4ERQ4w/297t1RqvtjHeu6J+kyLJydGCV2gIqNME61Y4i1LBw@lists.linux.dev
X-Gm-Message-State: AOJu0YwTJkcLPKfPaWUIJ5suv8gSwdKUF/006qX1HTX7OQaBHulaJ8z0
	sMhaTiCskyaEng/D0gwNWKdt9HdfL0s1ZqMJN238MsPt7FwL/99Iojq4J4gQSA5hBA==
X-Gm-Gg: ATEYQzx/6d2zCOcA81hSCukCkPUubxkzlFL3CusQYzW3eTFUa4I+GYGyLhqEmn72wpG
	7smrO81KKdMwTYTIwPqDbP9hiOTxWxymqHzPlBCtHMSBDlz/fY5YczPvsy1uX3S6V0c7NDlXBN/
	LMIftbvjjx9G+gy0WfYVht2wxkGdxflsJXzP9zmToM2eFNZawQhYYub0oMFZxiErJmM/NfLHaOC
	3h4S1GtkbRWsSt9/YFTHaJz5MxxGDVo/YLeIKme+iScllEWyeU1IWi75rlQbQeO/OnKuysSxw/e
	0Vt++VTDLALNKIYiPapeE/yVKcFoo9ogNSMTMrIPqOk30zJN/4t3euXponsNG5So/qHcJDHJdRL
	O+ky6LJN9pemnFn6UxYU2ASwDv3Lf+Y5sf79VPOyyhGFUCAS9RoFMOsfyn13FtgERpfQJM37fzD
	lOAceYDcADG/i5IfX6tIS0l5moUnQlRmvuKbb0pETwXzmF8apec3SH9hI=
X-Received: by 2002:a05:7022:ff45:b0:128:d51a:5157 with SMTP id a92af1059eb24-12a96f09443mr36464c88.33.1774368726341;
        Tue, 24 Mar 2026 09:12:06 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.122.197])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12a734bbb57sm11608018c88.10.2026.03.24.09.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 09:12:05 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 24 Mar 2026 10:12:03 -0600
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
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
Message-ID: <acK307B9c6KcJD_a@fedora64.linuxtx.org>
References: <20260323134504.575022936@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>

On Mon, Mar 23, 2026 at 02:42:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
