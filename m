Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C1C1F5E8
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 18:40:39 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3adc9770737so1414188b6e.3
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 11:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695062439; x=1695667239; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FscpY3xTC9ICVoNkL3BbrpYTdLnfoHmR+kw2SpUpWvw=;
        b=dY7X/Dooh9vnmXFqDV8692pDFNI/+sgDEWR3r9jUaDJ0lx8u+kW3AtKoUtmw8SU1tb
         WITtEMOF0MZayXdsUQ0OFNNx3mAuBSpmnebkgAR6E/1EFZ8aLh6HxuiJBa4ZC5z6+HpW
         gTh1EJrWNVpq+TCgoz97sjTcYOpISCyG/6GJabwzgs1T1MldE6tHUFk1+fwxcYWDyNVC
         EufTAbj+3uJhNZuVIvtyxygsypRUo81HyQShCVp5JbmtBC0Om68OmhfhVN+Te4cdhNek
         PsrWq6NYzMCC5vLYQ+mWaYitbyC4ZDP7QOJnhOj4w08RwkuHm4AakU1ItCKWOhH6p6KZ
         LLXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695062439; x=1695667239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FscpY3xTC9ICVoNkL3BbrpYTdLnfoHmR+kw2SpUpWvw=;
        b=IcN5RBLCsOAuzrnFcnNi8HwvrX9Ql8EAyQuOYiIou9fjnGbxjXo+wFmWCmt5FU+SxW
         c55qPxqWjBe4jq9QdDmJPzN1xihc8BI5GGSVHEThXKD+44LYYDZYB5c7xHjn7Zk52kCc
         gB/YjWiuA/wFgRCN2Y9FCIOWVkGcugdJgqribZLx6U3tTU/Wsr42kIVUqM2bFlYHDllt
         8YBabiUhqKdqii81k2933RFSJiCqCkIr8wRk9WmgMmBs9HgJ3GfUU5Hn34pMjuRATXld
         jGjU5ozI456G3T7AcXLW3cQlpT/FtrZAt5XlE48VPGE+3QWBcjpd/ofE71m1/WBJcwgD
         q2iA==
X-Gm-Message-State: AOJu0Yzf/EOBIq5bKdZS2TQVZc8fCxjXPM6xRcURpICzoBVLfSOizasA
	Z9dNOaZAL9nr1sG21UmFFiFV9g6x7ms=
X-Google-Smtp-Source: AGHT+IFSfcF+Y0rWXSYJZYLkg2/5WLf/M2X0h66+gaIoVGOKpcPT50Hbi8lKYP8di/g1NknGYFjgBg==
X-Received: by 2002:a05:6870:391f:b0:1d5:5d44:7404 with SMTP id b31-20020a056870391f00b001d55d447404mr13120346oap.43.1695062438706;
        Mon, 18 Sep 2023 11:40:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id gk1-20020a0566386a8100b004302370a169sm2870493jab.157.2023.09.18.11.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 11:40:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 18 Sep 2023 11:40:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/511] 5.15.132-rc1 review
Message-ID: <d51e5236-54b5-40fd-86b8-c19a16f56904@roeck-us.net>
References: <20230917191113.831992765@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>

On Sun, Sep 17, 2023 at 09:07:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.132 release.
> There are 511 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 

My tests say

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 509 pass: 509 fail: 0

However, trying to build with clang (as done by ChromeOS) does report

fs/ksmbd/smb2pdu.c:6256:6: error: variable 'fp' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
        if (work->next_smb2_rcv_hdr_off) {
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
fs/ksmbd/smb2pdu.c:6367:21: note: uninitialized use occurs here
        ksmbd_fd_put(work, fp);
                           ^~
fs/ksmbd/smb2pdu.c:6256:2: note: remove the 'if' if its condition is always false
        if (work->next_smb2_rcv_hdr_off) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fs/ksmbd/smb2pdu.c:6248:23: note: initialize the variable 'fp' to silence this warning
        struct ksmbd_file *fp;
                             ^
                              = NULL

I guess I should try to add clang build tests.

Anyway, smb2_write() already initializes fp with NULL, presumably to handle a
similar problem, so maybe doing the same for the read function would be the
easiest solution. Note that the initialization was added upstream with commit
2fd5dcb1c8ef9 ("ksmbd: smbd: fix missing client's memory region invalidation").

Guenter
