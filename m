Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3DB100C1
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:58:48 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-68a3b66f350so6573b3a.3
        for <patches@lists.linux.dev>; Thu, 24 Aug 2023 08:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692892728; x=1693497528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=56e+b4C/mK4valOujlIcq0N2XDGggcYVhpWinAnjybM=;
        b=YEliFwZd3Hk9HcfhU8gt37K+KxE91c3fyXTGfEjhePtLq0OJsKvodr7fb78DpBNDDt
         mRGfahUfSVCHwo/jTypCI24qG7jO7Y9DCjs0Kj9c7ayUWzYv2xa8HPdR6JP5x4plLdEZ
         Mbij9FQ9z9p1I9P4PosUkD87bhrLRX83js0TBdiJpku3oaza0O8HZXLJ544V3G/ScNNY
         u1lr/yhwJjuCjdrLvVV3Uuz+r5lxipor4Rj4eGHAI5KUWnGekhyCmfmrG1MV3f8NNFlD
         ZIKHuXyXMXfLu7qj2ZWWER525kzlpkrRRhIrqn0vyHbGgrbnDYfzKG4LHFSS6jW4hmk2
         klPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692892728; x=1693497528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=56e+b4C/mK4valOujlIcq0N2XDGggcYVhpWinAnjybM=;
        b=DvTMzIo1w52noU6zEDS9amj54AybSkCa15xa/XjU/gDWdCPnViaBOBfJaSW3VeWOL3
         RVcngBmxlkLURX/8lF6HtOlRPsIOH6cQJqbujBYkXzFeughq3sPEvdPTFDjkkTyH38KN
         NMNm6MYsXUnUxkbl60u+tp8w1bF5Sun3LbBp6057738MJYm+bLP+Yh4NaIRqIglJniKP
         m3rTbO9vyIAdukdik5OBsFxAF7zhGp0THw1NyKiDFGOHTRGk8F3p4n03IY0Lcj8TqD4h
         2e4r9orP3A5lK9KnDje4u22fP7MkDQjBLJu+oiquiBN5r6qGNHZs0bv6uexkjNdJtcDv
         W3Sg==
X-Gm-Message-State: AOJu0YzCoGf08HzdnHqwKGGpwuXRszkkSJEo49/gAjAUIw9skHHaYTwP
	cTzQSE8Xs+qwabc4ucJgjco=
X-Google-Smtp-Source: AGHT+IHyTrgOO0pnw5NhpoSlYM9QmCFogTbtDea1WgU6bIwzDc6FhdcVrobhqDjDiV1tPxUioSmAGg==
X-Received: by 2002:a05:6a00:2353:b0:68c:70:d175 with SMTP id j19-20020a056a00235300b0068c0070d175mr990075pfj.13.1692892728249;
        Thu, 24 Aug 2023 08:58:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f11-20020aa782cb000000b00688965c5227sm11264163pfn.120.2023.08.24.08.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 08:58:47 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 24 Aug 2023 08:58:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Message-ID: <78a26d15-68eb-4a6f-a092-f7a554aa29e7@roeck-us.net>
References: <20230821194122.695845670@linuxfoundation.org>
 <991b93d2-9fde-4233-97d5-1133a9360d02@roeck-us.net>
 <2023082309-veggie-unwoven-a7df@gregkh>
 <CA+G9fYvwxuVpSn24YvtdNXaofg2JtZDREatOpDsKTVJX+nFN3Q@mail.gmail.com>
 <2d8a5f48-6c50-4c12-8a3d-23e621c6b722@roeck-us.net>
 <2023082325-expansion-revoke-1f3a@gregkh>
 <2023082401-arrange-bulk-d42a@gregkh>
 <4b8fcb23-c5e3-4bf1-957f-f0cc717564be@roeck-us.net>
 <2023082459-oxidize-script-77e4@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023082459-oxidize-script-77e4@gregkh>

On Thu, Aug 24, 2023 at 05:15:30PM +0200, Greg Kroah-Hartman wrote:
[ ... ]
> 
> This might be an issue on AMD chips, but for some reason, in running
> this kernel on my systems here, I have no boot warnings at all.  I
> blamed it on them being only AMD chips.  If that's not the issue then I
> really have no idea, sorry.
> 

AFAIK it depends on the compiler used and on the enabled debug options.
At some point I lost track about what exactly has to be enabled to see
the problem. We see it a lot with our (ChromeOS) debug kernel testing
which has various debug options enabled, to the point where we may
temporarily remove the warning from the kernel to stop the noise.

Alternatively, as I had suggested earlier, we could revert all srso patches
because they only seem to cause trouble. So far I have been resisting that
because I am concerned that it would make things even worse (like one can
not really revert a heart surgery without doing even more damage).

Guenter
