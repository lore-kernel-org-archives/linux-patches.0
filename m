Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795675404;
	b=DdIcmZgd8u9XKi2yPciLh0wRQd7ZcaG+2Ra6LZgx9rcsFizxXdtyswbqLxbVWNhDaX5R
	 eyJsA6SqEuqQPCobVtuM69z3c9oOlQbOzrmfM7WQZZ0zXWY6WiOiFaOM6OoheiPy/k9e+
	 JUIbChqTXVHcj8iUrFS2FaSctQuD1PwYFTpRWGZyavrYKwWYjseUzq6FAB8TyqF4gzN6h
	 fetR/bOGaMoPbNeqleyMF27v8WrzvjfoelP6ThHzPghFIUlq23prCGDAK24p3WZ0sCWBb
	 iUJBsvnXYZTr7rmaE8AKxskBsmKfwU/BbW9qvsb1oNMixGCSQH+1sDGwK2cQUN3vqiQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795675404;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6VuaqvZnXbuCtA6VHala2pXt+UVChb1skPG+1z4T5f4=;
	b=Ul6gVviiiSXLo0Tii621gSXSCt8ttnjv5LR5/Oo4lP7ta70jw1K6iQwCMm8lACfNq6sC
	 t5Bvc3GtX6GW2WtyjNXa9brUDCknZ/pme33Cq1Yk3+F8Yu6W9sibSvpx4EZtkbjgudIpU
	 oJBWqjJgv+sIt5DINZp5gHFzEFXFrzb/Yq9Ly3phZQ3PYpNh0/+AlDWvQTlssIVHYYptC
	 m1lBrj27hFNOr+mFC+q2xtJfGX4Trn8V/+jqEExARam42diKlEKrQTrdy95VE3VpLpHX2
	 gknCZSQK0SgLkUlNWEll78jsfQyTFagipgMzd8MKczuQw0QHRYol5PihBYCl5ZD7ZFA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="U7W/2vnw";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.181
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794DE606A326
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 06:43:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 794DE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U7W/2vnw
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3acd523a802so57547171fa.2
        for <patches@lists.linux.dev>; Wed, 25 Nov 2026 22:43:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795675403; cv=none;
        d=google.com; s=arc-20260327;
        b=kAFDjj7JuEpwGz+5cAh1P5A5SXcmc/lTy7dd1SVv3rtPbJJP/CA1kKWpHtqEkFIrTi
         YP3SBZHmjUYHM4jeds/zJf06c5khikdOC4ETbdMA3rSOaacJYNEO3CURNwO2WA8IZMxO
         ZUB9BrD5dT2EopwVb5dRc92BckBJQjfrCPaSldL4kwBZRyAOlMCngnjK5nh7fhvMG5Ij
         uL4kLM2JZadIZ7TAZo9PX0Nn5l8pt1anjT2T0BA4JniLWLygPFq2SqPNxbo5Me/J/tkd
         MEynsu+bTUkCjgc4shcgwwbQ73pYWOV03881PiAZaPveNIHU4o6d0g2p3rZIbGwyn+il
         wJXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6VuaqvZnXbuCtA6VHala2pXt+UVChb1skPG+1z4T5f4=;
        fh=9s6o4kZSbt2IbxZzaAO+N8AC94JyCi9SCOog4sHGYjo=;
        b=G+JjEFxfng39vGMEwQeubXAIWldgj1YfivM8ajuOzMAMpDOCEQUwcMxoA0ce6EuxdE
         sBXu9H4yZRaAbgGXLsV+raemTk9QZAyq45+iE5VKFkblWSRmTdoWQWDITTm93kukO/zK
         x9tVDZuy/RCgRBcZeLV8aLQpJYyvD+Q6fmiRqWKaMhiHg/xQLBfmKJdl8YPhu6bWdWTM
         Ok353r8gMgEbaYsjzo0W/GrjlbgMbNa4Teh0YFRmpE+V4wnGj94B1YTjd2tnCKIXDvM0
         sk2k8q6UtBH7hx4p2zRBqfKoNSBbCq40ucR4GuMTrzPucyt+RLT3wXF0oF/vbMTrOQsF
         f8Vg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795675403; x=1796280203; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6VuaqvZnXbuCtA6VHala2pXt+UVChb1skPG+1z4T5f4=;
        b=U7W/2vnwgazl/x2Iq8md9GBxU5hU+vMhrkjJnHXT10qaUEIQp3reEj89FxtdVEsbtr
         5kQjFUA+CdBgjELed9IEsXJrO0h3LBCsxS25AKGm3uwf+MadrVaRRfp3nJlipZenz15U
         IZo4Y0sFbYMqz4XT5P+LlW/TlmTdWCcIHuKYhuq+1mwG7TzkhIKD0tBnmCh/ql/zPXtt
         Z0b1fcUcJLXmfR9bL6AnD5nj1PzqxWfeUS7NkB15/Qf21O5mOZGlEdu0nDTQgngRxREj
         ZBQN7eDdamaDZdNE4cyBcPIRUHufxKF2sJTKxuRGG7kC2cWhd+kHNFJIxFL314SSa7HZ
         Tr4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795675403; x=1796280203;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6VuaqvZnXbuCtA6VHala2pXt+UVChb1skPG+1z4T5f4=;
        b=Fjdbwlf97udjo4uStiStZknh2/1NTMnJQq7qm9aEWhmlYVuR/Cv798iuQJ6G1MxQdz
         EnIjTpDtruImhBdv/EzBDxrTn7JebVUqhlCeeWB2VWZGH+4AfJl9eNDs6PdCYdnYfrgD
         ylFSTaXfbaJ7aFqCBr8ApVxYUdlfnwcbbJsKtMAwPrCSvzS5/9K35zxeWX58Z3YGcBUZ
         IgtaCTV+3tZ/K4JASwlIqVjS7SgHRMXYWQANCN2wMZyPE/Ux+jP/UCUsN/EUFuerUSiQ
         7NSOBZdgZ4ZP6fyAiTVjXN9ONftpR8lkuQ0dH8Pzzc0p8BGQUGwJfCJLs9QEe5/ykk81
         wxrg==
