Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2C9256C
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 00:01:43 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2685102cd16so264062a91.1
        for <patches@lists.linux.dev>; Wed, 26 Jul 2023 17:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690416103; x=1691020903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+w33LNLoiwSw2VlILl6AfG1BwyassOteYXSp29cv5Yg=;
        b=RRqvq4CYxbc5JdrX98mwS6dZteytxfMJ+Tg5OWaQzsqfoVNk+Z+n86iT0IwR3be0Q/
         IHNyRN7Dwramj5xpizbbLCQWdvywqOx5yDmOdKHh8mYsfggrKNk0g06navLIzQI/XKMr
         tMWPfQK2NLJJTClPpi3CfeeI1AQ0cJTgF3KlrquyvHKj3l+VZDNRn0O81ODW6251+ODL
         ou8PztIILiWnS8mEaQ+GCCl/Cx9YmqPslZ/Qmmwj7TZiWVqttQo/f7cPF85rsGaklKsE
         fZvWXxG2lwLzGDl8lNf/nbvnjdxwZZdgu9nzODUH/2wQFbUHYzsuqtbGB3qUxvBEcPKZ
         Yq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690416103; x=1691020903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+w33LNLoiwSw2VlILl6AfG1BwyassOteYXSp29cv5Yg=;
        b=k4F7u+USlm5r07Sdxd2+8NEKXqrNQ+0NHijIpKPz/cnkjxwxgkliBnE8fdej8nmrQH
         CN5Rp7aVioRaNbzu+Cqz2sFoYztH/XqNdJiimhv7stO+Ylonjipj2b7NAnV/aoJJmEKX
         TucritZ7/oNTC5k4igYmihJj6eU5f10glIvJ9f6dqL8oTmuA7l6qUi86S7o2atzzJLbQ
         y2XTe2SZFxfcXV23cSxCZC4+9eMJOCkvSSLbnu2N3IIAF7iOSJDS1ffcbXNVUJqUgAH2
         SksZU00taBxKgAuY9dkv020JoAcf0ZLyoozytcdyBY+lPuMMD3EFq6Id2HumDH5VCS8M
         4NrQ==
X-Gm-Message-State: ABy/qLbvy3hupORTmPFdgWoVZYyHwQ8aUO46jWSfeVL52GryvRft4vUl
	D+5gYbDeRq9h32E5h/iSK1c=
X-Google-Smtp-Source: APBJJlHKGEtb+lgid+Eu9Cxp6poX57XlYRGXskc7sT8BANTnPMC+9AVgMOLgMOy/R+RXsqAmDkeg2A==
X-Received: by 2002:a17:90b:3ecb:b0:263:eef:1465 with SMTP id rm11-20020a17090b3ecb00b002630eef1465mr2771509pjb.44.1690416103308;
        Wed, 26 Jul 2023 17:01:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c14-20020a17090a020e00b0026358dfd2a3sm1894038pjc.24.2023.07.26.17.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 17:01:42 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 26 Jul 2023 17:01:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/508] 5.10.188-rc2 review
Message-ID: <d82c1be3-7177-4567-a0ec-5e7e23631922@roeck-us.net>
References: <20230726045328.327600022@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726045328.327600022@linuxfoundation.org>

On Wed, Jul 26, 2023 at 06:54:16AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.188 release.
> There are 508 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 28 Jul 2023 04:52:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 487 pass: 487 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
