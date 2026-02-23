Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3C037419D
	for <patches@lists.linux.dev>; Mon, 23 Feb 2026 21:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771881566; cv=pass; b=j85W8KGTeQV1t72Nar8E+7IVrH11enozlFX8EWqc++xfmPkePmhfXhmGq0jmhWo50c1FBrZlIFQOucqLmVMVZTC1fSpfqImJgTXbhWnMSohB/HIsFab/jRU0yf2eji1U2VZLVL1S3uYq5Tq6zqiZRDNYofvbQkWwS1q/kja5e8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771881566; c=relaxed/simple;
	bh=6xucJiKz6gf7cBFoHRvH8DDttfd7LVVX7JhNAoPFST4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f116bjfutsJTMCQTTo50+LcnPO1kSIpjiF9fDgH2kLbypqBVJwnqJxzgGuczP0LH7AQS8sh24LCL7vJK2CNWoD9WstbwbMlTcS/Q7+d47ASyeyjGD+ICPw2HyVtIWE6BUg5MnwvZ+4U3n2t7IKtOkRfL+mM/UN5l1t6X8bqf2tk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lrS3zDo1; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lrS3zDo1"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-79827d28fc4so23316367b3.1
        for <patches@lists.linux.dev>; Mon, 23 Feb 2026 13:19:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771881564; cv=none;
        d=google.com; s=arc-20240605;
        b=a+DtFTHuITamW1VNPcuN0PaBU6xotHHKdIa+GwAR8NaZo+qd3LGLZhQsT9INVpWiRb
         EpVHMg4EnLsE+ybUjTaDc/Mr61VlIfKL2sinKqnaK2aAnnXT2lIGd8ZrQlY6tDBVnH/A
         RB+ZzGBRiol+PFg32Jh6oAe08D8V2oi2++U87OcuU75iqaa6Lit6P7VH9BJGtS+PDkUT
         NY+wFwiKQGgLXZHJlXUsQyF7P6dce1IJd+ks70eHhal5JzoMCKgbUoX+0qVYdO2xSFYg
         AE6ZACy4iKFP7obWYJXdK35agxaw8zirzeU+lggkCVUq6wASF6rlESA0MX2jVtBss9MD
         fVLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6xucJiKz6gf7cBFoHRvH8DDttfd7LVVX7JhNAoPFST4=;
        fh=WghXYmLL6wUjTJ41n4Bq9noeKJ9XT+BwcnVntz1M9ao=;
        b=TlAE0KknF43ZyWKLntaPIYZhbAXdzt5TFWu6nS5bQkcx7IC24ftQNtaAObj4r6rOut
         e0BlA98oa7jD6molA+V0ClX9yPgHw29hMHLLwESXqTVUFqmC/Umtyc4E/FSKpSOQ0Gbt
         dZa5XyXoUFw5qe98JVNCxlb/Tz2zWCTFQm69wag7sV8j1o2A+QpFc0AP8w4PV1Ypxo10
         FNRprU19hYwru4QgRpI6cuP7ZCIKtsUoyb3bb1r8N/hUaU1FSBd12C8nQM36GGsQwtSv
         USBtHS2dIM2Wpu6tLBs65/E0rw9i1NfLpnXDCfeWChR1hyH96FBdZkVHgGjAFK+MLpcC
         i/vQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771881564; x=1772486364; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6xucJiKz6gf7cBFoHRvH8DDttfd7LVVX7JhNAoPFST4=;
        b=lrS3zDo1W8mgOLIZAWO3Jppnk7ZEDAv95X6bFR+k50dY/66gBgTrReF5BvHc/KlMJf
         u3JxS7YexWeRUjlabVYATjNKgKfRED+lIkLt/ncfkXHDQzFgcsCJmC9cr8xRVJVYbZdM
         GGwJTtjt7eXVKzCM1Y+yklPITfimvgkgFjCOW9dc9n5UZIUAtFFx3CbQEjbBOeO6vFmP
         fzI0K7LkeYjeQxoT1WOrZCUujhwL6R0hiXkR2uuxkbU/ZSxkk+9FVPFFgXYx2/uotdm1
         EBLMURLx9m3m7Tk9mNp2jkSkLEaOF0aBMSzhLp2ThNok5dweL+NatXJolgMUW4AQTv1C
         lFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771881564; x=1772486364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6xucJiKz6gf7cBFoHRvH8DDttfd7LVVX7JhNAoPFST4=;
        b=P5Z/OEMLgH+D+y0Z90fgcG+FDt3cXshWmKh+p5UznPP2U77EULgPfeGPAkKzuMybDA
         VXtSgg9nFaE5fttfsAN3AGyG5oI/QDAcwK5w3HJN4ULpf91kp/eCq7Obx3VmdaC8FxnR
         o/9XVuydKk8qvgbjtMoSO/CXjZOKZr+h3xro8Epr8VNdRqTaEt+AbmKm2UH42GaoBQB+
         x8yPY4QSjCyVz7FpSKbEWP2RPhUmVVKhvmlh1CHj7uafJEJOv4BBReFf5WNB+UfgOzVk
         CA0tn2o+26h/1Ap/yy5rXVuLcd2cvec+G0X+fI5jUq90nOX88g69/lhesAeOuoGyjpuT
         YR3g==
