Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8104D6D24
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 16:22:03 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id d12so2325818ioe.10
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 08:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1GJtP+8RjhN3ucRBaCvPm/TRUilYHvgTU8JtJej4p/U=;
        b=qU59TttVz/e/wcOYB1SJLUkVQYB53HqGeelzg7cEIMsNsM26BkE5+15f+XpWxsfnBo
         0uhG4siyjADlAJl5wtonvS+OhaMge2/AbYWSF0jzU0qqt4kvO4+Meb88yeX2Dy0BGY8g
         0RMXs2Zo7E6a3xgIEaCtVTjALrgGgkqpD04VHO8mMvXxjvn9R24kxwjGUi6PN69i18+G
         HX62k1EysSqrYvREhC0gurx6kgBz3wDxZswimZI0qbeYxBqGBEtYAnrynRgrx4OEQ/F0
         3sInRtlPSdg1MwVWu00O49W3G7qnuKQcFKEOt9GEckTwj253AYBveIf373B5dKNwmAde
         fNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1GJtP+8RjhN3ucRBaCvPm/TRUilYHvgTU8JtJej4p/U=;
        b=ZSMy/K4zLcWl+k5rTbnrAVv53XmZtoqi7X5+D6pIIsPPUECyMu1aWVETsnvADi1+d/
         il7jfCEpUc087OrCS3bZB5xPkFfoztW/au6xOJMiyvXQ6bG724wpQHVC2roloThQ4y3i
         sedxyVwFPWlfycDOm0ssfbYEMTOMd4WeoxKO3umNkF9SLkYvNEvq4e/zkHp3aBgl4Guq
         rZoBBOa76HI7NRT5pQMG3Jv1KzYmMn8QpIk7jniMCdT+i8QkF8VQP61l5Q59aUdhpF6p
         XvZmqLti9P09xjwWeGbJYvHIONvcE3aIQgtR6MPfQxYPZ0lcDOa46IQWXe+p9kRle6pj
         84rQ==
X-Gm-Message-State: AO0yUKWLmcY8AaPkL1y359UQKYZRr4VuquaEVgoJvzHpFQ3Y+M/e1V6S
	3MlMEcy5DFX97HSo2IvhdLM=
X-Google-Smtp-Source: AK7set8v2GVvSmrxflWjovVDNlprtI4a06+8hyX4uRMnTXqRcyFjwtGAKfHtNz03vKC1YuM+Sg/a6w==
X-Received: by 2002:a6b:590a:0:b0:71e:ea4a:cad2 with SMTP id n10-20020a6b590a000000b0071eea4acad2mr10831301iob.21.1676996522661;
        Tue, 21 Feb 2023 08:22:02 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w3-20020a5d8443000000b00745bc07f527sm1027464ior.10.2023.02.21.08.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:22:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 21 Feb 2023 08:22:01 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
Message-ID: <20230221162201.GF1588041@roeck-us.net>
References: <20230220133600.368809650@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>

On Mon, Feb 20, 2023 at 02:35:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
