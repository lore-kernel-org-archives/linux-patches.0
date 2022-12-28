Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB8C23B1
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 17:42:40 +0000 (UTC)
Received: by mail-oo1-f54.google.com with SMTP id e22-20020a4a5516000000b004a3d3028bafso2771331oob.3
        for <patches@lists.linux.dev>; Wed, 28 Dec 2022 09:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AdJW0zFNO7I8CdbGi6ec4i3VeAiyzncUC6V1niYK8jQ=;
        b=P+RN9TABtn7zrlQP9gYBpowkXv1j5CEMhdZM9/s14urNSAzOWgvEluGqgUz5hrIAKk
         oJPOLhQ4bWD1y4mQ/1y6mPUwtXAfGtH/INRXFF1tA2oFTJRg4LmS1ghFQYEKqDKoXwjW
         LViAvg3i09F3qjetes+rpzSUs3dl3zc2vH85s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AdJW0zFNO7I8CdbGi6ec4i3VeAiyzncUC6V1niYK8jQ=;
        b=nGxUt2x3Dq3OnykRWbEOP/6VwSBB+e4Phli/uNx6//3R34Ci+T4EwuWpiGD9eCc1C2
         6bo+06PiHF5tFaCC/7ZiShXgXTPqu2Pu1bThMrYOvaHZgtm8M4hEz2DrDOnYEc70mKXB
         +N6J6bdLxrP1nXrdSsVMqR3KznOzTAmZdAMiMgenMpqHqbG1nP/TamXFy5e9FsiCpgyD
         JPSDLY/qEeFPceBjb/NPTw9ULo6Ua2BrQ58NMnjcY/VAO7DnxF5PCISCTbuUa9Rt9WIX
         6JM15X5FnLDa4wYCv8Am1Z8ZjSK/kB/v+vloGL5GIyGm5l6/iBHdQ4twZV/j7F+idSRi
         RjAw==
X-Gm-Message-State: AFqh2kpu2CZ2oTVbkSrF8Ph89fbcnzgteXhX1UVnC6/VcCxkRaePzSIQ
	agO93m6JMV9H2NPlpc6cyk7YVA==
X-Google-Smtp-Source: AMrXdXtPdlVUzf6XwhF1skTZyHCzRpQF3sEO53N2Uh800gxau6EksX34u9u+mBC7ouSkTo1k7cWpNA==
X-Received: by 2002:a4a:dd98:0:b0:4a0:1897:d467 with SMTP id h24-20020a4add98000000b004a01897d467mr15368052oov.1.1672249359145;
        Wed, 28 Dec 2022 09:42:39 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id d18-20020a4ad352000000b0049fd6bfde95sm6705149oos.26.2022.12.28.09.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 09:42:38 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 28 Dec 2022 11:42:37 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1073] 6.0.16-rc1 review
Message-ID: <Y6yADXdrUQ5I6snV@fedora64.linuxtx.org>
References: <20221228144328.162723588@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>

On Wed, Dec 28, 2022 at 03:26:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1073 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.16-rc1.gz
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
