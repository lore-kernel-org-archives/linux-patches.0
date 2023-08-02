Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFE6134B6
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 23:16:46 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1bbff6b2679so3147975ad.1
        for <patches@lists.linux.dev>; Wed, 02 Aug 2023 16:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691018206; x=1691623006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AmQD1D91D22XtFsCLqKfkymZHSPkp3/JUyiD0yuHCPY=;
        b=R/tnLvngHv+w0bDFSVAreY7Y9/Oj3UosPTDbtA6wO3Xz7HZoNlilvUIslFvphTDWm+
         IkRilwqgsRGOGDhT8F/a9mVILTU4LUmY/mDOTVB0D9ueSeESkwlu4VpTkf/r/erfojoO
         owMRSfG9O/fm/c4Kk84nqzOdzC6xwynNcKVjpljla1n/2N2pIkMFOTLhzPVkoynuTIVO
         /7AVM+CHwKFK8tTGSHY2Tx7rPITf1PpwiisQ6Xw4MK3EqLhcwmJlznIAcR7L4VdoPCpB
         ZVRQY2LTFg2lpyw66s46st5Jcx3DVkiTepKcRBPWpB7FPTOv8nXN1RIiu366AsP+zhuR
         SjzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691018206; x=1691623006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AmQD1D91D22XtFsCLqKfkymZHSPkp3/JUyiD0yuHCPY=;
        b=NAgUp1ftOombGb15+X2ZLJYs0PNSubxMNgT9fOPizzIKABx4/gZ+czYDteITv8A9PZ
         mkJQCez7de7trh4kIbmykgxEW6ZeW8m3cuSZft6r7CY2o3d6wjkOeV2sQFRo/fgahavU
         DcqVNmHmKTWiK54WibaaVAs9QJU+DtrN035jZk7RNXBV1gL/E1OvBR1E/3J/nMHNMSn2
         pHAtfqNhjfNnmeRhKwORMHt40XZAx6yX56oikjAJAcoYaCd1V3Hi6Cz/yvhZ5v1SXezQ
         m39+E1xOd8yi3hsWQhZJR2QQ1zJn2/fOBAmNm8Ot4UnWbMtQpHgInrzUI+QL53kmcDfU
         hTfA==
X-Gm-Message-State: ABy/qLZJyXgBmFLqGnqZxij/EGjV4tEPdVECNOAydqVDsEj6nE7WJHJx
	S5q1q/W8VRR6CBfDO0S7VAA=
X-Google-Smtp-Source: APBJJlEZBN7jU+66uj5yt+B/dTz9pCaagOEqh1KOdzAgmdHqr40K1yOSyZ+Z5OR+cgg6dic63xH75w==
X-Received: by 2002:a17:902:c94e:b0:1bb:32de:95c5 with SMTP id i14-20020a170902c94e00b001bb32de95c5mr16394723pla.65.1691018206393;
        Wed, 02 Aug 2023 16:16:46 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902c11500b001bb889530adsm12663686pli.217.2023.08.02.16.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 16:16:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 2 Aug 2023 16:16:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/153] 5.15.124-rc2 review
Message-ID: <c9a82590-9263-4c02-adee-e116a8f1af7e@roeck-us.net>
References: <20230802065452.161574662@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230802065452.161574662@linuxfoundation.org>

On Wed, Aug 02, 2023 at 09:41:43AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.124 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Aug 2023 06:54:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 501 pass: 501 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
