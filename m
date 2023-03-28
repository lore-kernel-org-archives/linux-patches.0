Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2422F2A
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 20:47:07 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id d22-20020a9d5e16000000b0069b5252ced7so7091091oti.13
        for <patches@lists.linux.dev>; Tue, 28 Mar 2023 13:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1680036426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F9TqwHS5VwuEVtgFkkRpwnXddHrCsiKppKpc5MLhcFQ=;
        b=KFbL9xuwqXgkaPDPLXMmcQu+jorC1YLUIQEP6RSeWACsh4JPTSgbvYXhpotibsVLrp
         59dEDCVqWpulJ4I3nKs4YjftCfdzyuPAvAsrq4SNuT7uXcmPsSaJewBT9jJdngPHVWRu
         VAc7LwTF1/MtSynU+n4sNiKgq9dpJkntyJcD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680036426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F9TqwHS5VwuEVtgFkkRpwnXddHrCsiKppKpc5MLhcFQ=;
        b=hfmbsL0dIbHKd/qB2B+EOOevvohdKRk/LFSYoml6HEcMXkbtWltOVwN0rcHjvs+NG2
         YpQplhA1LtxXgpRCFeClX9o7WU9k3BoK/HivyKeU6XEjp0AcL92AQLNesoMWxoqTxLb+
         tB9htaIRSEQ2UwQDLbhtNuKW000BQf1Fj741MMOGRpRS+lyUXeU1RKDR6hsODp3zckKM
         55OFbUi1Uq+2ILENxW+KHR3K+772G7MKJWlbNHumVo2BE2+NHlxwwWzLBiy2YxAzwXug
         SddPJGKU1j+VzIpzBm9rT0fn6Dumw1Nh5W0hwC+p7TK5qMy1moTdpwuz+ufJ4XFUfXiE
         6vxQ==
X-Gm-Message-State: AO0yUKUd5vTjy8AJrsvyH+o8bDLvtkyVV5Zg6qo0N6krAGPToMr7jpkn
	b19NVY9IaFodL/HMOFCBtCMPcw==
X-Google-Smtp-Source: AK7set/VDHp+PB8OuqkSD6KOGOyXWkSsZU2I5b0CJcb3uf9UpPzC7sBeEYWNQ9FL5EgVF+JYxr99ug==
X-Received: by 2002:a05:6830:d7:b0:69f:afc8:119e with SMTP id x23-20020a05683000d700b0069fafc8119emr8493332oto.32.1680036426395;
        Tue, 28 Mar 2023 13:47:06 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id l26-20020a0568301d7a00b0069fa776d3c2sm6961811oti.18.2023.03.28.13.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 13:47:05 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 28 Mar 2023 15:47:04 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
Message-ID: <ZCNSSAzHmtTHCw9O@fedora64.linuxtx.org>
References: <20230328142619.643313678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>

On Tue, Mar 28, 2023 at 04:39:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.9 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
