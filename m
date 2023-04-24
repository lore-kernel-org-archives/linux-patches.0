Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C0E63C5
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 22:09:41 +0000 (UTC)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-506767f97f8so8638105a12.1
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 15:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1682374180; x=1684966180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q3vo8hN0NTp+VghdOI9Hp/duwMShqFPxn5hXcMLBGsY=;
        b=f/SoEqea+rKQnXN8NytAsBZMxcCI6/CT+J6ZLDswvldOXjq0ybDsR/RUTRbw+D9iaZ
         sHWpeRscqR553t1QCg7W1zIZaZs5caI+lKbWQL4bew2yDtN9VqcmUI8f2tViSCNDkWMV
         d6wFAvqP16lyOK4cIKfBotdWxQEoY9u6gAEdYy4kTWC8Ay/jQ/pg0nObvvomKTWtJJTM
         yj8tX5B8yKIMA3UNkF8wi8Uvj0zteSJ73GAJrtxFYslXXgbvRZJmo7GBb/ECRChT00n3
         46i6HKPajRSWbfHycCJZLGxliYthi7lY1+jIc3NALBE4JGG84hvOj9xzJ0QWBTCjMV8x
         Xjfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682374180; x=1684966180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q3vo8hN0NTp+VghdOI9Hp/duwMShqFPxn5hXcMLBGsY=;
        b=U+05+Y9D0Hm/SuhgNkftYgKBblCr7EuLSjjQ9CPl5iDGbNtZ+3yW+EJ049u60pBLY2
         8IhOGkesSwrozGCyOtFdPlQN9cfgQWSfe/3VYUCVIeXHAn3opk8uu/ZBjBAUb0rNpdWH
         pRptmtzUpG3EWx2ETQ2AXJNOc2Xj1UwaEDqdTUM+/23Bn1KbgkC0MMhg3nl3iIVc86Zo
         nQp9OknGmJzCtrLwh14p5a0uLGWfnbtlyVE3iaHGUEMlEhPCRyzdWXirXMLA1P+ssLNN
         83JVZiS+8RA8D0g/ZUgQUIn83dWwF25RQXHF3UovCojnbMMNksFBA3EtZUKwozxftkQV
         FwUQ==
X-Gm-Message-State: AAQBX9fjkrSLa6xyBlrNzFbcwA/tZw2UGZmK1COLdHWrzPEnVtFhLblk
	4hY0yphrLR2wk9POAfJbLbaWi23E3GBg6y1yKc5weQ==
X-Google-Smtp-Source: AKy350YPqje98LYBmLx3j66DAjxMN04ofbuTdqe5UqlpewYae4MIHJ0w5uaLjc3d84grCTPIOX8t0pXtqAjaFZBsgP8=
X-Received: by 2002:a05:6402:48:b0:509:dd75:7a0d with SMTP id
 f8-20020a056402004800b00509dd757a0dmr4220399edu.30.1682374179521; Mon, 24 Apr
 2023 15:09:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230424131133.829259077@linuxfoundation.org>
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 25 Apr 2023 07:09:28 +0900
Message-ID: <CAKL4bV5N_9HVm6h-=c8wD7gomekk3WsWirbUdKixRc2_oPrY6g@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/98] 6.1.26-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Apr 24, 2023 at 10:25=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.26-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.26-rc1 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
