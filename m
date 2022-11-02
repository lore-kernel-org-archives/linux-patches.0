Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFBE27701
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 20:48:15 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id r83so15112oih.2
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 13:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1R+kPdUwpILgSxzae/u/gpRu4jldLuHqjWFbxDw4WVs=;
        b=V9JnLImy+JyZXXXE/VotKasJjk7dEVynobUp+nN4iVZ5L8Ov5fs/OL7IuPPFpTeCHP
         CxHfsyshrcEN3YZNnmQ9x10WtyeHrezctAEsLH5/4Qt3zmSw0desubheZgVcrhycoBsY
         LlOW6WxoAuyhmSZfwmq6hnI9umxALGdSZfB58PH17Dk7q90Psm46TbfVw6Fzo1M4+L1F
         2vJcwBSqamCQTz0gZBKM52ulds3tou64OvWXfMagbiHU/krccTk/Pw/lm1hhOMsNmuG0
         nP6aCMD+LLuTCsgfmB3rh8EWMPGS7AS4HfPa3j5jKWLSxGfrTthPGhZOo8TMcsO2+vE7
         NE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1R+kPdUwpILgSxzae/u/gpRu4jldLuHqjWFbxDw4WVs=;
        b=5IYZqed8vOc8zPj2MnE+Qo7IChvTw4O8bm2s0a/K0x6yFeaHPnVOlaGGGq+IASKm/f
         SeXQpzjMHIYT+utNYd/nNjpcKWL7HUdoJCebIJ5656kEt0ACD8LZzBnNtOW6ewz+/rhj
         BQrGnVbphSLZi/+y15MBbg4y8lCyBmolFr2Uaew++2dyJbJEN4RvYyR+2XVp0J/F8MuI
         P/nSeAtKljiTKLuTmvBiXvJgn8/ffxlxQh0yoXlD+Jf4dBDNDMj/3PELsyvOKDEo+nRL
         C8FFrXy4+t/llZAEt6oIRJXCQqIyyPjqP0Kn2NkhNBnhoTi58mu1hk0wNSDedD7dY2zC
         UQdA==
X-Gm-Message-State: ACrzQf3FWRx7sJNVCe7cV2jTOUXHG1OUM+jZO0nKv08PA4yYP9Y14Knz
	qcSupWGwM/iqlHnRX8mQyHA=
X-Google-Smtp-Source: AMsMyM7YjsxFiz6JcexC8tue/fTcMAq7RLth3HOCMWC5GYPADqBFwBpAh+2MIPSNixPw0Cx6asJfRg==
X-Received: by 2002:a05:6808:1527:b0:35a:4051:7287 with SMTP id u39-20020a056808152700b0035a40517287mr2365779oiw.5.1667422094783;
        Wed, 02 Nov 2022 13:48:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s6-20020a056808008600b00354b619a375sm4931739oic.0.2022.11.02.13.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:48:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 2 Nov 2022 13:48:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
Message-ID: <20221102204813.GH2089083@roeck-us.net>
References: <20221102022111.398283374@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>

On Wed, Nov 02, 2022 at 03:29:35AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
