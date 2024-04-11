Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622E714600E
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 10:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831914; cv=none; b=GiPOM0BQFNZOVJ3Fa12avCDhkb55/s+8os5jKM6+tRH26fmWqkJnsAKsOH0PXoz7X5mQNIgBRdRFUYvSTIrdiuZShPXUhDBLTodZkanOzkJnNNquDWBGC8X+wvM/eTJiEdcwdIOR5T4t35I7UVgyckBswViGrGWsAy659sm3qJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831914; c=relaxed/simple;
	bh=MESeRDHPunaASxUaHAPetHb9HjlSRtpxTfy9NZaixs4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tW+ZCpqO+mwwZZbnoPqu8YP52+0rOhdZBsomiX7on/6hX8ssgWeEcoFXUS6IDcTvQJT4cvCqlKy2Vv30VXnsAFWAkBJWb+L8xtA2Svd7W9erT0Los0q+VyyHP8ODPWzL5radXDjCyiuudGGqAeRVv9WnrZ8nYvEt0e2ZU94lKdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UpLQosfD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UpLQosfD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712831911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0eR5GNV+l4scBem2kbMM6ywL7pC+HMBlFnK+oKg3nC0=;
	b=UpLQosfDjC8ippZZ9n5tEodGUI0ylRULt1NtTjTOzbnF9elMAx3v3J1agCmRGmwobVAknw
	SCnI5GqGTt6yUoWJFX/rttkLfxrxeMHBzRTLDEHUb7N1ouSGqL07ndL5Z0FctVcvRrC1eY
	jyQgBuDQUK/QucblSXGfPh7ghykS6ps=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-xl4CTr1qPRaGTyNHWWFMlw-1; Thu, 11 Apr 2024 06:38:30 -0400
X-MC-Unique: xl4CTr1qPRaGTyNHWWFMlw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2a4fc4cf54dso4283613a91.1
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 03:38:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712831909; x=1713436709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0eR5GNV+l4scBem2kbMM6ywL7pC+HMBlFnK+oKg3nC0=;
        b=CusqRdiiV+1cI+Df3gq6fpVaPA73quVbsq0/yJkdF5sTLB1XYrRurCCGFbC/+p1oA7
         aGPEKKV/wGVgHQQcjwgCqVpQ1KL5hAJ/pIRKzKuGK34PHVNr8xZD/NcQJLQdgYEix+9L
         IkiQHX5dO0bPqExGxscubhRCC2B/FvOuIZBiEDaSCl0o+NSEsqtlK2Q2DSgHdftajt9e
         4YGAe7N32nV7cyvCgiME4knIEseKMV4CZ2fibCgdHNV46tRNo8Af4FgxXgvJ5CFHwVOS
         28s556y2JFBsqwH89pW7rFjJSwIFbTT/il5OPUKweiZptS/dRwSrDmAqapZeMr+k47AI
         lPnw==
X-Forwarded-Encrypted: i=1; AJvYcCVGnjh6LZtrGCvsZDgsuflKqCqE4h/yyjWZbtB96lJQBZ7x9utTPypkAw01i/hUS9XyIjmIW+6N7fHnVvmcQarJFIsc9AQlaw==
X-Gm-Message-State: AOJu0YwKdN2ZuuQjzgp48PzLE4LzTK3DOx3AeUNbVxIOY+pcwWR9aK7K
	hYgCtYCr+rCjoEMqCOeCHvF0sX6NdammMBQGU3H/yKadjWGztBudDgJtY552Q5QzX52YZLYMquR
	CSNnq6artTLQuMPwV/ifiZpLG4RWUkjV2ajjTKH2jCMpprcW1uTSdlk02QeYqjTJTFouUZE2eZY
	1+CD0c0VbHy3Tf8kQN2S0HuS+yDL5kHA==
X-Received: by 2002:a17:90a:fe8c:b0:2a4:ad2e:1c5a with SMTP id co12-20020a17090afe8c00b002a4ad2e1c5amr5444735pjb.35.1712831909030;
        Thu, 11 Apr 2024 03:38:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYG81oDiN+wTKwCsGUjBQEW5injtojjDmF1lTGqvLT/7uNsSF/5crOEW6Z3A5mh2Rjwp8eO8wI6YZpwsipvhA=
X-Received: by 2002:a17:90a:fe8c:b0:2a4:ad2e:1c5a with SMTP id
 co12-20020a17090afe8c00b002a4ad2e1c5amr5444724pjb.35.1712831908682; Thu, 11
 Apr 2024 03:38:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240411095424.875421572@linuxfoundation.org> <20240411095426.249853460@linuxfoundation.org>
In-Reply-To: <20240411095426.249853460@linuxfoundation.org>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 11 Apr 2024 12:38:17 +0200
Message-ID: <CAOssrKfFgJcKK1RGbo4bDy0DkQ57Fe3Q9H89Jwgjh9yVj3qwJg@mail.gmail.com>
Subject: Re: [PATCH 5.4 045/215] fuse: store fuse_conn in fuse_req
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Max Reitz <mreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Sasha Levin <sashal@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 12:16=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 5.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Max Reitz <mreitz@redhat.com>
>
> [ Upstream commit 24754db2728a87c513cc480c70c09072a7a40ba6 ]
>
> Every fuse_req belongs to a fuse_conn.  Right now, we always know which
> fuse_conn that is based on the respective device, but we want to allow
> multiple (sub)mounts per single connection, and then the corresponding
> filesystem is not going to be so trivial to obtain.
>
> Storing a pointer to the associated fuse_conn in every fuse_req will
> allow us to trivially find any request's superblock (and thus
> filesystem) even then.
>
> Signed-off-by: Max Reitz <mreitz@redhat.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Stable-dep-of: b1fe686a765e ("fuse: don't unhash root")

Why are this and the following patch marked as dependencies of
b1fe686a765e ("fuse: don't unhash root")?

I think they are completely independent.   While backporting them is
probably harmless, it should not be needed.

Thanks,
Miklos

