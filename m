Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE912F7475
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 22:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761951501; cv=none; b=DB47tOWCfCpGbBObwNBYZ4P5F83wiA1XpccB94LmLyP1igjnut6iycuhMjQuXIf7v/JvcdyI62TXTVI2ubeUN5rCfdxJfZwBu9PHN0SA1wUjk/ctZXR2OfR/DEdNLvAaWjU63MVdsdiCsgvxxpelrFMw/ukJC02eLVNnnVegfEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761951501; c=relaxed/simple;
	bh=cFcjY5xhnj0bHFmoZpuKhefy18W+dkPGLsfStYZg96A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iVeJPX65pE3xJ6DZuS7fGAEH/nAESK30IA7ml5Li4DJqqmg5NQ49MRvZpXAyc/t+mhE+AKtrg0NimeV1jSxXJ9gOL4PXBOnGsSBDpEhQ+xBKRoe1oCqN6++rP+OwVTK5NCtG0yI9YSPjwBR+mE+EiLM9b6m73/KKbZIEJDtkMds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=bIw1wy5S; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="bIw1wy5S"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7a28226dd13so2779934b3a.3
        for <patches@lists.linux.dev>; Fri, 31 Oct 2025 15:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1761951499; x=1762556299; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rTbu2Y1n3nG2K1ZFxQ3ZdRVxmOMkuNF29G4mR+aamAE=;
        b=bIw1wy5St53cD4SstxCSak8k1Lhrd4yy63tQ3I7JfK6JeBwVQxa0uPTi2xvp8iueXW
         3IhM1Z5iq/Td+XtXH6jyn/+BJPDEayTwBa9pxgO7t8/qfwe87JwJK2YoRvFBtd+MVw+e
         5RISp70jCdtEGrv/zXsC7oBdWlmKncu4JYTzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761951499; x=1762556299;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rTbu2Y1n3nG2K1ZFxQ3ZdRVxmOMkuNF29G4mR+aamAE=;
        b=HAyp0RMjJ839tJonszGaGG7zvgqNLYqBerY9xw5jAqz3NbzrwWZz3oBysHZy1MYzwL
         iKyRwp3KVhRtAw6VHMZKbbV6dqvK//t64moG2C8lAJcNRhow1KXlqUWtJtT6Nl5yhGtn
         MJZgrG7ZzhtcZo5CN+6qv6V4+BkATeCTUa0ytBceTiLDhplngr7DeUHcc0QZEUa01hD8
         /bfz0glS0fSV7O13ZxYliSqFOcfeNElSRpHKuDXy6BAtwfz6D2wQKbVhUFlXOMmMpgk0
         wNgcxkRC4b0ITts/AV7aTrUBugnB125bI5Z9SD/DN1QHNh68u1XVFxBKAfdHBqnqVIF8
         7vjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAKMcBA9eg9TctD8fdvIhdJzDsMaq6Xq9GbNGCXgvaqXAj1kVnUHis6D8oQ0tseO5dlvIviQFq@lists.linux.dev
X-Gm-Message-State: AOJu0YwDXaF/fl44KGAKReGj45vEumiUxe3RnaDTLXsTE8fY1eaxrWaQ
	GCLlU1yGbzC699at2vkR1YYYinwuPKiGYtaGBW5ORBYkcPYmP1rCAVAmW2424iEoCQ==
X-Gm-Gg: ASbGncsdDMJ2EIVUVBgNr4QVhPcVhXbInt4MQcPA1chXNOp99qIifM1g7Rty3w2vCjz
	fgO0novHBsTYNWe52Dg7P5z/gVJJtdiKxrYxK3Tk3djvvCCGZy1jGIqEuYmTjKeaSjuw7YvUVoe
	iCv9DBdyGj/QGdEIvS9eWcG0l+id6kiElbzCNIEEE+xlc/w2aCXPIxIhBqLGTqQqRCocFvdEz7+
	0kUoRda0dNH/dHR+Y9jImxVU/hIBJ47wL173vzbVRWrgrQ/ErNRnGyYpF9dcUEK66dZzv8Mc+PQ
	vKygQnwIa6PfRFoLT5/OS3dlNm2gYx+SDOFKWp7O1pcWEKJ+MzAy1bYA9PiVPkenymD7eXEp4jU
	198tlJzh5cG5qxMkZJ+SRD4M9+BeI8oMRuG+zS/1i419yVwCcXO7aSAUNCgIxSkrevBDLETvwIM
	Ej8qMuR3tBkIbvFojuLIsgIg==
X-Google-Smtp-Source: AGHT+IEdltx1Q3f4Um5OVUeI5/5FIMfij3hj5c6VggtsG02XE+ivNwh5P2yHEG2MIlLPxJE7tbWO3A==
X-Received: by 2002:a05:6a21:e098:b0:334:97dd:c5b4 with SMTP id adf61e73a8af0-348ca969008mr7483131637.27.1761951499275;
        Fri, 31 Oct 2025 15:58:19 -0700 (PDT)
Received: from fedora64.linuxtx.org ([216.147.121.149])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b93b7e1afbesm3206235a12.8.2025.10.31.15.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 15:58:18 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 31 Oct 2025 16:58:16 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
Message-ID: <aQU_CBmRIwx4ZMek@fedora64.linuxtx.org>
References: <20251031140043.564670400@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>

On Fri, Oct 31, 2025 at 03:01:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.7 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
