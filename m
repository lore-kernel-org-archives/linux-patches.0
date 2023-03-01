Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2028323AF
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:48:52 +0000 (UTC)
Received: by mail-qv1-f52.google.com with SMTP id m4so9984697qvq.3
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 10:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6WiBSXa+E48qQYLm/lnScVBkZgoH3ONEJTiQuXIOskQ=;
        b=Bk7Ud611aQR5ZxIg2XFDfdz9bwBG0tQT87zZDFD9qQttXoomfg2yH+AlUwVKtMNtfE
         ohw6GkAbYvDUbCa4PAsgFNk5x7ViEox7Kw5xU378idA8ySHJpyWYzlZyr050/H97thR+
         RzrEmb7Sj7MYb0Zqtc2pAac06tiRKn8BF3FX5b24JI3VrS10L4xOkT95jrpkBcSScVST
         NTvbTG8CnZ0/A2LXceQhN2LY8vLIdspPSiSyim6K99JcwhE9hvz++o9C+iBkvudWl8cQ
         9VYy5dugs4RbJmGzGsM6aJNC+HBMGHiSv+/zBgfJBEVQsDD30+beVWeB3Caq29xuYtKS
         RdNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6WiBSXa+E48qQYLm/lnScVBkZgoH3ONEJTiQuXIOskQ=;
        b=1O/RQCxo0RYlIbqzuNKTCsOAcwJURkEQMFRalAq5NpfbVenrn7B2BGsfOYcv6bqf/v
         LLQNpfI93bvH1el7vP/yvjb6jTJi2GgovBcrZYgCMyd/Z5rMdvFCzpxv+/zOKs7oX52c
         mxIWri/hp83zpGFYMUJ2Qu4szctnpuJ/SuUGw5p41NikASQzjhkPpCHukXvmarzlIuIw
         Xp+/cf3TrCu4Qt/e+OwIIHHht8wEctLs8gpgNnh00AFIbHwuhzhG8nZ6Hel98GD7YMhR
         YLk9gnJBBZg34MtGtlyy2g99EgaCw22fw71BYduIcRjoYhjnLB5bthB9JXUWdRDbRUjU
         7xuA==
X-Gm-Message-State: AO0yUKXL7SsUa15ofEMKM/6LjXvrGAXz3IiKlfdHexc8t4z4EKO5hPiV
	GFMV1DxVJf4Yx33ueeL0GZaL1Q==
X-Google-Smtp-Source: AK7set9Q32uKpAGHSv0HyLYBLlDB6Bd8twTYxngWaj1UeSvkamYBDRS6Teq/thgmKhRh2KboWK1nbA==
X-Received: by 2002:a05:6214:2a84:b0:56f:72c5:e085 with SMTP id jr4-20020a0562142a8400b0056f72c5e085mr11758973qvb.52.1677696531844;
        Wed, 01 Mar 2023 10:48:51 -0800 (PST)
Received: from ghost.leviathan.sladewatkins.net (pool-108-44-32-49.albyny.fios.verizon.net. [108.44.32.49])
        by smtp.gmail.com with ESMTPSA id s62-20020a372c41000000b0071eddd3bebbsm9296942qkh.81.2023.03.01.10.48.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 10:48:51 -0800 (PST)
Message-ID: <1b33663b-0418-77af-3417-dff4b869f4c1@sladewatkins.net>
Date: Wed, 1 Mar 2023 13:48:49 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From: Slade Watkins <srw@sladewatkins.net>
Subject: Re: [PATCH 4.19 0/9] 4.19.275-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de
References: <20230301180650.395562988@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230301180650.395562988@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/23 13:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.275-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
4.19.275-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade

