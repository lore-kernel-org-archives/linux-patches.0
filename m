Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C9614D70C
	for <patches@lists.linux.dev>; Tue, 23 Jul 2024 10:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721729635; cv=none; b=Vh3zvEYIR6nWqipsipz4kwoNZ0qyqdEtkKxvwzHjVkSUE9z8zN/CMjwwY69Ynw4uroKBBL6ape7MkMzZctIa3zP6tl4UhOqUcISEU7ggeKM05LicYNQXtN3p4EgG/mihSgLuU10XekHkR8O9d0/t8X5xsaCRkQZVQUd31wsS6i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721729635; c=relaxed/simple;
	bh=KEk0smRLPVkFTP6+3W2ooQcQf5x72wZKLgttJGDtM8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IqK58Q6Izhr89n/v0/Wca2i5ew4RY6CvZ+Ye+usvyBfj6yPMfUpJH3KzhV6GpxvtHb8fhI1nFU3V7cKRb5l5FPjwbTQRxbhZubkqfqQt81Ha+qYNrsXGeQnpwaW415miJo1PUUO/hoFRR2ipi567zMphArE7bN6lwuKK2oFJ55c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gBuMhfeR; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gBuMhfeR"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e03a17a50a9so5724097276.1
        for <patches@lists.linux.dev>; Tue, 23 Jul 2024 03:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721729632; x=1722334432; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KEk0smRLPVkFTP6+3W2ooQcQf5x72wZKLgttJGDtM8A=;
        b=gBuMhfeR2CUEbeu9UjuAapYPIM33enoZmoIwmPXthDDTRU1iqWgmCqa+BQ+BHjFSrm
         aYu+tdFl25Rc0416MdkYTJHW9yhzSd4jIpRjZ0hPvmPvMgyZirZrKxvsAYa3BbGWJ5Vk
         35A0e22O+SkyrBVCr6Y6WHjFHi6b05ld51kLJdp/fb8xQVd3EcvGDqLvnZ16kGc7peE4
         2AGY7H/h+Zd1rt0yLoGyNtR4n5d7UeciyFdrnB8xKD8ZDAM72iXgqdJB8hDEK7A6niuz
         ETSNoVZoaGDujAc1U5gzfEVns7zk6Tp6dWqKVNJOOIm9yKOmrOXCYkJgLWa43rRWlnAm
         60Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721729632; x=1722334432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KEk0smRLPVkFTP6+3W2ooQcQf5x72wZKLgttJGDtM8A=;
        b=PdGFPQm254z8WAGHxHbxhd3nR6bpRmrsoACwG7dK/UrPb5ccfDq7FqdHJKV4ESwgCQ
         f1QliYM9vyYsmzG2gZCI7uGbMU/681077F1zrWI45R0N39Q/rfQm8zRlGTDc3mJ7INli
         m2VtE2oixtWryawfkH8R488SaeaM4L+0RMDNAdG8w7RuI9DUCOt+21oAlyieJG82UEFQ
         jZnabjSR3WB2K4SFkNLY5dkDAvTH7lil5YKh0y2h5uz3q2ciaOaBl8zkc0nEbIUPIZXL
         pv2ZnbHHRFTnv6IbioDLxQ8bmV7hRGs/qUYKusWP8J17i4SbqEHE0jGQQzhgC+++RGF4
         9WyA==
X-Forwarded-Encrypted: i=1; AJvYcCWpl/DFy99tP/cvhbNNnp7NwXoWg3f7L0gt8YeUGXbB+l/MtgRKWIcpvWY9ut4N1TwaFME9q0d06diO1KbNvzI94p6xtkd3EQ==
X-Gm-Message-State: AOJu0YwR90Y7LlUHnSgcgjZbzFu5wRcG/oV7Puo5BxSzfsByAfPp4nNi
	fnvZr/oJwlNWfXyeTHYcdg/n41kouiMXWQvEUIVJ7gg3IpL3L7UMXUh6F//hwQUl6eloOxKPSPg
	dcMVUy/bDvuu6StfTNgJ8t3qtmow=
