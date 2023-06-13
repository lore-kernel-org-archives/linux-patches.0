Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0336A1361
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 23:09:42 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1b4f8523197so2062775ad.1
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 16:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686697782; x=1689289782;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T60JVgCYXCr8Rq9RWZr9/GJaBu6kr4Qnjf8Vn23FBLQ=;
        b=h9BZLBSJ3D7cz1UDCF7vZfnupgsX0r4pN08GaDsEK+skUmlREMs2NDaiK0kBdVLANs
         fe3G7RDSO010gJD+oktEzVxLe5fHgaFReWlE/vTe54lxP+k5xrliPX7kTt0Jj73/AKPW
         6OJC5I0aMK7WX6wWTUKGGeu3FgVldb13DNP4SocCzZWMuXMqVa0Jj+JjIKXPxIkBe2ud
         oaIfxmGaEIp7RinRA/l9Jea70h9vzedr0lqE6ZB5gRV6cWKRMyWm80qqQOGPitEmSs/P
         aE1LF5TfmHuiX+m3f0HhHkLZ3+HGohjNcCu6zzF3zTybrX729thxM5lpJKnbUD5UkRTz
         weKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686697782; x=1689289782;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T60JVgCYXCr8Rq9RWZr9/GJaBu6kr4Qnjf8Vn23FBLQ=;
        b=JmdQjoBpjsTYY/+CtwCE3pPMaqQ+Wtp4YVUYp7D0zCjJZhQoYQho+DITQ4U9Q9zUse
         Qgi9qm9uNUMdgBCPt+NScKYkPlYMeExRCny96eZjO9EAYBrtwuqPnaknEC6PY2eGu0Dr
         2XaADfu63W6uM4Aq9Pz8XkWQvPE/wJ/mwrNv1az14Qd6Ou7+rnzlN0Aa4Oq1LE1F0X8n
         gU6WL0jLeAJtgQnKSnf+eZAUytKpCq2ng0nN9YGDkZGnHcnKiyP/T6Poemu1dmKQLwrp
         hYEedy2VfM+0OPogWunTkswcVyRuvvRyd7iXWIcngCgQvaVXGqfBz+oJGrgRPkADxa9V
         WkfA==
X-Gm-Message-State: AC+VfDxScj2D9rW+rB88bp6ZQiLf0Aj1yGdOQvdRI7ZTC0jgAnAGWNt/
	PHkoN/0U89kDlNkd2281prs=
X-Google-Smtp-Source: ACHHUZ7G0/kGa0jAJDcr7NcNxq1ggihuhi6U4gzDm+xzjYRc9pOG5OS07ukX1bAtc9YMvqiETN2Pmw==
X-Received: by 2002:a17:903:1ce:b0:1b2:544b:3d54 with SMTP id e14-20020a17090301ce00b001b2544b3d54mr14258756plh.17.1686697782254;
        Tue, 13 Jun 2023 16:09:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k21-20020a170902761500b001b03f208323sm10761715pll.64.2023.06.13.16.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 16:09:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 13 Jun 2023 16:09:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/68] 5.10.184-rc1 review
Message-ID: <08240a68-1ce6-4d58-bd20-9018749c90dd@roeck-us.net>
References: <20230612101658.437327280@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>

On Mon, Jun 12, 2023 at 12:25:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.184 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
