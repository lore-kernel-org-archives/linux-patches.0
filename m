Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D3260B97
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gmL7b+/s"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6d8751c8e7eso2662177a34.3
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 08:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701795332; x=1702400132; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sow2MusPsrtxMYHQTqvOsRCxKJ5Iv4+FAUZthKEE3HA=;
        b=gmL7b+/shdiFwhebn8umacdpfiGDpX+feee3n6RiDFMMXw5Oy8CHG0gBRpMAsqefql
         zuN0lmPUgrlN+KpxzFbv19hrHAU4eK7Z5ElJ+0KbPXVlUqhh1RmrxZrV8mMIldGiTclR
         XeU0TEqSgTGyYxa4GE6UzxxOtOmWPIiHTUVN7rruBrSQfqjOCCnoNbT0tIlhwYmgX8LW
         THkPslR5g5O1E3WpqIKSoF1wKSKO1f0FXgWaZLX/teFDrlHJUW8sE7iRunACIj+/L9qL
         HuyK7I/zISV1iM/XSm4HtF1UKDDvxNjjWXlw7YWuergMHvchvmO4fpEje2+0JMKjvPeM
         aORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701795332; x=1702400132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sow2MusPsrtxMYHQTqvOsRCxKJ5Iv4+FAUZthKEE3HA=;
        b=mvEiaY+XGDTW0YUpDIBwkO3k82pD0PpjfjKJHqd0GYZi9JxaAfRa+Af58FsexzWt5E
         ebRmCFPVCjPFW1uPHrgLwRspy89wWA2IIh2ga+GjsVhzFZpeJpxcfMuyn9+fzv/AdEdO
         uAdN5GpT9kBsGShbl/hflKzIrxAccESjr4MNfxrvgyNFV5aq1SpcvvEMn3i3GMwGmSot
         8c7Prq1WRiiUBbr5yYx+uoUUoPe24HzKi/G645U3x9c5NgDhsU0oLNnwFt3ruwRBqSFn
         5qfvKvVJOAtJxwK2vaZYESeqT5LQBgNGrG2MgyDIpytJKa+59TcL2tDRLlP938EQuLCd
         ZH/Q==
X-Gm-Message-State: AOJu0YzNS2RooX8Eh9v9/c3Bd7iYuG7wIj6kqZeGqiO3anqnb7qpGkqJ
	vu65eQkuV0F/ZMGJxwhXa1I=
X-Google-Smtp-Source: AGHT+IE4ZDce3hthWdMCRQldjC2n9Zx2iYL34DI9ZghZZy1irbLKsqvsO35LTAr7yz5hdYezZbaxLA==
X-Received: by 2002:a9d:7853:0:b0:6d8:7d67:dd96 with SMTP id c19-20020a9d7853000000b006d87d67dd96mr5094198otm.66.1701795332482;
        Tue, 05 Dec 2023 08:55:32 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f18-20020a9d5e92000000b006d7f41c7e11sm2271407otl.33.2023.12.05.08.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 08:55:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 5 Dec 2023 08:55:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/134] 6.6.5-rc1 review
Message-ID: <8db0a771-b99c-40a2-8101-42394dd598ee@roeck-us.net>
References: <20231205031535.163661217@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>

On Tue, Dec 05, 2023 at 12:14:32PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.5 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 538 pass: 538 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
