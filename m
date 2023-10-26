Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA41FBE1
	for <patches@lists.linux.dev>; Thu, 26 Oct 2023 05:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k8c1gZt1"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-41cd566d8dfso204861cf.0
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 22:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698298521; x=1698903321; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6SNwqL9uBNOocRtfcI4WCu7LgRyHeUqmggRpLJrTQbA=;
        b=k8c1gZt1BY3k8TdCS5I0OGoonOmQ9IcNEkU1AvkLIHCTDtWVXwQdKNTXRqGmAo4QSl
         kiURos2sH/x6tlkwh93OFBclzctxb/Lq6HBAXdlSQBiFiMaQRxNO/TnEw7MQPH8hyZKi
         Lin0B8nDP/jSG7xK0BD/vK49Uc85aMileSiLZKea2hVy9q765Q5FhgPztOO2kmb3ZZ9p
         UFiwTeG31rd2iimhKL4fJ2LuWOOeBWY8aE7LKSYxahuX9yPiDU5KNvkyQrBhTLxzFLbz
         j4snRXp2N4KstsbIldbR8a7zTK0c8i/OmsPXxsuev0Bo/st/TigBhYuGKJDWFkrDkPBZ
         PWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698298521; x=1698903321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6SNwqL9uBNOocRtfcI4WCu7LgRyHeUqmggRpLJrTQbA=;
        b=p+ghfYxwHD7mEL46t43Tri96S0bQJrTqERGSzv+NGiBkwmdM4nkTWZHwLqOH/vPEZd
         EiK+hVv1oQAq5mGgc4yIycYPo8sgu5T3a0A+DqyG9QZOKG1DHRQx+tu07OH9tS2ko0Pz
         KH8sA0bZIXLHwiIFktT+XwagMrdK4idlYnmpHc/oFPA4B9fEtJwq4vV6ye+6LTyUJC1W
         JHzkI4dfkVTPFw/mxs1uXbXNCC30sX87mVNhlt7/XYNhIdSqs8InK0px3Qh7eajwEXei
         KCDmXduYE2yC8sCMAI3OsFPKKNVyWRL+Rsk30B0gcdv8uiqZeRM0KBr/ipPo6t2khpLK
         6hPw==
X-Gm-Message-State: AOJu0YzEZMnrfZ1kcWHOot2YzSm8dG10eJqEpWzIFEFhRAe1H4Me+iTD
	uWXpRpTunnLfHBnMeX9gE++Rm4hnpvLUNEL+51JG0g==
X-Google-Smtp-Source: AGHT+IFjQWw9/rfKoFj/9Kj2dJrdIzzaC4vNi4Vi5GlKzW6tfRkrBDWGUlCY8d/IiEyXwhxSyfM16sU50tKw7OiUALw=
X-Received: by 2002:ac8:7cbc:0:b0:410:9d31:68cd with SMTP id
 z28-20020ac87cbc000000b004109d3168cdmr386865qtv.27.1698298520922; Wed, 25 Oct
 2023 22:35:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231026015728.1601280-1-jsperbeck@google.com> <2023102618-tributary-knapsack-8d8a@gregkh>
In-Reply-To: <2023102618-tributary-knapsack-8d8a@gregkh>
From: John Sperbeck <jsperbeck@google.com>
Date: Wed, 25 Oct 2023 22:35:08 -0700
Message-ID: <CAFNjLiWtmsticUCB+_D_MMqXCtH=RGr4f1avNYhtk+_CVGgsDg@mail.gmail.com>
Subject: Re: [PATCH] objtool/x86: add missing embedded_insn check
To: Greg KH <gregkh@linuxfoundation.org>
Cc: bp@alien8.de, jpoimboe@kernel.org, patches@lists.linux.dev, 
	peterz@infradead.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 25, 2023 at 10:17=E2=80=AFPM Greg KH <gregkh@linuxfoundation.or=
g> wrote:
>
> On Thu, Oct 26, 2023 at 01:57:28AM +0000, John Sperbeck wrote:
> > When dbf460087755 ("objtool/x86: Fixup frame-pointer vs rethunk")
> > was backported to some stable branches, the check for dest->embedded_in=
sn
> > in is_special_call() was missed.  Add it back in.
> >
> > Signed-off-by: John Sperbeck <jsperbeck@google.com>
> > ---
> >
> >
> > I think 6.1.y, 5.15.y, and 5.10.y are the LTS branches missing the
> > bit of code that this patch re-adds.
>
> Did you test this and find it solved anything for you?  Your changelog
> is pretty sparse :(
>
> thanks,
>
> greg k-h

I wasn't sure what to write for the comment.  The original backported
commit said that it prevented this objtool warning:

    vmlinux.o: warning: objtool: srso_untrain_ret+0xd: call without
frame pointer save/setup

But because of the missing piece, the warning still appears.  That is,
the backport had no effect at all.

With this patch, the message really is gone in my builds.  Shall I
resend my patch with an updated comment?

I also wasn't sure whether a Fixes annotation was appropriate, and
which commit to reference, if so.
