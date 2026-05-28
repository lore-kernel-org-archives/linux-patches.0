Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9FD352007
	for <patches@lists.linux.dev>; Thu, 28 May 2026 21:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780002186; cv=pass; b=eL9S3eB8JJqoySnvZlmwjornD5U5ORsDRz7lcYXNfHHXn3Scf/yBKalCiP1XalH7R2+DwhIZjz4fHkQutrz3FWD8UC53sEU3pmX0OQZDqxP65TcLrC1wfsCYaNFX9ufygd+Snk/WrIHOIlo34hBlBG1O6dM/Zo69IvrbkUli2HY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780002186; c=relaxed/simple;
	bh=8/H0s5ObSXuYN0fXRn8e8f15KeuvhPQzxR4j5wSdGW8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LAraKKPP/+A1Vm+oMZHJBsfAbwNxEmeooYuFmIdRxGMujpIs9VVVVi6BlqsQ88MgheSJg/2FSiJSDAhRB0OuxHLovKgZN6DubL3bzM0VmBXJtykbKJsWUJpfavAD1GM8HrURJgkz9L4IPDe4HrRh0nVUO+Sli7kJVFWmmXDKmfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FqDJDKq2; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FqDJDKq2"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a8bd9a881eso101e87.1
        for <patches@lists.linux.dev>; Thu, 28 May 2026 14:03:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780002183; cv=none;
        d=google.com; s=arc-20240605;
        b=bU507wBUYtyKUOKDxUBXe9V4TUB6Yyf4jEDnDbd+yJvJlS3sQxGMqBz022ktCEd612
         B6hsM1UVhNoo4WLYGzdk7NbXSrMb9/+P3cjS+ecxc33LtX5hQcsv8rdTHT8Uso6emxXa
         JLSgJCIrE9eThj1SuASJYYwYKGkr1xK/LXkAH4jdpV8449/wwp7X72zEV4DMGDPt7oH3
         RYRYap4/bmNvxb6U2ZGJ+QuVl+J6GEmI8wKvNRoTYOKXZU+6w8ob92WurQi0ezusvJ6V
         Q1c5xdDOfBcHfxMNXxgdfuD6G7UIEGwDC073Dm9bN9g4N4xFqqt+M2h1IYtvGy9OPTZw
         QV+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aO12JApDqdyz9RPHxp/SAH2mf80I46UDQfAPg6V7HWE=;
        fh=qde1tVVtOh+R6GyO1ioemQhAaJjquXp2WgwSH7dq9Es=;
        b=eQt1/raQZX+UbUa7rUPnKmyjr5+q3GMgdC7hBqm3XvP7gXCdaJ4mlJF340kT4F7v/a
         Z0m7WX4vqm7xjLZ+GXRnooILmg8QSZHUd9Oq1O7b2TAe0KuQz8wRqCW+ABJBvMqOpwRq
         oU5GbolE27twVvlp8dIJBGVPz3es70YSjfAq5zO1hWFiWOQ4qZ2gCHcinp3xWg0HE9j8
         ouePYMuDYetE+T8VTIpKvtTg4ntWKjKbJxTcy97QJ5geUBuvlO94m/B9A907uTU2/pOy
         SoUlw6G2608uPbNMtwsSC1YfoYIvOdmH8GT8HENSh0B7My4olFHlwgnFLaMKh0jrYczr
         F3iQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780002183; x=1780606983; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aO12JApDqdyz9RPHxp/SAH2mf80I46UDQfAPg6V7HWE=;
        b=FqDJDKq2uYWiMdnrA7jkk0xR2Dh1J6rVaqczTyf2sZH3LYsx2WhM5If8Coi/O0u/vo
         HuvhU5SrtVF4AEMLdZcDlfQRXE8GJTyIDv7kgSwJ2zOmNx/MY+FSyQ9x2U/DrlpdzSt/
         EcPgLO435Yq2MYEd+WlFfKe+p1DvytwcUwBJ1NeyhKlVx9Yu6BzloDWLK2yIl6oIIJNm
         dR/UcRHe4uC6iG918Z3B9Tp5Pv61SdL3yLgVUZvPHwK1ZPgQJtLpN0p0/vy0kIckQtAc
         Pzqt13DaYQGT6B+l+lblmjUF40lQGNy8LhpIAMLpx4ouue/clzavdHyUemqnvt9704v/
         0eiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780002183; x=1780606983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aO12JApDqdyz9RPHxp/SAH2mf80I46UDQfAPg6V7HWE=;
        b=VF5I9g/NxvnNVXdMx+SLGbzDHx+KPTQKy6BlD89dUpANA6gcZvtnsm19/PzRPoQuu8
         TRT3HOujjqegno98Zc41h3QUEuz7Zb+wnPLHqXSD3X922I7Id+hCkHaUlEs7ZUB6xyV7
         pfJZu9lN6BEHKQsPl/vaCWk9dYtZLHBLVa80N/JTIq8FZMuJ+BtZ9//uD7kTDqgbVrIM
         5eYY4Fd4bN7dQw0W838uLf4PD6QIXszk5eumS+RRUB2MwJV2QJfnaxNE/d/kNlDbpr5B
         fN8hwt7CpfZaY19kZ52wnegEk4RQzYiUqWoDIpgfwRHYhqj978vfEnKFhI+JR154SKQ6
         e/FQ==
