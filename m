Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CBC3093AC
	for <patches@lists.linux.dev>; Thu,  4 Sep 2025 18:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757009860; cv=none; b=RztE6jQ+hvymYER0u3R0Q4Tk7N934odbcTPE6nL69E/n8iCzEu6Pbbz6LSSvGBio40CrE0lQUUZRtTxbn5YPss3DTWVBkdtXtfHxfqElRNbaTIXeBhxU3VaHf7myUFycyvMS6zNr05RxJg9zWP+ab/5J09Apt8ubULGTxVqzItQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757009860; c=relaxed/simple;
	bh=LYq5jMmwf1tK6A427+seN6JAweLGHNz8cuvRskLWoWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uHCklJ1P6xYVjbbd2oSjuMzmLs7I+h+jkTYUy39XKdkj5jB59u/Ms577otxLlbhRxDMEbH+xx7EBiN0Q96nxD44yowFG50TE9++wloommK/3qUUfaF2P5CuaLTsst8ER0TynrFl7THtRkl6jLAF5vsI1uwpyI2ZFSsvzPU1gTSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EWQun7fq; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EWQun7fq"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-61cebce2f78so202408a12.1
        for <patches@lists.linux.dev>; Thu, 04 Sep 2025 11:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757009856; x=1757614656; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CVl9M+7rBYeEk+Q4ereQo1MssY/lzOzRON17aSFuTwE=;
        b=EWQun7fqbaZ/ERVq2Lt8BDLU+RW2vZa4csomUwCfQaPucM6FlbdmAD5voVY0UT8O5H
         scRrc9Hd+PzSC8AoIsug5wjOUtRjw8Gp6y1XdieJ4ppJl/T3ihfPglOgLg57FPifrIiT
         dC1UVec7vg+tQILWnSMYM569sy9VWt/YNdSaa8Jd/cZrGOtQxwJzE95O84WpA2wgZqku
         U/xJU6q7WmUkL4/aSthJgxkPtWEp5AA/BO5/DHuamlCKFf5dauwo+oPShRcmGblOdWMI
         FQbKxcYXUiY5od37MjrR2p59eDuNiiNYXD7+/zIUIC+19qDpL6hD6vx47KBRrq6b/cSj
         MhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757009856; x=1757614656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CVl9M+7rBYeEk+Q4ereQo1MssY/lzOzRON17aSFuTwE=;
        b=cqok4Ri1teFfNSMgA6ZZ3ykXSQmifk6zyLMFRCnVNhtZ/CRV7sOxx0oiUFzTKC6f+S
         UuuQIzmhq0wzAYhB7UE6FeoQhhTxO4ME5w9VbqmzsXGnhkVPh/uYZx60lcFUF4ydcled
         0crbJRlVWfoRioArOHQ75mWnIdSCK8Ii/Xj1sHXOvPUu9hi0AGZyH+McqgKE++4zOirp
         KsKl4x3ABlTZ6ZKGOggG6YzFiQhqGYOdGV1QZDzQ32HZCie7EcFJvcaRHCSkv+YyrEFO
         ag7qBYwJl84jQwrUcV3qmydIUMWq02/ve4/O9siCuYwu6RIb8hhyl/OqU5EpGUvXZg5e
         m7Yw==
X-Forwarded-Encrypted: i=1; AJvYcCUZFSE9GwDiEOXohoESVSMCMIt3QqwSIM+lRhjTm8fYS9BtbGWA9FNricJODlhHppbyGUWsyWU1@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5n6L//ZTqtIR38Rq5qkFVbGMmqmVA1EDri5pmgJDoH3I4Ojrd
	G7WloTNCdfk9nhxSlDj5FFFibsFSHdAaqKlXtauZOrVwjU6A60VpFENghpJxG31P219fqgAn9As
	Y/Y2mJmzJM/3Hw1moazxwnb4YL+m0AIk=
