Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5035B1365
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 01:49:17 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id 20so4920635oix.5
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 17:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBV6tLgmQoWDoh9RhWPBNIn2AEFZuaxRQtRmny5UPaw=;
        b=NpwO/8uDseHlTvg1WKGhfINn3fp+R3EeG7vjwBorjzGvrDqXc6WQTHKMe3NDxQhV9P
         Y1LHVit0tIhDcTlfyGDaZOH/UoYyx2OGIKD3mJOifSMD3wsY0ia7IDNmvbwdVmrmekE1
         8pn/rHQbNWP+pjf/ktqBzL7RsUe5cx9RMFzkg10tl7OqC1Jz8eRNGzDuC8Q4JavdOCWB
         4xeqwCY85clu3Qx9/kTzx/l++z6mTv7E7sWk/mkLytUz4OBZzwgpaaZpNqmMY3K5oL2i
         YRvKqSSxbYY8YFGPJny6KyG/kl7/G3aQvWUmXII0P1oZNCTTicm/kNccGFjgOk+5TYvJ
         NI0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BBV6tLgmQoWDoh9RhWPBNIn2AEFZuaxRQtRmny5UPaw=;
        b=Ag1SINK5qa+UcF3r6aIRyo+6gA85Tv7KcXK0qn5Bm8IvjAlMl5OCywPdR6l8R/JlOj
         XC4bHTcVN3CssHpxij7ouIKf4BX18VpczkrYoOSXdnbKbNlWiGDlu99r16o4XomB3Jgw
         sSunBSncanaN6UihSU9TgeixH9224+Ub97776CQ47MnTAvF76qnHoxr4tXDqIJIEpUuG
         e+Ya+hY10L6Kjt82BlaGOkkPpwa0abFG4pljRDCcl77sBLSvHe6lvP3KiAmt5996eZ6u
         u6JIQMXB1JTuig0uAQIY6dOGyZQ5fyW0GEYoFV+mibQnrU+8hzW5u2ANJjMmz1vbD7af
         FjdA==
X-Gm-Message-State: AO0yUKXF7OBoCxJEldayD/0bii+bKPfBpmgSBOEgHY7V0dE0fKnbaLXT
	S3gEqO7gvMt5OOvrh6nUEnDyj5781dQ=
X-Google-Smtp-Source: AK7set/c2QtTnBc5ohHtDll1Vj2MBQnTFhgAf2asBDsy6jGuszBs9B1//LH3f2jF8JvTTm2+PNSIuA==
X-Received: by 2002:a54:438d:0:b0:35b:e443:e5d0 with SMTP id u13-20020a54438d000000b0035be443e5d0mr5179070oiv.17.1675475356404;
        Fri, 03 Feb 2023 17:49:16 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s6-20020a0568301e0600b0068bd9a6d644sm1832157otr.23.2023.02.03.17.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:49:15 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 3 Feb 2023 17:49:14 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/79] 4.19.272-rc2 review
Message-ID: <20230204014914.GB3089769@roeck-us.net>
References: <20230203170324.096985239@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203170324.096985239@linuxfoundation.org>

On Fri, Feb 03, 2023 at 06:04:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.272 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 17:03:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 154 fail: 1
Failed builds:
	ia64:defconfig
Qemu test results:
	total: 426 pass: 426 fail: 0

ia64 build error as already reported.

Guenter
