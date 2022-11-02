Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123AF24F2B
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 20:46:04 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id a13-20020a9d6e8d000000b00668d65fc44fso10940868otr.9
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 13:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4aG3HGUNyt0DwZjjpAuTJy3w3YBkMNz9bVnWWoE5yxo=;
        b=mfGOuVFr9mYTrrD4fJ6eUxcXNsu/7ZbadNCdYERyIVRHIbU9VX6YiOjiBixVFxgoFd
         Uuig9VXG1k0xYSoCEDqjY8L/DrvyK5xt3GIEpyh6Xjr58WpH+wuwMfce3O3p1TlND7rJ
         4sDfYt4ug35saReS2gSuDXjaAvvwarpHeOCej8QWULwBX9sJl/Joz3utLkdDkuFF8snq
         gjd0Yg2f3c9WLPmeeuM708ziCL97lDMwdOicl6bL91C9brf61oSAv97Ezv4AAaO1Z3nR
         RnJG/hE6D3vdRVa+VbL0KDH2qcNgiKg1/FFe82brEJHYn3/UFfXiIdXpCgZCcu4cC3Ub
         wWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4aG3HGUNyt0DwZjjpAuTJy3w3YBkMNz9bVnWWoE5yxo=;
        b=MKlTHXZLpuNgOV93xTzSbA0S5QpptdgkpYXPzymtitHZRDTDH1RBd806zt5++f9bF+
         uFK3bCCmio35gt4qDYY4F8pYxMXNV0jMk0FImsKTpIXFWmKloGevN3dgof+G81K3Gz0U
         25vZV8BBUrwjPshyoB59AIJn0/rvH9SCpkxGt0ynJYSdoRLwiyx2H1ln2XWzL6GVNQGX
         Ejhi7jDpAVQvFh6FzIKg7ATMf8PX72SJ0FE2t5bwL8kIeUF6uGekLbF5JzFcIC1LgmJu
         ECAOmcponmCh5CU8tHQzbETivfDhMwnfTwkPso1S/q0/StkWVv7KpVLWAhFRlrX1B55U
         u6TQ==
X-Gm-Message-State: ACrzQf3RrtNhimcrt+lKFt+ApVYR9OKqsmTcvVsF9zNht8vhVyQDh2ky
	wTHZ8eMT50aqEt2bO576+hQ=
X-Google-Smtp-Source: AMsMyM7DFmD1zxRjWQ8b6Se5pEik4ZuRNeplTN9G/2+VqDX+VDDjf4dczm+fSbKd/dTF0QdkuXU/Ng==
X-Received: by 2002:a05:6830:6019:b0:66a:f955:4548 with SMTP id bx25-20020a056830601900b0066af9554548mr13508765otb.176.1667421963185;
        Wed, 02 Nov 2022 13:46:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y37-20020a9d22a8000000b0065c2c46077dsm5328617ota.67.2022.11.02.13.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:46:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 2 Nov 2022 13:46:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 4.19 00/78] 4.19.264-rc1 review
Message-ID: <20221102204601.GD2089083@roeck-us.net>
References: <20221102022052.895556444@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>

On Wed, Nov 02, 2022 at 03:33:45AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.264 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
