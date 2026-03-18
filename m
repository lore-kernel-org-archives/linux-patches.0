Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D5D17A309
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 07:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773818175; cv=none; b=gRCFEk2YVuFBmIn8baLYw5ffARzc9JOi+jnsPMLYEm2fRhKTtxP8Fs562I2tOfyZ+9+VexaxqDdt0XX6JE3jNtyduRX+J7y9u7kWXtOS5T2aRN5Wudq3DNLeei/jy+HKzyi46POg7ars12LEJjP6GRf9Kh2JjGPI5EV5Y0qF//Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773818175; c=relaxed/simple;
	bh=DnxEnemkB2WH/Z/UoSAWJTNRzqVI9q6avWpfXrDlFw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nEQcxg7C6omopxYl0w4ou/41YTBJPdkVuj2pan+prTlvbx1BK4cquSADpTqAE9siZgjC3J/LQxEeJ+FHGGtsHOecxGZ2hd8KbReejVnv8goD1NJST7AB9f5l+n4US6n5hYwVS8vwTTfKIy4NW4zhzL4Qh+dYhWLnx6k/nR6gfX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FyAukJb6; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FyAukJb6"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43b40fb7f95so2924171f8f.3
        for <patches@lists.linux.dev>; Wed, 18 Mar 2026 00:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773818172; x=1774422972; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YuswB05nXpaspdO6YZ0AYDzRRQbxug7MJJF7jh6gDCA=;
        b=FyAukJb6fdBfJOpy6+tD9v/o+3YPudsVzOdRjT7TB5REhwbbtrfFU9hNSOnLbiBOyG
         53u+gByV0NsRzomgMR9r8gzeSc+INk+x9w9OfhI7xLUQiFnsZ2rVyLxzMSPyHYfgiKik
         iArNaOcegwDF55O4lT/XgseAfYfARH97hBep3JTfTMeFIuBg4xBoSFiszVs7mgixBz3/
         yllZULYJt2L2XL151sJV5aE1YdfKJgCX15CwfQ2SnupQ2JaJDmypF3WQ772K9AgGiENE
         Hd68Fplg+2LaOQnK3yVpI55iwJlXmebL5Ti34OjwQrHfrsPefw03mEB9E+avPcnmnaFX
         jO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773818172; x=1774422972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YuswB05nXpaspdO6YZ0AYDzRRQbxug7MJJF7jh6gDCA=;
        b=WIaJ5+vvzk0dXtJRjtXrtAI+os7/tvbNvDQYUJjSMhcc8Pbogl81ZR3gKYW11sLVOL
         sc+ieO+5h/GJ9/bY61JuP+sT4N+M86W1VjGrE3TZ6sBCXUwRVEhiEddwy1a35Ak9yfnj
         5DAD1Zq6zVM/XwFJBRCiP4s8Ny86cculr+7kgURtvrpRUQNlJcMMf2PRrb+o6+eImY/0
         2tW4XGrfRAOIS5PFXZ4AB2LuODFH1K+IH3TCEbkZZLsQ8caQc0gKHN5Jsk2gS6z8E9cn
         DGIUPElBaqkg4ukSKEeOdO/vKwq4WnY8yx256cZEfcq2rvGUrN7rhRHFxkGFz8i6NVY0
         oxyg==
X-Forwarded-Encrypted: i=1; AJvYcCWWF6+0lJAUJzdOmDfveiix7rGRsarvUNqsTrdqVJ3SOY6B5Jy7RudKDjghkR1JnPNwily5xYLD@lists.linux.dev
X-Gm-Message-State: AOJu0YxDIO66tm6UTUDTNWL5TfRr3r6BWOvDOTHoqAjJyRaU2v4r8s/E
	Wt5NDeZgDpSg1QBBOusRzENFuKE1kX5kMCCkTwenGLrHlku/Owwz+9JZVh4e9Eu94CM=
X-Gm-Gg: ATEYQzzYFfHjo9h3pmyUzdmWgrUKOl5IZbZCIFmwXbM2nVB5vo1MtdfDsva8mGMNUKO
	B4yLOegOpwqFUO7xwCTuVBZ63sZTtMGgaB2yDB+X+Sm+3hFB5HDQFczPhh7e/VZBvWRqMQ3BabR
	drPsGQOHMk8Ji0JnlCov+exYzQWAWCBoTQyA9RhH2Tkz2ogbYDBdQlevxqbffGV48yME+cwoHWZ
	hYqXdswnrb5PbCEYRz6+mHbJsQBAg06ksDWmB2p7gzMO7EbXWo0ReW1WrGnksb5RC4f6Xd50LQY
	EuYZtvH/osMdvYQSIgmQ7krXsytXwG6eonLKinbnAZ/IGVHVKmeJTk+qxfYCNVTVVvlnFfuBfpG
	dblBddtETbgXsVoavQx7aOCgq6zV0aqblGfd3SrQLwOI0OQ29jnQ+MbPY2MWoHXP2V4KpX9kYA/
	c2AO2iOdkmW3IjBz3y67rmHmvPOmGdVA==
X-Received: by 2002:a05:600c:3b28:b0:485:3aa1:a7f1 with SMTP id 5b1f17b1804b1-486f441bc51mr38158405e9.7.1773818171752;
        Wed, 18 Mar 2026 00:16:11 -0700 (PDT)
Received: from u94a ([2401:e180:8d6d:4286:a96b:a815:7332:44e7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c741e54461csm1459482a12.15.2026.03.18.00.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 00:16:10 -0700 (PDT)
Date: Wed, 18 Mar 2026 15:16:02 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/378] 6.19.9-rc1 review
Message-ID: <2t4msypqkqfuclftuorojbwk2o2asi7qgudwwdwouljindynyk@bwza7tj64vws>
References: <20260317163006.959177102@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>

On Tue, Mar 17, 2026 at 05:29:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 378 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Mar 2026 16:28:59 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/23211625016/job/67531397718

[...]
