Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4D91AC43C
	for <patches@lists.linux.dev>; Wed, 14 Aug 2024 12:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723637165; cv=none; b=jbNIObpSDg1vLLrWeIRjSqCvVYwaMbfHUCHoykgdHRhm1i7QCAWG00Qz6enTM5mK+TlxrLWKxl9h64Go++dhHs1ee5qOWUebcmI3AstZ/GVeRjUpXTDHIQI7pa0AFQagGGGzAA3K56RefK6pZEJjydL0KS8cXtjXquDO4bgy/tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723637165; c=relaxed/simple;
	bh=gd0IZ5EN8FLvwLtcwZohMxrnj1Hv3wxOAK6EJ8hB1vU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZYd/rOqxtyaXLYPlqNuLqZ9c9/qQcY03yiD9JCv/TsVSwbsxGS+mF+JXS4a/Yp8Zu6PE7T3uVkaEs6eoiw8qdfZoqtxIEiqP+0GTeCsVhuR5rxSQAKDdatf3YQjMJfTtMm1O8PcOgGwmDdIEhHTnOHOTYRpGnvB1t9IDY19iZ64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JsLiRieH; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JsLiRieH"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-429d2d7be1eso4737755e9.1
        for <patches@lists.linux.dev>; Wed, 14 Aug 2024 05:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723637162; x=1724241962; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gd0IZ5EN8FLvwLtcwZohMxrnj1Hv3wxOAK6EJ8hB1vU=;
        b=JsLiRieH3TcmnkLmboVDwJrOrobq7OrHAFfRyJjzedLyyFphWTko7qrMQeSnB3kXxS
         BRg9UT5ZC/eONR42CaHvLxhVcIQLz8xAugFuZi/9PClrfoUGoeNsv2U7Wi0IMqwdX+l1
         hqu0GaWj1QJ2TI2N7Hw+CoCqixjoaq13JT9shPFZ3k7JCZUHSp+AGt83sCZQ2AX4GRPl
         YTOVxzqAWS/3iBAnN4JnQ1WcTEKrB0dBka+gES8sAlNpJQ7vlL2h3lQo+8XHuAYVZ2cE
         O+PDSSv23cL2fZvodDYohfsur6YKIwgz1L2XREwx25W1cFmXydDsQAwR+B7swms+b1wv
         kqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723637162; x=1724241962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gd0IZ5EN8FLvwLtcwZohMxrnj1Hv3wxOAK6EJ8hB1vU=;
        b=eZ6Hy7EjzeHuWjvdNykmFpSKdtFHntjWGUhqHrZMqY8c2aCEju9m7fXGJp+Jd3Bm/D
         VXEb3lQKM1UqoY+dy0tK/TkgX+WKecctOK6MOcIdQ7nomhrg5sh4c19C/e+v33wEA5/+
         i8qfslRDg4C4ik7G91Qf9ygiLhDWIzg8eNdYs2bSpaydm8F2M5zKHJjEv2n2kTQyNKAo
         /PkKRUI2usMOVnDQeoZdvzm/xkzR0dwOPD72/xEnAsJvgaCXERInfcXIv0X/UMf6yw+D
         1fMmG5+9JZkL6kZjRkIKc8IZYSBHEZPEZ7U/CYBZHnhfl/j6I+I8ml/R6/7L80s1SvvS
         0gHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGWVYN24ay6BHwmoFxWX5k3q/9wEN5lquTpxbNyFvwUnDuqr38yKcX2q497wrzluT/dRok+Y/XqACbAZs7ysU8wDHDvBJNpw==
X-Gm-Message-State: AOJu0Yx4KG1iEkyzmUo2kcy8Qtp7Vv/fCsky4bacOhR49AtEth6t6rij
	31eANZQwgId6FSZoMbcDPjVdv1FdoY+hwYw/GeW0f18I9O0/pgysEUJKSQxBhFndyd6aiyddYAq
	+
X-Google-Smtp-Source: AGHT+IFK9tItiQFrBm0FFaTbJQ6kU3PJtrSKuDDXaxVjodxyGXKZveXBhaEMoW3T8np6iwQotEm4FA==
X-Received: by 2002:a05:600c:4514:b0:424:8743:86b4 with SMTP id 5b1f17b1804b1-429d62900cfmr51225855e9.6.1723637161918;
        Wed, 14 Aug 2024 05:06:01 -0700 (PDT)
Received: from blackdock.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded2882esm17835185e9.13.2024.08.14.05.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 05:06:01 -0700 (PDT)
Date: Wed, 14 Aug 2024 14:05:59 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 017/568] cgroup/cpuset: Prevent UAF in
 proc_cpuset_show()
Message-ID: <xrc6s5oyf3b5hflsffklogluuvd75h2khanrke2laes3en5js2@6kvpkcxs7ufj>
References: <20240730151639.792277039@linuxfoundation.org>
 <20240730151640.503086745@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ewb2dnr3qonsceaz"
Content-Disposition: inline
In-Reply-To: <20240730151640.503086745@linuxfoundation.org>


--ewb2dnr3qonsceaz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Tue, Jul 30, 2024 at 05:42:04PM GMT, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> ...
> Fix this problem by using rcu_read_lock in proc_cpuset_show().
> As cgroup_root is kfree_rcu after commit d23b5c577715
> ("cgroup: Make operations on the cgroup root_list RCU safe"),
> css->cgroup won't be freed during the critical section.
> To call cgroup_path_ns_locked, css_set_lock is needed, so it is safe to
> replace task_get_css with task_css.

This backport requires also the mentioned d23b5c577715 to be
effective (I noticed that is missing in 6.6.y at the moment).

Regards,
Michal

--ewb2dnr3qonsceaz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTd6mfF2PbEZnpdoAkt3Wney77BSQUCZrydpAAKCRAt3Wney77B
SZfxAP9ywyRvIKhBVUuIF+3idoVQKQWOlPsRUq+dEm0ScNqbmQD+MtZgzYHXuLkX
Mby2RxhSRXCwCsXKgpEdCEBqBpKvLw4=
=VlV7
-----END PGP SIGNATURE-----

--ewb2dnr3qonsceaz--
