Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131322599
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 14:48:37 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id v15-20020a9d69cf000000b006709b5a534aso7258340oto.11
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 06:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=br8OaTd1jmDrjbOIMn6DNbL6n+WVDgDsFDt7T1bWXIs=;
        b=DzwRqJ3VXgF7MH+6Y1xCnqo8qCN30QMRKekMEl7vIC43FBj3ptBDRNbfNc6LDZNV4N
         TZ7zhmFrjDD6lAM59NSrmeLUHUP3x3Fusw8LcDZE3ytrjBHF94aRerT9f2eOkLJqzTjG
         FXSyNZ5U7hCFAfIBWIoOt33Pv54j2THG3C4QQaFwlvikU6KtBl3W1C8EtZ7gm3zU0rIj
         60g9ICZmu0wM/tnbu9PeBxzN+4osSdJFA5i6RigrwrnsA5UqYqUtx6LW6Lol7A3g/JBk
         ScF4sIxgEuVNPgCDQ6E6ZcdroqWbPC/Z71zOAUB4qKPC3ndtBhYdWyy4lBy7VuoIflKW
         Hw5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=br8OaTd1jmDrjbOIMn6DNbL6n+WVDgDsFDt7T1bWXIs=;
        b=zsAqK04kS/Gm9lNAJWZIHOmhdSy3okSiSp6pjU564QVgGo6VgxlA+ZwD6P3k9fu6Lo
         dUqyAg4HKCwDOBQJomMLkBrFQOoCThnNJbzFzepCuUkkRuN9alJ9AyOsVxOWdlOpCLp8
         MD5TU7FBdgHh87LeoGH16AvLimSTN86V7pu/PmgrjYa0J9h2M4YUEkO3QfzlJ+CWczIA
         0ElEnxLQ5TYhZJG1NstVagMbdBL+evneXbE5V7xlho6lBQCfK2Y7TzjaNdoKu77GjCpe
         F23akYF0j1gQaIiQdTsDaOtsXzNVlqb8xX6d8ctC8HJuj6gF+F3JMg0NL2/h6OWdfHJF
         1lIg==
X-Gm-Message-State: AFqh2kpLb2yW6W09Fqvt3Q10wd2vwF+AY4Whi3Fu/C8h079YFp9bdLc5
	rPJTH95xINdTLp4ymgfig9Y=
X-Google-Smtp-Source: AMrXdXts8Q0Ag37eRlfRPOQMiddlxmPHjiwR8oLevZc+7XE5aQZPzvr3ISCGX4LQwHyYUJUbSFQw+A==
X-Received: by 2002:a05:6830:1e6d:b0:676:205a:605d with SMTP id m13-20020a0568301e6d00b00676205a605dmr8865959otr.37.1671547717051;
        Tue, 20 Dec 2022 06:48:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n27-20020a0568301e9b00b00661a05691fasm5624889otr.79.2022.12.20.06.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 06:48:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Dec 2022 06:48:35 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Message-ID: <20221220144835.GC3748047@roeck-us.net>
References: <20221219182940.739981110@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>

On Mon, Dec 19, 2022 at 08:24:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
