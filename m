Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832AEA935
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 21:38:27 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1a67d2601b3so770055ad.0
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 14:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681335507; x=1683927507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zryaPgAYMlVR+T3G4KOAsz+hbudinum/d++UX2e4pk0=;
        b=Gj6a4c7rP48bKypuGbXyKnkj3i7jYX1EW//9af3ssw9LgkQPtVn7ZhI6alSuhOweS7
         O6KQ4XJu6td5/GE7AZFiOoQk72fWKiiV/6zzUV9kTKYJESgYtddVSh+qDZ2lzm6R6dW4
         SRdxEiVSaqzENvuNWG5IzDKrRVlfk81Wc6yjqzc85yFo6MofTY67IaNwxtont0vA0C0Q
         YzAHm7tf+CGAfOzD9Q7pV52BNo/1hVJfKU2QlKdYRLhAK1+XQdRpCwKSgetEo7tJBTix
         QLq37xIYTZ0Z7TXWpU0mHN/zejVN6evyPqaGmez6WpCVfgsXDvxF+HtRr4Z2QBk594LG
         oAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335507; x=1683927507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zryaPgAYMlVR+T3G4KOAsz+hbudinum/d++UX2e4pk0=;
        b=UdzF+HubgqJ9t7sslcXRWWO6Lc0WkOPrb19bav7KgTgY84vg35UGfMqbz/qc+S7z8R
         znbKz8ZbRN4qRnQNvaSktrKo+TNwjld73UOHdO5oOgJsUDClNypOX+67y1eWMrmk25oS
         qWgUZrPYvWtUdreQqon+EaW1BK6IAYuVkZIgG18BnoUJ31ikPo5epF3dLR6lPk00aViH
         lVUYyCnHG2kQSKwbYUP+BnMRpTmG7fNobq3DArkocvOBVYxQPbkMt+aWY2mYbGYRRuYv
         3no24TDnAdzQVAaqJIsYBCNrMM2Ed/DBW6yKjPia8wt3pWYh3llqyLMlBO3HYjtpBg2g
         NkFA==
X-Gm-Message-State: AAQBX9dL5CGGbZSWjiBPXHSCzyngpdT2mkE6SihI0/r0mNjTJ3xpE4Bo
	uMiEkR4j0wGkrfDOuNhD/kCYaNsSrdY=
X-Google-Smtp-Source: AKy350ayLRuWTQHmaXMx17Sh5poDoJ9CEU6/hCpz0PPGekzJrdBt9TWO8taS2nRnD4He/5JUfAQpXA==
X-Received: by 2002:a05:6a00:1a43:b0:627:e69c:8488 with SMTP id h3-20020a056a001a4300b00627e69c8488mr339839pfv.14.1681335506700;
        Wed, 12 Apr 2023 14:38:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c11-20020aa78c0b000000b0063afb08afeesm2406261pfd.67.2023.04.12.14.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 14:38:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 12 Apr 2023 14:38:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
Message-ID: <10bdb21e-31d0-4d86-bfa8-1902f32f2760@roeck-us.net>
References: <20230412082836.695875037@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>

On Wed, Apr 12, 2023 at 10:32:02AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
