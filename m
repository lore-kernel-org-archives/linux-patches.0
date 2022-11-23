Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9B01FA3
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 10:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669200496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q21XGGIV0kLQZIROdqS+QQLvwJnTsCRdjio/ZDAURPE=;
	b=Ai5SX3frECIg9pnN33NdUzbGswQ1nTfEfhpCe0ETms/zdCCll1V/e23aMPl70iH46biPh3
	pg+/Tjzbt6ahxtLxRF+IjZS1mYvI+Z29REacDZ86O04pD3EJJFg5yHTS/n+L9vlyL8GGOt
	EtBy3sbiCnsUon/rSc+mLaPg5VQrFVs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-8tkKkYFnM7KhQMAhkJOAEQ-1; Wed, 23 Nov 2022 05:48:12 -0500
X-MC-Unique: 8tkKkYFnM7KhQMAhkJOAEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC42C85A59D;
	Wed, 23 Nov 2022 10:48:11 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.2.16.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EC231400B15;
	Wed, 23 Nov 2022 10:48:10 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org,  patches@lists.linux.dev,
  tglx@linutronix.de,  linux-crypto@vger.kernel.org,  x86@kernel.org,  Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,  Adhemerval Zanella Netto
 <adhemerval.zanella@linaro.org>,  Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v6 2/3] random: introduce generic vDSO getrandom()
 implementation
References: <20221121152909.3414096-1-Jason@zx2c4.com>
	<20221121152909.3414096-3-Jason@zx2c4.com>
Date: Wed, 23 Nov 2022 11:48:06 +0100
In-Reply-To: <20221121152909.3414096-3-Jason@zx2c4.com> (Jason A. Donenfeld's
	message of "Mon, 21 Nov 2022 16:29:08 +0100")
Message-ID: <87r0xulzfd.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7

* Jason A. Donenfeld:

>   static void *vgetrandom_alloc(size_t *num, size_t *size_per_each, unsigned int flags)
>   {
>     unsigned long ret = syscall(__NR_vgetrandom_alloc, num, size_per_each, flags);
>     return ret > -4096UL ? NULL : (void *)ret;
>   }

The traditional syscall function returns -1 on error and set errors, so
using unsing long and the 4096 is quite misleading.

Thanks,
Florian

