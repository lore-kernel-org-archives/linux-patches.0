Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB646383991
	for <patches@lists.linux.dev>; Thu, 21 May 2026 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779386386; cv=pass; b=t2xidCyIWcMZxSrKtjXBOdQJphgBKp7nfpMXhJZpHiKpinCqd0P18XmI81PJDWZFuqBg6DP8NxDyBxlcLqH6hRzoROYnswN/MUSGQsp0AQ6Mdox32o8m434AxEi2s/4PKnTlxvhxESrAT4mPGWRwIkZ/chjFF5Xx5UE1cLF9rHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779386386; c=relaxed/simple;
	bh=2XlcrqYwh/tcTuBrkPI/x13X9seNIkqUvfrzLePc1OM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e7qBVyPqlQ/ViPWTApT/AWzlfQir5fggoDiS28PNT543OCwpKcqWhUQZX8fVJAnh1ak23ruLhT+mcgON4uJsxCQ8fAhILBnDgZVEmiXRQLO5T1h5fF0Xmk6NczIPNe3+yElhlFylT9Cznkjj1XcpLOWexsgesFYfgJ8hV8X7EFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f6tdCkJX; arc=pass smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f6tdCkJX"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1353c2f35cfso19028840c88.1
        for <patches@lists.linux.dev>; Thu, 21 May 2026 10:59:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779386381; cv=none;
        d=google.com; s=arc-20240605;
        b=NrlcvUbqqHjQPSqlBdDyzPLgfE3k8lFpXL9IF6dcB9iVoLwvv8Xp1637YeNX6Tx9aa
         Yj25Z6w7GdzKImUkab4W+afXjrdutibzHHcAbWct3kqypY5qfHKOc/e+Vy7S0yklORPO
         s7LLlEGDadgQVNHMymCFIQsQuJt/0LbZI8f2Fxe3nkO5sPA+n1TyDYJ/ZCmXt/2KSlUK
         A3+7zrfy0RjuEsaQs04pcC0cpTdjKJUmLWy/uURhtpKcOX8bLRWmGShOA43HKGuI7Taa
         XDKBPwVGjj59/qxk5bjEZoN+3hcIdeCMNkDyL6ZF+ha3pVx8aOTpDynSKs1n99PCfosm
         nqaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2XlcrqYwh/tcTuBrkPI/x13X9seNIkqUvfrzLePc1OM=;
        fh=AvuqWswDfoblBZ5clFuUOJfjdfZ2ueQ1ndUHKT5jHD8=;
        b=OhQuJqQYro9WTl1Mt1fk/NnqPCw9+bqvUitjI+u+QIUF7Oy5HrIJKUoJhiyGHS2TLZ
         Hk4QxAk1DaxuqeYpPJ8qSto8AUqmbyBvdg+2D0t01AprS20At58/94aSwTReB7wLmmDs
         B9lR2L9GemnLhOUa4i4dngvtwmyyYH9da+Bw66VL+320njFksidWI2IjiwsknXjxoz8d
         JdbdVBN3uuLv3RyqhsFTwG+AkTcNiO0ZOEeY/6eKICa7UEAI5VFCeGp4RXI0+XZgsZ5j
         tR/xM7vcVldN4/zjokvCOtxU3ERZvIFWgBPE/kv/9NOQE848EjnTcCkVqazQjp5IsXwz
         zqsw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779386381; x=1779991181; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2XlcrqYwh/tcTuBrkPI/x13X9seNIkqUvfrzLePc1OM=;
        b=f6tdCkJXyTEitaaB5gyJkSL+PML4QYLCo6ETvps0yvLpR/P1GweJDZz/mcjQ5CZkbW
         dEHuyrjJvlMq2s9XQpcWjGvrVRNu/UD8/FTaMgxfkvd/3467uLRb+4mYUO77SQap4yEI
         KG4ktfhlyyK1+XwIzyPeRFOiu6bz1+6ugLdUZQhOBi4fY4G4dzZkWkNRKja+oPpARrjS
         7aiOmdhNwrnaoAnTUHKreACDmMZSMFnWdqdNm5jwPEJ8aZ8/Nwu5WBPoUKDSmlRWdu67
         LhZlU6wqGxhZ7KB6K8TgU+CSXtGJ6MyvuVPIwtt7yJmPHPQXNlIuU95Ij/+Fs7gf+hNL
         f8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779386381; x=1779991181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2XlcrqYwh/tcTuBrkPI/x13X9seNIkqUvfrzLePc1OM=;
        b=B4fPXSa8G4wGqwFCyFVqlVA/hOW+y9/wtCHejkRMSCndLS2F/snGkrc895eEXeKX18
         gDAeecDzZH14P6MJGc32VFfWk++gVL5x/Ecg47LjkJ0gOW9F4OfrTVLNvvbf3/aIUgls
         g0LfwSf9j8Ya6UdoGSLIRF/xdE5JaU1ElwokQ02WSqphmbKOwZz7LOcCnWw7JGkqhJ9I
         XNY5FkhFgwnLzows73EIX0g5oZG/J04p09pSNde8665JllLTKMPUx3CA1U88UKCCucVE
         Qr6cTacGEop6EfHPLEuMb8J5XRXVMLAGBoYl9OomFtHZQtiGYXwOzYZxWbSjpU9YRt9q
         JSCQ==
