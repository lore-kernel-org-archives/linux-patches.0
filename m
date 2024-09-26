Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906751AD3EF
	for <patches@lists.linux.dev>; Thu, 26 Sep 2024 10:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727346932; cv=none; b=Aup5Gbv8H6MFbe9exj5jGzZsjaMOOPjyilbZrA1OctcfT/UJlqv6Q72GA4Jimt0qhKM2E9tKXFr+qXK3vX/o7e4KpCgvN/f/uBoDP7WWHNtk0GjGcm60fOeLgCe34bPnCt8hPVlEPafeuI7yhmIyJEueUbzMd9zNAY3FKBBerZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727346932; c=relaxed/simple;
	bh=DQRtPPfHDTPkf+uykLyxQkqqMXbOre+Rf1fHvFHNX+s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kj3xOdbYs64YhSTPOzQGQIwZri0181wcCLB1ByuuRPPLd6UPAFr4+HpwS9+mepTHNtToMCvXwHaNo2t1xRzVo+zYuwdMQypGzOqYgcfs8qntgMZlxEg3qDYYtfOoeoQMSlO2PeV0pjFSR/yjpY3f7ZTUUZbCFsUf0K9iH8TkaNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WMB89pNN; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WMB89pNN"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-374c180d123so489562f8f.3
        for <patches@lists.linux.dev>; Thu, 26 Sep 2024 03:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727346929; x=1727951729; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQRtPPfHDTPkf+uykLyxQkqqMXbOre+Rf1fHvFHNX+s=;
        b=WMB89pNNXYHYMxS3upcxJVLuJ9wF+ZpTX3YNKsUJKqVk/Svg0XvAr1j2zjbhsolQrL
         ySLjjPKaCGWakuyBv0BUZJbHCpBx2HOF7elhYlcE7wUuZh+ElAB/oa/TLRS9G5BSJhhq
         LqDGqO335pKp8/KykXuDQTG4lHYcZGuGwNgR0RRYOIrgWcyuF95YO5DpvpLhRgIWNbdR
         SMmZHQ7krb4mEkFRXdNW07J5nX1zQ9PYqoL5WSJ9W2SIgTK74POVfggBK39hLLm59NuL
         KATxLRIornu0rZWWbUEeYdWiDFwNPpdqqAJFoA1o6xBxyP/FoMz/WmLV1r8ootIr9/WX
         UwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727346929; x=1727951729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DQRtPPfHDTPkf+uykLyxQkqqMXbOre+Rf1fHvFHNX+s=;
        b=ubfYMKSgoiNZMOK2kvIaLDGdfqBB3pYFKleq7ugEEUZ5FGv3LXz9CVrZ9g2yIQ+Wi8
         8s3XPCb4obkWRDaZ+WRMK72MRO77k88pwx+DdR3NZcvqJD2Bfm3EZLtT6B8XMTwtoL13
         Vpsd4RwTm2d7HBKuatMX17l06YdLDIwgfWNt4m90tbAfxd4NnUNJ5yBuZRNzTdcvNjvq
         oSOK1t1X4eykC8Uihg78hyKgC7lrQPMrwXFzX85ZbrOPn5WNnCQ1y2Ox1MT9dqYMnUy8
         P6jtLOdiTgfl91jsbOdyvd7wfnvyd7OoF0+78jfKLEvq17xdJIEYr+5exEPe5NlVx7+Q
         qnpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUd5xx2GJQvp4HYRmyLSkZgZftAFVYa3bSQVpUk9g4Bqh3MFexecpKL9ISvUIJn9/+/n9aPhOQL@lists.linux.dev
X-Gm-Message-State: AOJu0YzoGOaAa6a2Q39oMUb83KeKjYBjyr7pmr3MJQMzwctV8ug95ioH
	1i9CjKHBanP+y6ygH0oTLeRq3YrkBFi2GFPMfVQugS+OJBrby9OQuwKBfwVXQqBIFIYgN87msz2
	NCiAWydQVcK8E8hsj958AHxh7XV3rZb28w0qO
X-Google-Smtp-Source: AGHT+IHXXeTT3uinw2wy5kXyeKfp1sqH22V93yXFOXjeGHyt9M0+KGc1cUhIdgFdG+pE67gOlvtDfEIEZCePatr0c9Q=
X-Received: by 2002:a5d:5d86:0:b0:37c:c5ba:b8cd with SMTP id
 ffacd0b85a97d-37cc5bab97emr3227843f8f.41.1727346928397; Thu, 26 Sep 2024
 03:35:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240926093849.1192264-1-aliceryhl@google.com> <CANiq72mGsevNqECufBo6EP8cxFd=vwcXDpVdsgts-Ve0+mPkrg@mail.gmail.com>
In-Reply-To: <CANiq72mGsevNqECufBo6EP8cxFd=vwcXDpVdsgts-Ve0+mPkrg@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 26 Sep 2024 12:35:15 +0200
Message-ID: <CAH5fLgif4X5pwSeky17M3J_9Si1HZtXjLAH7J2e=V36Wm7B7xQ@mail.gmail.com>
Subject: Re: [PATCH] rust: KASAN+RETHUNK requires rustc 1.83.0
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: ojeda@kernel.org, a.hindborg@samsung.com, alex.gaynor@gmail.com, 
	benno.lossin@proton.me, bjorn3_gh@protonmail.com, boqun.feng@gmail.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, gary@garyguo.net, hpa@zytor.com, 
	jpoimboe@kernel.org, linux-kernel@vger.kernel.org, masahiroy@kernel.org, 
	mingo@redhat.com, nathan@kernel.org, nicolas@fjasle.eu, 
	patches@lists.linux.dev, peterz@infradead.org, rust-for-linux@vger.kernel.org, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2024 at 12:34=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Thu, Sep 26, 2024 at 11:39=E2=80=AFAM Alice Ryhl <aliceryhl@google.com=
> wrote:
> >
> > This is caused by the -Zfunction-return=3Dthunk-extern flag in rustc no=
t
> > properly informing LLVM about the mitigation, which means that the KASA=
N
>
> "...not informing LLVM about the mitigation at the module level (it
> does so at the function level only currently, which covers most cases,
> but both are required)" or similar?

That phrasing SGTM.

> > This is being fixed for rustc 1.83.0, so update Kconfig to reject this
> > configuration on older compilers.
>
> Yeah, let's go with 1.83.0 as we said -- we can modify it if needed
> later on. I think the PR is fairly straightforward so it should
> probably land in that version unless there is an unknown unknown.
>
> Thanks Alice, looks good to me.
>
> I will take this one soon.

Thanks!

Alice