X-Forwarded-Encrypted: i=1; AJvYcCWWwa4yUTvCE1jVXQ1wMY1qRvey24aZxw6g5ruiGRsy6zzhZiUK5eO6gKyZKL9rDmCnIDJl5Dlm@lists.linux.dev
X-Gm-Message-State: AOJu0YyasgGIp/tVbGmaU4txzNaSR0azukNAm7TOKTk40u3R5sXtEH33
	k9RBN/cdTPuaEoeuFnGtOfr8wM8A6HXHSKHidbgUdUiGzxuph9pQ7ghNTZrMbx02aVTttUYn+QQ
	oqMougwZs8XNLLj2/B2+Wopsj0hrsMec=
X-Gm-Gg: ATEYQzzRFugwaNRp7B74NKY5F2sRiZyiIR5FZso5pTDbvNrpkCzUeLK176g14PwRNgZ
	27HNUiRQs471zOZDrkGRh6dBpaIFF9s8dxcoNTB8d+BCbXjVbT0svlFwLS366/7dzAa+sPLI2Zt
	e5UL4kW6PnZJCgeBmo0DTMmMMSxQb5au9qb97+Ncw5s6muD1/QSRZJwIsDqDbDsYJyCgWZ0GldV
	E8l1N4UaPayo4/W99IXW5B+I3Jj31CInNu+EzR4ZGCKmX07S3fCKbIV7C+rkFf/Sl1zWvVF3nhk
	/tSXcyk=
X-Received: by 2002:a05:690c:298:b0:798:3be8:b724 with SMTP id
 00721157ae682-7983be8c0bdmr55059167b3.65.1771881564464; Mon, 23 Feb 2026
 13:19:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260219210312.3468980-1-safinaskar@gmail.com>
 <20260219210312.3468980-3-safinaskar@gmail.com> <e67898f6-4e33-428b-8498-b8b28f817bd9@landley.net>
In-Reply-To: <e67898f6-4e33-428b-8498-b8b28f817bd9@landley.net>
From: Askar Safin <safinaskar@gmail.com>
Date: Tue, 24 Feb 2026 00:18:48 +0300
X-Gm-Features: AaiRm50sLaC9UJuN7QdRgNE3QNOZiS7DWDKIfXjMKeU4af4U1Sw57WjY7CysLU8
Message-ID: <CAPnZJGDDFrOObdxa70nSS0bqXQ0zqRPnKWLRFUBCj-FtnkpPtg@mail.gmail.com>
Subject: Re: [PATCH 2/2] init: ensure that /dev/null is (nearly) always
 available in initramfs
To: Rob Landley <rob@landley.net>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, initramfs@vger.kernel.org, 
	David Disseldorp <ddiss@suse.de>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 4:15=E2=80=AFAM Rob Landley <rob@landley.net> wrote=
:
> Are you saying it's reoccurred, or that you plan to run a 5 year old
> userspace with a current kernel?

I was not aware about this. Okay, I agree that /dev/null is not needed.

> (Although I can't say I've regression tested an init task statically
> linked against bionic launching itself in an empty chroot recently
> either.

I tested current Android NDK LTS. I found that if stdin/stdout/stderr
already opened, then bionic binary will not crash if /dev/null is absent.
It will not crash even if PID is not 1 (so chroot should work).
But I didn't test what happens if stdin/stdout/stderr are closed.
So, assuming you already somehow got /dev/console, then
/dev/null is not needed.

According to code, bionic binary should work even if stdin/stdout/stderr ar=
e
closed, assuming that PID is 1.

--
Askar Safin