X-Forwarded-Encrypted: i=1; AL+hErEsChMD2YyyIMwsXLjO93igOIPaW5AHAiQ0g2V7SCMdwsEN7xH2poXVF1TSsjoEeb1BFSkIpzBp@lists.linux.dev
X-Gm-Message-State: APuU4Z8EH2AvaPRQayH5WdsjIfongrBbVchoDA71Djo+eapddA9bpUvJ
	F9bWZfnPByCzEn93U90dZfmXydfOkPpMBkTMNQ9P2lm5lidKryeZgIHvnph0AvNgYcBviL15/Ps
	cQbLDSVHpgyH4NRtrzvO4J+XvP5N1q0I=
X-Gm-Gg: AZFdTZfwmP8sh5Jy9vBZNN1x7ZVKT2SRjMIKvEGqn3ST8f+7/ZXazL01RYM9N1QWkEE
	hXdPntNKxQaWaV0YGju5HcCHFuBjm5GJqhDa0KCcO4K9+FiD6KbcFxD2nTj29+CCwvLPddd8au3
	fQO/E//1NYCfWzwiXMr/6uczbilw9q/1LxZL0MT4ubUzc4ujL2mI7K9xypNcLdwVoa+lNa9eYHl
	UFicZL45N+VKc33rcSsRBzoYattPk9wzUCbZu3YOQTUlt/J+hDDS24lSrv5W7NrF7ncMsi9Zj9i
	dEf/GRIXO81OyxGbepSvBxiHNuGb9YnAmrSjhJCcRiLW4nJY+m6Fxu/gjO148J84OmN5ABRQ2dI
	h54ZuQhi7jwd81UG09gaaJIWI3UhD/lft0qAFqxgF6PmeeNgHgPHjxpGXimhdrTPXoqQ6dw==
X-Received: by 2002:a2e:bea2:0:b0:3a9:9c1f:1b9e with SMTP id
 38308e7fff4ca-3ae7f9b08dbmr66942221fa.4.1795675402448; Wed, 25 Nov 2026
 22:43:22 -0800 (PST)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261125143821.729802100@linuxfoundation.org> <20261125143830.189554233@linuxfoundation.org>
 <0782adf7-20af-45a3-a09b-2a34c76afbac@kernel.org> <2026112640-recite-tipping-891f@gregkh>
In-Reply-To: <2026112640-recite-tipping-891f@gregkh>
From: Rahad Bhuiya <rahadbhuiya2021@gmail.com>
Date: Thu, 26 Nov 2026 12:42:59 +0600
X-Gm-Features: Aa3M54ouDePqYZg9dGf0okJ2sElAYrlc0EtcH7b3FGYFv1E4s2easyFvl4Kr9d4
Message-ID: <CAFj_507cGXSjDw6kRmatZhVo9k1LdzGxLd6rCVwZ1pV_VKutew@mail.gmail.com>
Subject: Re: [PATCH 7.3 0361/1005] sched_ext: Reset task fields on exit of an
 SCX_TASK_READY task
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Jiri for reporting and thanks Greg for taking care of the
stable backport!

On Thu, Nov 26, 2026 at 12:36=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Nov 26, 2026 at 07:19:47AM +0100, Jiri Slaby wrote:
> > On 25. 11. 26, 15:28, Greg Kroah-Hartman wrote:
> > > 7.3-stable review patch.  If anyone has any objections, please let me=
 know.
> > >
> > > ------------------
> > >
> > > From: Rahad Bhuiya <rahadbhuiya2021@gmail.com>
> > >
> > > [ Upstream commit 564405c424f49d70b13debe7fe5b550234ad6b84 ]
> > ...
> > > --- a/kernel/sched/ext/ext.c
> > > +++ b/kernel/sched/ext/ext.c
> > > @@ -4198,6 +4198,7 @@ void __scx_disable_and_exit_task(struct scx_sch=
ed *sch, struct task_struct *p)
> > >             args.cancelled =3D true;
> > >             break;
> > >     case SCX_TASK_READY:
> > > +           scx_reset_task_fields(task_rq(p), p);
> >
> > This fails to build:
> > ../kernel/sched/ext/ext.c:4223:17: error: implicit declaration of funct=
ion
> > =E2=80=98scx_reset_task_fields=E2=80=99; did you mean =E2=80=98scx_set_=
task_sched=E2=80=99?
>
> Ugh, I wonder why this code never hits my build tests...  Thanks for
> this, and the other report, I'll fix these up after my coffee kicks in
> and push out some -rc2 releases...
>
> greg k-h
