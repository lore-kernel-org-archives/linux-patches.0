Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9041448FD
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 10:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723716041; cv=none; b=FSlE3PM1zOb1jJQA78QzhLZgZIM8ztiR/Qc0vQw8aI/gSGK+KFeMt1UXtcMAfn2BLmi+1fH1CXiLJlengUMYCRpPBow7cH0v5kh6PVUEzUxVYi9nEFVzJvhZhw6FGceTQngEcJj8YqT/sylRMK11+Gqz+IT2qneJeRSVpiJckoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723716041; c=relaxed/simple;
	bh=6GHbETPPC/B/1h8t6uB9Eun0Lhnp/zyhCpFIMq/RNB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uORx8+VvwR4cxhPP2v1Cy/AIhkXzKOP9cE+JeFLQkrkOlEyBWZlFKEbWJWuqL/E2trOUl3S3tJQue3zDkI3Ssd2atJORh8QN/n6BEHKdmT2I941uAQR+7ObeZaKLorsGE99/ZKfHz+ARamug6kUBIwoRvOTBPZFrgGERsH3NjHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eueamjz+; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eueamjz+"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42817f1eb1fso4735475e9.1
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 03:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723716038; x=1724320838; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QhqqyUskTcZ04Sd5gpzfZtw99v7GyBxBE1TibBPMa0Y=;
        b=eueamjz+K0gtQY4sRgD1tqe7kUwI9efWXWuTjAdS8tK1KZkINrjQnTAIKQBVS9YCgc
         AkLjtKErgbHyqv3gOPSoJHq3bDZXULOjx8t/fxHUZCmg1sya2dYWP0dcW9u1Za58AoIn
         Od6LWjqOoHK7dKxYy7l54sNaic91Spn6hO2SyaqkwhcN070se+gcw17yfpVP5cWgoY2R
         rNYokWVxvhJpZDjvyrvc9kkKNxeJdm4x5Cr/flOiS+eGuBR5KjYeW++KDdKYLj2Nqe6p
         PjiHzPQ48Pxo8p4snc334YXYRwMNO24Z4+HsQG/e2X4DLLZpZzyuB7Dbu8t+J1C3jQje
         QUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723716038; x=1724320838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhqqyUskTcZ04Sd5gpzfZtw99v7GyBxBE1TibBPMa0Y=;
        b=SlSkXXc4xIGQ69ycQGL5da3/A7Vrl0ZKykavQ5gMxXOuJ+cRiEA9iRb9ESKALtVsQy
         QYiCV4JzxGuiliwizGagyh8LZyzqlaYYuR+Q7XxPD6Fev87+v4a/gEVHGhDhnSoFh0E7
         FvPerU3cyHteHWwQzcqjbTYT0hWA+iv7sZC37T3jqHze1zNYjR+a8QlY8HG+I0I6XxLE
         zrILygSV5oNXeyUMIOWzXYyh/P+485c34L9ZyjH6STOxzl9xEcOV7/dyPHsuGtKkZUz/
         XjWLAykeqM/pE+1P5Btu8D3QZyPUvPy3ByCt9P1+Vd9H4owkZcFio3rx32m2wXIGhlS0
         X2wQ==
X-Forwarded-Encrypted: i=1; AJvYcCUttiKJBJ254FMWIIPKnqo8MmNgKiHDLWf7CLDZmbWCl1jEVmAfdfC5Zy/3yG2opG5gnD8pdz6/DZ/K1+kKjvSWkFWiumLN1g==
X-Gm-Message-State: AOJu0YxOcphDMPJZB0J0UI30yr1wA/hxNYtAThgVnqamM4cBe7wne2F+
	0hedkmzIjBfl7iHx8CXqwCWNjOofOiHRwFiPurhLkGSf0juvy7lVp9KzG38m2zk=
X-Google-Smtp-Source: AGHT+IHww4OWyanfDio0T5TudWyimzwe45bbB7fxk4PgsGoDlm0bZ4uZHM/UyNZ4rOvkr9MZ39oZpg==
X-Received: by 2002:a05:600c:6d4:b0:426:647b:1bf7 with SMTP id 5b1f17b1804b1-429dd32c3efmr45142765e9.32.1723716038150;
        Thu, 15 Aug 2024 03:00:38 -0700 (PDT)
Received: from blackdock.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429e7e1ca56sm14468855e9.45.2024.08.15.03.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 03:00:37 -0700 (PDT)
Date: Thu, 15 Aug 2024 12:00:35 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 017/568] cgroup/cpuset: Prevent UAF in
 proc_cpuset_show()
Message-ID: <vxrjoloxbtddsmdqybntugwocztrjrnu4urqdfkcm3oybusyeq@4rqtm5foijgs>
References: <20240730151639.792277039@linuxfoundation.org>
 <20240730151640.503086745@linuxfoundation.org>
 <xrc6s5oyf3b5hflsffklogluuvd75h2khanrke2laes3en5js2@6kvpkcxs7ufj>
 <2024081444-outwit-panic-83fa@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="v6y3yibrc3ombwdo"
Content-Disposition: inline
In-Reply-To: <2024081444-outwit-panic-83fa@gregkh>


--v6y3yibrc3ombwdo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 14, 2024 at 07:45:54PM GMT, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> It is in 6.6.44.

I meant the commit d23b5c577715 is missing in the backports:

git grep "list_del.*root_list" torvalds/master -- kernel/cgroup/cgroup.c
torvalds/master:kernel/cgroup/cgroup.c: list_del_rcu(&root->root_list);

git grep "list_del.*root_list" v6.6.44 -- kernel/cgroup/cgroup.c
v6.6.44:kernel/cgroup/cgroup.c:         list_del(&root->root_list);

HTH,
Michal

--v6y3yibrc3ombwdo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTd6mfF2PbEZnpdoAkt3Wney77BSQUCZr3RwQAKCRAt3Wney77B
SbgOAP9wFVcU+bcey3YCLyDxbJVX5DJM8ZJugdei99xgJdTRPwEA4b/v/m3Pl8z6
WIu3n0VkSM7SS/slmDgwGpLn/akU6wI=
=JKW6
-----END PGP SIGNATURE-----

--v6y3yibrc3ombwdo--
