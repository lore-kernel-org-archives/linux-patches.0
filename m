Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2E03D88E6
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 13:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692692; cv=none; b=l8agYmYTD8RSbYxqtVwLJOzQqEgz1ghX3sxSXrF1oghlXxX/BLkyjksWA2X5nG7ssr1+q25c+xtSiS8M21HFsBgExE4IdHpyquMmviVijqdT50SNR6CQDRGoQqoILycMbo0knFCQF2jDKX2M1uDv7vD7aDIjnJKy+WVbybp+F/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692692; c=relaxed/simple;
	bh=C7ZkUintBNR+n78eHUpXeuDHLGAWIRDXrwfIjjftvQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oxmneh121wzGAC1dDMUntsSSFm7z9MqK5cLoKAMIpEJOlE0FyfiW8IFOCAfEIrM1JuuQRA3T/Kq6K7VX4WsXf3KZCtH1C4+Lf3uGRSIkamf29Uz2QCmWyiJrQrFoaPvM7v8cAr9qtR/uh2y9BjJTGKZi4+cAtus+9z5rV+TBZ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IRuOMfOH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IRuOMfOH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776692688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j+/nKR8khsmc6e6yq/Nrf/JA9GPxtBwZwZ1LoRnfnx4=;
	b=IRuOMfOHqX1P7msYitc+Q0Dfc3e4VawnQZDEcadYCZMfva6dDU9kWAZ2LnMC/dgv/pkASL
	neLzIN9+PbAdz41hoBGdhQVu7O3fGFitR4it05pQlmVGg9fJqyhqNlLp+POEl5iAHhKKje
	MbWIrdTuHy1fppf0rFNyzfQjGV8L318=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-XLStyaHsNQWHOaoZqd1x8A-1; Mon, 20 Apr 2026 09:44:47 -0400
X-MC-Unique: XLStyaHsNQWHOaoZqd1x8A-1
X-Mimecast-MFC-AGG-ID: XLStyaHsNQWHOaoZqd1x8A_1776692686
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43d7e5b98ebso2669126f8f.0
        for <patches@lists.linux.dev>; Mon, 20 Apr 2026 06:44:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776692686; x=1777297486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j+/nKR8khsmc6e6yq/Nrf/JA9GPxtBwZwZ1LoRnfnx4=;
        b=Zb43zN8/xjaxSQUIzusURwhjng8f+u75Y/qx2ssuxDZsdnsj1xHr6XjfJrjE1HMlnd
         FxjKXOMrixFXqtBgRLwJvUlbVp9BFqyB9SyZinUJRPI3rx7drIoU9eY+G26LIb0pxAg3
         Sl3MtE2MHPtpa86UuNdmRitVSa7rdly1ImdK56/3OSwzs2NEL0l2DfawdvQJlC+bvR78
         x78F1TorYZNEP+JeNSQjagyGqGlvdanUriK1c1K4nkRke6UiLBa8g96X3kkiNwud7eYl
         aLPvM8NwI9msppLozcgbl29G+ocXeok42aB2dCLg1wfQtXZuQFApFgeQVV1OCp7d6p7I
         uySQ==
X-Gm-Message-State: AOJu0YwDrSzxygNevbvCy8Rh7W3awJLRlPbb2qEP0hTQ4EiYjHOjCKKP
	cioKLJVw6AHJzA2SBoR2Gz98EaaW+OZjNajldPPgRjnAyz2xecGOrMJ/atjXMmMuNYzrPQKUJ/l
	BszcYGC26p/83K3GpIY9i0L9rghn/5Jwr2smBrmqP5PIi+Wo3PrUa5W7iSNVConveIxFml4gIYt
	EutcZUErz6HGiar928ZK5IQkbA6y32hLG6Pw==
