Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95D5386C03
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 08:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782377651; cv=none; b=nOAXHBI/gVUGqj8HkzvQs20tPy0n2/NqTlplRPobkLn8YSUuEADE+8ADyn5u8WlLVHFQeDREsF+5x3TIRcYd76v3Hiy1t5iIa0an0aS8cy9D1qYtrs2Bgq44znSsgSF9tcmIF4EvJVU6xvcgngNSMeIASgQz+36OzzUOO7hFBy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782377651; c=relaxed/simple;
	bh=07Gz4DVxSchKBz41aocKqPwLf5Q7wYxmqWLTrZ9H6nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U1y9TtBAICVvjHcaMOS9GPkuHi8r2kgpZ16Vure9cWj9jAsDxMqqk7N/s0vk84JOA0NdgHrpyEsizRG7Xr0qCVkKo3+1O5GvHOUqHOyGPGECcXeqvfyXfnJds0hhbOrYLCyjDXCa8NtB7LbcSTceu17UPEfyut88izhaQ9t5OIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QRTH4O77; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QRTH4O77"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-46cbe01d4b6so980651f8f.2
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 01:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782377648; x=1782982448; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/jDoMmJJU0PpNgF+w3Xx9Gr+Xmtdk7u64RSrEr55CTg=;
        b=QRTH4O77GAhdI69O9C9mWDi3ZQMTEtxzBvZDuBUo6ZM+FkQi6oEP13KvNj3mrFpzhn
         19/2oTONKPkUgwzwq/9L8K4vxPoUkeIUOe+DG6n/B4hH+QqMqgXNG/eKiEQWuG7RgKmi
         7BAS8sjiGs0Gxb+Pvgn9R1E8XRjH2WMaxrccoodb8ImskcF7qp/9Wyxil5JNXaB4WsSU
         LNOr1F7j3FzP1nsk3BtC6PIQifiCyt+HvYzPWZIpP61aBUooE+wXxL6x0mMphpN7vk71
         qIvDbmZsgLAndAXCkB7QkL3UAIUzO01kguE15PjajVG+HO3jGl+bEQamVFLiXigkKaih
         6NRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782377648; x=1782982448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/jDoMmJJU0PpNgF+w3Xx9Gr+Xmtdk7u64RSrEr55CTg=;
        b=QYUEuafd1QMU6HeMEnYo16qEkk7QNhPj/3U6s9xv8wSLXG32c0fGLTS10zjJSCr9Xk
         cmPb60g01v9H8XIR+CIQnu5wu90xCuAm8nrMJJSEMmpF1S85viIcVvz5oFqoO0rNEhXQ
         1axIHDE/1/YtFBh9hMM0WSe3xALPtI5kKAvCIbD97gkOdVGmhD3jJFKnEPyXcem03/iM
         EpPvRzhw2Ke80FkatGgZRAs4P7+pAkmQ92Z+J3J/fpIZ6pvRuRwkFzIBWWptXnUv+DSK
         cZbX62dX9nn1Vr5XrUgBtDzMC/khbPEwcouJEyG8BwTa9SKLr2gVC3f54NNHtjIVMlun
         WUKA==
X-Forwarded-Encrypted: i=1; AHgh+RreUUaBYvSbxMC1l1To9m2jqu1iRoDYSMqwH0drJxof83BgCsp3337hkBhN4JHy58upoOawS3m6@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8ehuoL1gbN26QH2mVHL0Yb6gZQQS7j/Z3f8vPMuW0Nm6zheSU
	qm+gXJldAEKVBITfqUF1crZVWHuHNc9HiKg9pVvxe3hzaNm3o1O9HW56
X-Gm-Gg: AfdE7cnUgAHbPYaAyrtNk52+YDH231lItgSCHdOGlhXG4d7QdWvk/wl/qkueEeRVZ52
	idtvFu0GY6vCNfwggClKcKF9WfHFMGGCKAjvagYXXZZ1FGgPXUm9zUBzBQzmHuVUN2Hc2y86pfC
	1nl4r6L8qa0VkfWIatD8mtdteQq8/Xw7WVKdpssblRhPzMQv1qGQkvTC0gFAy0Nz/zRkkZLAHCV
	PhZCofAq4WBp62FRGruFjRMCKImvqwtAH7If7x8Gq2C5pFtAbBJGB/XYNINtOEHKxkC0z15Ivhf
	piD9eMwFa1lqI3IQwML8Aq6Kjwk3nskGe14UscxUhbFCAM/bgAPGGv59vLbCVChr0G87Dw7gXro
	py6FViw/bRiUv3sx7ANSmUmKfyEdUh+Yq9kl+TEAYLMwyxk+0PJRXIAZPxtLptWD/jIc9cRYwQw
	vCd8kWZ7go
X-Received: by 2002:a5d:64e4:0:b0:460:67b7:54f1 with SMTP id ffacd0b85a97d-46dc30e2c21mr2268492f8f.42.1782377648254;
        Thu, 25 Jun 2026 01:54:08 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c1ee018e8sm15530598f8f.11.2026.06.25.01.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:54:07 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: avagin@gmail.com
Cc: akpm@linux-foundation.org,
	alexander@mihalicyn.com,
	axboe@kernel.dk,
	bernd@bsbernd.com,
	brauner@kernel.org,
	criu@lists.linux.dev,
	david@kernel.org,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	joannelkoong@gmail.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	val@packett.cool,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Thu, 25 Jun 2026 11:53:57 +0300
Message-ID: <20260625085401.3787887-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANaxB-xUrLQYGiRJZc4Boi+KX=0TJSWymErNovANVko20fMDVA@mail.gmail.com>
References: <CANaxB-xUrLQYGiRJZc4Boi+KX=0TJSWymErNovANVko20fMDVA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Andrei Vagin <avagin@gmail.com>:
> On Wed, Jun 24, 2026 at 12:12 AM Askar Safin <safinaskar@gmail.com> wrote:
> > Does CRIU actually rely on ability to do SPLICE_F_NONBLOCK vmsplice into
> > named fifos? Or this is merely a test?
> 
> Yes, it does.

I. e. CRIU relies on that named fifo behavior? Okay, I just sent
v2 version of my fixes. The patchset contains fix for named fifos.

Please, test that this fixes that named fifo problem.

> I already explained that this isn't just a perfomance degradation, it
> actually breaks the pre-dump mechanism in CRIU. vmsplice is invoked from
> our parasite code within the context of a user process, where execution
> speed is critical. A heavy performance penalty completely invalidates
> the pre-dump logic, making the feature useless.

This is very unfortunate. But I still want to remove vmsplice.

> At a minimum, we may need to consider a deprecation plan where vmsplice
> with SPLICE_F_GIFT triggers a warning for a few releases before these
> changes are applied. Alternatively, we could introduce the proposed
> behavior alongside a sysctl to fall back to the old behavior and explicitly
> state that this fallback path will be completely deprecated in a future kernel
> version.

My patches change not only SPLICE_F_GIFT behavior, but also vmsplice
behavior in general.

Let other developers decide what to do (i. e. do nothing, remove
vmsplice now or implement some deprecation scheme).

-- 
Askar Safin
