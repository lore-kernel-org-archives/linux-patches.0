Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572A96EB61
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 18:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rnau97eU"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1cfabcbda7bso9259755ad.0
        for <patches@lists.linux.dev>; Wed, 06 Dec 2023 10:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701888299; x=1702493099; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I+/98j/xqe2VNXzxExNyuXe8kMEXJoLbPHQEvWYwrPg=;
        b=Rnau97eUsNHeMCuyRot4RO3H3+MRU459/CqiCixwIc4pbMdp3e9nsg8KVX9w9FwydI
         7MT7f7tjSgQp7kck6hwYz4vF6QR8flEy35E+F0iYRZ+wjK4Enk9B7/GaXNcflMc3m/qp
         j/YacnmJHOxqS5T1AA8Cw26lHrkdNlT9W22G95/UVh5Lb6uqrR+mvbl8BQZnPOTUVMW+
         WA7bDMEKPU5ICldAqKZkg+CniwvgmtQ622OMrxvovw1WF/PvGm7qF+GpmVh5L/h8IEJD
         aHft9CP7UCa0EC7j7jgvwaEfX/cCMJhv50IJeEFJ3PlVZpN/Z2KX0ArNciL0FnwxRGda
         VMYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701888299; x=1702493099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I+/98j/xqe2VNXzxExNyuXe8kMEXJoLbPHQEvWYwrPg=;
        b=u4no+f6cPNECtqFSu0N4bNNUmMTJszq3CwR10s30PbXMzNratInfmwATqbYHbz7dz6
         5SNSAPydzgVyAy/neOxX4Xur/FApdnzv/6d0Be0dK/w57wVA85EEqNxQ6+cJu3B0IBL0
         lkGyeWVN+dcDm6ngcVDt8O34VlXB8sy0o/r67vDm7RsMMxjPEGGYG5MwrECe1VuUm29A
         S76Fp2LabW5wq3PePFEoGFttQMeyPxSj21O89oph7vYEcWR2E2MgABHBB8E/wkvNbYNJ
         cLSgeuGHW/eCmgBXD7hjJi6vPqaPNbQ4dZ8GzfGSufXLkZJnRyNrJ4GaQkhWZgEGcoTD
         JnzA==
X-Gm-Message-State: AOJu0Yz4+GdxtItRqgoJ/u1o7IdgEDQhsz1EtyjdRyTS3hLfzZU55MCU
	dqtAGFjbQ0p03CArudum2r7TSd56uu8=
X-Google-Smtp-Source: AGHT+IFbfCrstIdUA4m1TuN4ZqxGaAd1VlYNtUqPm4jg7M0XPKC9yVJuEBtBHvWQ3wVPiv6eHLzAvQ==
X-Received: by 2002:a17:902:d487:b0:1d0:b5aa:2ff6 with SMTP id c7-20020a170902d48700b001d0b5aa2ff6mr4917265plg.39.1701888299532;
        Wed, 06 Dec 2023 10:44:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d14-20020a170903230e00b001a9b29b6759sm145074plh.183.2023.12.06.10.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 10:44:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 6 Dec 2023 10:44:58 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/105] 6.1.66-rc2 review
Message-ID: <b118cdc1-3cb0-4a27-8b74-6cb27e45b689@roeck-us.net>
References: <20231205183248.388576393@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205183248.388576393@linuxfoundation.org>

On Wed, Dec 06, 2023 at 04:22:38AM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.66 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 537 pass: 537 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
