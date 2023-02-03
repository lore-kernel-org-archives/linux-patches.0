Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622374C60
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 13:58:22 +0000 (UTC)
Received: by mail-ej1-f47.google.com with SMTP id mf7so15552466ejc.6
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 05:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pCUGL8VPixgFHZJLqdb1k6pVMMrRD13TGA08RWk+l2Y=;
        b=vrHrIoSZwFiYyiaGc3dS5QJxFJej28syqCpWncYrNGrbz0vi/zIiXmS4Kom8vck4CI
         yqNepijzzfhWSqWDOj+XJRmVxvvUQERcHVGRjWyfhxbbS0HUQfbax0MQQN/XgYDdymKV
         0QpPOmD71yg5s3NZa64KjhwS34e/ApmwvFSMLE+hmeKV/uKmjNwRqAO+2mln0r23UJpo
         1BbxYvkdCkuiM3LjhxW9Atj5WMh6jri684Fweg1YoZ+upBKs9l3lNfSAFPoJmebe3KnM
         e0vzFOHykfF327dU9jCUroD/licQxP71m4CpiN1NrWmEYY5boyWzw1CHElzGN0/9v6pu
         NYWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pCUGL8VPixgFHZJLqdb1k6pVMMrRD13TGA08RWk+l2Y=;
        b=pJb52VeirM11pd15fo7/0jxnlU15xkKK4eMxMYM21D/rizkA9IHxMynzjL9DtcTYZf
         cIoL6Uh+XZ+vufW3kdCSfdF5Fid8I8G7Ny77VAqcamOu9FEgoXjxg6pum01Hc01cTzS+
         JKvjHpF6f6h0FzGdRdbnAqesuzAXpIg3AK6H5f0Nh3KEpX7og1NtlvGc1IuSERfI+5GZ
         SO9QPNY0PcvT7JuwmZ6q3+WwjZkf1DKR4mwYwhTcWl+GZaZs39Upv5XIYZ1WqPCjOBlG
         yff5aN9/qfKG6P3Wj6QaKbpMjDYyzcWA9FuphJP7SQXLFRoK1WurNM/5cDjHde3u+Vyw
         SLHQ==
X-Gm-Message-State: AO0yUKUAIbJW6v6boYzDjYgmfKsGjZrB8KTfbMYMRGv6ZuPMjVpEXdpa
	3FquOjKR413nnN7vE+dqwJNDyT2D33Qu4fgYo2khKA==
X-Google-Smtp-Source: AK7set/HKO5v6FkHVvwoDYgd8Or22xvQOYV8kCOWchXa4DTk6K6JpVwZu/1GF39IGoqCWYV3PX37bIrqVnVrHpEPo+A=
X-Received: by 2002:a17:906:650:b0:88a:bec0:11df with SMTP id
 t16-20020a170906065000b0088abec011dfmr3308020ejb.178.1675432700555; Fri, 03
 Feb 2023 05:58:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230203101009.946745030@linuxfoundation.org>
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 3 Feb 2023 22:58:09 +0900
Message-ID: <CAKL4bV5HVujYHpAjYQGZG42imRnQpOsHm15hOiwy-E6Qe+qHQg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

Hi Greg

On Fri, Feb 3, 2023 at 7:26 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.10-rc1 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