X-Google-Smtp-Source: AGHT+IFQ4zPPSQuppKaSAmeMi32D6OCmwZWSG4R7sgAN2pLVjB8laSzPFfYfg33GVFpZciwNSLIWa2mDTWNrfVBxi1M=
X-Received: by 2002:a05:6902:150e:b0:e08:7171:698d with SMTP id
 3f1490d57ef6-e0871716fe2mr10571110276.20.1721729632472; Tue, 23 Jul 2024
 03:13:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240618123422.213844892@linuxfoundation.org> <1721718387-9038-1-git-send-email-ajay.kaher@broadcom.com>
 <20240723092916.gtpvnifv2rizbyii@quack3>
In-Reply-To: <20240723092916.gtpvnifv2rizbyii@quack3>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 23 Jul 2024 13:13:41 +0300
Message-ID: <CAOQ4uxjGrPbq8=znBSV8i79Kj2Or4p5O5BZ0+RL1oXbxxNu3rw@mail.gmail.com>
Subject: Re: [PATCH 5.10 387/770] fanotify: Allow users to request
 FAN_FS_ERROR events
To: Jan Kara <jack@suse.cz>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>, gregkh@linuxfoundation.org, 
	chuck.lever@oracle.com, krisman@collabora.com, patches@lists.linux.dev, 
	sashal@kernel.org, stable@vger.kernel.org, adilger.kernel@dilger.ca, 
	linux-ext4@vger.kernel.org, tytso@mit.edu, alexey.makhalov@broadcom.com, 
	vasavi.sirnapalli@broadcom.com, florian.fainelli@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2024 at 12:29=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 23-07-24 12:36:27, Ajay Kaher wrote:
> > > [ Upstream commit 9709bd548f11a092d124698118013f66e1740f9b ]
> > >
> > > Wire up the FAN_FS_ERROR event in the fanotify_mark syscall, allowing
> > > user space to request the monitoring of FAN_FS_ERROR events.
> > >
> > > These events are limited to filesystem marks, so check it is the
> > > case in the syscall handler.
> >
> > Greg,
> >
> > Without 9709bd548f11 in v5.10.y skips LTP fanotify22 test case, as:
> > fanotify22.c:312: TCONF: FAN_FS_ERROR not supported in kernel
> >
> > With 9709bd548f11 in v5.10.220, LTP fanotify22 is failing because of
> > timeout as no notification. To fix need to merge following two upstream
> > commit to v5.10:
> >
> > 124e7c61deb27d758df5ec0521c36cf08d417f7a:
> > 0001-ext4_fix_error_code_saved_on_super_block_during_file_system.patch
> > https://lore.kernel.org/stable/1721717240-8786-1-git-send-email-ajay.ka=
her@broadcom.com/T/#mf76930487697d8c1383ed5d21678fe504e8e2305
> >
> > 9a089b21f79b47eed240d4da7ea0d049de7c9b4d:
> > 0001-ext4_Send_notifications_on_error.patch
> > Link: https://lore.kernel.org/stable/1721717240-8786-1-git-send-email-a=
jay.kaher@broadcom.com/T/#md1be98e0ecafe4f92d7b61c048e15bcf286cbd53
>
> I know Chuck has been backporting the huge pile of fsnotify changes for
> stable and he was running LTP so I'm a bit curious if he saw the fanotify=
22
> failure as well. The reason for the test failure seems to be that the
> combination of features now present in stable has never been upstream whi=
ch
> confuses the test. As such I'm not sure if backporting more features to
> stable is warranted just to fix a broken LTP test... But given the huge
> pile Chuck has backported already I'm not strongly opposed to backporting=
 a
> few more, there's just a question where does this stop :)

I'm not sure is it exactly "more features".
The fanotify patches and ext4 patches that use them where merges as
a feature together.

IOW, FAN_FS_ERROR was merged with support for a single fs (ext4)
it would be weird to backport the feature with support for zero fs.
Also, 5.15.y already has the ext4 patches - not sure why 5.10.y didn't get =
them.

Thanks,
Amir.
