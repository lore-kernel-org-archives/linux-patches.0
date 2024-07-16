Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A090A71B52
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 18:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721155364; cv=none; b=FWtZgX2opxXXV3sU+dzX+DhJXAxYQjoYw+LEphvp9KZ91XuM3RfGcyhtCUE+Ef8jdmHVih39v2qePNfBORtDjsX/xwmbvDIMxKqgmYa8rV3G7GZrUoF8sVdbUqUMWKJg4tCqN/wSZnd0djxswMkhyVNaorDZPgeMlNRwg4rgrDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721155364; c=relaxed/simple;
	bh=OtM83p0v0bbwTMl1qFMjDNx45+qYTPed+Z02rE3XIlU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yos0dAbd+GSoi/gZU4weh3ONoHYukgs/5Ysc/urnL8aWN+gX8rjUz4LLDxCGSfRhLCaLgEXic6q74VA0SxYeXCkkbfXNHALy3WUC3eKFv8xp1pZfg/QFIzNdg1xBKs7xxJJ/uxv7DLhCpvn0KcXPemH3Fhohr4UTUOaR6S3Dj6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WhYN5Vke; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WhYN5Vke"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70b1808dee9so4005835b3a.2
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 11:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721155362; x=1721760162; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AeOP7jXMgDQvw4LZCIhrjKiS+hKtF6pyIncmvxzluxo=;
        b=WhYN5Vke8ARuT+LgwmHUHNJIja1bFBNUPX2Zpdq3I5KOVCtdHBSq7lKExDiANk8Cfm
         DY8cqoXu8HsuNb5n13ncU06S8TNSW+0Rb8+e1E3tq9pMVUw8VCrvRIxzrvziqRv58XBd
         wFcUvEge56tgusvIcGpxvFe0jSMOgZf/NN7Wq/fcmUp9Yb0SgfKnkCGB0nWZiunJxEF+
         53yndNTcUiFSEAoXZJROhFUeBL6Jr3++M3mcr47FWFSQ02AOOr1bpgIifMFeisIWKAdT
         2Oh3GgyDj7Mn9371EjllLpSOugqktRP7y3h1V+GcNPL8JFgYrIGKVQeaJaVsY9j1vUNn
         p2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721155362; x=1721760162;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AeOP7jXMgDQvw4LZCIhrjKiS+hKtF6pyIncmvxzluxo=;
        b=cq+m+WcAqOs4NHjoRLj67VLDHb0fcV3HZwVrS7emB1fvJFMbPrMxjm28ufTg8dGSyJ
         idU7giZ5Ql0pELVxOXO4Y+33up34AoOJ/Na/WTlMzHk7hHeMdL+F9f7jQbgazwVbGYro
         fwEL74ASPu2ysYFjVWYDcLeBNntllahRYJ8PyLpmmcFattnPLYWNVKhB4e5SEE4/WDB+
         MN8EB2mIMBywy5V3f+FSpEv8JQnBssSMXevBEekadWsEZNUf9EOGU4GSfXwq8dEWzWQm
         RTunYsAWEhAAMJn9rl3yTUs90bdJbXKSn8+TYIRGm7FejcPkzIyUg70EuhPxQ7FOAbkU
         HUOw==
X-Gm-Message-State: AOJu0Yz6HNfaYji1asjzzblODPSW2MvYJSIElsz/giIHMccX/CeqHOYE
	mBgbnUUXkhWLO8f9hKFCyRwNRTwa/IWMiWSJhRTFLEIuhlygA+yU
X-Google-Smtp-Source: AGHT+IGW/0ckM13SuPrVn4HByA0vnzwoFr3Xr/MX9/f+DPDnXtm/eJ6IkCBp2Cwz9+YLCv2b8sWmXA==
X-Received: by 2002:a05:6a00:4f85:b0:705:e5da:8293 with SMTP id d2e1a72fcca58-70c1fba11c6mr3706547b3a.12.1721155361788;
        Tue, 16 Jul 2024 11:42:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-70b7ebc56ecsm6663504b3a.86.2024.07.16.11.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 11:42:41 -0700 (PDT)
