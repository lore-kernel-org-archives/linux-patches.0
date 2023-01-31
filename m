Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2806629
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 03:12:31 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-15f97c478a8so17743440fac.13
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 19:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L/yFocoAYOTu5Uft/lZVZXiYiDwDL6YcXu2NwPqre3s=;
        b=aDSBNEUP8tbrXHIFzNhcEdGzUNi7f/asW71tXpYn5t0/NNx3nJ3CQuZhUojBGkX4O8
         rpvhSo8BJh4iFMcr/t9XbpvDUZeZiSmUR5npEYVvTrNLkwuENm7ttH4fpiE7dfJdsstV
         HAjaDj+JUUU4h14EbMRwynY6vTR/kCDwpkhPyE19UulRk/ioti9jbLJro3nm6lh1myXe
         yQb7jWeqDaWABwGjJmALirR61gLkVPk21/Aj0KYYTb+aufd+Yv9P98DlOLd9ll7/+NUX
         +d7NZX5lSc/7AkQpIZQS1ZJnRkm55b2dTJJ+oCGkvTs0mwYz5D1YSxZqULRoDAGb025O
         Sw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/yFocoAYOTu5Uft/lZVZXiYiDwDL6YcXu2NwPqre3s=;
        b=pa3qZ7nB7Y831ZlZ3662C+UIYPn8jUaIR8YlTMyzFbtXA9QgGCQwbVLAZwhceUFRdU
         lDOhIsXJMunCnHZACaTFdpIHy3Jl6xaiqmElJ8p71C+zJpq2sS0anOjc+OfMM/c6urDP
         AWssnB8u2WlPMlllE8IyTvzyPbr3+KBD4uiVO050uzQGsxsl6Fz6k+mc71CPWLOzyRdi
         tIDxTIyZgvgBKv881ShFSFGYepTLfEGiU7cxKbeCgo7f6Snq+rJajDEf33MYVcjTqeJ4
         abx+6Dg+PM3Fm5PAz/owLA96qGd3PdGrc9MbP5icSAoVXUTc6NChGI5dTgpveKrLXfhw
         OfWw==
X-Gm-Message-State: AO0yUKU/wik1TMH+gIrltBxtP89cT7IO/NGBZYGewedJFwOwnG9+TLLR
	usg9GdFAj+ETMZw2JMLAbQcxq/Kh5VY=
X-Google-Smtp-Source: AK7set+2/9rBzTouYtt3GOr3dKVr0B8Kqi90JNM+W2VJ9815/BgBt/8XlGzdAWBlvU5GsCHqP0iohw==
X-Received: by 2002:a05:6871:8aa:b0:163:4a41:ea94 with SMTP id r42-20020a05687108aa00b001634a41ea94mr10380304oaq.49.1675134751027;
        Mon, 30 Jan 2023 19:12:31 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f4-20020a9d5f04000000b00684bcc9e204sm6074907oti.78.2023.01.30.19.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 19:12:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 30 Jan 2023 19:12:29 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc2 review
Message-ID: <20230131031229.GC835036@roeck-us.net>
References: <20230130181611.883327545@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130181611.883327545@linuxfoundation.org>

On Mon, Jan 30, 2023 at 07:24:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 18:15:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
