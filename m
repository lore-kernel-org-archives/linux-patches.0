Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC70D2599
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 14:49:02 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id m7-20020a9d6447000000b0066da0504b5eso7252172otl.13
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 06:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kU0qpDCF5riG3lUKLpgQ+p9wqeopjuwXlJUExZoUcco=;
        b=geWLdArBPTaA/RN7P/IOgW9ZIdxGg90pVUksdUfAoL/TrZnPzu6z0jRc5tKSW7cPAX
         QiR3FpF/MLGgmUVTNugRXbDE9zOx9XPDtJ81dXQOJfOUNqG98rb1PVBXZ6vJvNUc69Je
         vtdm7lMXQ76ITsjFnH0wn4Rre3UtiajbGjc+AuP4vHTSIf9ZLRvnV2h4VMQ0HdywUjdY
         Uct5e3CkSxGU6H0m3ivEghsL3y2E8BRvJhRsNZzQVAWfg5JVql9BiZo6rLyckcgwsyim
         /m7ntsKWzFre98T2H4+bq5FBkZTOj7RIcotl+V4BvzDLxiaOtgHiBwj2JNSJwpGnI2uc
         RL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kU0qpDCF5riG3lUKLpgQ+p9wqeopjuwXlJUExZoUcco=;
        b=awA4K3XJS11yRFZibzdx8T2fcPKDj7QyUMMMTgXBYwFaHJlMvsST5XFZmogo04Ff0t
         4+ihC0MGHh2z1hO7hdB4mqwxfKpdvbprj2Ozl2eGGSBJLRGwdRd1mh3TdbtY2/snwYG8
         hArWtRMidUqJ9I5Fg/EdyEs96UqFN1yIbG2/psHYGQ//wsjXy9diVgOlhRQ0rgUM1Zyi
         8nrliomlgmq9G1rf8mziao6gkIUvV3ZNs90Ict++/Do+iqoQ88LKwHSZv8RVNp3GG5ai
         86AIBd+6UzQIVGAlXgso2mtNHie3QC+Rk4P13y+XRjhQthLnQUJej01sa1nNA6+WglqY
         1hzQ==
X-Gm-Message-State: AFqh2krAxjCv50l3pbBcTVQuqh44bZQ+IppUT4+benGiktypDRLodlzu
	0fFj6nqK8Nx1qln0SUaOKbI=
X-Google-Smtp-Source: AMrXdXs6tA8IH6SIio8ED/97cPJpONxFQ/q2TZ0VbuDgsaqasyRHAr5PVqqRfae/+GrFb9OdSg6reg==
X-Received: by 2002:a9d:7dd0:0:b0:670:64af:1a4b with SMTP id k16-20020a9d7dd0000000b0067064af1a4bmr6153716otn.16.1671547741942;
        Tue, 20 Dec 2022 06:49:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y15-20020a056830108f00b006708a6274afsm5720175oto.25.2022.12.20.06.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 06:49:01 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Dec 2022 06:49:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Message-ID: <20221220144900.GD3748047@roeck-us.net>
References: <20221219182944.179389009@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>

On Mon, Dec 19, 2022 at 08:22:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
