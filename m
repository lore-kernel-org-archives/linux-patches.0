Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DE812DD96
	for <patches@lists.linux.dev>; Tue,  6 Feb 2024 08:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707209677; cv=none; b=cQpAAQqVCs6iH8R1tWmhet0fNh4NZRnpNr9bn8MNTnMIdvZg4gWiDdYPci/FVTlvx0W4PCivtwa2cn7LGrc5m1JWE9E0IcSgKv3bwrVPbdNkPFngdc6VypyhPAKEuj6KUBfBlRrU3dbrdJq03RvvadCZhnCKaoWnYzVOQOwc5Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707209677; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qN2Z2eG0rdHqVZTjVV+RpYi5xVwsDmo4YBo/W4e3poXsUys1mqZFO5wDwCHXMHEm1wj8CNmtTKJzTnTYVVlrY0xdkz+2sBS5Z889pChx5sUoaNt7xm7YPcfSVyfudGiCWK7xwGSUgLjv/EW8yQANWADAoUZ+n44ywtMIIelSnF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YX+l+wDO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YX+l+wDO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707209674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=YX+l+wDOqgTGZS+buF2qZyqb6by+t23AUYgVCFtRz6zCOSqSAKla9MyFq0Vm6dHDvmz/8L
	01VdKKNSiHzrC+moHssdDxvF0IQH7OKL6n0FH22dRKQpOn0ykz9VZQ1QMBEmojIfDpHyqv
	d0+tlQcdIp4KZbZRUbnEkAzlD15WuTg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-b5yTF-sQNnSYpfbUNxo2oQ-1; Tue, 06 Feb 2024 03:54:29 -0500
X-MC-Unique: b5yTF-sQNnSYpfbUNxo2oQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFF2584AC60;
	Tue,  6 Feb 2024 08:54:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5572D492BF0;
	Tue,  6 Feb 2024 08:54:28 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	kirill.shutemov@linux.intel.com,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] x86/coco: Define cc_vendor without CONFIG_ARCH_HAS_CC_PLATFORM
Date: Tue,  6 Feb 2024 03:54:26 -0500
Message-Id: <20240206085426.3262128-1-pbonzini@redhat.com>
In-Reply-To: <20240202-provide-cc._5Fvendor-without-arch._5Fhas._5Fcc._5Fplatform-v1-1-09ad5f2a3099@kernel.org>
References: 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Queued, thanks.

Paolo


