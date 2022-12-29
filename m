Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA1E33F0
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 13:43:30 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id x44-20020a05683040ac00b006707c74330eso11475776ott.10
        for <patches@lists.linux.dev>; Thu, 29 Dec 2022 05:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c/AKNkpjG3AzcQVd4ZQ2WSvobV2zMcJthzt1GCCuMa8=;
        b=lx51HzEUMKRJNqK+LwX1Y783CIcF1MdK99uBpWNybmnsDgUNqgcC9xnqH3vMjqvE05
         aJdGTrehGxkhMKHJHrHOpvGztuLhOx1mMSrACKXV0yRPlPwme+t2CGuvAsVbyTghEWtR
         DBZUPsZAgYbzfkGZwiXlIYlJNTltoRB4VKe0GggcTJJ+H8RSJkvMP/XznQ1zCx+BSkgd
         Z0DoPPkVZxFUGp46d0xkdgzJAqd+T+76DvozceDGkor1ZVJtHpMamoReswERHjg8JHHC
         AoW+pLmx7u5l9vIG6SuxneBp15snj9SpOBLqLNU0W8q1s/LHH26bwkOqaobso/CyN8I6
         OMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c/AKNkpjG3AzcQVd4ZQ2WSvobV2zMcJthzt1GCCuMa8=;
        b=HiTbpHyUT1ihiTLkKZIVCBbePMC8N1NYUTAj20I+grSjeB8qB5OfoCIfYz7un7qJR4
         PwBfO/+89CpI3IuzfzN3MxwrV/lXJv1IoCdso06u/ExzR+XLRUeznHcwryDYv29MqHVi
         0foPGA94K5O95kT+ZNkhmvDuocU+vXa5fX2lsYwtit+d6WS6PU1O7HiqmEx+iUYlGY8a
         DZqsSI2rQ/Of1KNDHGwrrKHUakMZU24Wn29JEB/uKzt6omLL8zURntg8PTQ55OD3siCU
         pReu7opdGR+QL71VDRogLiax31h4vn9OiCjtMN7zLTXklEuluwzcM7Yb3Rx5DzivAn6M
         cs3A==
X-Gm-Message-State: AFqh2kpGhj/3RZpFVmzs4pdrLGZw/cCbJqQc6kpgFFBmlAn88jcopDmx
	a3C+t7XT5sgBiniV4Qwcvj8=
X-Google-Smtp-Source: AMrXdXvdz3WgDc5KZ8RSpx3y8x+2pyRuWkgjB81V/gHbU5qzSVNz9Fk5odUxbxUXLOQiozcJJzEnVw==
X-Received: by 2002:a05:6830:611:b0:676:205a:605d with SMTP id w17-20020a056830061100b00676205a605dmr13867016oti.37.1672321409656;
        Thu, 29 Dec 2022 05:43:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m12-20020a9d400c000000b0066e80774203sm9169354ote.43.2022.12.29.05.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 05:43:29 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 29 Dec 2022 05:43:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1073] 6.0.16-rc1 review
Message-ID: <20221229134328.GB16547@roeck-us.net>
References: <20221228144328.162723588@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>

On Wed, Dec 28, 2022 at 03:26:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1073 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:34 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 153 fail: 2
Failed builds:
	arm:allmodconfig
	arm64:allmodconfig
Qemu test results:
	total: 500 pass: 500 fail: 0

Build errors as reported.

Guenter
