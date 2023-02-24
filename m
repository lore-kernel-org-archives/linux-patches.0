Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED39D2E6
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 03:42:24 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id u10so15164380pjc.5
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 19:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dm48pFZyVUakxJYWdujNt6jVqzb33IRoM5ttLAEElTc=;
        b=NckyLiPi7//kP1eOXaMTWSJx6sObdjPdjQ5u87ghNeY1HoSDgB6HJCSb3b3DNmOzzb
         S6adJSW7ggHTP78XJk20CzmhbUeO8fa7nVDiNBphzFhcMiGdF3dnJ8JJmVRSgtlm3XVT
         IyWIBFMU99fyzWiONpRCKEBs1ZURWHjgO3krA6dwTz9jtPF5v/emVqHQ1fDiX7CX1/Dq
         3Mo7YWEKfwFrR5aYBXnufS0BoXZSSKwLSlrkJ7kL0zm4D7DTz1xHk5qUfcT1n3YeB5HO
         GI0TAGfRyD4ia0ElAxag/nQsV0z3/oDdCN1eMat5Q4oF9n7cd0LeuKJc+kTACtC7BUWU
         f5uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dm48pFZyVUakxJYWdujNt6jVqzb33IRoM5ttLAEElTc=;
        b=7o3lu+lGX+o+LbtLXrmw1v+YuR9omSGVEjaR92ro6fOJC0kZQqdhG+H4OAqYVpgN1h
         G/V+N38xyctAPhqdBxwnbYUMquOVYWL1l67ItvpSRCceNooDYKQ1iKnwgkUoVe3kyljU
         XnHZoYH1BHjb+q3LbbBMUppFCn18HZ+b135BeKBQEYVLcupXtvlv5Bxxive42/REVylA
         wvCEQvSXgdfoBz55zC7wcoE7IJydQDRh+rjDNpl5cSh/4ebdgLxlWEKBVOU+m3qAmeoh
         w/3Qf7B9Hl+B+who+5Fx+YdPIDIYpdToThAGDCikiqp3GEQ+PtHgBQyvB8mLoTHWLOLV
         O5rw==
X-Gm-Message-State: AO0yUKVDLbhMCv+PRoiVPPB2KVNFcSmWSjPKZoRH+1oL+e1zl/5n9x74
	cRXO48qHQY73SzbTW52gHI0=
X-Google-Smtp-Source: AK7set/EF7WV/kje5lDltcwnQzpGuNdswVxJYj8nhFHVGkSTqyQ4dhXgEe9H8jtZ2HyPzr3AXMBCvg==
X-Received: by 2002:a17:90a:15:b0:237:161e:33bc with SMTP id 21-20020a17090a001500b00237161e33bcmr12796870pja.16.1677210144300;
        Thu, 23 Feb 2023 19:42:24 -0800 (PST)
Received: from debian.me (subs02-180-214-232-89.three.co.id. [180.214.232.89])
        by smtp.gmail.com with ESMTPSA id x18-20020a17090abc9200b00233aacab89esm429235pjr.48.2023.02.23.19.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 19:42:23 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 171FD105EA5; Fri, 24 Feb 2023 10:42:17 +0700 (WIB)
Date: Fri, 24 Feb 2023 10:42:17 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Message-ID: <Y/gyGS08EIuFYxjH@debian.me>
References: <20230223141545.280864003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>

On Thu, Feb 23, 2023 at 03:16:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara
