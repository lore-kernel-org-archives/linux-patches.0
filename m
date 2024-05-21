Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F3D487BC
	for <patches@lists.linux.dev>; Tue, 21 May 2024 11:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716292097; cv=none; b=USFihDTD11sFyLXdopg5mZTCCVi7dHQsnLbbrQf2dvLt5AAgaIln9XlsezvPwBhOTZRMySIrlqZ1CNVrEwCOLIYaS5bTpuK4YEf6OA3p6MowXSrSZNEHjGkANcBBWq4OlcdMiuZ9iRKS6fQ3FdMRur4Y1P1lqA4duO/ieNXUs5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716292097; c=relaxed/simple;
	bh=mOJoqoemCb2h0NhMLeFjcITMcLIhyF49JAEwSdnhYe0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qhw0/W5tQuEKVml11ZdoKTANv8UyMu0EFBuEx7ci11erCl7IuEBNjCZ2W/cXwBCPozhG5HISW32GlvcNNDbv5rkkdhMuqXX3YHrRqX1vUM1S8RepDPPn6nx3OBBLtyIKVBFHRhn95dXPfb648pl/0sZfaTtf4FJv45M5qyQz0EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YFxMZ9EM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YFxMZ9EM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716292095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ScVJ44SNNv7slncCQ9AbQNPMEQULt+EbdHOtj84evl4=;
	b=YFxMZ9EM0YjhLC3HyWtE3uNEyhF3kB85sZ1NJ4aqkvRTQmG4T0jMPhFSoysNwQfVPNRV/B
	N9nNm+3D9oNW19oPwkFsZ3nFzhxog0PKTZml1D2jI4HFhWAf5XVM61TKUlHYYbsYji5QHS
	oQ9AFYhWHm0PTVN8cAhH5Pkf1SRe8hA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-9tXyyicKP1y7f5W_UJ-cyg-1; Tue, 21 May 2024 07:48:13 -0400
X-MC-Unique: 9tXyyicKP1y7f5W_UJ-cyg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3852A8058D1;
	Tue, 21 May 2024 11:48:13 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.192.157])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58FF8400EBE;
	Tue, 21 May 2024 11:48:12 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org,  patches@lists.linux.dev,  tglx@linutronix.de
Subject: Re: [PATCH v15 2/5] random: add vgetrandom_alloc() syscall
In-Reply-To: <20240521111958.2384173-3-Jason@zx2c4.com> (Jason A. Donenfeld's
	message of "Tue, 21 May 2024 13:18:40 +0200")
References: <20240521111958.2384173-1-Jason@zx2c4.com>
	<20240521111958.2384173-3-Jason@zx2c4.com>
Date: Tue, 21 May 2024 13:48:10 +0200
Message-ID: <87msoj5qth.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

* Jason A. Donenfeld:

> Libc is expected to allocate a chunk of these on first use, and then
> dole them out to threads as they're created, allocating more when
> needed. The returned address of the first state may be passed to
> munmap(2) with a length of `num * size_per_each`, in order to deallocate
> the memory.

I think =E2=80=9Cfirst use=E2=80=9D actually means =E2=80=9Cprocesss start=
=E2=80=9D here?  We don't have
a way to report failure from arc4random and similar interfaces.

Thanks,
Florian

