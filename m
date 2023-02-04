Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE101365
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 01:50:30 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id bx13so5667234oib.13
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 17:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zhmFp+m5BOhDIQMjpmUyZASvbs/UBISjLx6cXPlayfE=;
        b=alQ6IDk9qPd/josJoGtkQ6v+hNK+qwfRZUGliivEUjMd99zWZqtl1prBLfKvz4qNAU
         zjLsJ2DFWKmp2hu4npnW01XIKa+l/FgpZl/s1NRkpzZXstB02Y7cXXjwl72Hg/COzWuH
         hswUpbd6ozTFEsg+dZy9q7tqhc8LT7RqETkMk+fhI5aqh5EjKytuo8QJu9oeL6RxktU4
         7DzLvtOZUZDsRMULYcp4T6I9aNBq13tZen/OCefZ+SgrWYIz1Ar4T5vmDPsqgHkvX2sE
         iNLYYLc0q6LnED3bQmN+0NQSZ+8uf45rh25s+R8FdUul4tXbJTav+QI6h24I5EpGEEYw
         964w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhmFp+m5BOhDIQMjpmUyZASvbs/UBISjLx6cXPlayfE=;
        b=4bAxxaBR2Von72NIwWXbm5bAvVd7bm5IQcXEGo+V84++2k3rRA9qUIqdGxSZQds4ji
         5njvQv0+X182BmsvttfmH+maVoiSF8BXwIPNo09IrXL3yFXMMuE5TIOTLhDrGnec/V6o
         XlCIEayIiULEvytrfnPV/gdsDS/fMWzNYDqx07jCRFT11GWGVi1zsAn+1o4PXYG6Qo8G
         KEQ/FoBMGJbUHSl4Tksch9a26oPRs/GixavmG3yLC43QS4PcFUkKanLY13vdlzRcizQD
         8TeBqXAF0FmG6gdadBiDwnRvGicOWpwRZaQe/lRVAR4ws3BKCnjbp1y0r85EzKmha7jo
         d7xA==
X-Gm-Message-State: AO0yUKXGdvRx8adJeZkBbX2KBvSLiEhNBNE40bZdbfTfe4oTTilKNXoA
	2gJPvjVmRYqewFlI3dsAt1k=
X-Google-Smtp-Source: AK7set/k4nC5XQdhGxsTmJ7b1NIMNHs8P85/gu/4kNtvcybGlhUxA1rAF8VQOE7DIOREU1nL/yToMg==
X-Received: by 2002:aca:4586:0:b0:363:a5fd:9cd5 with SMTP id s128-20020aca4586000000b00363a5fd9cd5mr4472301oia.3.1675475429993;
        Fri, 03 Feb 2023 17:50:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d2-20020a056830138200b0068bd3001922sm1831736otq.45.2023.02.03.17.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:50:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 3 Feb 2023 17:50:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 0/9] 5.10.167-rc1 review
Message-ID: <20230204015028.GD3089769@roeck-us.net>
References: <20230203101006.422534094@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>

On Fri, Feb 03, 2023 at 11:13:29AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.167 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 478 pass: 478 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
