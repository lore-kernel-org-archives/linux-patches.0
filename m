Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65AEC2FC
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 18:28:01 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7918997ad9fso88172139f.1
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 11:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692037680; x=1692642480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l3DxKgyMPcstTEDb6kptBJFKn5Z00KFtFcxXmcD+73I=;
        b=nMdPmZYrbtvtPE3iOGZWMEg7p0sk0N7JpBqByKZ9qgjpxjtoTnbyxA3TILCYEpQoJG
         i2Ds+cc0nqOuHoIMu/FCenV6GQlQAwtffHNl3GxFmE7MBTbgalWFzD98G877l9SdYOxX
         L4sxfl4HhdMxrfMrjncD8ILidQDVJWqOoIDkROsiKRgW0IYkRJz8zTm4jZkNvg48fCt+
         yJgyXteWEYJUuLHl8gAoj7yxgWjzZhwOXFf3n9QHVmxYvd5Qfu+P7EaOi2dptEHdFgET
         l8XUtXht6sW8tMxEHJ1H9T303gcxKimZs4kEfchZe3JTayOryXM8HT/C+nd30NR9EHyE
         rWzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692037680; x=1692642480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l3DxKgyMPcstTEDb6kptBJFKn5Z00KFtFcxXmcD+73I=;
        b=JlLLIDD0Wfg96En8FM/Sjhtq054oKcdkq9IBvOzF2VMgSfYz62Q4zNuulgkk70Qowa
         tz6qOezoVb2LWN/aW/qyEhyCQvFZXYfSktkdIFho4eSdDOyPgcTH9W2Qz09Bzw+zatzV
         R5cfuvZrOF91Hrt647ldjdeUzILJu8TYdcMKis134apNcfJm3ACI33ARHHdk5FBfHV4e
         AswLMJeceu4KTjyxEhEEU0Sgzw2hzJAP7BvxkDqUlYzz8cGly8stWeYI0jx3XkJoaX5d
         HKiLCngrApONqPv7blSQZ46BN2cib/ZqCKkh+KP1+tykbcwGX4nh/0UEsafTpU6DMB0/
         u9hw==
X-Gm-Message-State: AOJu0Ywubjo4nD16S05hqHCZrrVqy3yp2YO5zcVws/mudue+9ngRuqZW
	bnXidVVFIdV6zSot3Kv+hIU=
X-Google-Smtp-Source: AGHT+IGNryW0eIkWw87ANhGb6gc9oozzk2/nwTcxGMbXlErQcDcdizkelmlipMA/QM/0vM6oWPzaxw==
X-Received: by 2002:a05:6e02:1c8e:b0:345:873d:1102 with SMTP id w14-20020a056e021c8e00b00345873d1102mr14981905ill.15.1692037680710;
        Mon, 14 Aug 2023 11:28:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i6-20020a02b686000000b0041627abe120sm3174115jam.160.2023.08.14.11.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 11:28:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 14 Aug 2023 11:27:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/206] 6.4.11-rc1 review
Message-ID: <8d11ca33-1924-4017-b2a2-40c872f067f4@roeck-us.net>
References: <20230813211724.969019629@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>

On Sun, Aug 13, 2023 at 11:16:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.11 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 522 pass: 522 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
