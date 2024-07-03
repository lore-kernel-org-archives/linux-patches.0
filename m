Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133931741DD
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 13:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720014037; cv=none; b=lzdnSgGWfoBgOnlrHiZamgFLUcb4GeqJUlL38m/RxQGozMpzwkvQt4J/OX82TOvRT6rJDDapeTksJ9bMSpr1ad4EVJUS/bEvXFe9s2oVvho6czRgtfMKCA6DuCgbeOJjqsc/IbfCdIKzXSoYYoB6dkVvzVqBE7SjyvF2Kr0RJE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720014037; c=relaxed/simple;
	bh=v7wwnRICdXXjAY6LgmjAdX6RgRmXLtgDcP5J/fl0+gI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Euztr1oAkxqiCPONG5uPjVFl1zlx06VldbewZKfjbu2SVtSLmki3O4A1lbE7QQotXJH7fnmArm02j+l8f5HRwqRMRg7X8qgda6fsu5643siigaZ9l8O8HeoK59ASPu7h0FJxdu+B/oUcZoUazyZxNFqljKg+SPqDK7x2vhl542Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=hggVoRB8; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="hggVoRB8"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-375f5c3ddb1so21824615ab.1
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 06:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1720014033; x=1720618833; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sqM6xmAf2FrVXZ/POZdTnbDcUyqueEVyejWAoz1akso=;
        b=hggVoRB8WarX3o1YzAVIg6ewldmuqjBn4lXvpuzIhXjL40BMj3FqnxgcosJDUPFnEY
         i5bi1JYlFBiab9thbMcK8fJRFq1linQiJffrlGIC5RdRMeR2oYThrJwsSIzCDwVjU8jD
         JMu+Mp0Zv+pEXy7O3ksMH10Hc25m/YW4xleks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720014033; x=1720618833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sqM6xmAf2FrVXZ/POZdTnbDcUyqueEVyejWAoz1akso=;
        b=hiGRysjkU0TKD/eExHbsiiNeLOX9E+ap4HzXIGVlD7D0hPoVPu7tQX13e6Z+WwaLCl
         qRRxBStCxNyiypum9cMv7xSB6Jw0p2URKVUw9tM0uVszhx8lBuMWj9l4Eg+6noNbOQi7
         4yaNvjXOAumooMQRRzxOaxlmQ3Sifs987OK7w+HsZU2oCgahCa+NRPtUUf5bwQM1w1+S
         rHx3HOf19IHjoYLzcRXogNJFV45FWdbBSNEtHdFv/wh4fEzPf/oPNYmPLF6/hAJbcA/b
         iNVLUEpqL7nkowAvDs2lrJyTR3JsQBJlJVE2SChq/mjJSQJaqJIh9nqdnl8dm1fAJFRP
         G7tQ==
X-Forwarded-Encrypted: i=1; AJvYcCWO5XjqkzoTPUItI6FWThZ1uJiF4kB2cpjnLPxdHdJPjLsGRgiW9cuLV+AAevzr4mXHD9Q+YxXe0WM83DJz2DUhdVco5EXLPw==
X-Gm-Message-State: AOJu0YwuKWb9QCoyltYZSQ73wPHW9qb2DNZ/yNKxFwL7FgZhJ3HPFCUl
	d9UXye+jcgNuuiOF5MBhJwsfRCmuVl5rlY3ru1jpOgXD9VQRqaOJ7DOjN2sxcA==
X-Google-Smtp-Source: AGHT+IGJTLo3uW4neYggrSnFI0GNTTvwL1bgoMUMB/opYf7ZK2wNJ8LlRk6COAdB+OwLjbazDn7txQ==
X-Received: by 2002:a05:6e02:b23:b0:382:3c83:6acb with SMTP id e9e14a558f8ab-3823c836c93mr16197865ab.8.1720014032970;
        Wed, 03 Jul 2024 06:40:32 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.171])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-37ad2f41391sm28762095ab.46.2024.07.03.06.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 06:40:32 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 3 Jul 2024 07:40:30 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
Message-ID: <ZoVUzgPfv5miFnWS@fedora64.linuxtx.org>
References: <20240702170243.963426416@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>

On Tue, Jul 02, 2024 at 07:00:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.8 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
