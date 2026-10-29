Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793304809;
	b=Wa1qAHR3UtG08w4JS3YVyNl90+dJJzQGN4yuC/5M7Pdu3QwkJT0r5IyfJ6+1pDzztjvj
	 bfcr1iYyrANrZdAzXfQQzcKhh4pHD36+3wHkL+Y3tU8F9LpdWNKAaiXMW6bcNoG8en1M1
	 bWh9Fws3O9Poe/oy+JzwYYT35UQw9IwBGcmu2mst84kgebJDn/24HO20e1W/EKwVL/0/U
	 2cHTJCw7dIBUn+heQR4k6q58j8GMJsY1EbDlBxX2St3Td3Nb9GjMovcaSL8Zo9R3AKasl
	 M6eeu4x0S5rTE6AiP+06l8cWnQJvIEr2klcHRUihf7+5+t7OpP/3UYVgy/lkEtKXp6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793304809;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=OvHBVNFEaIP23Yj7JU5FUqxkZwdHXB2TgBTrhq4CMzI=;
	b=NgzGTG2md4R4N5305clsNn/kjgccaoz9UAX4kpDY867BmM2YNdW1yCBqxocxNyWHCC19
	 5noQ8fSdBeYQiOpTHhMCJ+1tAnz1MxqcBkENIgczAgyljC1nwRM1GUMBPEMrtYuEIyYkq
	 ntwiq6wpVveU9WO9eBgcne8CZPDOVeuns8Ol/P6A8l0tYKzkrXP0Nyb1ab9IfQ2+jR5kW
	 QzzFEDB4TL+ZxxQFzWTzImEDjb4xd3G+yXimzou8kpURsO/B4cRAPD+HZEKpUKyhmslFf
	 7V9gKJXvd7cAzyLx4sMGiOjJrd5C6geSkATd74oJFosfDIjtGjGdeawn2lH8nTXLd9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=WYuD1bYg;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70145606A31E
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 20:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70145606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=WYuD1bYg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=OvHBVNFEaIP23Yj7JU5FUqxkZwdHXB2TgBTrhq4CMzI=; b=WYuD1bYgTITEbQ4VQyRCaWMP9i
	/7BTCdaBvtBEwGO4CLiWbb8F7ahELZrP/EdHfGvAagZI4bJmINRCsmagdrm8Ws4cdsihwO08AaZJR
	OiDpZ3TbnSNldds4bYj4NovAQv2gm9eGspttc8zX9M7P/+BE0yKv/v5h8aG3qGxGCYYLFojqq6upm
	HF3xKPx4m1I99GYLPlqVvsrYS+5/nPqgR9hgbohjuMyc3dbP1TJ+hlmKbfQ7NPn4pTaaBKnVAD/Ur
	V4Ht2xl5sThXvqtp76mko6osx0qXo0Uye6eUJEhG5Zrdy+KjG0auuFMxjypuUOGX3M6smJT7xfcWt
	T6F/cmpQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMWV5-0000000AJR2-1fmX;
	Thu, 29 Oct 2026 20:13:27 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Geoff Levand <geoff@infradead.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 0/4] powerpc/ps3: repair some kernel-doc comments
Date: Thu, 29 Oct 2026 13:13:22 -0700
Message-ID: <20261029201326.2672284-1-rdunlap@infradead.org>
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

Patches 1 and 2 eliminate all kernel-doc warnings in their
respective files.
Patches 3 and 4 target certain classes of kernel-doc warnings
but don't eliminate all kernel-doc warnings in those files.


 [PATCH 1/4] powerpc/ps3: platform.h: fix enum ps3_spu_resource_type kernel-doc
 [PATCH 2/4] powerpc/ps3: htab.c: fix enum ps3_lpar_vas_id kernel-doc
 [PATCH 3/4] powerpc/ps3: mm.c: clean up kernel-doc issues
 [PATCH 4/4] powerpc/ps3: os-area.c: fix some kernel-doc warnings

 arch/powerpc/platforms/ps3/htab.c     |    4 ++--
 arch/powerpc/platforms/ps3/mm.c       |   10 +++++-----
 arch/powerpc/platforms/ps3/os-area.c  |    5 +++--
 arch/powerpc/platforms/ps3/platform.h |    7 ++++---
 4 files changed, 14 insertions(+), 12 deletions(-)


Cc: Geoff Levand <geoff@infradead.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
