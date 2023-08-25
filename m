Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CD418003
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 18:00:15 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-54290603887so682111a12.1
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 11:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692986415; x=1693591215;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dTGOHpLCghqFrKN/eG+RlHSLAI5UV3j2Aq7spVq32nI=;
        b=mDxH8FzC0k8We0/YQN5LGSp11gGbDLEx03QIYAIGfn3uIbh33ngtC+NrcJEnjWPqQt
         gi8RkRoAEwusx+7SlYNoRhmg8OuX3EHwNmLNNdgmj0SVSL2K1jcfRt/iIszeANoqrk9I
         oD/7wy2VZrUtEGq8A+w3pXCMKrUlBAQzx3ghair5yCDe6CmoXPb1kBAaZu/McmdAIsY9
         5m7delawhdwTAid516waO+TmCtTUKmV5OUOCJQhDXufpDmLREJeIF48en8/FOUlWdVA7
         MM0UqzOX9Idu//n1R+AMDrK+hr+XoPaPQL5TY+EA9CXwWmOGzxBo4Q9C4mcdA9G5jI2q
         MWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692986415; x=1693591215;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dTGOHpLCghqFrKN/eG+RlHSLAI5UV3j2Aq7spVq32nI=;
        b=AJ5/MkBlnrfdTJ/YKPUSeN2E18nVc/Uk52jlcug9rb420C8wy5JfB9WnodgiZ4zbzH
         eH7HbbNzAGTmvkDbNmvrLeIvjKTM+4H1PQob/7uOJfSTkk5FIzacl05mrkjwYL3P453Q
         wdqmZPNm+nd41KPRS7BRbqBaQVSeTiSR0zFFMUJQOZIJcxYzxH9XmOe3ipza1RcChUok
         rmfsO2iewNCkDnHQL6zYL4GcWfWLzQPeFY8PFVTJt+cIVS0ifZkQu8RWgMyQI4S6KVAu
         CRqZ+6EBh4PX2MMkvpFJ7jaBraWy0VSc+3JHcJ8S9A3wbvFL5Bf6zN0D9OEQrH4F5kYj
         I3uA==
X-Gm-Message-State: AOJu0YyU85BPhIZZnFrLSYr2AfoSi3Oap9tP1whvPVElmHQA8bQzFjUt
	mUXV+WEMLJ9EmDBBTXDMV/9zBZ1WiPffssmRnds=
X-Google-Smtp-Source: AGHT+IGbmnWJ3gBrg1stH0g/5v7ANGHxVRCdm4d42EaMLTJeTb+ZjbwwAZWv91ujsSbmUsfaAxUew0HqmFwF+iFCGpA=
X-Received: by 2002:a17:90b:3b8f:b0:26d:28a8:5880 with SMTP id
 pc15-20020a17090b3b8f00b0026d28a85880mr16340536pjb.32.1692986415286; Fri, 25
 Aug 2023 11:00:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230824145023.559380953@linuxfoundation.org> <61314350-629a-f870-e203-270d66b13a54@gmail.com>
In-Reply-To: <61314350-629a-f870-e203-270d66b13a54@gmail.com>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 25 Aug 2023 11:00:04 -0700
Message-ID: <CAJq+SaD=0=MAti0fcif_cGjXi_BBEnswgurZ+ZcRFjPCdkM64Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/139] 5.15.128-rc1 review
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> > This is the start of the stable review cycle for the 5.15.128 release.
> > There are 139 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 26 Aug 2023 14:49:55 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.128-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
