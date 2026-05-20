Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005F53FE34C
	for <patches@lists.linux.dev>; Wed, 20 May 2026 18:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302725; cv=none; b=cdJds3ShOhQnADZWXI5cWJPAHD547W9fgq6RmMlQ6L4Dmz31sxh+ftay3c/ggrakGouCum0aNhL7edUZ4zwOg7yFNXbmez8mIhMwErEK/6jRTb+fhSbN/9vs9ZtofNTfXM3SR8NW6k9b8FvoE86Em+3pllZV4xzsoJ9FBH/rJEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302725; c=relaxed/simple;
	bh=MBu9X2B8pymxnAWSnFXaGPij6bRewxrEGR1tIUkT9+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qy0W6rZEHHkPfX3uuGn8sasbeRJevwcsjTomhRIqkLDmCbaf76u7QaRVpjpSJZtuBKYkZIBHCqGxrFvBuyD5m8Q0y/OuO0ds+owub9DbYJUZMuWv/4ujWyMKrIPMqqxJZpMkcHCzkSF7cmYZQTS2rVg9s23CMeKG9/9huvyByhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T91oALKn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T91oALKn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779302723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FkQN7Jz3dmlcVLBByrLAHFF/AIIFafPxC3BLvbAjDyA=;
	b=T91oALKnKucS7BLpnxvi2SsWj0bcnV6mwhzHIUBcvY5Ux8zSxezj/vpgniHfKBI0DUzihk
	KlXfQ0x0ffaXm2XPkB4AbpHhPT5KtFn0gwMZDAjQ/mMW1eW1RGt+WEcy+g3fRe/QL/LAlx
	blB/vFoiQ93IlKt6e3G2HlErzv92TmI=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-fO0CtZPIOO23v83lga8Eug-1; Wed, 20 May 2026 14:45:21 -0400
X-MC-Unique: fO0CtZPIOO23v83lga8Eug-1
X-Mimecast-MFC-AGG-ID: fO0CtZPIOO23v83lga8Eug_1779302721
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-65c7091141aso11883353d50.1
        for <patches@lists.linux.dev>; Wed, 20 May 2026 11:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779302721; x=1779907521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FkQN7Jz3dmlcVLBByrLAHFF/AIIFafPxC3BLvbAjDyA=;
        b=hblxHy/dRRugsaNcg+7faA+i2NDc2E+kTmUCqZ8+kwFAOVIWOennahKRse3DMiQbHb
         PWMGS83sa2gJsBnu5DCzwODWx8xGRubORjJSkRAJRKnS5pV18CpfX9k3IxF35sxC3o1z
         4BqNHpWn/4RPnTVOz2ycPwPOiqw4OFxTf6aywDcvhny9eA8FpEPN8dBnanDnDfQrOJIr
         KHebeQD5kxkizXhKleaD75BbC6y6j6nOyKosif5VSXgUfILWVNYm1cIYRdR8ZSrBeI3G
         i7askABIgazPnVzYR6PtCvWpNuiqzrGVNdpm+In9T8qpFlRCQa3BcyfMPmE1BKw2/VUW
         wy1w==
X-Forwarded-Encrypted: i=1; AFNElJ8w7fvWdBWPlit4g2izIUUMyc1zp+Ywt4PeL+plDKlnhAU09YfJ98ijIfnWY9vlF17MJxgXASb9@lists.linux.dev
X-Gm-Message-State: AOJu0YzCPioPwZm5vsWY2skK6i1SUrY2+lxiMwwSvsyCHICmnBgJyKWF
	vMyOn0s0qkEivEwlGFRN/QdfEgfeaLbtKGZ47SKTw+XHIlSrQlFQj3x355Kirspy48nreUllZiR
	7TRTT2yIlN/7kUFZkfn22JILbSZYAKCoJ+sukdxCKeNgHBTa6cLGLr9B+m/uxKZzplMpscH4gxg
	AvHIO9uDPD3/UTsx9WFzHgYmaBZuGmPZ/k7w==
X-Gm-Gg: Acq92OFcuqwIjJJPmImlD+ujiXeWvDl/NLYh/mRfuZYSZV08Q1wNFUiRXEVe3VMtCYA
	9OgxOyykhj1CztUG3ZA42x5NTpENzmKTArUQN8+2TdfCxv90XjXNONTJW8QqifZRfL7DlL0U0mZ
	eKMq5YvR8ZFzbV2RBEuhEwMJK6xVdQ9nOT6sxLibKfITFzecoMHo99obYixtL+wkx+zykG4ceyR
	0uerA==
X-Received: by 2002:a05:690e:4191:b0:658:e840:d5b4 with SMTP id 956f58d0204a3-65e22751c15mr21641909d50.29.1779302720879;
        Wed, 20 May 2026 11:45:20 -0700 (PDT)
X-Received: by 2002:a05:690e:4191:b0:658:e840:d5b4 with SMTP id
 956f58d0204a3-65e22751c15mr21641898d50.29.1779302720454; Wed, 20 May 2026
 11:45:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260520162134.554764788@linuxfoundation.org> <20260520162142.034488466@linuxfoundation.org>
In-Reply-To: <20260520162142.034488466@linuxfoundation.org>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 20 May 2026 20:45:09 +0200
X-Gm-Features: AVHnY4Jc1nrTQbkUAir959qNNC65RhEgclffoM9HfcQTtbhYMpE5PAufxLoYQik
Message-ID: <CAOssrKcqmVW3kJ131tRF3LCJVQUtdRB31B5HENDfpgrq6r=jEA@mail.gmail.com>
Subject: Re: [PATCH 6.18 346/957] fuse: new work queue to periodically
 invalidate expired dentries
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Luis Henriques <luis@igalia.com>, Sasha Levin <sashal@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hd8yXFxSNJNNH4CuMROQ8GGgfe9jPsakiHBaz1FXLHw_1779302721
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 7:31=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.18-stable review patch.  If anyone has any objections, please let me kn=
ow.

This is not stable material, and I don't think the dependency is real.

Just need to resolve the trivial conflict when applying 5a6baf204610
("fuse: fix uninit-value in fuse_dentry_revalidate()")

Thanks,
Miklos

