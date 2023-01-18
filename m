Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969687B
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 01:39:12 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id f88-20020a9d03e1000000b00684c4041ff1so9191924otf.8
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 17:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WjOCE/6QEfK5v5inKKv9A43fPEd/1+NGW5Rg3mfqGHk=;
        b=LVHWbf3VkVq+3DVCVKvwxoa2Yd0ZxD7jd+gso77QzWkzthWv2b4brHEbcX3goledLn
         66yvo/GYW0xJQ5Sevzs+dyx0o7WPPXJfGLNcq23zTH43bY6UR9wP+saoFsLY4kYfLwZH
         3FS5vbW99oHRBM3ybPHFd/JmbBARFHc6ZFRyqjEZEUzv/i2VDlyjra0FobbZAPNsJO1G
         gGCvWlGGlH0kY86IjHhx9550fTfeSuobJrfNuEvPc90j+4l86IKTAqOcWCt1He80zTnF
         l1dHMZ/AjVBPvPQzm8k2p0S+4jb79J720MbZktjpNqf7na8iSX6uHcJXTdI5RiblRqUD
         iLVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WjOCE/6QEfK5v5inKKv9A43fPEd/1+NGW5Rg3mfqGHk=;
        b=SbhTAqGUwAFcvHgBiIbZs+jVrrAlEQHzdLWMr7Wl1N8wUzIt4JseqTBHIdT3zoehLM
         huIpYqRhRU2NvuV+GEU73oyvquuQKqZ9Sg9T+ohst/F/WKjHkdEL8WYQWly6uQ/TbcGv
         8jcY/tfdXnF8qqiVygBGdxYoyMSRP8KlDtUCFUcomAlPenKDYL4JXllEhLCIkDiD3xB2
         crhXh1Qnyg2LaAty+XcksxpOFeVZl1fzI299QbjYhOCoqs+TjfQ37mSmhcVzd04YdWnj
         PCGLiaF5Yfd/nMBANIK5ite/9GVmkt5bL44RIsM9nTQ23haeV0bqsCgw2ovyDuFx1P2e
         Qm4w==
X-Gm-Message-State: AFqh2koo6KEfwrUXs5QftNQswDB+n3sYd61JOOtVmtSI1rbn7N0sP1/5
	Anx9oEOWU766D+1NR77NxKw=
X-Google-Smtp-Source: AMrXdXuxj89SNu2eoHKAcXG/K66C+TSY83q0QMK0/f/11cH0feaiQRdCiDQ9Oz4+tuYusyjNJRQ5rw==
X-Received: by 2002:a05:6830:6782:b0:684:e78b:348c with SMTP id cs2-20020a056830678200b00684e78b348cmr5630503otb.25.1674005951758;
        Tue, 17 Jan 2023 17:39:11 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r15-20020a056830448f00b006864c8043e0sm1618465otv.61.2023.01.17.17.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 17:39:11 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 17 Jan 2023 17:39:10 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc2 review
Message-ID: <20230118013910.GD1727121@roeck-us.net>
References: <20230117124526.766388541@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124526.766388541@linuxfoundation.org>

On Tue, Jan 17, 2023 at 01:48:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
