Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC393882B
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 21:54:28 +0000 (UTC)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-545cb3c9898so244399317b3.7
        for <patches@lists.linux.dev>; Wed, 29 Mar 2023 14:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680126867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wuJnhqOglm39EigVBOorfLFET4EJvRI41CYQanO44wE=;
        b=RR7FRCugnk5U51rg3Y0p5oRleymdIcY3kRaH41wkygg/t7izHSgVSqpiOOlLqo0q3p
         lp+FFjkF2hXhFKtua4KcjqxOGgnkMFiNy6ea5u497E554KmNIyY6xDeu6ceI+U4HPLGE
         iTIeoMgZCdrQ3BYNTi6l2TrELklRlSuEDyrTB3+M+6XZV6zuuCeEQoEKLbf9AqCP9RQN
         aQttkXbUHWfiy4l3lyIru146D49LXUkbCiCk54XMlrRnmmIhyblFBIWk8gBHiiRKHy/R
         NGhk1+TKyEXLECw2JxuFWDsjlK79hfO4ZdB4TOmQL8WsMZ09CkB2WRcQryQaLqYxffFa
         3umg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680126867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wuJnhqOglm39EigVBOorfLFET4EJvRI41CYQanO44wE=;
        b=Q16K8HCXdeLNjjahT9s7RKaCXkOh1InOJeO3tTeHsmhDPC4iTR3B4WgiasTBmMvqrC
         G6JzkbaT+oGHQ1moDP1ea0ZdrhHnzxTBGjR0azJF/bV2GeZe/ld/NI+yDPIvvOdatrJ+
         HiH7QgDabHfzf89gBFnzzhfVJVLm4q8FESp5DxKqAwnkffJgVBSt6A/IXqZR7Gqhmul6
         X5DQ8CCb74X0aPgMgkFsO7bkP23giVtfrLF2YLMQZuNA7xOhWK7yBR5VjrqaQifhhoKv
         ZBgtK22EsPghUfjf/Po6B8pwkEpR40Xcxb52QvVImdxYE1mnYFFGgiaSyr3RQOmBDhEx
         S+fQ==
X-Gm-Message-State: AAQBX9dDEO8HgtfHkzz5UcXoL2d9Cv7Jb2xCbLe616y9+aS44NxUdiEF
	/5fwpAr52JLlDaY0VDdaZK8=
X-Google-Smtp-Source: AKy350bJRteG/ORlYIW4b6bWV9t0iBvfTo+73hIctNo2CSCTcOD0C9HvwPFtn1vOfm5LoswRNSXRxA==
X-Received: by 2002:a81:4ecc:0:b0:544:4d3d:4231 with SMTP id c195-20020a814ecc000000b005444d3d4231mr21168821ywb.47.1680126867682;
        Wed, 29 Mar 2023 14:54:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id by1-20020a05690c082100b00545a08184f5sm3195290ywb.133.2023.03.29.14.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:54:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 29 Mar 2023 14:54:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
Message-ID: <232b80c4-e885-43f4-8f77-924cd1b763fe@roeck-us.net>
References: <20230328142617.205414124@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>

On Tue, Mar 28, 2023 at 04:39:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
