Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489E517D4
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 03:33:07 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id lh8so15291610plb.1
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 20:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681875187; x=1684467187;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5zouXbp8ZPl0MdWpzxDdQ30m2pJpDuz4uXDplfNvXnE=;
        b=qJDcdkdBGGZ11t7TxtBnbnOAxPxjMKpp+W492ZTMl8nSA37rFYoV/8tGgvfuz6hDji
         Ic2kTYRZmOiDXhkdhv+SHpfW1lttOkohXyAbNyl43r9/4yt6RFh1I3r0+gU51cuNJLKr
         olQ7vBeVVtxmXaF1mHK7xSQGAU8/y/Wf8P+ZP3oC7jduylxsx2i3lXHnBDUPBEw2L36Y
         W/9UCy2GeEM2RxSeqqDCtyCgIbU/lKOyWrORxH9M3UOGsaFn5T4NttgHMqoIg36P+G2v
         ytPu0WU3uoafGrZn6sowa5ihAzqdbDG8TYv1wKov6gO/4j7s4cNC/JSSNn66oJYACPzJ
         G/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681875187; x=1684467187;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5zouXbp8ZPl0MdWpzxDdQ30m2pJpDuz4uXDplfNvXnE=;
        b=IgKQGhrpH1xZ1/99BaxhRfuIp5sn4Ye6sI6cq0379UYLt0vk7kA5nYCevmjanHi2W2
         Fpd1eOyz+6gsmqQfRVcdQyMocwdjBGfvZooXX/+sci6iDXomT/WhTUkP1Nag1L/hw2Wa
         VVJX4NvUMLnGcE+jLFfu7EseObEWCX1nvgDc7aYo20U7hLry3aMZhMsbpTQhLiHjKFm8
         C8zHzQsqxyZwyEPWEArTo2Ies4SJHHxeLouFN2khRshBwBqqmZjeZPS7Vf5nu5WkNa4T
         KF9KT/ytmb+OKBxzMETJAT4OkvZsURJfnnksMjfTX3kgQeQJkNxOJrW2laQ4rl/HHiza
         5Y8w==
X-Gm-Message-State: AAQBX9dC6gXuU5/WSUmjiOW4k5rCDN8mccd7WC3j+v3UpeRAnEoWcsxX
	okjfvC8LW1rKIzsm/w8AfZA=
X-Google-Smtp-Source: AKy350aL3CS55612HBRg6wDR5eOE0B4NB3o76CO+7vysLQSHNmozyI/yzLumzO0+bivXo8zfj5N3dQ==
X-Received: by 2002:a05:6a20:158c:b0:f0:5920:77b1 with SMTP id h12-20020a056a20158c00b000f0592077b1mr2001520pzj.28.1681875186566;
        Tue, 18 Apr 2023 20:33:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a20-20020aa78654000000b00627e55f383dsm364815pfo.3.2023.04.18.20.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 20:33:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 18 Apr 2023 20:33:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/37] 4.14.313-rc1 review
Message-ID: <ac457e3c-fdbc-430a-a0a8-8850c69e06bd@roeck-us.net>
References: <20230418120254.687480980@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>

On Tue, Apr 18, 2023 at 02:21:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.313 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