X-Gm-Gg: ASbGncs2gS2ZJA2rLCYgdKAQXPLAQbfwnJZorL/5qw2vOvFXsCWFSYa4GvNRWLf8ZH5
	6/TLw3Y5WyfvbX/r3Xo/FShwMAjDzhz8U031ahvU86j0yPJ0EtR8+r8nVUF/Jy04nXD6crBtYlK
	VGE0SSjRnzpQ6k3s/TGSQAWy8MqekKyynJqVX2Rff2cn8QQtETMyjpQ2AYIEqbZMNu3OwC1UsB0
	Aus1hmWshgwhbyLlLrb3RnPu6gv
X-Google-Smtp-Source: AGHT+IGJz2JSIudgEVnDqRLiJcdmRiYal+DuCpFAIEVDl6VZtoOCZE1q2R+rgnd/I+RcowpUp6K16WAn0QPb3JC09ns=
X-Received: by 2002:a05:6402:2714:b0:61b:cadd:d95 with SMTP id
 4fb4d7f45d1cf-61d269974c9mr17198288a12.8.1757009856140; Thu, 04 Sep 2025
 11:17:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250904062215.2362311-1-rdunlap@infradead.org>
In-Reply-To: <20250904062215.2362311-1-rdunlap@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 4 Sep 2025 20:17:24 +0200
X-Gm-Features: Ac12FXweM2CRLKaIHwZXF44ldMbhiIcgbauy5mqyeZCT433IcAeKTjD7Y5imqKU
Message-ID: <CAOQ4uxiJibbq_MX3HkNaFb3GXGsZ0nNehk+MNODxXxy_khSwEQ@mail.gmail.com>
Subject: Re: [PATCH v3] uapi/linux/fcntl: remove AT_RENAME* macros
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, patches@lists.linux.dev, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 8:22=E2=80=AFAM Randy Dunlap <rdunlap@infradead.org>=
 wrote:
>
> Don't define the AT_RENAME_* macros at all since the kernel does not
> use them nor does the kernel need to provide them for userspace.
> Leave them as comments in <uapi/linux/fcntl.h> only as an example.
>
> The AT_RENAME_* macros have recently been added to glibc's <stdio.h>.
> For a kernel allmodconfig build, this made the macros be defined
> differently in 2 places (same values but different macro text),
> causing build errors/warnings (duplicate definitions) in both
> samples/watch_queue/watch_test.c and samples/vfs/test-statx.c.
> (<linux/fcntl.h> is included indirecty in both programs above.)
>
> Fixes: b4fef22c2fb9 ("uapi: explain how per-syscall AT_* flags should be =
allocated")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Amir Goldstein <amir73il@gmail.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Cc: Alexander Aring <alex.aring@gmail.com>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: David Howells <dhowells@redhat.com>
> CC: linux-api@vger.kernel.org
> To: linux-fsdevel@vger.kernel.org
> ---
>  include/uapi/linux/fcntl.h |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> --- linux-next-20250819.orig/include/uapi/linux/fcntl.h
> +++ linux-next-20250819/include/uapi/linux/fcntl.h
> @@ -155,10 +155,16 @@
>   * as possible, so we can use them for generic bits in the future if nec=
essary.
>   */
>
> +/*
> + * Note: This is an example of how the AT_RENAME_* flags could be define=
d,
> + * but the kernel has no need to define them, so leave them as comments.
> + */
>  /* Flags for renameat2(2) (must match legacy RENAME_* flags). */
> +/*
>  #define AT_RENAME_NOREPLACE    0x0001
>  #define AT_RENAME_EXCHANGE     0x0002
>  #define AT_RENAME_WHITEOUT     0x0004
> +*/
>

I find this end result a bit odd, but I don't want to suggest another varia=
nt
I already proposed one in v2 review [1] that maybe you did not like.
It's fine.
I'll let Aleksa and Christian chime in to decide on if and how they want th=
is
comment to look or if we should just delete these definitions and be done w=
ith
this episode.

Thanks,
Amir.

[1] https://lore.kernel.org/r/CAOQ4uxjXvYBsW1Nb2HKaoUg1qi8Pkq1XKtQEbnAvMUGc=
p7LrZA@mail.gmail.com/
