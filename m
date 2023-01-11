Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B798F33D2
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 17:25:18 +0000 (UTC)
Received: by mail-oo1-f51.google.com with SMTP id m23-20020a4abc97000000b004bfe105c580so4207397oop.4
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 09:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lDHX0didgEx7NNXd2mrLuD7KLRze3bUT5PfKEBhLQbk=;
        b=GEMbsofdELSoxX5S302sWGhE26vk8y2/1xI+xpXiA51vd2F80yKKK+QTEvts5z91n6
         nrhMzwwNCgHN3c0dG6KJpNgDp4A558eZRvHS64j0gF6vCdtzjevCrIHOpt94/rdfCltQ
         0dyzaHqgc57iyUC3Rpc6KJZ9ad746SsOYehZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lDHX0didgEx7NNXd2mrLuD7KLRze3bUT5PfKEBhLQbk=;
        b=DZniWb+rG5oV5dcrr3y3ZPdQUgVb6C+cjCjaxoxneuwCrtCKkLGvw/fzsUP7cbOMAw
         wHKgyiHpfj942PEBfwyE6o8McJwrWorw0ZMAea8FC05AhfHfFMmATNUnjKnKHCW1HZrR
         6elQdnKXDA4bsnay4Nx3z0pG25qCwNq1Vo5XfFzUh8cmaHpasxj1z+A0WgxYHM/2LeII
         wLMYKXrb2Ab+89fPl2dOXfujTrYI8oVbuXR/DuYJXeYU21//waeLQKWLITnymFVn+Aco
         4ZEFTNvFsVV88i6CJ8OGYwITzAfQuyNbme2nZKwz9HjH2puJme0YtOJsSw8+Dc/BwzFh
         3QAQ==
X-Gm-Message-State: AFqh2kqMRkUajnyxolVyEFdbsDAYnWCfyEhgD5cvy17rcj7uSVhyHVNe
	qUhCcELRzXJQMVrln2OeNu15ug==
X-Google-Smtp-Source: AMrXdXsHjOAqQ65hK+eAjJM3izvsckhP1hCa26zI2DqF0gCiZsLYEJNJMw/d/RVb5QVSgXxHfpkY2w==
X-Received: by 2002:a4a:ac88:0:b0:4a3:b889:4c21 with SMTP id b8-20020a4aac88000000b004a3b8894c21mr35113344oon.0.1673457917580;
        Wed, 11 Jan 2023 09:25:17 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id j7-20020a4adf47000000b004a5a69c1861sm2689702oou.22.2023.01.11.09.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 09:25:17 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 11 Jan 2023 11:25:15 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Message-ID: <Y77w+5mqOR+n5G9K@fedora64.linuxtx.org>
References: <20230110180017.145591678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>

On Tue, Jan 10, 2023 at 07:01:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.19 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> NOTE, this will probably be the LAST 6.0.y release.  If there is
> anything preventing you from moving to 6.1.y right now, please let me
> know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