X-Forwarded-Encrypted: i=1; AFNElJ8VtBbfHGuyaQ/gZvbVbukNB211+z5KRmKGezko4kN6s0nd34eEfqMrav5h5nSxrUdl55Cft24T@lists.linux.dev
X-Gm-Message-State: AOJu0YyecxKVbF1KCLqLviB8eKy68k7tQqb89B8VAD+LM7CAX/gymnvl
	avbPu69eR2BsJ/vMcykj7+eUUjN+eE1g3tCRPO/ORTWBfTeLSiDMKlXFul2Cc6rSOYKJJie1NGz
	5OUGxfjxLDSxlB18j9tFub5l+w2rzEH6N0J7gjeQ=
X-Gm-Gg: Acq92OHJ6QNbcna9bx5XjsUu2n1k7tcCrnMjugt0q5zolPOzrzxHTwOFs5xWWbjm+6M
	yaAWwzB8NhSbXD5vF+pqOe0u38cLiebO93EypFVLGqY2i4JJnRDaK7tDE0XgyV3Q9kSN/UoDj1k
	gI/wYPWEyAnDfLosIjHV3ie80PfZI++jO7DQ5Qps/VG73iDMmduftf2+lcayI/XC8LcZjPH6Y52
	NOeh661oACyuSL8HYrzFHjD8GbnGyZoOLZApj4MG/pADCicclO5JX/ACDn16cDTQy0LGy+Ss32k
	ALC0cMeJhD1PIkSymGtERd2Po44ftq1xpnel8SlqQfIQnBcfiNHxOqZ9d7/mbBRD2CdnYdZa7Wr
	5Yy81mCvCgyfTBOE1Kg0xJ1qrUXWxlA5SLfUTYjacz20qxQ==
X-Received: by 2002:a05:7022:f908:b0:12c:6da8:856d with SMTP id
 a92af1059eb24-1365fb53575mr16057c88.26.1779386380625; Thu, 21 May 2026
 10:59:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260520162134.554764788@linuxfoundation.org> <20260520162135.687777470@linuxfoundation.org>
 <CANDhNCpZWMk6GWubK8+E0rxKUqtuhOtrjqxunS=Kmho-UbR0UA@mail.gmail.com> <20260521-sched-proxy-6.18-drop-sashal@kernel.org>
In-Reply-To: <20260521-sched-proxy-6.18-drop-sashal@kernel.org>
From: John Stultz <jstultz@google.com>
Date: Thu, 21 May 2026 10:59:28 -0700
X-Gm-Features: AVHnY4L2di6RLsg6hTSyZtoiuJUxzmHc2ryKHNDbKyp5-1JHqVFZiuqAbMqAzb8
Message-ID: <CANDhNCo2qx4fHB6sKUyYLjBDuWpL_i_6b_6odg5_q5rjn9m-rw@mail.gmail.com>
Subject: Re: [PATCH 6.18 052/957] sched: Make class_schedulers avoid pushing
 current, and get rid of proxy_tag_curr()
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2026 at 5:56=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
> On Wed, May 20, 2026 at 11:32:26AM -0700, John Stultz wrote:
> > Eh, I'm not sure of the urgency of this going back to 6.18-stable, and
> > I'm not sure its worth the churn.
> > [...]
> > So I'm just not sure this is worth the churn/risk.
>
> Dropped from the 6.18 queue.
>
> Note we have it queued for 7.0 as well; since your note here only
> named 6.18 I'm leaving 7.0 alone for now -- shout if you'd like that
> dropped too.

I'm ambivalent there. I think it is fine for 7.0 and that has a
shorter lifetime, so the risk is bounded better.

thanks
-john