X-Forwarded-Encrypted: i=1; AFNElJ/0tyls5LZxcw7zHKDa+tvnoT3dnYqTqQIwrpjmaGxTMX68MLYht8WdX65JIffU18QziXH/h3Pj@lists.linux.dev
X-Gm-Message-State: AOJu0Ywl28rGMW2Ade++m/n4wB/LyUVnYbWrZnia0RnRN2WIHEk/6htB
	1HW44hSmeHcQY2wSMZdVLccNJbmbX8I0f1tdAiy37EP9H5l1x6JTqzbfsI6B+vIIP/B382h4vFb
	2T94a1SJRouKnA46oFOBC4lohY4WPG1BIfGDlhWde
X-Gm-Gg: Acq92OF34qocmHUqZDkTxMiq/vaecawwzBd82Kz566/I1Nf4Nq87/sQs1xS2aOHFFtG
	XgFn6Wo1m9OVTtMrm++W1d7jrMEUvCwvron/3tlW1F/3PzuNJnOzW2QEcoGc1JoAdj7k6EoNUJj
	BYfbSn0Bp10kszSBfdLNH3HGLExlX/vTKfcaxj8wc5eNP9/iBd/ZVPGPha4Ze2LWy/H74Sfo5IJ
	No3Lg8CKTczV5GgBLmebbUnxDG2ZK066dchk5sbPm5asvFE5pyoOtQpCUMbNISbGAmxXzDZ8eAk
	7N7xcMO2fNoDdZu1EukGNjtJM7KNrVCeXC8aYEyAzgEQ3HE=
X-Received: by 2002:a05:6512:234d:b0:5a4:b0e:d756 with SMTP id
 2adb3069b0e04-5aa58f9c0a2mr11796e87.0.1780002182945; Thu, 28 May 2026
 14:03:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260414210626.2097722-1-wnliu@google.com> <ahftwWxiL9NlJ5g6@8bytes.org>
In-Reply-To: <ahftwWxiL9NlJ5g6@8bytes.org>
From: Weinan Liu <wnliu@google.com>
Date: Thu, 28 May 2026 14:02:51 -0700
X-Gm-Features: AVHnY4LPgbWDgplNNi5uPg9sYMAtw_Ybfu0DFYLHcXRDXVQxdtLgvA5J223arPw
Message-ID: <CAPhhraxy5Bey67Psynqvsp37cW3HfYdWEU8+n_3YVqPAqt5TnQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/1] Don't split flush for amd_iommu_domain_flush_all()
To: =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc: iommu@lists.linux.dev, jgg@nvidia.com, patches@lists.linux.dev, 
	robin.murphy@arm.com, suravee.suthikulpanit@amd.com, wei.w.wang@hotmail.com, 
	will@kernel.org, kpsingh@kernel.org, josef@toxicpanda.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the feedback. I will update the patch, gather the necessary
tags, and re-send it as a new thread shortly.

Weinan

On Thu, May 28, 2026 at 12:25=E2=80=AFAM J=C3=B6rg R=C3=B6del <joro@8bytes.=
org> wrote:
>
> Hi,
>
> There is an updated patch in this thread, can you please re-send with the
> correct diff as a new thread and all Acks/Reviewed-by tags added?
>
> Thanks,
>
>         Joerg
