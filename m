Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786F83EEAD6
	for <patches@lists.linux.dev>; Wed, 20 May 2026 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296344; cv=none; b=gHxzOfgtua6kRAjnLd2qt5PSKTGM6Uhlt2eHmZj9LL5KgBbjb7bK1cTYFeH4T64q1W0xeV7CKOeU/pu6KfBQd0j/GfC9lPVq21huu19dNOp5HGMtnmg6fKMoarNoXmaHHEvNibzopEhHxROnvt51QGSCaISjVvYNI6lFv4V7h4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296344; c=relaxed/simple;
	bh=/N3cAkuhC0sFY5XN2iqTKl/9FqFNKW3EYh10C+xNj38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Eab5/ksH9LmucBZZYJ7mBawaduJGh7+V0Bp5PJHVwrjJ9oM45dj5fjgQ2NSZpyltkz9Uo5Y89wrvMypAN0QA3wuMvFIm6xLNiXGyDySMS1d9hnQ6aqdThKvYAn9HP5nEXFUIiB8avEqtZQZURUtRR3IL7Y/jydGNXGYC+ftHPNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G6fql5nc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G6fql5nc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779296341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vh5MuTZX0xtaFylPc5morN8QD2kp7GolTmmF27Hc4YM=;
	b=G6fql5ncEi8CQTXa3NiAMIps5gQsF5I+OnUfW2E3G9uO2q2gWsP5r7K27X8JFV74oUEPwy
	Sc+XqGdxVALXzi9Wmw1+eE1aRie/SSN9DWwVZRYht1tgPRWtZAVytN/cuLHfzfZK1c/w9V
	VrD49icICR0nC6DdQc/5XCnfZ/BjJIo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-ENLUWMk7OjeqnmFcDkpH7Q-1; Wed, 20 May 2026 12:58:58 -0400
X-MC-Unique: ENLUWMk7OjeqnmFcDkpH7Q-1
X-Mimecast-MFC-AGG-ID: ENLUWMk7OjeqnmFcDkpH7Q_1779296338
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-bd52e681e03so391409666b.1
        for <patches@lists.linux.dev>; Wed, 20 May 2026 09:58:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779296337; x=1779901137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vh5MuTZX0xtaFylPc5morN8QD2kp7GolTmmF27Hc4YM=;
        b=UOawGVexhQ6SkFWFpmx34yzaVKQlaVTPrRJoyryivpjvH1zrjvtIHULJcrP8RA8o77
         dMb1REkufYEiCiMt/vWjMwli2YDVAfgDCjCljFP8ubHdYicmievurjPikdejvxP27Gqr
         XvUWiIFGu9zAbt+jhiJePJ7HZbQTX3teHB1/LHXG1PkPuFFTIE8LIrhCbhXg+ltFDLyd
         94sd4eIEEfjBreqUHoIwK0mWTK6cX9OejWZ4gJkFzPTQDrbXQY7lM6t4Qi/wGygLwPhL
         N+35NzZpXDt6/5BCPxBpx0RW8Il8y4WATA3tpViARHKmh0dLwV3ZEvat+TlGnlp9Y4aU
         7Dlg==
X-Forwarded-Encrypted: i=1; AFNElJ8WHP/1VdeFK/rrVkfWaPF7s/h/1wfbbgXi8unw4c/meJJR9M6+nrz6QrqxToo9irVqemJK5+Sa@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/gx/YJnAizyZEd2wrlVNwcP89s4Whn6S380hXxH/RBAACp0+g
	OEng4fGIDVpxCXU35a5atNefTYbsxdwj93jtZZjvp4p5Y2y/OtjsAIJmVy/SIie825OYD80xm66
	kqweVqtIjo0dPVidumQciLd87ehIMo4/Nqje1RFBftBTQANeB3BJ0ggUMU5MmVFtf9MqSAnlsw1
	JXYv7jstUQLqPrN8HZC8KrPcZX+qCn0OWJDA==
