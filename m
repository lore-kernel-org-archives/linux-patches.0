Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B471D9664
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 17:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730221635; cv=none; b=JgILM7fb2O3onWBynUQxRissGuvl54ur4EsbM/GC6HJ65a0/BdTp2osZS5q+wApuvNMGTe1pI7Z9HIgi2rJjpu8kVKpeiMmzf+Lxi9AqoSl24KEU3otQvN6Yphwz5YR68RfFvwv33P+FvPqEGOcPtAMCOZruqMEQKdlE/WbRL0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730221635; c=relaxed/simple;
	bh=HIAt7Xdq33eEcSF47rRGWWp8L+H3VMAAWWAYqZoatgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kHYgOiC5SN1SD7Z6xdSpQnZ5NLvhP5Sric1pydSrmSa7KfT9VpQUNA23hPqebSD6KpL1k7fzSEGUiVTFUzRZH8qoa/laH/Dv0XIy2caQEzInliDwnDdatOOgsHECKm+ZWub1NA5pP62yFsmxbh/lLcdCEDz/ENKdqqPDWUfAv/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=UJCiDLAQ; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="UJCiDLAQ"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-83ab694ebe5so216751939f.0
        for <patches@lists.linux.dev>; Tue, 29 Oct 2024 10:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1730221632; x=1730826432; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=prNOXuzq2k9yHwgN9GjPKL//CDayG10KbbsLQkFhgd0=;
        b=UJCiDLAQxBKZqVou/AH5do+fcIXh/0fSBa7cqCrKdf0gfbTQllRqvBEzgcdJM+dQcp
         7AFxPYz1xFbklZzphbCy0khRYV/ake7SRStI515YZtz3Pby69bIaJ0DS2B6PXskfh3NL
         L/OFU0HEFagxZexroXlcfCV0uhFvbR6aLb7gs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730221632; x=1730826432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=prNOXuzq2k9yHwgN9GjPKL//CDayG10KbbsLQkFhgd0=;
        b=MBZysQZUIpYpyQOTIppQTfZsiRfRu1z21kqCPgC3FcgPho8B6TWXrIVAaYO/eA/rLa
         V4zesK/4KmUXhHvENdC4Li1zff0lll3MHf0egubexZq+PfUMS1SydalaqPsLtFSK/ogw
         UAN5DnzHpTuD4rHkJx7eexvSy36rl0ILX/5nXDu/ULbsmIkRdUbgtOja+Y6vBCM/dywC
         a94Sf38/U1a93GlyW99DH1UCnAmUyFrElakLMFc3TqnI7HmvV6vZErjaO4DqyTA9u788
         v3TH2qaXgx+OL9ikNPgGzqYAYbvxWdo2woz4KoKpRzx7ZSA/BXkpsRrwavTlOApHX/dU
         8vCw==
X-Forwarded-Encrypted: i=1; AJvYcCXcewsFxNN6gNS78gMpj2DODSyhAvI7kzHJ7PeMLwvDncaZEs/mne2+w7xwAGRO2fP2SAyPSAVZ@lists.linux.dev
X-Gm-Message-State: AOJu0Yywu+oM0h5zKAASb9fChDFzUgUEh1IdWDmK7xgY+W6+csJQfsqa
	rd2W0zVy5WKv2obeH4IQeeoTrl6EbXyrXRX53hiZ3hFf6yV6UdwSS+JBcJUKuQ==
X-Google-Smtp-Source: AGHT+IGN9Ci4Y8VOHnsfF3L5QUISAu+V1eVqvAiXjJUJFmaZ1nzDtFq+vrmYfNB8DmH4n9y6WW09Ow==
X-Received: by 2002:a92:cd82:0:b0:3a4:d9d0:55a6 with SMTP id e9e14a558f8ab-3a4ed2f4ad5mr120407025ab.19.1730221631706;
        Tue, 29 Oct 2024 10:07:11 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc727b245fsm2480505173.179.2024.10.29.10.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 10:07:11 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 29 Oct 2024 11:07:09 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.11 000/261] 6.11.6-rc1 review
Message-ID: <ZyEWPUUCBMQArAP_@fedora64.linuxtx.org>
References: <20241028062312.001273460@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>

On Mon, Oct 28, 2024 at 07:22:22AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.6 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
