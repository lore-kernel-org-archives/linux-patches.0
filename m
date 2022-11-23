Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134F11FA3
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 10:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669200428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=crFkgffTIUwQTCrTlA+F1BqRlUTl8wnT00TJycfR8vo=;
	b=JXOpiBivjk16IbPqHnMxlJE0nFiz2DqCQM28QKHhPIFcQ1CcIFZ/Z5w9Xj2ZWZ3ObVbKp8
	ESmxjmF8Tps8mUOcmJgw8IevmW/zcSxzL+rzrjvSIH6tmo/JUlhtI54RTeMVhScwpfF3vB
	hxpHhPeEufPZb/AfVgr0uL99rw3l5n8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-Twyqpe7lN0qoapwfzN6ZKg-1; Wed, 23 Nov 2022 05:47:04 -0500
X-MC-Unique: Twyqpe7lN0qoapwfzN6ZKg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2F3C8027FE;
	Wed, 23 Nov 2022 10:47:03 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.2.16.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D952A7AE5;
	Wed, 23 Nov 2022 10:47:01 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org,  patches@lists.linux.dev,
  tglx@linutronix.de,  linux-crypto@vger.kernel.org,  x86@kernel.org,  Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,  Adhemerval Zanella Netto
 <adhemerval.zanella@linaro.org>,  Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v6 1/3] random: add vgetrandom_alloc() syscall
References: <20221121152909.3414096-1-Jason@zx2c4.com>
	<20221121152909.3414096-2-Jason@zx2c4.com>
Date: Wed, 23 Nov 2022 11:46:58 +0100
In-Reply-To: <20221121152909.3414096-2-Jason@zx2c4.com> (Jason A. Donenfeld's
	message of "Mon, 21 Nov 2022 16:29:07 +0100")
Message-ID: <87v8n6lzh9.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5

* Jason A. Donenfeld:

> + * The vgetrandom() function in userspace requires an opaque state, which this
> + * function provides to userspace, by mapping a certain number of special pages
> + * into the calling process. It takes a hint as to the number of opaque states
> + * desired, and returns the number of opaque states actually allocated, the
> + * size of each one in bytes, and the address of the first state.
> + */
> +SYSCALL_DEFINE3(vgetrandom_alloc, unsigned long __user *, num,
> +		unsigned long __user *, size_per_each, unsigned int, flags)

I think you should make this __u64, so that you get a consistent
userspace interface on all architectures, without the need for compat
system calls.

Thanks,
Florian

