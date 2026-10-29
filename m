Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305592;
	b=0+FKKcX4ZEPJkKdOdgtbWivzuqSyOc22RPgvRo7S+DJWdQjWkVS0MCNZWiNisvlaA12L
	 AmIXzQeW0bGDgjFZY+Xsl8sCn3yliBeCziD961sNjAgAPeYLd6b9tghj/C85AfkoKSly+
	 r/9HXRVo+ZFrhGew5wQuYJDNIP0GdCqe8dIKXotz/5wwXO+sSf9flxy+lKGqotlSOsS0t
	 1ZBpee2nqaR949kVDsrYd6B6Z9nEE4q/28xYqxmRYvejOZeEyKVxzlkctOh4yAy+NxE3s
	 rjxR8nQUg9aj1LOihnWhsgYFyGVZSKZXZ9ZBNJJJ9ma6QS8efkMQHZGKzkiYTXfzhvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305592;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=wD0+bNuXf8yjiCuu0F2XL0gVzvQAbTIKBC9a3vok6no=;
	b=zJYYJCvVRxMde7tnbai4CKJvTlXDmXIbikfjMBvF/bskf2aXNCbbGwkZhgcYF2ISMdTd
	 tO1X1cQOf+oZhmZADpws4bhXwx49G6n9WrYky7WoPZpwRxA+WjxNxHo/80SBYaeDsTToR
	 DPIO0/IF+LFZluwRURPCk9WQ7f2YeZ25uk9Smhqo6elx8aZ/hiwmEWCjW2K6V3zdXir0f
	 jNe+ZSS3JBX8bdIKokLTND2le+DdpBLQbZhzt8WwBNTAxI5HvQGiME1w4z4gQ7lhvCdPt
	 QltM7CcCvdKyWPtiIQudF2PA/y8xcHqR/DaM+qLzi0SZwzNCdwo7JZOxipjB9sxbhFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=g53EBpxL;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0562606A31A;
	Thu, 29 Oct 2026 20:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0562606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=g53EBpxL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=wD0+bNuXf8yjiCuu0F2XL0gVzvQAbTIKBC9a3vok6no=; b=g53EBpxLZGKDzUbc6sEigvLRSB
	9AFVX0AB/BVHZh6lVk57Ui9HUmQZkCjTrOOcFgcmxpG+Wo6Bw/OiJSxfgEcyupoIID9E75CoNTBOk
	VHILl5FPfdvjtx7M9o5a8yk4Fk7m52q/34gD3JNKs6zSkCfJP1U6NYA4PpAfG+H4gGenTr2aMFMW7
	BWikvuwnbM2tHBqGBg8P6XXclvjGKudusqm49Mdkez2e9SOQsCSeQzS+U7ryOezmgdITMuPpTby4C
	k4SsJdI0XMzOEujo+6mJD8VJT7QnJ58TSVuNnuqGWkAzpupRGpDl34m/8773bkr9M2trC7QEctFUy
	HxTpCrlw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMWhh-0000000AJot-3yj9;
	Thu, 29 Oct 2026 20:26:30 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Guo Ren <guoren@kernel.org>,
	linux-csky@vger.kernel.org
Subject: [PATCH 0/4] csky: fix missing prototype warnings
Date: Thu, 29 Oct 2026 13:26:20 -0700
Message-ID: <20261029202624.2685097-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing function prototypes to prevent build warnings.

 [PATCH 1/4] csky: cachev2: add missing prototype
 [PATCH 2/4] csky: perf_event: add missing prototypes
 [PATCH 3/4] csky: kernel/process: add missing prototype
 [PATCH 4/4] csky: mm/tcm: add missing prototypes


 arch/csky/include/asm/cache.h      |    1 +
 arch/csky/include/asm/perf_event.h |   10 ++++++++++
 arch/csky/kernel/process.c         |    1 +
 arch/csky/mm/tcm.c                 |    1 +
 4 files changed, 13 insertions(+)


Cc: Guo Ren <guoren@kernel.org>
Cc: linux-csky@vger.kernel.org
