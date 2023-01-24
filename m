Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6190EA31
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 02:48:31 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id i9so8388273oif.4
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 18:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yje2JP2mUPKrgvQ8BEU++4+nLYxRl5QuruHK7Veg1Qk=;
        b=l2llHYiEgouvs8ePn8UGMqsmZ/pJMoFDoY9XJmQd5/HaG2cg127Yt5QEdZCIjaiV+4
         9TF4wkzF/4/T92sKZU9gzHF8cEgtoIG/pDeqLz6R352qkpSBYS2/PA/l09g/xE70pbuD
         KsoSYwGFyWAGM8mTFLQ9aRQiKWhCMWwQ8lMQLI0VYsGEMi363JBnT1IKSuS6rQZjIIGS
         QfxgutHpBrjNkZU6fRQoCQE7/7aD8duV1H49Z+Aei+RlX91FwWqnl7yBanuy3FV7kc4J
         q2hDmovfYi38/XUCcoq27cjLhWgqjfIX3t+u8b6qKZ5UUW1FPeOYwSAwICOU5JB1g6lo
         ag7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yje2JP2mUPKrgvQ8BEU++4+nLYxRl5QuruHK7Veg1Qk=;
        b=v+1awYCdeI3Od541OeoB3of8+RRuFGFJ0u6MnsGtbPB/AJpopGqd5DkUl8OgULtFdY
         X3jwnGu2H9Kc9vmplnijq1bV6GxbOztbVQCHyxrlst/0NG4FprIFgRmgo3pRLOv1Ft5W
         oZ4nd2uvou+WwhgUtWXIX2y9U/oKDWaZa2lDQc6gdB086LGFW6NucMCkgiaY235zyXEP
         /8Y31eRyEouCy6xHnO9RnD5uaH2bJ3Nwga+u5egItdmsKtrBD8/N1C/Bhath2ZD3d5cP
         CGjqNxIseRQGIYwvr2P0VrmWevhIsHFpEx8CxTrzTmqX/d7cMjvqGotTGfPZQQgN8Mga
         ECvw==
X-Gm-Message-State: AFqh2koXVgUMdInf5LyrRYHm7wFCRc34DzwCTy3gySM4Nm6icTyNCSG6
	cfkVPMSi9rHmhhJVrnXCAzI=
X-Google-Smtp-Source: AMrXdXvgfKGP1eMBWG0z+qx5Lxw6MDhD/sD1+4SLoLfnHBnOxSixilC5fvjsFwG3ap/oKxXOVZ1CNg==
X-Received: by 2002:a05:6808:118e:b0:35a:6005:3dc5 with SMTP id j14-20020a056808118e00b0035a60053dc5mr15366094oil.51.1674528510466;
        Mon, 23 Jan 2023 18:48:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r124-20020aca4482000000b0036eb408a81fsm480457oia.24.2023.01.23.18.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:48:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 23 Jan 2023 18:48:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/51] 5.4.230-rc2 review
Message-ID: <20230124024828.GC1495310@roeck-us.net>
References: <20230123094907.292995722@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123094907.292995722@linuxfoundation.org>

On Mon, Jan 23, 2023 at 10:52:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.230 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Note: perf built with gcc 9.4.0.

Guenter
