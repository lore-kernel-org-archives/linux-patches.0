Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB6E303C9C
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 08:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761120398; cv=none; b=uR/B5NrTIU8yDenGSAKiWLXxO1K+tFQScIxoyDjjrxZQBDv21cE+yxrFV04tJuyjZebUoSXYTfv4kNs9PeINe6AXgbS7uP9ywmb/Sox2chClqUmvrUkacJ5fpmVIg0Nxk7AxP0Ga/XRWwZo0jhQ+w4ItS+tQknQW1FoRXY+0z+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761120398; c=relaxed/simple;
	bh=eyBdO2wWOgqsPzs2lpBJ9/L31r8e4dCSgvgCYmxIx6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QF+eOX2Te49NTbhe+bUrxh15xCcrcw9zz0TBaOpYtLc0We1fbTwgyZMMzbtK6XysROmX3TQb2h77OuMx1irwc0Q+V1gINak2RkyVgELGfpMr/8min4OlvPdc6siiFMTdfFEgWY6fSSIFThBTeoH8p33iZFcNEBThl+KNRZ2jTTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T9tgEKdQ; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T9tgEKdQ"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63e0cec110eso2195726a12.2
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 01:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761120394; x=1761725194; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=toHlnWQqNYbfD0u6quHogsDi3+miz5wiSuRT4/A88gI=;
        b=T9tgEKdQEDl73PqOHgWj5XmSnwkRQQE7OuRTOI7TX69d+LMmcwZ3IfRozilVCag6pP
         cLLBcqC7IXN83qXmExqEmR6Ej1pZyf4IDK/SSeB9XsTivn1gjDw09WVIcUfO4kHJP9s8
         JYqnpVHPujxsFKbwWYA/IqjnYWmZN/JP8DvvaQwajT6CnauPkjdJigPqjaFD2zI8fvMZ
         elDdV7jTYvJnE0Q5RKyDhk8OvbWIsBJ4hPbqrPlrP2ilWc8UF2GGYSfNghjjn45FdJx7
         1OwJyrIWZ3H22ffbvie+uPlZbfny7wGZkIM9T+Q1p7VRO3O7YojwMy6IVa0Q4GEWl3xi
         gQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761120394; x=1761725194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=toHlnWQqNYbfD0u6quHogsDi3+miz5wiSuRT4/A88gI=;
        b=vxCdPRsUHW2/2u2ExYYmEUcqTYNItpa/7uhZHI6tx1ikswbigyUObzzfqPKDxoZnD8
         g5WJo5ZMqg/wFlNVjEI8clIXSIBZbqzeBqLYSPAdrsLm3YZku5itZUljiAAPIYhdCD/l
         p4Rhfsz18B9WYrPLp6mVLNBtHQrVwvp6/x7+gRePulA+OSb2kVIx375lCl76qKu3QaL9
         nVf7NQapX15oZdCgrVZBt1sv8rC00i9CXiJhtmS37WshNjt9dyiaBqy8zYynVTqSdlQw
         FhgMPwIQmlUhypDRZvJ46QM1SGh6eiGqxXJuLMmVlcjhmD7mtuBVCNaSAZ/itro8TuIc
         DhpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJfynK6dBU9JYRyaUrmMqfmp8SLj3QmhoVFkUEVwHj8KpaxaUlEYafNjuj8HoEWmzLeGPLkhdd@lists.linux.dev
X-Gm-Message-State: AOJu0YzroFyDTqR6Su66DhC7vm5K1oPkGsqFjnLWbTpZFzSWom2y8JiQ
	8Ne/MXdU1KY6BU7s4x6UPOtmzP/EcCshm4dvXqgAkii2RJrrsdqeS5VV
X-Gm-Gg: ASbGncsEMi1EL0waI4hvLP30Pqa63/zCbe9r6fcN0s4D/M3HsQTZEOauEkoxFvU/ZcV
	pAE4UurF91jQxv4HeD6VQkX2kNWkVQG/W9TKesg1/Ld2r+BWuvnHzWSHODwIZHb1R4h8PJ01EON
	Ho3J1VcZEitVUyitk9kSGWLKWwxnoezUQdkqfED1fV/0Uh6vfZGpZIn+FThg5ixfvu5nOlaCub0
	5IZan+y98mtvXl7MEixLfXMkD8WYQpf6QILySPtc8U21+02pHv9VrSfPXOBKvgsGcTRVNbFrNZl
	1f7RZ9BQti9gDG68MqZEjRF1ojvqAHIqoHirncyh0Ub+w8dMpes6TX+bXZaI6MXPFSwHSbxG36e
	X8zkwWcTDlFZpzQEXMhAQnO3sCwD/2Og+D+OCbKQxdcrg9LrChOXAuyOL+XBto6EGJADjNGmPjr
	hX
X-Google-Smtp-Source: AGHT+IFKMamBOdEkXZztW4+a96FX3cVQPwKK7mU8xvsOl5ZRh1X2aHXQdNoBVmqwPChAhbEjv7M9Xg==
X-Received: by 2002:a05:6402:2791:b0:63e:23c0:c33e with SMTP id 4fb4d7f45d1cf-63e23c0c43amr1116868a12.27.1761120394218;
        Wed, 22 Oct 2025 01:06:34 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-63c4945ef49sm11192106a12.29.2025.10.22.01.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 01:06:33 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: bagasdotme@gmail.com
Cc: akpm@linux-foundation.org,
	andy.shevchenko@gmail.com,
	arnd@arndb.de,
	axboe@kernel.dk,
	bp@alien8.de,
	brauner@kernel.org,
	christophe.leroy@csgroup.eu,
	cyphar@cyphar.com,
	ddiss@suse.de,
	dyoung@redhat.com,
	email2tema@gmail.com,
	graf@amazon.com,
	gregkh@linuxfoundation.org,
	hca@linux.ibm.com,
	hch@lst.de,
	hsiangkao@linux.alibaba.com,
	initramfs@vger.kernel.org,
	jack@suse.cz,
	jrtc27@jrtc27.com,
	julian.stecklina@cyberus-technology.de,
	kees@kernel.org,
	krzk@kernel.org,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	monstr@monstr.eu,
	mzxreary@0pointer.de,
	nschichan@freebox.fr,
	patches@lists.linux.dev,
	rob@landley.net,
	safinaskar@gmail.com,
	thomas.weissschuh@linutronix.de,
	thorsten.blum@linux.dev,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v3 2/3] initrd: remove deprecated code path (linuxrc)
Date: Wed, 22 Oct 2025 11:06:25 +0300
Message-ID: <20251022080626.24446-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aPg-YF2pcyI-HusN@archie.me>
References: <aPg-YF2pcyI-HusN@archie.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bagas Sanjaya <bagasdotme@gmail.com>:
> Do you mean that initrd support will be removed in LTS kernel release of 2026?

I meant September 2026. But okay, if there is v4, then I will change this to
"after LTS release in the end of 2026".

-- 
Askar Safin
