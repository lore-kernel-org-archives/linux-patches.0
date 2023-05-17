Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACED290FD
	for <patches@lists.linux.dev>; Wed, 17 May 2023 02:52:20 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-253340db64fso370882a91.2
        for <patches@lists.linux.dev>; Tue, 16 May 2023 19:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684291940; x=1686883940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jaTHqXWE1EpiMliJCprZs9xZj+DcX2XA9gKFLsIwevY=;
        b=isznSnUI6Jag61h3gdlTcxd2az5dkaJhf69SNArQCjOJj5Q1bzkNBjvajBXNT3L75r
         APh4j45eTRpIGpizESnBUqjfLnlORKFOvKPfOp9UEMuNJwDCYemaQebC5aHxVP0Fnjom
         qceCWmdcY1bzO+CCuDoUbDFUUenMj+k7K4a1swHAlGPy4V7xmLm1XVvo78mWIm8LZORo
         +bnLehJwOo5eGnSpnZk44sWPTNAQwilhowoRFpuGCmrkm/2sLE7gduwUpMgUUNh6HV19
         Dv8oiv6GvBwVrnQzJO8E+EjJFGldkdoEICc2wF62y7nE1SxLDl6hn8aNalalbKg6mJSK
         rZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684291940; x=1686883940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jaTHqXWE1EpiMliJCprZs9xZj+DcX2XA9gKFLsIwevY=;
        b=bx15LE4/6gZKO2v5cdVugRLLl3wGNUnpV4FNoW60OcKkXsPblegBR9YCBtqnopzyzZ
         AzOJtvaxtuPXHPDgdWaWaEE/PJI0ejbiPLLleSjfAKW6qBgI9Ebcsm1GI6DjNhJROavY
         TTBPzl+OeNdPJo58hLaRRRUJUeb+RJg8I1X4o+vIwlPQ/CXQGT1fRfpdB9XDSFE7in6b
         GvCEetiBlw+8J/ZPW3erPn+kfzNIyWlYrOx1mawZ6LFiVwc+mRzqiQKG1qHU9HJjQ+gf
         SEwWP+nlYcRrR35pos6B7r0GSOJwVx1CgPBlzCJwh5OJ12SG5SVKRH2WRUbN1fZ5qm4L
         Wexw==
X-Gm-Message-State: AC+VfDxolgNYmEpZeArKvVkAItjhaY79WcyCbpPbVWv+QaJ6qQOfc+K1
	jSrmpHFBGqCi34RNLAVR8nciczD6iSc=
X-Google-Smtp-Source: ACHHUZ4hGMFfasa4TY9gMKoC/mYVhcOMyxS9iCz1t2Hp5jnHlU/kepIw570D74PJDd0ghL5smGZ+vw==
X-Received: by 2002:a17:903:2281:b0:1a3:cd4c:8d08 with SMTP id b1-20020a170903228100b001a3cd4c8d08mr47903074plh.38.1684291940517;
        Tue, 16 May 2023 19:52:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g7-20020a170902868700b001aad4be4503sm16268713plo.2.2023.05.16.19.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 19:52:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 16 May 2023 19:52:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/239] 6.1.29-rc1 review
Message-ID: <1d30a01e-7e51-4152-b6cf-f3afe3fbe9b2@roeck-us.net>
References: <20230515161721.545370111@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>

On Mon, May 15, 2023 at 06:24:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.29 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
