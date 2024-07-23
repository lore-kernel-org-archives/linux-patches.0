Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2006D61FE1
	for <patches@lists.linux.dev>; Tue, 23 Jul 2024 09:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721726453; cv=none; b=t6an2XMhFoR3qklzjNEfy4FiANZvlikvLOXx7d2jxBTA7Bx+N4DJ+WJp34oR7iqcrPze/8IHFnUuYcU76wLFOJRSKzNj/PQS4/O9EqagT5fS2GauWujBfuGa2JyPiTVoYaNX7FLteEJgm/9jSjltomfMZR+uC1pTKy2CZIC7ijY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721726453; c=relaxed/simple;
	bh=8yy+rbLTVl1v9LEfxIdWFqrtokzsNG6TszVLeKeZsIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EF0ymJ8go0UoUp8NgOsG8XY2tzNR0by3T96aZ51mn+Bf6g7yHped77Gjxe2uTgv4G0oDowlZkzNFA2PW3MBir51WDfuwxP1NIVwg0syO5ylfkXdLXQ8/D1hkkT3LlysTsNXvRsrcFmVmFfOIa00cjxeztiojif2es/Ok4Zh9yQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GakHkH+P; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GakHkH+P"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-79f323f084eso323353485a.3
        for <patches@lists.linux.dev>; Tue, 23 Jul 2024 02:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721726451; x=1722331251; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8yy+rbLTVl1v9LEfxIdWFqrtokzsNG6TszVLeKeZsIY=;
        b=GakHkH+PDws6V2Gz8rTIyr8oHqsjm16bgZc9IdBjN84idf0Fnsht3mhsxRXWKmN5ZD
         IH5svVz7q8VRnrCPR/PqU1kBiObfLIobh/ax5UuUG1XiNqZGemHG4IWF/C9O9Uk6oCEL
         5oNM0Jc4sOzf0v76GXfmJ3TdM5KzIXz27la9QGLpWcr5AWV9UrVvOU2ooSv2iRbf+ns5
         SRzgk1nyRZJgop6vqJ97aIaQESvTpN4nFkxJ1w6/qDmPKYXozCDcVxFEho0W3C2tpeE/
         d95qliNcPVPJ2Q5fpr8r/tMZAmZRUsyFTYOsRJXZMHmWj5tabOBDZn4HUu6I6BqyVE9s
         fJZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721726451; x=1722331251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8yy+rbLTVl1v9LEfxIdWFqrtokzsNG6TszVLeKeZsIY=;
        b=NvoZw3csNcXDlLGzjLpfCAnR9Xp0KDVbvm562EgTZJ9Hm8fXm9VRcYaMoXb2keqy3X
         Clf3wKRxh8sYflbtdq3vJ1nvJVdBvQxB6/s8CBWfKSav28r+Hgn9of9vGEbo3oe5FD9q
         k6SpSsKYALhmIw4L5erwg8UIciVKxmp2KGERBAZczrt17i/21jszt+WMg5CMeZN0X80t
         yE+svK03U7EGrBQiaUQneceAu05TDg1H9hFWkHIaIz1iVioJRMHy0zxP96mjaVS50uhk
         N0zt7+6WDv+olPrU3I5vGgwbvm8yoxN1PYiSLooNmds00PWAsPOgBBITLrdekuJM7179
         GZIg==
X-Forwarded-Encrypted: i=1; AJvYcCVOV9lFOPv+tWv+uzuVDlnxEAJzr4hmzgBDlUFPyPTPFeHPRK4mShKHnAH8CyFD7Owqolv+8GqFZZpJXrNIOjWlnoAVOhL/0Q==
X-Gm-Message-State: AOJu0YzQwIh27ZVB7cHQm08ezlybd8VhwTth4RuxHfK3RPdUsJ4Ca4PZ
	07nokd5jzgGuFJtMvAXDoaXEp3b6AdCsKfRG6N/Z7abtxcJWOW3xUaBNRxsfC8e4OCAlfYQGl6J
	LomeN0iWsGtZW1lhKZKe/jRObBoM=
