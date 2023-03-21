Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DA38820
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 23:13:04 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id s1so3057561ild.6
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 16:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679440383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUNVtXTLAxWYM0b/A1ZTGJcL1PBuc2/bSARaicUf2+w=;
        b=S8Gv/Ta5cHjRIJGMB53cTEO+K/BICRG5/WYhjakfVrvdZo1mTjMuZOIdPIAt1OQOs5
         MHYKN2GBec+ySZnKTW2B1GX9Q2919smFwb0Ty5DCyW6jHcuy9bg8Z+dFW+w2r+O9z0Dj
         DDA4d9IOVem24pcp1KCcQ05eMjzGJwJRBg0Yv1fwvYZ++OsWlf+1zGo0aPO5ATnpa4Nm
         Njjg7G4mHikwtJE+l8dTpqyMNpt1sZhvb9abWoonRFI7c6opW/8M/c36ezKlwxfXInWf
         XY3UXiQz1jGNst0ewEVIutHYahcnafaZ0ZSw5SOsVQiZ70wG2Ubg3KUQhDYiHTvrckvC
         caNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679440383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jUNVtXTLAxWYM0b/A1ZTGJcL1PBuc2/bSARaicUf2+w=;
        b=IM7xwhuq91SI+MPFe6R0J/m5Y2F14Tpp55GvTFRS05HYw6V+DLivhs2HI5G11uknTU
         iqYm9t/VE4656gGxu0nAS5SUSuem8tcQWPMPz/9TY6jSfoHlDFd7F/P2vuo7HpVk6vnH
         GQcOCzMRQFs9IE3r9MawK3puZFhoP7gZVbdN0nPtPJjKIls0KwE4km7HA98k/SERPuuA
         qX9ff19vxYmkv8cUFyl25m6w8x7kEcNluyE+McsISbB+i4jSfz9AMZKth4NM3Ty0NtQ/
         oD6LBMX0OHGJxWiWAzdEuAKYdiB6RvJAc+YTwcGa5PaJiK79aD2ECHcoRoiOGg4MUBHu
         m0hg==
X-Gm-Message-State: AO0yUKU1NdphbkX1dITRNeU5MYKIwsF4DDdHZogZN0yq3jGynxfAbaPC
	85f9z2J/pq/81WfYUBQVP3lpNO+VYJA=
X-Google-Smtp-Source: AK7set+Azzc9dn3DEe+Bh29zBK8lHCg17Fp01fnoimMKptZhooGN+9tJzx89MSB7bKAQ5fi4AW9geA==
X-Received: by 2002:a92:d3c7:0:b0:315:51c3:2ad9 with SMTP id c7-20020a92d3c7000000b0031551c32ad9mr2815805ilh.21.1679440383151;
        Tue, 21 Mar 2023 16:13:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u26-20020a02b1da000000b003a958f51423sm968487jah.167.2023.03.21.16.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 16:13:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 21 Mar 2023 16:13:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/36] 4.19.279-rc1 review
Message-ID: <865c1eeb-1efa-49ee-9508-c25fbb7d833f@roeck-us.net>
References: <20230320145424.191578432@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320145424.191578432@linuxfoundation.org>

On Mon, Mar 20, 2023 at 03:54:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.279 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:13 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
