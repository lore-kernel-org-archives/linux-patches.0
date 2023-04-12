Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C976121
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 14:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681310880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+ZFIv/p/zrHXi9Hb3mDpf82IzUDGx965Bpax3jM97+I=;
	b=NKszh3qtwaXt4iIXO7Cas/6/7wGFBSRbjPx3Lrqvcft427oY5DqX3LVW3v/G2c9e1mREt8
	cjSbrpCIJMEiq00ntBLn0hNgCjUCUda8tYp5IptPm5O6Om7jI8y4bK9Q2ZgXvfs1jaI1oi
	QWGIlmUeE03VQ9tw536coqwJsTeoFWU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-SglHw7HQP3idhFgQT1CIDQ-1; Wed, 12 Apr 2023 10:47:59 -0400
X-MC-Unique: SglHw7HQP3idhFgQT1CIDQ-1
Received: by mail-qk1-f200.google.com with SMTP id 1-20020a370301000000b0074681bc7f42so5992843qkd.8
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 07:47:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681310879; x=1683902879;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7aoSHBk9B3SuF51OwG6nN2I/gKWPktJ/GEECG1+4VA=;
        b=EqriTYvGKSjzsjyCqpFseoAClrNbiix7ee20PTNMAqjZFwBEyZYno7g/EgaIjhgHH6
         0IfcDSekmFJfmPWzNixDIlQb5OF9FFm2R+MW9CIoZ7clRj2L1+GzhCvXSmCsfXwKDKND
         xolvjdThBdA/kAE6ZSkOyxmXbgtukGzzRGPtfeDny1fqkHWFYvxVvt2/R9vi8BlPYJIg
         DdmHus0eIWWa436DYw+YdUJw0hXi8xUf3gqe/YhMYGCb9+qDPF3T63oIhLSsp2q7rOIq
         Jes8SxGLHIDKEHTp79Ll17dk5DbFhkEUFfb67jHH/3s17pv4bYdQ5ibO8LuM4ONIIISN
         hdxg==
X-Gm-Message-State: AAQBX9eOMHCSSxVlW1HK6NIuCClPU/5PMMW5DACbBNF2Hr4AGb6aK08E
	VwEVKq0aTplSzGyCqWrJCTX6Aw5G5rL8MJrZiFWvLZrEjoM5Qy+YMAdUPUOXVmcro6b4sWawrLh
	o6p1uUsgI0ojlsJfq10L1mQ67g1TVbqiSFHnefHEMJSc/v2YIB4/+sR6yV3L1ypY6GIYAHFdOPU
	ZK5g==
X-Received: by 2002:a05:622a:1cb:b0:3e3:824f:45f1 with SMTP id t11-20020a05622a01cb00b003e3824f45f1mr3961277qtw.27.1681310879078;
        Wed, 12 Apr 2023 07:47:59 -0700 (PDT)
X-Google-Smtp-Source: AKy350aG1bLmg0WEoDAicV85azZn9oNrATuG6ivlTsH69LgN751j4sEUZ7khp0xPnzerYNinK4cpLA==
X-Received: by 2002:a05:622a:1cb:b0:3e3:824f:45f1 with SMTP id t11-20020a05622a01cb00b003e3824f45f1mr3961249qtw.27.1681310878775;
        Wed, 12 Apr 2023 07:47:58 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id d9-20020ac86689000000b003e3910db4f1sm4310584qtp.35.2023.04.12.07.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 07:47:58 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jeremi Piotrowski
 <jpiotrowski@linux.microsoft.com>, patches@lists.linux.dev
Subject: Re: [PATCH 6.2 101/173] KVM: SVM: Flush Hyper-V TLB when required
In-Reply-To: <CABgObfY3Ly6PeFqQ8uv+s88LX-y7iXLV0HXWQ1H4uSHwqkfwYA@mail.gmail.com>
References: <20230412082838.125271466@linuxfoundation.org>
 <20230412082842.164450040@linuxfoundation.org> <87jzyhfnza.fsf@redhat.com>
 <ZDa/D5+HjGVuJgdA@google.com>
 <CABgObfY3Ly6PeFqQ8uv+s88LX-y7iXLV0HXWQ1H4uSHwqkfwYA@mail.gmail.com>
Date: Wed, 12 Apr 2023 16:47:55 +0200
Message-ID: <87edopf97o.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Paolo Bonzini <pbonzini@redhat.com> writes:

> On Wed, Apr 12, 2023 at 4:26=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
>> There are no functional issues with the fix, and there's no evidence tha=
t KVM is
>> to blame for the slow L2 boot times when the TDP MMU is enabled.
>>
>> > Jeremi, Sean, do you thing it's still worth it to push this to stable@=
?
>> > IMO a small patch disabling TDP MMU on Hyper-V would be better for the
>> > time being...
>>
>> Yes, I think it's worth pushing to stable.  The fix is valid even if we =
end up
>> disabling the TDP MMU on Hyper-V as a workaround.  And the fix is mandat=
ory if/when
>> the TDP MMU is re-enabled, or if we root cause the boot problem sooner t=
han later
>> and don't have to resort to disabling the TDP MMU.
>
> Agreed plus it's a good idea to keep this patch anyway for correctness
> of kvm-amd.ko. Performance is a separate issue.

OK, makes sense, without the correctness there's no point in discussing
performance.

--=20
Vitaly