X-Gm-Gg: AeBDievd9V83yM2z5b89IfXxYZ4U86v223rMU+SQGbVsD0qRW4fxAIX1bLNH41fx9Ob
	ET5XPMygLdZw+3Z/6ly1H49Cmy783TNpNPunbCi1Fxg7BOf62tfATfOLOCk6t09ExWNcyYmNLsZ
	j7vt9dx1G7x3ZHvfwA29c9qd/6I9sEN2VQjibaJPPOgdYhYPTU1ojNuwl0MnQdFBvDmWTZn+sPu
	6tn+9IZmi21A0P6Eef+Jw3L4GtewvaqJke8Ev25dLsFGZQWmUqIzhEvKH11G/L6FWAQ/pW2Ru7L
	UcJOs9IiLRVBBL4=
X-Received: by 2002:a05:6000:1acf:b0:43c:f1a5:56f6 with SMTP id ffacd0b85a97d-43fe3e23c0emr20516833f8f.43.1776692685808;
        Mon, 20 Apr 2026 06:44:45 -0700 (PDT)
X-Received: by 2002:a05:6000:1acf:b0:43c:f1a5:56f6 with SMTP id
 ffacd0b85a97d-43fe3e23c0emr20516790f8f.43.1776692685324; Mon, 20 Apr 2026
 06:44:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260420132314.1023554-1-sashal@kernel.org> <20260420132314.1023554-334-sashal@kernel.org>
In-Reply-To: <20260420132314.1023554-334-sashal@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 20 Apr 2026 15:44:16 +0200
X-Gm-Features: AQROBzDobIMPDnE7Fi6IMXXk8ozHKwMYsB0F5MzEPgxvyvUL_mGRNveHXmVGu_U
Message-ID: <CABgObfbWk_AxsLB6v6RJQY6VfA3mwH_tiuobFrb94XBD=PdVXg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 7.0-6.1] KVM: x86: Check for injected exceptions
 before queuing a debug exception
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Sean Christopherson <seanjc@google.com>, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kTrSaw20rma8NWrFPgphD-lmAtJ67GT1dZDqs9VLJos_1776692686
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2026 at 2:34=E2=80=AFPM Sasha Levin <sashal@kernel.org> wro=
te:
> From: Yosry Ahmed <yosry@kernel.org>
>
> [ Upstream commit e907b4e72488f1df878e7e8acf88d23e49cb3ca7 ]

Nacked-by: Paolo Bonzini <pbonzini@redhat.com>

> - NO Reported-by: (no syzbot tag directly on this patch, though cover
>   letter referenced syzkaller repro for the series)

This reproducer is *not* causing trouble in the host.

> **Step 2.4: FIX QUALITY**
> Record: Obviously correct; surgical one-line addition of a boolean
> condition to existing guard. No risk of deadlock/regression - it only
> adds another case that returns -EBUSY, which is existing ioctl behavior
> that userspace must already tolerate. Aligns with architectural
> behavior: you cannot queue a new exception while one is being delivered.

Debugging a guest from the host is not architectural.

> **Step 3.2: ORIGINAL BUGGY COMMIT**
> Record: Bug introduced in commit `4f926bf291863` ("KVM: x86: Polish
> exception injection via KVM_SET_GUEST_DEBUG") by Jan Kiszka, Oct 2009.
> `git describe --contains` =3D `v2.6.33-rc1~387^2~10`. This means the bug
> exists in every active stable tree (5.4, 5.10, 5.15, 6.1, 6.6, 6.12,
> etc.).

It's not buggy, just incomplete.

> AGAINST backporting:
> - No explicit stable tag/nomination on the list
> - Impact is guest-only (not host)
> - Requires specific user action via KVM_SET_GUEST_DEBUG ioctl
> - For pre-v6.1 trees, minor adaptation is needed (inline the helper's
>   check)

Bigger: manual reviews are needed for all these AUTOSEL decisions.
Please don't DoS the maintainers with this stuff. The most stable KVM
is the top of Linus's tree.

Paolo