X-Google-Smtp-Source: AGHT+IE73OAgH4DfytlYjeMKjbOMoaZbFZgeGl+saAzlAJ6H2jd5JojFCpwiV/nEV8aexgs+whhuuutVBJ34sBHNlb8=
X-Received: by 2002:a05:620a:29ce:b0:79f:1860:5629 with SMTP id
 af79cd13be357-7a1a13a8992mr1223374485a.55.1721726450830; Tue, 23 Jul 2024
 02:20:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240618123422.213844892@linuxfoundation.org> <1721718387-9038-1-git-send-email-ajay.kaher@broadcom.com>
In-Reply-To: <1721718387-9038-1-git-send-email-ajay.kaher@broadcom.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 23 Jul 2024 12:20:39 +0300
Message-ID: <CAOQ4uxgz4Gq2Yg4upLWrOf15FaDuAPppRVsLbYvMxrLbpHJE1g@mail.gmail.com>
Subject: Re: [PATCH 5.10 387/770] fanotify: Allow users to request
 FAN_FS_ERROR events
To: Ajay Kaher <ajay.kaher@broadcom.com>, chuck.lever@oracle.com
Cc: gregkh@linuxfoundation.org, jack@suse.cz, krisman@collabora.com, 
	patches@lists.linux.dev, sashal@kernel.org, stable@vger.kernel.org, 
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, tytso@mit.edu, 
	alexey.makhalov@broadcom.com, vasavi.sirnapalli@broadcom.com, 
	florian.fainelli@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2024 at 10:06=E2=80=AFAM Ajay Kaher <ajay.kaher@broadcom.co=
m> wrote:
>
> > [ Upstream commit 9709bd548f11a092d124698118013f66e1740f9b ]
> >
> > Wire up the FAN_FS_ERROR event in the fanotify_mark syscall, allowing
> > user space to request the monitoring of FAN_FS_ERROR events.
> >
> > These events are limited to filesystem marks, so check it is the
> > case in the syscall handler.
>
> Greg,
>
> Without 9709bd548f11 in v5.10.y skips LTP fanotify22 test case, as:
> fanotify22.c:312: TCONF: FAN_FS_ERROR not supported in kernel
>
> With 9709bd548f11 in v5.10.220, LTP fanotify22 is failing because of
> timeout as no notification. To fix need to merge following two upstream
> commit to v5.10:
>
> 124e7c61deb27d758df5ec0521c36cf08d417f7a:
> 0001-ext4_fix_error_code_saved_on_super_block_during_file_system.patch
> https://lore.kernel.org/stable/1721717240-8786-1-git-send-email-ajay.kahe=
r@broadcom.com/T/#mf76930487697d8c1383ed5d21678fe504e8e2305
>
> 9a089b21f79b47eed240d4da7ea0d049de7c9b4d:
> 0001-ext4_Send_notifications_on_error.patch
> Link: https://lore.kernel.org/stable/1721717240-8786-1-git-send-email-aja=
y.kaher@broadcom.com/T/#md1be98e0ecafe4f92d7b61c048e15bcf286cbd53
>
> -Ajay

I agree that this is the best approach, because the test has no other
way to test
if ext4 specifically supports FAN_FS_ERROR.

Chuck,

I wonder how those patches end up in 5.15.y but not in 5.10.y?

Also, since you backported *most* of this series:
https://lore.kernel.org/all/20211025192746.66445-1-krisman@collabora.com/

I think it would be wise to also backport the sample code and documentation
patches to 5.15.y and 5.10.y.

9abeae5d4458 docs: Fix formatting of literal sections in fanotify docs
8fc70b3a142f samples: Make fs-monitor depend on libc and headers
c0baf9ac0b05 docs: Document the FAN_FS_ERROR event
5451093081db samples: Add fs error monitoring example.

Gabriel, if 9abeae5d4458 has a Fixes: tag it may have been auto seleced
for 5.15.y after c0baf9ac0b05 was picked up...

Thanks,
Amir.
