Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B075F205E2F
	for <patches@lists.linux.dev>; Mon, 25 Aug 2025 13:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756128538; cv=none; b=PBHZaMhs8iUVOuo6l7wzggzxL09qk1VxQs533hGXipkoqx5loFQJQoVHYkkqXsxUP1xKIRUXkHpPuN7XiH/DYQJP6aXrdDF2T+exWDEaFtGlcg1MUn+n2CP2QvQOo7m6ppe4S7EiqtheiAHl8gHuAeIKo3tX6O1or1BVqmJ2jbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756128538; c=relaxed/simple;
	bh=glxL903XYse6spc6RSJ/TnBV9+4a6cesqqG3KZ6BNnU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ca9rl0Rvn8eXfyPiL+KolyIKf7T7eHk8w15MlaprvwR4z7zVvFZ+5tAo7pFo7lYEQvu8ijlpxZwWZXSHm4v1R7aSWXePjjQU1W/7u0wkI7rF4c7HjmwbPuo3qndWetwcEp7MWQFT1lRuwugm36JAuEa7iMnUwx7t57yid6cubVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RLnZIGFs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RLnZIGFs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756128535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HfB1ubHeDiRSQTP9+9v/Hpvr15wT5Rq18S+uFfbKNPk=;
	b=RLnZIGFs7755w2OfGQwe7ntuF22sQSfZJJIpIQriCEwAmw6YaKtnWy7uoEKkF7tmprqAVI
	QfvN8E4sMowpXLJkfCgiPeRWZ1Ws7rOLM+iDNkkZ3sfsikxQd94dNifmbB1/TpctHsnS7R
	/JGUVCJ7JqrL4EqgNAr1yNp6wuYCc3Q=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321-mvmJJHIcNjKFsTN1paBn3A-1; Mon,
 25 Aug 2025 09:28:51 -0400
X-MC-Unique: mvmJJHIcNjKFsTN1paBn3A-1
X-Mimecast-MFC-AGG-ID: mvmJJHIcNjKFsTN1paBn3A_1756128530
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AB6D19560B3;
	Mon, 25 Aug 2025 13:28:50 +0000 (UTC)
Received: from [10.22.80.227] (unknown [10.22.80.227])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CE1730001A5;
	Mon, 25 Aug 2025 13:28:47 +0000 (UTC)
Date: Mon, 25 Aug 2025 15:28:40 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Nathan Chancellor <nathan@kernel.org>
cc: Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>, 
    dm-devel@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] dm-pcache: Fix 64-bit division for 32-bit platforms in
 get_kset_id()
In-Reply-To: <20250821-dm-pcache-fix-32-bit-div-err-v1-1-cab5448f44e6@kernel.org>
Message-ID: <f9793847-deb5-67ba-c875-927fadbc2cf0@redhat.com>
References: <20250821-dm-pcache-fix-32-bit-div-err-v1-1-cab5448f44e6@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: J1HfBOYW65arGVyZC3rJiTOU_-6E1dFNTYJd9SHF1-I_1756128530
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 21 Aug 2025, Nathan Chancellor wrote:

> When building for a 32-bit platform (such as ARCH=i386 allmodconfig),
> there is a modpost error:
> 
>   ERROR: modpost: "__umoddi3" [drivers/md/dm-pcache/dm-pcache.ko] undefined!
> 
> Hacking up the driver Makefile to allow building into the kernel shows
> that the division comes from get_kset_id(), which is inlined into
> cache_key_append() in cache_key.c.
> 
> Use the helper div_u64_rem() to avoid emitting a libcall on 32-bit targets.
> 
> Fixes: fd5cc4922bef ("dm-pcache: add persistent cache target in device-mapper")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks.

I folded it into the existing dm-pcache commit.

Mikulas

