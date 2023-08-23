Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A71E2917
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 13:28:07 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-34bb6d58f84so16227935ab.2
        for <patches@lists.linux.dev>; Wed, 23 Aug 2023 06:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692797287; x=1693402087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b1k7Fnb+QkSpaEkMrTKWq52o4HXWXKwP+S+nMyf/GHw=;
        b=gzAKzbTbV8dOIOXlhh8uGXW9cIpX8TpD6AB4yVvOahUMcyAkJS7hiOePSaKyUcAAcs
         mio8ENCnFmO/GgAUK5iq/MdVKNHQby/yLBw3LNIYnbRLrsluxFIMew+MLhOgNqc/VyuW
         CMv7svmImwWGB/1NJZV28kxHac+fEJvVyUhVAEyIwrThD8UXluu4tL4aLTAIk2yObS8v
         +7bZPEIR39G8yF+cIUXylMTFZJ8qc0AikgEt0iAg1lh5OxYmOWhF3tVeVo5K5Rw9vOlM
         Ha3Pgfa1sKKmQItyYY9dESAxUziPEgrjvhr8GhgSOujL0marCWH9FknF5HEl+PK+3yLt
         i0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692797287; x=1693402087;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1k7Fnb+QkSpaEkMrTKWq52o4HXWXKwP+S+nMyf/GHw=;
        b=TasZJe5L5CU8+uEmRREWw6VYBbNMbdr+/ES0ndFOmwFlgeZJrATXfG/BWiydDdNXvK
         ZR700hJ2QGvGkC1Okx6mq3oLQ47xbB3oXb4K8amT3lWd+08gSPZ6nsNlUWWRYPObNy9X
         kOouNHoF7gJcuNvg76568HRecMYrMafdHRwUASByUe2Y+tnFgMCdBAbkT62g78LFgEfP
         E5VyYc4+bmrSod/NJCmE1MdOjrN1t+0K8sNzGdQrkGBCLE6OAdAWGgOMvlp3r0FRrn7d
         0/H6Mq4ZE0ae22VuMuyssoblrqp0GD5fHyYMhpJQpi8jkvyJ8qzrmYuuQyDqxussaUx7
         CE9Q==
X-Gm-Message-State: AOJu0Yzyoh6y9EBTwQEFMAxaaRfK9wFeBVQb4NY7FXxD2TzfF1Vbqe34
	SJwEt8yg7wv68Ub3dEB02NE=
X-Google-Smtp-Source: AGHT+IG0ENLXwnyM65ixhgaL9IR4YqAghb/lD07OIOdsWY7rDdauhYn3KJbcJB5ldSNReZWiQQ433g==
X-Received: by 2002:a05:6e02:1a0b:b0:348:d78d:a1a2 with SMTP id s11-20020a056e021a0b00b00348d78da1a2mr3192080ild.21.1692797286832;
        Wed, 23 Aug 2023 06:28:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i25-20020a633c59000000b00564aee22f33sm9690768pgn.14.2023.08.23.06.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 06:28:06 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 23 Aug 2023 06:28:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Message-ID: <a47e9615-aabf-4cc4-a479-430c309c3c8a@roeck-us.net>
References: <20230821194122.695845670@linuxfoundation.org>
 <991b93d2-9fde-4233-97d5-1133a9360d02@roeck-us.net>
 <2023082309-veggie-unwoven-a7df@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023082309-veggie-unwoven-a7df@gregkh>

On Wed, Aug 23, 2023 at 09:03:49AM +0200, Greg Kroah-Hartman wrote:
> 
> > For x86 I get the same runtime warning as everyone else.
> 
> Yeah, this is troubling...
> 
> Is it clang only?  I'll dig into this today...
> 

No, I build with gcc. More specifically, gcc 11.4.0 and binutils 2.40.

Guenter
