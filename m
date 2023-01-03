Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B6E8466
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 14:52:00 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-12c8312131fso37003360fac.4
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 06:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jnflFZNe0pA/ZYIPDzYWn3fRyrXDaT7T1O70Kantkxo=;
        b=TEDrMUd9RqBtm4eSy6MmGo/oCcTE4Z+FJhmg2mTXBmzQN0OPOJVtyX5G2LS46k3lcP
         unaUK2ln0mnXgAld+D4g2gRCGHYZhIC9w40gXvI0wqFIdgZnh7mu4jSN1rjxcJwv2qdp
         o4YPvcrTlO9ti3tHs5fkLO1R1J6l21pxZRdhPbgTJ74JrIaXbN5yGeDOAkjHemow26Xp
         /365dOB36MY3+jNdtIOlbmgB9gOa3SBjZPvuiaBuzrbqkNzTHjiWTqYowvQSGu3ek+vo
         FCJBUOQslBfMUQXQQJztqZ88w7U6nH06NlTG1yzaSFjATY4xKOdkC+3wuXKwaooJi0Uu
         mPPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jnflFZNe0pA/ZYIPDzYWn3fRyrXDaT7T1O70Kantkxo=;
        b=bhpEsdHi2n86H5DsCc8+KAttpdt2z5UC/AL0bn214bQiBGh8AjtweftTzklE/EnrpS
         AhUnP1b1Xp0b1MqCxSLNjm+PGJ2oF1NUuI6+3IMVhQXkZZhGiTBwiiSlbYWEl9A/mBcE
         wYl+xntSZCzONRX56JwzOVvfcbCg0YeMfLNAGmhsvJu08cotelotBmebBBGgnWv+ZhPx
         vueSZCW8KWTbua5vU2frdeS/j9acFV1Hq6Su8uGHTdsk14HFHuPF8njMdeKQWorf5wTy
         dHSgQ2eGHx9mAibqLa4CupMBvZSJF6L5xG7zW2qGI4P6F9QZHHpB/iGq5HVopyAfo8Tn
         QglA==
X-Gm-Message-State: AFqh2kqan6R684jhd3DpRbADlSKAb8glo6b/oYGdFH/WRUINhM3CMXsa
	VLNLl7+8D6qpKTF4mFdggzg=
X-Google-Smtp-Source: AMrXdXs6MYI9m3GkQ9ZQCPw1EwIxc+QZ3vKMSFuwc2q4U1HHyfemHaKsF1oIptKevWas5Xc5JHHcCg==
X-Received: by 2002:a05:6871:468b:b0:144:d64e:d6e1 with SMTP id ni11-20020a056871468b00b00144d64ed6e1mr19836087oab.44.1672757519804;
        Tue, 03 Jan 2023 06:51:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f13-20020a4ab64d000000b004ce5d00de73sm10555926ooo.46.2023.01.03.06.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 06:51:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 3 Jan 2023 06:51:57 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/63] 5.10.162-rc1 review
Message-ID: <20230103145157.GA197592@roeck-us.net>
References: <20230103081308.548338576@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>

On Tue, Jan 03, 2023 at 09:13:30AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.162 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
