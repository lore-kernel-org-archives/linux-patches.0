Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2FD1428EA
	for <patches@lists.linux.dev>; Thu, 13 Jun 2024 13:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718283781; cv=none; b=obUlWv+e/4QPZ25nOKxRk3gWKzBJ4o4NtrQwBqwn3s/tZBM8oiKpB+EOS2GPjxeKDUZi5RJFB9FaBSYR3c9cNFFcv8GCKJpyZJb6++MbjyLkisK82rV4E+AXU8soe+TkLb2CnPRMKM7Yd49uc7/JIStzWMuNw81mqZOXylE7m90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718283781; c=relaxed/simple;
	bh=sKGNoMP+lwPXhQbfCPopDvkrZozPiEMdXonWAliL18c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jUjY87SUogOXzKchnuTSS+OIIv+0/9jpZ6N8hrkfqIxE21zcoXy4iPVPGBmrGfK3Lxgy7Ll97nqc0V3zMcu3n7gwk+UUkGWH6H84INOtj6ffaZub8NfurBVeuBK4CKULZ/0/xMyhKB50n3faFIu4ibPedpzoDcfgEkKueARmv6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O0kwljKs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O0kwljKs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718283778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yH+jWx7YZJFNJzFGP96zaKaLc8ns7bridUA/k1jWf3U=;
	b=O0kwljKsQnqqVY77Yo4HF/9Z0uPECohqCKrdO6nEUEawYev87xwfB+KYvFeCBZShS5Tn7Q
	UgQv/qtMWwntjEzREPOaMYcKu+V36oYGaB6El8fIVrwlap8ywxEvWvQmTuqonRAsom6oon
	FZ8eH0Fjm1B8s9iV2FSdq+YjLBrLBdM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-H72jlKoEPaezTYEK-gQEAw-1; Thu, 13 Jun 2024 09:02:56 -0400
X-MC-Unique: H72jlKoEPaezTYEK-gQEAw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2bf5bb2a414so906610a91.1
        for <patches@lists.linux.dev>; Thu, 13 Jun 2024 06:02:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718283775; x=1718888575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yH+jWx7YZJFNJzFGP96zaKaLc8ns7bridUA/k1jWf3U=;
        b=Qb8LDuDg4FZCLfvuDeb0yYFGNaivj7kDioxyV1UZDIvdZXNg2Z3ZNoR5YJ6mLo/Sur
         1B6rQyKHij9ES5u7dK5V2heIbtOmif8KepQTO3Ef1efmpK3/7RX/yhvikl46vQAeRate
         yfByY8nX9G72qZ1UX7/AfRcGigX/5GHMmGHWp2tioRj72GyKDUqY3Op6s+tpiSAYXMCp
         TWh0rTQMp0GROyVMlWOS2R4stAfkKigLp3xsq0TEmSBCHG+snNJMHbL8ZmUEqeh9NLo1
         Ho+XvGA/kfe8+5SuB7xYM0hwf2W8RYlV646qYFIH7hGoVQgj8r+obWHYIqly34u4HUKx
         54CA==
X-Forwarded-Encrypted: i=1; AJvYcCUEuvzzClN7MB2aUqLCKX5YqdGeM/c8H5z88c5hYvpVN9TJ8prQkb4nGAmpsLA0LG0YrdvLohWcc+Q2phaXVRZSm8As/SOgJg==
X-Gm-Message-State: AOJu0Yw7PcCXvexQ2qnwkOsNeRUTVyd1oFaFo8Ml28LLttU9DOBZ2An+
	PDD36mahEe1CWdXv7CCD/5gfgUEeyJvaLQeCxcb0tqPEyS8cR67Pa1zY9zm7O89on3hHeDoHt3X
	qdOLVngs10+t9cRobbJayZnhp+qaQNj6BszQ8iuhQqjdrfqzgJ46XoMkVh4btMhW00SOayoHmf/
	qBY0+G9DcxHx0U9B7yif+eSoBD26tUOQ==
X-Received: by 2002:a17:90a:4ca1:b0:2c2:cd03:4758 with SMTP id 98e67ed59e1d1-2c4a760a30cmr4616052a91.1.1718283775501;
        Thu, 13 Jun 2024 06:02:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIjH+d+c66ydyxKKWv0UjroQKAiNYbAIfjO+2HQRComC2/nIyrwuIX2YZV2KWKpJB4BwzdJ4ixQxLzH3JxxuI=
X-Received: by 2002:a17:90a:4ca1:b0:2c2:cd03:4758 with SMTP id
 98e67ed59e1d1-2c4a760a30cmr4616020a91.1.1718283775020; Thu, 13 Jun 2024
 06:02:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613113227.759341286@linuxfoundation.org> <20240613113232.007208207@linuxfoundation.org>
In-Reply-To: <20240613113232.007208207@linuxfoundation.org>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 13 Jun 2024 15:02:43 +0200
Message-ID: <CAOssrKfZCxxnRyesXSXUWrCbWRq94ZaDJjt3z9BRm9zki7P5_w@mail.gmail.com>
Subject: Re: [PATCH 5.4 110/202] ovl: remove upper umask handling from ovl_create_upper()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Sasha Levin <sashal@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2024 at 2:00=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 5.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Miklos Szeredi <mszeredi@redhat.com>
>
> [ Upstream commit 096802748ea1dea8b476938e0a8dc16f4bd2f1ad ]
>
> This is already done by vfs_prepare_mode() when creating the upper object
> by vfs_create(), vfs_mkdir() and vfs_mknod().
>
> No regressions have been observed in xfstests run with posix acls turned
> off for the upper filesystem.
>
> Fixes: 1639a49ccdce ("fs: move S_ISGID stripping into the vfs_*() helpers=
")

Hi Greg,

This patch is in fact a cleanup, not a fix (maybe I shouldn't have
used the Fixes: tag).

Considering that the "fixed" commit is from v6.0, I think backporting
to anything earlier than v6.0 is not a good idea.

Thanks,
Miklos

