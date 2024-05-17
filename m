Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB8A384
	for <patches@lists.linux.dev>; Fri, 17 May 2024 00:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715905716; cv=none; b=oPiadz7sFpwfWwxA+Yd9hVleDXokc3aKf8jB7dEveXXJ8OkghMrrmNlsMjYBxFCbSCESERcJSiEy62IxBTa9IMzCNgmk45umb5NzoS4o5XM0ehlTnSJdIAAADDF8TeQT0BmsN9gvxCGUehrR7EpQ8z/zm2YvuAPwZ70f/rwIqHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715905716; c=relaxed/simple;
	bh=CkO8SGr3uIUI/OgequQPuoLhpOqUITNQj9EK8i1IjnA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HLYuBtr04QZFlw8PsY9p55ApHa4v517u6p6xaUvDXedXhhIPe0ovEP/kb1gGsgIGXCHhqlMeTWwAEmjety0Ehs2u6vS2xwkqiVrRzw4BYJeDWfPro9oDvK+LahmyPfIW5o5lJcojZzgPrUIVTPqRWiu+W0AnRtxPLlXDd/0SIPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T6IVny6B; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T6IVny6B"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4e1459a13fdso64158e0c.3
        for <patches@lists.linux.dev>; Thu, 16 May 2024 17:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715905714; x=1716510514; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n/jyAWPQcY8kSQKEOoekqeq1mLd+RuTg+/71Ne2/pnQ=;
        b=T6IVny6Bq++kWUE0hNwk66idVlr2kts2A2ZIv+n2D34q07KY5TdMydze6VgbxHcFF6
         Vn1OX3Hn3WQsszeC5f2+75hxCxvUSdOS9lRFdmfRueFL0tDTcWX9rgkG+Bg48WeQ1oF7
         5N3/XGwtOlfIg09ignmjoBwvpCNT6SKUHWKYoW102yifjfMFbSa5gb4ZxNY06b8aqr7M
         0GPg1PSiz8DAjyRxcv8TYFhRpxgOvqj+o/OaUZcF5n1QNa3C56/zTIgEaJ/mwwGG+ECO
         rNCfbhS5tbtF+3CuHIGR17OWVkrgZjzOtEpmO93t329pN9bCsDCBStYdlrb55OMK0Axp
         76gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715905714; x=1716510514;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n/jyAWPQcY8kSQKEOoekqeq1mLd+RuTg+/71Ne2/pnQ=;
        b=XaqSsHPZitlljJ33177Re7ltnkb0cPMeMVTbgBw2uGZYxHWEwffRA8JDSJFXWolQAc
         iThYSnG58HSOWOIO4K4azXLmBuxkkYGCK3EWSGDdbm5tA9+D/2tlVLHbVi/2BeRsZqXU
         F6isaytwmfJ0v0Y7OZD6lDJutXlYjPtQRAksFJNKLLTrtnZarzKXpI0DjbQQ+Llt/fyx
         dt5LV7fdtFaQjYlklDbIghR+zzlqmqf38dXX6p+m4ESxbhCElYyigxVT5LuCX7RTSdSA
         GgiWONAH8yj8leoI1Q/EDXmhjkiAhLyFdhG3GfUKJj9xp7N5Wr1pjbdzFcdN4k9FomMO
         hb6w==
X-Forwarded-Encrypted: i=1; AJvYcCWittxEXQw5T2sKWkIk8GFJVkCpXSQg9aj9A7kBQFQ7akWIowxSYQ+7cRlNtbdIRQ2zHRYdZsJxS4wYhnW6WnqlByUNMentLw==
X-Gm-Message-State: AOJu0YwmsA18+cPoVchByvkE0j/Oe4pOIvXIzYYFMyYNyIlHSDFMFoyo
	bRQKAE2OoLRT+kYOtqHTrJbIiVcvN0Qr5iZCQ4sDLfrrF4HVEhp50cdzzVebu3W1ehpF6ZR5jfa
	5iBRyxyqGuAVJrCmzjhtjnkBdJMA=
X-Google-Smtp-Source: AGHT+IGZIPNNhi/2On1W9ZhO80r2OJahAqKc9Ee7yecm4HVWGUZQe22zbWas3dFzHStJmIZDph3hjW9cby3ssEJmJ+c=
X-Received: by 2002:a05:6122:318d:b0:4d8:7359:4c25 with SMTP id
 71dfb90a1353d-4df8834b266mr17676695e0c.12.1715905712899; Thu, 16 May 2024
 17:28:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240516121349.430565475@linuxfoundation.org>
In-Reply-To: <20240516121349.430565475@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 16 May 2024 17:28:21 -0700
Message-ID: <CAOMdWSJr4eN-V-hD6UqdQ9aurk3RUj_A+3fMk+SMREhasGk1kg@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/339] 6.8.10-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 339 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 May 2024 12:12:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
