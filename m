Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D7D85260
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738334853; cv=none; b=FALWUowBPQWXOO+ujYLS+t2uQSFcB+uMUxe7maXEaRcEinlekhMaqV6FVDLoKuewf/i+PW5PANUQzuQ+jc4uQ9HocXX4Kao5RkZl4/Mads4qiy+TkdT+a7eRBTwo1DUqMjF/czO9soAp+xpxFNgUcMaDrjZ1b0D6cAQc65tsbyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738334853; c=relaxed/simple;
	bh=3OkWV1e6WZQ/dF5Yn5YAx99NLIo/IUO/RUBaemGuqFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BMXVtAQbCZgKTIvd+aKtwDlYaHa8Y7EdEISRSSOhIBrSA6wcQmYSpUBn7svCfQYa85n/1/+ps7xwa3TMyAlR3vIfsb5M21H3oSPkseV24h0y1lPw1LCY3c5MQSN62Bfeg7aD96vQdYJN5ceD9gHk4lnmmJqW9h3lOmJyM+7Nizc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=SQbmYVhh; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="SQbmYVhh"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-8521df70be6so161395539f.1
        for <patches@lists.linux.dev>; Fri, 31 Jan 2025 06:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1738334850; x=1738939650; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J0i8jARHM9o2vH9POVudqrpVADfjg+0Wl6rXBt3YUB4=;
        b=SQbmYVhhb1zmTKGSLuj3vG7R/oXpjwCix7Cpenf3qEIsWS3yoWmA8XzLE9z/jCPb4Q
         J6HiySxNOIZAfY4d+tVTn6s9rSu3Q9Ci47WG3rX3PfPJxeVXhkFq7rN6WbggcaxzcdHN
         W90OxmhUNJ/b0CjJgm7BbTkSxNLN+RXIARUw0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738334850; x=1738939650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J0i8jARHM9o2vH9POVudqrpVADfjg+0Wl6rXBt3YUB4=;
        b=WDMscRYB4DtJN6txmu0JXGd4ppngcHORfMseZndje0SqUTpYlwPq6TkfuMkE/mJnqE
         fMi7IAYcrEW7fSlxGA3/wmsYsrS4fFSBn9G8WFN6YbIObmTa+Zp/y1MLc7IEsCipfDuu
         ftZUGzjiyy7PG7PS6DGSUNNcFy5GNsfc50VDbLYBIyiZLRvgIRIlwfEDdO60fPn7RkQY
         Q94Z9/u4ahXMYFuf8Iktw64Oc6qyfOySMS39lrxqpw0JxHtuRlvSYFRPEq9ZtBAd/hfI
         /GlPcm47zvKdhWKmjvG26R7jAZq0RxAg7tTbUdM6CPDLZe7eM1ZHteTUDcUa2vPkYzKM
         r4/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQBPII2PTk7P+c+ZXizIQrUuQkg5Q+cVmvP6vlDC0K613eet/bH9v2bPBh5aucLgBUN2JQsfLx@lists.linux.dev
X-Gm-Message-State: AOJu0YxjvuespMEzzdsRS5toNyvQmRjMSMJ4KT847RjflRWd4PZEbW1Q
	CuBmS/y9yP1U2u6IqCu6sNItKxmjNXaMK7DuJjLODtaWHA9eMdu/FJ65bt6BwQ==
X-Gm-Gg: ASbGnctxA2bdheunHqNlY690IgnmVYzkj2cnhWAK6gh5JfRp6l/7/uk+zsKn2Y2yCga
	QArmf/FItnNCbbCOCmkd7d4JTnDR9zu+GaYeMaS7EiZAmffLtLOche1TseeIhpnl4q9VWaVdSL+
	hDW44VwpFhKySymKWzGvZKHzSlVj6t6BEc7STeSV+KRxJLlr+PHE826DKC3H8u8Et04B+WtxXjF
	SWk5jNLWKuMddRqrdcQ8xMc1U9kXK0gLdY8u9e1PRpwqengCrCa2ZSj7rhsmrZuEP4/6atuzeQS
	JL3hqXJiIShLysy7+mi9/fLpJFAQLi/v
X-Google-Smtp-Source: AGHT+IH6BGQGzWRpGFP2/mx32I7TRFgh3qostrn98Keogfw3HieRqTGh4nJPUiH2IEzE1d6C0ug7kQ==
X-Received: by 2002:a05:6602:36cc:b0:83e:418c:8a28 with SMTP id ca18e2360f4ac-85427d799cfmr1096773139f.7.1738334850633;
        Fri, 31 Jan 2025 06:47:30 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec7458ee70sm841402173.18.2025.01.31.06.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 06:47:30 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 31 Jan 2025 07:47:28 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 00/41] 6.12.12-rc2 review
Message-ID: <Z5zigMpU7NyKYGyh@fedora64.linuxtx.org>
References: <20250130144136.126780286@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250130144136.126780286@linuxfoundation.org>

On Thu, Jan 30, 2025 at 03:41:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:41:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.12-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
