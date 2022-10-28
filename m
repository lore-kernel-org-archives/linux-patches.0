Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7998923A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 10:45:18 +0000 (UTC)
Received: by mail-ed1-f49.google.com with SMTP id a5so7244811edb.11
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 03:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dLBIpFQFCCtDMk9X0sNN1QNG1NRCfa2VZ76WZoXVN48=;
        b=WIQtlKrVQQvFqiZh2ZIpzJ86Lr7Ta42awBU4887QoCC6Qzci9x+zzXRUQbV1I1SBSN
         pa28C4Y5gkSwYV8laCGq2Vxo5Ddt4FGYbicK96dvPFwbcpJwqAuU7XLsiszpLRV8rv0W
         EXzPbGiLQD2CWF72epKrqouEeXD7YUx/gzIJcifvCOjIAXpUleTOBRbxgAwsncf9gQWS
         4nrnZg6h9+zHMZpNPRGltlnNJ4nt59ZpTWOd0bFzpPzaHwoy7nJBtKlkNIjJ+LR3mx4P
         LJrjt7UIL13xRKnYkAvxStf76ldZwK82CU6FA+Diwx39LGc6pE68TC5X/lX6/1b0bGte
         ltpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dLBIpFQFCCtDMk9X0sNN1QNG1NRCfa2VZ76WZoXVN48=;
        b=v9PksrW9UxUYDt1SI4Lb01yBuLDfZkHdl9mUUIsJ50LNvWgyPBz1g8AnqHUD5gZ87v
         EGajp58Cn7i7FjSymShYvWa38q3iSm0NWy2AXfHmBKnK88g5D7NmwdlRIIqE+FE8xZj4
         ae8cghsRcPPjMIv+N/ILOc3DwtwnC+5pSizzzKuaLsRc8eXbW7ALoEiTBKybaGLSXLDh
         8I03dPS2pPW+2ohN/NKjiUUwWUgIYFnZBT5MEliHLHth3S+26S3NxJEguRIOAp/IecRg
         mVtGA75tqmVCI5GBDgWpP0ZDvWF45ITXDEhh+gtZvxle9hFNZ7z8JSO4DwuNQYXZ4x22
         KyRQ==
X-Gm-Message-State: ACrzQf2ZDH+BvqBkq6jwGH7/0HBAy9h2gmUoPB/ZgQZmM+f3njrAVMSR
	a6CJlBnw5CBJMoi3+Vc92bARXzp7A44eenLRhrY=
X-Google-Smtp-Source: AMsMyM4w0QCenQ++V8j+5NeFA/LOJ+bayADVUZ9D9fNJZ7vJxlu/zVyjRBGmFkXy5Y3ctkb31tMUNn2pxqKfGt768Oc=
X-Received: by 2002:aa7:d80a:0:b0:462:2c1c:8716 with SMTP id
 v10-20020aa7d80a000000b004622c1c8716mr16462827edq.185.1666953916705; Fri, 28
 Oct 2022 03:45:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221027165054.917467648@linuxfoundation.org> <Y1uxn8/y6AjCu4UU@debian>
In-Reply-To: <Y1uxn8/y6AjCu4UU@debian>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Fri, 28 Oct 2022 11:44:40 +0100
Message-ID: <CADVatmPTjngRzhkMRbRCU=Ca89AtJxsDWnPKLm9Ec-5Chp5E3Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/79] 5.15.76-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 28, 2022 at 11:40 AM Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Thu, Oct 27, 2022 at 06:54:58PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.76 release.
> > There are 79 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.

<snip>

>
>
> 2) Already reported by others:
> /bin/sh: 1: ./scripts/pahole-flags.sh: Permission denied

Ignore the "pahole-flags.sh: Permission denied" please, its only in 5.10.y


-- 
Regards
Sudip
