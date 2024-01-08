Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B5354F80
	for <patches@lists.linux.dev>; Mon,  8 Jan 2024 19:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CU9+d7Ku"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4b745fa9671so247475e0c.0
        for <patches@lists.linux.dev>; Mon, 08 Jan 2024 11:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704740550; x=1705345350; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i6abKjHrQB2M3iEvyThch0ew2ujiuN7TwHMLgZSiAGw=;
        b=CU9+d7Ku8l18IPyQL3PiTuMN1iDmEOwkNXkg1XYj98yCACn3RdknVvfwpQqjuFJGKD
         j3s2SONATlDL5WcoXMYvPaFymqqENkY+DCTk8eb3GXEgIYZyQivR5ahvF6dD1MtfRsST
         Lg5m5LD65+9ExHGwI7BF0QVpgC53aJajGogaQpWIMWK52qGZxqZjN+bO3O8gcsb3VWgl
         +yPWaCAygnehY27Db2I1XTSGLRuQvY8cEqruXjSoyQ6BdvK0kk7tAJmYINOEygc7Qqds
         RDBSf7g+Hgka6PismmIIservkRnQ1QCJ60M8SOibgg04UVoOtXnDxiqQbMC8RBk6VoNd
         jzVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704740550; x=1705345350;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i6abKjHrQB2M3iEvyThch0ew2ujiuN7TwHMLgZSiAGw=;
        b=AUyCA2XdctTeZD99olxMoaS5t078PVlv2eeUOfIhtxLuelfl6/QE7NGTIShoSBEgtv
         HQTssrV0SxX71LHNByAupkgE5hgqNT06zXi5KOiO9hmCN0yS1TVEzh6kD77nzjlQOhr/
         F+I0qWt1GyuVoF+M5TKkj68+8sjceOqR3Cq+EGQ4kkivIeGO31m2BTLGpLTD9sMInx87
         5gxW6iZ7XtClbb2fM1/1V+iykvS3+/rGPbMGdEzxm1LUIxtD5D1S8CDSihS1jtVtgNt/
         uAnKdJNsWGKfTR5mDUrHgRA0n+0ydElHBB/m+6NMi7WSxAjmH1hCt2r7Dyn1Wjxs8J+T
         DFlQ==
X-Gm-Message-State: AOJu0Yy2xrax9iUsWRRrTXWe1V9FgRT9FaPN3pPpviU6HFynySvMkPUK
	U6h81lzb6pmKwdZVn61V+tE+/vI24PalOsAbPCE=
X-Google-Smtp-Source: AGHT+IFZ1oroFQ9FrqNxPzcXlCCnla9b5liu5pflOjp0/Ol/BjcIbkeCD8sMeSlMGrotbUouwpW/5I/1St5MfZUJ1D0=
X-Received: by 2002:a05:6122:589:b0:4b7:97b9:527d with SMTP id
 i9-20020a056122058900b004b797b9527dmr1351897vko.26.1704740550525; Mon, 08 Jan
 2024 11:02:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240108150602.976232871@linuxfoundation.org>
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 8 Jan 2024 11:02:19 -0800
Message-ID: <CAOMdWSJei7UHccSGRcUD-A8uoKz-nGdpogVk5bOU6=3cHJ5s-w@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/124] 6.6.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.11 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Jan 2024 15:05:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
