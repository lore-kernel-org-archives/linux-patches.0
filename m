Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CB4611A
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 14:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681309739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K4OXioAsNwvXZ/K4d6kxtMxBP2GaRJrPo091krrcB4E=;
	b=ip+Em0ekawFg0yYHPE8Z3WN9KGRkqsHZMi9RzceCwvsRnR2tbch0f2YoZFwybOwrft2ALB
	yT+vHUvQ9aMi73w/MrYbWhqzLjgcT08+RbbQEmJtctG8LI6mVKyS1EUY4KVjAQnsAPn6Jr
	Dg4I+2sqcAC/82IGUXS7YWwrC8zlt7U=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-dFBk3OgvPGmSBhzebS6SnQ-1; Wed, 12 Apr 2023 10:28:58 -0400
X-MC-Unique: dFBk3OgvPGmSBhzebS6SnQ-1
Received: by mail-vs1-f69.google.com with SMTP id g28-20020a67d49c000000b00425dd7c582cso2984009vsj.22
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 07:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681309738; x=1683901738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K4OXioAsNwvXZ/K4d6kxtMxBP2GaRJrPo091krrcB4E=;
        b=PnsQ03vaOdLO1uq5ZVOfmEPrfGCNMgkcnD4P5nszpp+aedAIbdy/0i9FLW9YDcuNvM
         Ffy6o/5nnZNaKlPpfgoEhG+G38LwoKu7z5qRDthRVcOqMXGBKq5VicZ8/uxv+so40fXI
         TWV+5dDyEN+5/Vvu060ny4kMaGInoI8MniiZjV/D7pqqydWOzAPlN+DXnpSV45CIv8Rk
         F9huCqwAzRU0Tsp849vDwLxQAkmHZn/auYo8vtN/XPQmrVut028hFRW2ANjmQhR6/jol
         mlpxNKxMMjcGQ9pWCk68+bp5HH6Wkm6oxgcHPqfnYmKG2YVF6RF1JerW0w54vxgZUNDR
         SZ/g==
X-Gm-Message-State: AAQBX9d4XltXA7CqhKo1VbrILp9XBlR0ejhETdqoyNxf0qyW4BY5PXEz
	bm3Mc53NAB6Sw+PgA2K/LES0L5nwpef/Gzhr33fI8Bmcpu1wpvABkGhJ7sgTHM21KSci5oI2f6e
	oHAH9T4W9shC2PfMiOwoI5RrPKSWxpHMAYqUpH7Gy8g==
X-Received: by 2002:a67:e046:0:b0:416:2ad3:35ba with SMTP id n6-20020a67e046000000b004162ad335bamr1437049vsl.1.1681309737985;
        Wed, 12 Apr 2023 07:28:57 -0700 (PDT)
X-Google-Smtp-Source: AKy350a+O+PE+LTKuY6GQvO+COcRTx3TNniSZzjqcUv4AblpnfFwjeYkSaIpO7UrXjAmLoCKpyIGiHDCHeNCcN4qe88=
X-Received: by 2002:a67:e046:0:b0:416:2ad3:35ba with SMTP id
 n6-20020a67e046000000b004162ad335bamr1437039vsl.1.1681309737698; Wed, 12 Apr
 2023 07:28:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412082838.125271466@linuxfoundation.org> <20230412082842.164450040@linuxfoundation.org>
 <87jzyhfnza.fsf@redhat.com> <ZDa/D5+HjGVuJgdA@google.com>
In-Reply-To: <ZDa/D5+HjGVuJgdA@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 12 Apr 2023 16:28:46 +0200
Message-ID: <CABgObfY3Ly6PeFqQ8uv+s88LX-y7iXLV0HXWQ1H4uSHwqkfwYA@mail.gmail.com>
Subject: Re: [PATCH 6.2 101/173] KVM: SVM: Flush Hyper-V TLB when required
To: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>, patches@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12, 2023 at 4:26=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> There are no functional issues with the fix, and there's no evidence that=
 KVM is
> to blame for the slow L2 boot times when the TDP MMU is enabled.
>
> > Jeremi, Sean, do you thing it's still worth it to push this to stable@?
> > IMO a small patch disabling TDP MMU on Hyper-V would be better for the
> > time being...
>
> Yes, I think it's worth pushing to stable.  The fix is valid even if we e=
nd up
> disabling the TDP MMU on Hyper-V as a workaround.  And the fix is mandato=
ry if/when
> the TDP MMU is re-enabled, or if we root cause the boot problem sooner th=
an later
> and don't have to resort to disabling the TDP MMU.

Agreed plus it's a good idea to keep this patch anyway for correctness
of kvm-amd.ko. Performance is a separate issue.

Paolo

