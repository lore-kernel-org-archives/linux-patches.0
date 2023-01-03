Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F250879C5
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 13:22:45 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id g16so22908834plq.12
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 05:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7iVDgE/YQ2ino+0gOp3GV30JgvXSTXSZzuw+o9mRVD4=;
        b=FXWzZlBpHcgN7iKM09lzW0XReiYVSPfCIYsNB7x5Uak9wls544eP6fBlNx43RYCwbx
         CwAipIHm135XV4i2uVjpQXW5SR6Yn5ubYB9sc6gtU3CGD7RQV4AIbMdu6CAQm9hrEbdG
         YuzD1n9AtIl+GZRKluyy/WoojawXcR4TTjZ9fgZhL2n6lnMY0sCQW7OzhraBAtDNxgPV
         VAE2OKgSLDPlVqgMDGq3+uyXcKg+b73Jxnzw8IrGrgabn0o/Th9sF55qQvg1MKHib0oh
         TQNdRzFPnHjvX28jsEiYiyDs2ZoRjXlTl8T0gCdZH7J0ru6KXQMzQmOexpG69tC0RYMq
         JJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7iVDgE/YQ2ino+0gOp3GV30JgvXSTXSZzuw+o9mRVD4=;
        b=b/qlGvpSMuCQPlEL+YI8ycX5atVLJZLjgoTrLtXUNhFdUzPNhuhXPs+/cuqJYkOk3J
         SHtUHuo6NWV4Ycj4+FtmfXsFatD7M5/F4DSLcQkIzO54aWhT/KvTzWRXtMmTu+jjRt1g
         WljrZ+1Azx5sAxwGXZkpVMzAkEDDw83P22aGFihSd3Y06KU49xNHloIUdBjd7SqTzSW+
         PxXb3aPrcjOswxhSuZ0k0sMDnKTFMwtcq1/1qJa0Cp+mnf9OaiAXCapLmSAyJcIHq5G7
         Cwte2A/JrqcRAwbfVI5u+zrxtuRVU1a/EoWS89m2ohWbT1MxBCcSxzP6wYPVbDZIsxcJ
         uE6g==
X-Gm-Message-State: AFqh2kqB+dnwZ5wovNWgeCu0tdIWrt5qBOmgA6NGybBdIBtF2JegWiOe
	mahN2Jk0NI+lDTXj3NYYDTgZ6i3beppDRyRUBGg=
X-Google-Smtp-Source: AMrXdXtLeKUZvtssltrdLCeVhKdmnsHT2zudStN2bzq1aKk1Cfo6VvhNMELg+SbgKY4XpwwNzgGA7alOtJFFDpXERks=
X-Received: by 2002:a17:902:ef95:b0:192:97d1:a4d8 with SMTP id
 iz21-20020a170902ef9500b0019297d1a4d8mr1505180plb.74.1672752165460; Tue, 03
 Jan 2023 05:22:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230102110551.509937186@linuxfoundation.org>
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 3 Jan 2023 05:22:34 -0800
Message-ID: <CAJq+SaD_H7ZmYxokc2AuOkPwfteUqovn_hYdYQPvp8BEFZsCAA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
