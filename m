Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC15DF49
	for <patches@lists.linux.dev>; Thu,  1 Aug 2024 23:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722555545; cv=none; b=cRksOtpdmR8c+xRk3TAaJOjOdNu2O6qU2vy/M3YvMtVeHOwt3oixTMk4V81GTF8Q3JWr/vEL0XH8lZ/joyiWjeXbJL7k0FkjhVngC/o3orwF2HUjZVDfxz081fFDMlVFrR8F5FIKWNj+aRCXSlQxuao+7WrNx2fXvG+LPW3G/9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722555545; c=relaxed/simple;
	bh=UmmXi35nfuScAHUEeIJwGppaSmZBoW8i5FyJvfJEzhE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=EnVzE6VAb9vt/shJBCzHo2cvJgmgcbTxFqhA8CmW78SPwawcGZR+QyHkGI0QdPve5wApnGr+zaLiJMxlMs0xevvzYV6UpnY8fgxJCqEPndbE38J5zEjGN0D5b+2ezH1r0owsuT/JZYRTGWZXv7xcD4+OKQcSc94uEvD8RBLb3Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-81f86fc9fdaso1087704739f.0
        for <patches@lists.linux.dev>; Thu, 01 Aug 2024 16:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722555543; x=1723160343;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ODcuns1LudBlqI4V0K87ttGH2rAEsrJeBiRSk4hIkus=;
        b=J2+HSg0Wel/0aqEusvdwyH1jn7rP5QAIVhimpEOjv0k0gsrwUez7BmvlEViGbw7fnI
         pZXWrv/teVvJcg54aWCPJns12oYYRspBWVqzC2nbm715njhfeN1EcBYhNktt98ya3f5U
         pychsBX770UkPJ4q/4FDKdrjsEldDiIC6gjZzDH8tsceRy8IOq5RyQOz817nit6h5jDX
         NSO7UmTPytURrglOB7AwWjfhxRJXYuI1pQmNQgm0Egdhwy03fltjl/wZJ+sgWd4T1bLK
         Wbf3a1q3dTxlHRJsMnQFh3cClxUZ3QDKVsUP9/xTvHs/EE9SDKN9M0YL2i8Ae+o6InsR
         vrbg==
X-Forwarded-Encrypted: i=1; AJvYcCVmDlwd1iWzMLpazTHOXEU/tmgYdDBmo7x35Le+yUurbb3GWQjbPh1Ys++DWnfTy/BxBCunqlaARhvPdWjjaiFGhnoTJMgugA==
X-Gm-Message-State: AOJu0YxJuvodeYV67q5rFRS4Q5Ss8e1sdCGBYWnReK3OoYCEM1qItOaK
	kJs5Y9A9afNR+pJ7bXGLPFrmmLgzkNT4FQSpoMVb1XpZy3vpMQQmB3TLw4w+moGu7stmcr4FY0X
	DW+IDJGNscz6mQY/iwbLnXKEZmNF4AG09HWZ1t7Me2V+pniHOSfkJu1k=
X-Google-Smtp-Source: AGHT+IG8TxilfBblIK7ewxLG6HE/mrHKCIseSqawEomYlhrUYVYyt4OhOTyyY0tgYhO72VI3qfqc9z4ejv5s988bgf3cBNUSPSDA
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3788:b0:4c2:9573:49af with SMTP id
 8926c6da1cb9f-4c8d56f8d03mr60315173.6.1722555543269; Thu, 01 Aug 2024
 16:39:03 -0700 (PDT)
Date: Thu, 01 Aug 2024 16:39:03 -0700
In-Reply-To: <000000000000839d4d060a0fab97@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000434672061ea7b797@google.com>
Subject: Re: [v6.1] WARNING in ieee80211_check_rate_mask
From: syzbot <syzbot+07bee335584b04e7c2f8@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org, javier.carrasco.cruz@gmail.com, 
	johannes.berg@intel.com, johannes@sipsolutions.net, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
	patches@lists.linux.dev, sashal@kernel.org, skhan@linuxfoundation.org, 
	stable-commits@vger.kernel.org, stable@vger.kernel.org, 
	syzkaller-lts-bugs@googlegroups.com, vincenzo.mezzela@gmail.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue could be fixed by backporting the following commit:

commit ce04abc3fcc62cd5640af981ebfd7c4dc3bded28
git tree: upstream
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Feb 24 09:52:19 2023 +0000

    wifi: mac80211: check basic rates validity

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15d0b26d980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=59059e181681c079
dashboard link: https://syzkaller.appspot.com/bug?extid=07bee335584b04e7c2f8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122bb7a5180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14dfa479180000


Please keep in mind that other backports might be required as well.

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
