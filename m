Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB1923A4
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 07:49:07 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-63b5465fb99so678135b3a.1
        for <patches@lists.linux.dev>; Sat, 29 Apr 2023 00:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682754547; x=1685346547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6pvjzdnd5gnbP4mkYTooIPMSHKs+RTnV2W0N64by8Pw=;
        b=UOETjtlz3CdVYolmMtxD0e1nV9O93OzGGSlMMQ4HKXnk5ksrbCZSM95qpN3PBjlVnj
         i7H2bAOPW8QJzpwuXetkNjl1w6OHbBaT+b87Bcw7SGdbeZ4a9KZP/djdQhWPLBq27NJE
         0FxRD5WOLunZKeHFlQmTpltSODGdAcofplaoeUINEanRSQr2Drbyh0vQc+lVosh+rn1L
         FPcgztbNQuLCzmQ1JaEbBvMqOi0EQTa2Gc88OPFCPEDVXHBNTEj9UxbJs0F4pG/Pq5nZ
         vO57ngeFHd639As3dQhofpmJzHaUhsMkdFHvwJIxk711J1hDbNshHOv1ho3GCRgKv4nW
         pQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682754547; x=1685346547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6pvjzdnd5gnbP4mkYTooIPMSHKs+RTnV2W0N64by8Pw=;
        b=JFXjOowVENvU/bCZjynJMzRgZ4X7k/oH9QGTQbp0Zv9yj1V03XOiLoTNW9h1q+lHdC
         M9Ku4JJ+9YNY827YowpCctdv+ciLuAMhQaiF+essEPK07kIJQx1L5HeBNXIl81F/5AXQ
         VMyBC3XOu/ROje4EVyhL/4/pqecpjugoLecbBLOiTF2uz+f/8zYaPWZwLae03/GqbLkS
         WkTgj8mC48/X9/4dcFVI2BcUA5bi9Zigeo1kr6YOlt/CIt3BOF3Z2f0N/0v5t1Gs4k9e
         8mV9qqPuguytW3WIJmzM2qkIr2ONNCpIr2pB7ndXWP48NYut+gcSp0+nue8CsU1cQcWM
         Ycag==
X-Gm-Message-State: AC+VfDzg4Ih67yBOLJtv0mgfW7cbnnndmYxCqOsSSQejEHeQgH0DwPh2
	d96BVrDxnLiiqBSGDxzMU/g=
X-Google-Smtp-Source: ACHHUZ4FfXYDtx3YiwCcG2AEidoElcs+0BfbQb1bL46mNdL6SKJCzyBq9SZhF0a9fwTUILh63UfeBg==
X-Received: by 2002:a05:6a00:2e91:b0:63b:5496:7b04 with SMTP id fd17-20020a056a002e9100b0063b54967b04mr12072767pfb.9.1682754546733;
        Sat, 29 Apr 2023 00:49:06 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-88.three.co.id. [180.214.233.88])
        by smtp.gmail.com with ESMTPSA id b21-20020a62a115000000b0063b64f1d6e9sm15245795pff.33.2023.04.29.00.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Apr 2023 00:49:06 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id EA1B0104FED; Sat, 29 Apr 2023 14:49:02 +0700 (WIB)
Date: Sat, 29 Apr 2023 14:49:02 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/15] 6.2.14-rc1 review
Message-ID: <ZEzL7kukPM0FhGjq@debian.me>
References: <20230428112040.137898986@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230428112040.137898986@linuxfoundation.org>

On Fri, Apr 28, 2023 at 01:27:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.14 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully built and installed bindeb-pkgs for my computer (Acer E15,
Intel Core i3 Haswell).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
