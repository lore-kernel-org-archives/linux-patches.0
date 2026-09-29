Received: from mail-dy2-f12.google.com (mail-dy2-f12.google.com [74.125.229.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88743DDDAC
	for <patches@lists.linux.dev>; Tue, 29 Sep 2026 05:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790658842; cv=pass; b=s2U1IRUIP33xIjS++R0Ex5AArFWXuE3iP/6bY+M4r5JjlkvtmjLQDCdWFh82uDA8/fx/fVbCIBUNZYr6j5abxbVN08aVUusy0NuMl86rOdelLb/i6pNDr/IdwyxHxgz0OQUqUTnUtNYTtBH/4ofppMCKhEyZ/rUybAj/gO86LPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790658842; c=relaxed/simple;
	bh=nt1iDr2ETez6hUNqs0WgZtwZnWmFB0cRIaZZaRitIY0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WQwXq0XEGbJu+VsMJn5PQafgqm9iXlQnwCoCYslo6uID6hPEwChJ2fiE9Rid5QFBJqCrgKWY1Lfq72OyFAGMFYWjEyHm4vDT/m81FgBRo8fDbXSrKIee8UcWEnEVBJGSExjpKX8QH53kgucCEj+Al2wq6V84KJYLO3BxlX5LnTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CbbKucKL; arc=pass smtp.client-ip=74.125.229.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CbbKucKL"
Received: by mail-dy2-f12.google.com with SMTP id 5a478bee46e88-33bc6ff6cadso503754eec.0
        for <patches@lists.linux.dev>; Mon, 28 Sep 2026 22:14:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790658840; cv=none;
        d=google.com; s=arc-20260327;
        b=lTP23Rsz78ZmrCwJJCUwFovKPfGt80wyRU3UYIC7JNNWjf9N9Qa10xxzDvuLFW9XIf
         qc5OzTXvRzKodUIEiomMU0t1W2C+gJgwgFt4/IifHTslIGUrb7t2CyDtif59v+T7XKkQ
         C9apAwleQ+GC3f4ufS9oyZiAjbnydCOTzFowPh6c0ytouXf95T5BcptYKMnt68Wbr+Qu
         Rvw5JdWxGJ8BTXfNZgkar4gbNCobqzQzNMkrgZ46NT19BzxD+tMUOA4vaCOWj+pg3JOB
         NhvVGbwRX6cp0NJyi9/tl4OV2Txm/1x0ovSVeQyMWuIiOYGCdaF85yquboPGadrMcGZK
         QtoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EAEfNr5sJR9Z3DQLQ0Wzy87dnyw+ZdWq7blTmjddLn4=;
        fh=gZUTiNoOUxtxgsmRJY6GG2tFIFVv1rDBowIPYWszbx8=;
        b=hYi7IaZGB1SZvPwQFw41u+lKqYCX4OE3K6E937RMapqtWnHGxMJ5nOCwSbm3BXUXsR
         EAaUt7aBwHUW6NJahWEAzaFrH0mxGaiqi+tAgiYwNptMMqadHIjxIF8qeOwm9pGqG3Dn
         XP4wqWF3pupAP7G0u5wUwRKuAicKTk1X05dwl8/Hl/VV8MGtjviXu0oZUyAEPRV/9lDg
         vOf2Dg0N0hSCNnWkerxX6QbNHCZb6KnxCbF0Nj45J16iFQpGohFDQHEMRgJ98FwFvB8G
         1pPodt+tXoox+izs5XU5Pz/BkPBVSIFviS4p3rLQBsA7dY+3FTs9yYbcQw8PEQqXuAQ8
         0mQg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790658840; x=1791263640; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EAEfNr5sJR9Z3DQLQ0Wzy87dnyw+ZdWq7blTmjddLn4=;
        b=CbbKucKLqEQLNsuUglTLZEit8iMIWk8ulZDrM1S1s043qdGurUe6xXin9uPH9XACxG
         6ON2edzAOzBqU7L823J0ppLAMB95sL14KhuwbNoRDf3v7h2zAZzNJsy9Z7JiBRTEgSJ8
         H51y/HKTXIB6KP5zWs9fhCfPbogvvng9zwtP6pxBDFFH3FqcTkwLXm3YR4f15eXOXyyP
         N+Xu1H5aKe6+m6Zwe+T0ldby0O3XqAYoU18yDZ/nxuJxjcvw1/w8LSXbSMHfQWXIp7KA
         77C2UTk1E3/ftFBIdYmATacaglGRvkNw7Vlemow7HjJjne/I2fID28sdkV6LPsDiXhjP
         iXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790658840; x=1791263640;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EAEfNr5sJR9Z3DQLQ0Wzy87dnyw+ZdWq7blTmjddLn4=;
        b=2VEY/33Lwb7RCXuY23n2OMBX9G1l0GBEFxm6VWa4L8fcTgotpRGmCZia4zCStw86MR
         4oUoKpoI9ICwsQdPnuXuJrglMXsStaXO7ZMY/yC9QrnW4QMRAh/5oZZ2eSa3mTBP9cvR
         7HQ5t6fVFNjp12OIRxntxJa5eaFm996+3eP+ganJcFDmDjv/7V+RjqkzInd14aekJxHs
         kHFxEwJjQA2zuhkiCzaHaAP1+vMNhh8/33xabDtviNoMn0lwIB4uUf2sxXNWXPll03Sa
         GcAizj5hdFirfdmYVtXcgh51snpzsHoEMg6w5Et6JxOmfTspPtWox9vrOKLb6T58cYw5
         J8gg==
X-Forwarded-Encrypted: i=1; AKwUvBzte0xh3Zrea2xvIP4kSY6d5fp3DjMtdQ5hw8gmF4+qZ/yyK6oibEwLJuzmR5VcXBJtVxlliYTk@lists.linux.dev
X-Gm-Message-State: AFq9FYI47NUrrxss6gHJBwnFqd32MOKLxILHdie41gPa6hh8hWUQTaSF
	YKUnvTjDu3UDcEijVEeRUypBnO7iYbjfYV6LCiTOQrcTcSP3uYi6fw/HuKMXbX4jyn91agoMalc
	XcSgQMIFl2XLkJpQ46SJP5ceGgfWG8w0=
X-Gm-Gg: AYBFou30ev90j3MKQMk2+HueikVaVR47TeE7E29LY4SDvzgyHV7MxUJb0nXZOetVBds
	YAr8eSjSuRfh+Te6wu5jbiFoAPNm8Seqxto0WEo47rkdH9WhJhosVCLnmbVY0GyiTdyX5x+8wp6
	MovmjJoAPCQ388HS8PIcqMIFdUruwpmDPQW0OyVhKvxVTzg/HSJPMEwkv3dCoPl7sD0UoMfHf2H
	6PGETFHf5QoR63TBtqFIPVQxITDENDVM1joq/TfFCHNTj3QJ6RC3tyOAFKK9hlDLgy+zBA7Puom
	6Up8S5Owjwah1DczKUrlbAlfXeeaR1L1VGOCQMumz4K81iAk1k81kXM29PSH7HQ+XAgupbaUV+7
	+DoyPuMVz6UGk/BhXdifSCjGoMHm7LuYEW1AFjSz0mt414wGX8ifd13ADYYLtaF/GBBenxSGepd
	yAyomaiK5oJFK8hAdptfXcloRSKU6KLPCq0M/nWpMy5SplZhy8KVc=
X-Received: by 2002:a05:693c:65d6:b0:33e:8552:6e06 with SMTP id
 5a478bee46e88-3426cfdd194mr20205871eec.0.1790658839924; Mon, 28 Sep 2026
 22:13:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260928102547.201475-1-ojeda@kernel.org> <20260928105443.205758-1-ojeda@kernel.org>
 <SEWP216MB9770115E94C3B65C35C3692830F98C2@SEWP216MB977011.KORP216.PROD.OUTLOOK.COM>
In-Reply-To: <SEWP216MB9770115E94C3B65C35C3692830F98C2@SEWP216MB977011.KORP216.PROD.OUTLOOK.COM>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 29 Sep 2026 07:13:46 +0200
X-Gm-Features: AclHuK8zhqw4hzXAxQU-LgN3hhSsxqTyet2X0hWMvxsfudBQiH4fkjXMyED0XbU
Message-ID: <CANiq72n6RwJeBo8_fKn5g7LH+kzhuGcTt1Hv3jOE2m5mjLqGVw@mail.gmail.com>
Subject: Re: [PATCH 6.18 210/398] rust: net: phy: fix off-by-one bit positions
 in device status accessors
To: "springbreeze@stu.pku.edu.cn" <springbreeze@stu.pku.edu.cn>
Cc: Miguel Ojeda <ojeda@kernel.org>, 
	"fujita.tomonori@gmail.com" <fujita.tomonori@gmail.com>, 
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "kuba@kernel.org" <kuba@kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 5:17=E2=80=AFAM springbreeze@stu.pku.edu.cn
<springbreeze@stu.pku.edu.cn> wrote:
>
> Yes, that is exactly what I meant -- thanks a lot for taking care of it.
> I re-checked the series against v6.18 and it is correct:
>
>     1d17bf1ae87d (6.18.y today)  ->  bf6272d87a7b (1/2, back to v6.18)
>                                  ->  5963dbbd54af (2/2, offsets 15/14/16)
>
> That matches the backport I had prepared locally, so:
>
> Acked-by: Chunfeng Song <springbreeze@stu.pku.edu.cn>

Let me reply with your tag in the patches to make sure it is not missed.

> Please keep yourself as the author of 2/2, and of course I am fine with
> your SoB -- the upstream Signed-off-by is enough for me.

Thanks a lot for double-checking it!

> One nit, feel free to ignore: 2/2 still carries the upstream paragraph
> starting "Use the bindgen-generated raw accessors ..." and the Cc: stable
> scope line, neither of which matches the diff anymore.  Your bracketed
> note already explains it, but dropping those two bits may read better.

Yeah, I am not sure what the stable team prefers. Normally, I either
do the square bracket thing (to try to keep the commit "as is") or I
send a completely new one explaining the difference. I was on the
fence about this one, because the original commit had quite a bit of
context that seemed bad to lose, but it is true that of course it
doesn't match the contents.

Cheers,
Miguel
