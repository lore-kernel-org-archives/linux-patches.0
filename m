Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD08BEEA5
	for <patches@lists.linux.dev>; Mon, 19 Aug 2024 21:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724102670; cv=none; b=IjsDdfBlRt5yty6gBFwhK4xSafPwAXMKeZgn/mD8/OyiwSh7+cEGmgVi6Djlk+CZZEnR3AEMvEjn3PMD7a2K6qpE9dy0ypy85kvJfRP8xL81B7HQY/kqcMe407AMHSJDC0bXu+7KRYV+dx3J8FHhsb4Ztts+Aj7+0RO3iyzWxso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724102670; c=relaxed/simple;
	bh=u+0m0US3QFw84sTqEbjna9w6FE0gpMTeeaVLynF5j9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MajA5CgaLZm6mxghF0qnZcTxA90pFhjUFbop+JEUIv/zwRbmcxSbstSrdmqDloAHf8SG+Hd2Fj0J0PPWXq0SQQdyTmIrt3WL0u8I+eNsnZUpcDVbm1EBhAxKkB/rwER5B3xZ2sr5HLyxeMJPXNiqSivrNxEHfA4pHzbY3YWjT5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PEPKdMmo; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PEPKdMmo"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-495d1a6db75so1596472137.1
        for <patches@lists.linux.dev>; Mon, 19 Aug 2024 14:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724102668; x=1724707468; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JiPuVEIARbs7nZfPRgac3ucMDQpztOtq3lJp2GBYRco=;
        b=PEPKdMmo42W5efSa5F1qlUHwK5DHGXmXJrPrhqa6h0g1146kkJQmX6SQKtDO1VWgy1
         wgfKBHD3v6FSeL3An8B5+IM3YmbJxRKFFHti7mzMDf+JjR9jQrYNgHNF/8nrxG2sYxcZ
         ABiDdK0kUHH7oufOGvJpjfR7NEiMgwHqFs9FrmVahVM6CeiY4ICcwMD8uzdER64IIu9E
         VM6AwRHRAqya+ZFn6JK2QZUJ/g4eHRHycgKUrc9d9Q2ARelh5PE4gb3Fxz7QjV8odVM7
         qa2TmbpXOWzFOOf8i+cTz6hEMHAZKW2kE+mCceP714M6xIDHj1LcsAff9Z5jT6Z1aBa+
         AhqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724102668; x=1724707468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JiPuVEIARbs7nZfPRgac3ucMDQpztOtq3lJp2GBYRco=;
        b=kJJLnnOXiSwNLx/S0e9d7gtz0tKmaqGv+sI8N8izH3ADNDmcec0x6BmkHdKGKK0/IR
         l5kRNLN1f6JI6/oDJMyVxgzD4dVhUM+H4X8Eg+HtkpufNSOpDlDd6O8xOQ+nRx7dSPz3
         3SZECCdnZEmOxUMwfclglMbes24LM/ddmYMd7YhUJ5FJbQEo2y7JNb3FJzLi22OcK2xZ
         FiRb6loHoJ0Sdzm+Vd+0SjL5QwHOj6sj0dPQYGn4qIkRU5Fe5vJTwoTFOP8pE6tOUJz2
         JR0m5rjo2ONx14MjFyaI3BLRMjzOYHyMaLVzxSgrKbI9UseKGGWNG8KqHRdM6N59ZOvd
         MkAA==
X-Forwarded-Encrypted: i=1; AJvYcCWb5QwNLYLf/XlY/tCKKOSQijiYEW2eYd9PUZTTREj031RssPs+pZ4T62iagZyspS+1cSthC36UvDNpIYqaGzgdLHiR6GcEeQ==
X-Gm-Message-State: AOJu0YyZ8GdeLtCFJ22ugfHYK7gj7mnuDGnDSs4H9sdTh6gzrI5x0/Ui
	772yN6gdBCZq/rzlfkPafORz72/qp7UgHUkcLkl6rZXOEqK/GRydNvSb0HhEMncU0ci4YwZt9ep
	5CM3PlOMKPIjjsEh239aoxRWb4UfUpyKrPJcD
X-Google-Smtp-Source: AGHT+IE+E6VJ5JvA7Lqq7iQmAIRzeQu5arI3TDl9cLtuS06laSaYx2Gcf5jbf18gxD5V1/WytLtXiNijQYFV+DdrRxA=
X-Received: by 2002:a05:6102:304d:b0:48f:8ead:7b7 with SMTP id
 ada2fe7eead31-4977997fc1fmr14487889137.21.1724102667560; Mon, 19 Aug 2024
 14:24:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240819-acpi-platform_profile-fix-cfi-violation-v1-1-479365d848f6@kernel.org>
In-Reply-To: <20240819-acpi-platform_profile-fix-cfi-violation-v1-1-479365d848f6@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 19 Aug 2024 14:23:49 -0700
Message-ID: <CABCJKue4NgOVxfjcU=oE23rogqgfiiJMqLHp-NSoSs=o1=22kg@mail.gmail.com>
Subject: Re: [PATCH] ACPI: platform-profile: Fix CFI violation when accessing
 sysfs files
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, 
	Hans de Goede <hdegoede@redhat.com>, Mark Pearson <markpearson@lenovo.com>, 
	Kees Cook <kees@kernel.org>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org, 
	John Rowley <lkml@johnrowley.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Nathan,

On Mon, Aug 19, 2024 at 12:09=E2=80=AFPM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> When an attribute group is created with sysfs_create_group(), the
> ->sysfs_ops() callback is set to kobj_sysfs_ops, which sets the ->show()
> and ->store() callbacks to kobj_attr_show() and kobj_attr_store()
> respectively. These functions use container_of() to get the respective
> callback from the passed attribute, meaning that these callbacks need to
> be the same type as the callbacks in 'struct kobj_attribute'.
>
> However, the platform_profile sysfs functions have the type of the
> ->show() and ->store() callbacks in 'struct device_attribute', which
> results a CFI violation when accessing platform_profile or
> platform_profile_choices under /sys/firmware/acpi because the types do
> not match:
>
>   CFI failure at kobj_attr_show+0x19/0x30 (target: platform_profile_choic=
es_show+0x0/0x140; expected type: 0x7a69590c)
>
> This happens to work because the layout of 'struct kobj_attribute' and
> 'struct device_attribute' are the same, so the container_of() cast
> happens to allow the callbacks to still work.
>
> Change the type of platform_profile_choices_show() and
> platform_profile_{show,store}() to match the callbacks in
> 'struct kobj_attribute' and update the attribute variables to match,
> which resolves the CFI violation.
>
> Cc: stable@vger.kernel.org
> Fixes: a2ff95e018f1 ("ACPI: platform: Add platform profile support")
> Reported-by: John Rowley <lkml@johnrowley.me>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2047
> Tested-by: John Rowley <lkml@johnrowley.me>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/acpi/platform_profile.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

Looks good to me, thanks for fixing this!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