X-Gm-Gg: Acq92OENsk3UQng0wCELM+Az4SFU/8f+9qJASCDS9H1sjZ3lsKjE1XYqFax0YJg+0sK
	ZoIsr3nkpgiYCenle2L76z8mELDBskuVE1rUQ0ES6GTVHMCRhZ9omww67QX0eyruocE87Eusrc/
	EI2KM53JZ4kQZy4XRza+yZhsjAbgF1FzVT3/qmV+flYANNt8lxRZy8TCrJ+biQSXrjp+0s8GFtL
	XtVuELvAUZoMOBPQGyMCLdqMkr6RgvtgVMR
X-Received: by 2002:a17:907:3944:b0:bd5:378:10fe with SMTP id a640c23a62f3a-bd517812d87mr1332170666b.11.1779296337555;
        Wed, 20 May 2026 09:58:57 -0700 (PDT)
X-Received: by 2002:a17:907:3944:b0:bd5:378:10fe with SMTP id
 a640c23a62f3a-bd517812d87mr1332168966b.11.1779296337030; Wed, 20 May 2026
 09:58:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260520162148.390695140@linuxfoundation.org> <20260520162158.452078806@linuxfoundation.org>
In-Reply-To: <20260520162158.452078806@linuxfoundation.org>
From: Tomas Glozar <tglozar@redhat.com>
Date: Wed, 20 May 2026 18:58:45 +0200
X-Gm-Features: AVHnY4JCWoPDByH1h3FbnlWBk7V9B6-mKZPQDTnnXQWu1iJwRKQxiMdn29nqVMI
Message-ID: <CAP4=nvTUdVQN8j_qJnfytGOJMa4LaX2h3Z9-cmDopBhKE87_nA@mail.gmail.com>
Subject: Re: [PATCH 7.0 0453/1146] rtla: Use str_has_prefix() for prefix checks
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Wander Lairson Costa <wander@redhat.com>, Sasha Levin <sashal@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EEav294mFLWZoFZ2Ub_A-jU_IRlTMjboscPxtiou290_1779296338
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

st 20. 5. 2026 v 18:45 odes=C3=ADlatel Greg Kroah-Hartman
<gregkh@linuxfoundation.org> napsal:
>
> 7.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Wander Lairson Costa <wander@redhat.com>
>
> [ Upstream commit 265905df83a4c1e78c1a912e1699d7c81d9540e6 ]
>
> The code currently uses strncmp() combined with strlen() to check if a
> string starts with a specific prefix. This pattern is verbose and prone
> to errors if the length does not match the prefix string.
>
> Replace this pattern with the str_has_prefix() helper function in both
> trace.c and utils.c. This improves code readability and safety by
> handling the prefix length calculation automatically.
>

This commit breaks rtla build as there is no str_has_prefix() in rtla
in 7.0-stable. It was introduced upstream in commit 0f4bc9d67a6
("rtla: Add str_has_prefix() helper function") which is not in stable,
see [1] - same error can now be reproduced also on
linux-stable-rc/queue/7.0. Please drop this commit and also the
dependency that pulled it in, commit 4bf4ef5292b9 ("rtla/trace: Fix
write loop in trace_event_save_hist()"), which does not apply without
this.

Not sure what the policy is about 56317dd01bd6 ("rtla: Simplify code
by caching string lengths"), that's another "Stable-dep-of"
referencing 4bf4ef5292b9. It doesn't break anything but was only
pulled as a dependency of what will now be dropped.

[1] https://lore.kernel.org/stable/CAP4=3DnvTootCBXa1VxJLGACVtVNuY_RiiAWVOr=
h+jED=3D4OD0SSA@mail.gmail.com/

> In addition, remove the unused retval variable from
> trace_event_save_hist() in trace.c to clean up the function and
> silence potential compiler warnings.
>
> Signed-off-by: Wander Lairson Costa <wander@redhat.com>
> Link: https://lore.kernel.org/r/20260309195040.1019085-12-wander@redhat.c=
om
> Signed-off-by: Tomas Glozar <tglozar@redhat.com>
> Stable-dep-of: 4bf4ef5292b9 ("rtla/trace: Fix write loop in trace_event_s=
ave_hist()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/tracing/rtla/src/trace.c | 5 ++---
>  tools/tracing/rtla/src/utils.c | 3 +--
>  2 files changed, 3 insertions(+), 5 deletions(-)
>

Thanks,
Tomas