Message-ID: <aaccd8cc-2bfe-4b2e-b690-be50540f9965@gmail.com>
Date: Tue, 16 Jul 2024 11:42:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/96] 6.1.100-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Paulo Alcantara <pc@manguebit.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240716152746.516194097@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 08:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.100 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.100-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Commit acbfb53f772f96fdffb3fba2fa16eed4ad7ba0d2 ("cifs: avoid dup prefix 
path in dfs_get_automount_devname()") causes the following build failure 
on bmips_stb_defconfig:

In file included from ./include/linux/build_bug.h:5,
                  from ./include/linux/container_of.h:5,
                  from ./include/linux/list.h:5,
                  from ./include/linux/module.h:12,
                  from fs/smb/client/cifsfs.c:13:
fs/smb/client/cifsproto.h: In function 'dfs_get_automount_devname':
fs/smb/client/cifsproto.h:74:22: error: 'struct TCP_Server_Info' has no 
member named 'origin_fullpath'
   if (unlikely(!server->origin_fullpath))
                       ^~
./include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
  # define unlikely(x) __builtin_expect(!!(x), 0)
                                           ^
In file included from fs/smb/client/cifsfs.c:35:
fs/smb/client/cifsproto.h:78:14: error: 'struct TCP_Server_Info' has no 
member named 'origin_fullpath'
         server->origin_fullpath,
               ^~
fs/smb/client/cifsproto.h:79:21: error: 'struct TCP_Server_Info' has no 
member named 'origin_fullpath'
         strlen(server->origin_fullpath),
                      ^~
fs/smb/client/cifsproto.h:88:21: error: 'struct TCP_Server_Info' has no 
member named 'origin_fullpath'
   len = strlen(server->origin_fullpath);
                      ^~
fs/smb/client/cifsproto.h:93:18: error: 'struct TCP_Server_Info' has no 
member named 'origin_fullpath'
   memcpy(s, server->origin_fullpath, len);
                   ^~
In file included from ./include/linux/build_bug.h:5,
                  from ./include/linux/container_of.h:5,
                  from ./include/linux/list.h:5,
                  from ./include/linux/wait.h:7,
                  from ./include/linux/wait_bit.h:8,
                  from ./include/linux/fs.h:6,
                  from fs/smb/client/cifs_debug.c:8:
fs/smb/client/cifsproto.h: In function 'dfs_get_automount_devname':
fs/smb/client/cifsproto.h:74:22: error: 'struct TCP_Server_Info' has no 
member named 'origin_fullpath'
   if (unlikely(!server->origin_fullpath))
                       ^~
./include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
  # define unlikely(x) __builtin_expect(!!(x), 0)
                                           ^
In file included from fs/smb/client/cifs_debug.c:16:
fs/smb/client/cifsproto.h:78:14: error: 'struct TCP_Server_Info' has no 
member named 'origin_fullpath'
         server->origin_fullpath,
               ^~
fs/smb/client/cifsproto.h:79:21: error: 'struct TCP_Server_Info' has no 
member named 'origin_fullpath'
         strlen(server->origin_fullpath),
                      ^~
fs/smb/client/cifsproto.h:88:21: error: 'struct TCP_Server_Info' has no 
member named 'origin_fullpath'
   len = strlen(server->origin_fullpath);
                      ^~
fs/smb/client/cifsproto.h:93:18: error: 'struct TCP_Server_Info' has no 
member named 'origin_fullpath'
   memcpy(s, server->origin_fullpath, len);
                   ^~
host-make[6]: *** [scripts/Makefile.build:250: fs/smb/client/cifsfs.o] 
Error 1
host-make[6]: *** Waiting for unfinished jobs....

-- 
Florian

