Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2763011C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE73C433CD;
	Mon, 28 Aug 2023 10:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219784;
	bh=6m20xTcB8iTU+41y8enngSpXNbrjXif+e5NB6knalEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjHkww3D7Rr0mX2/Rcy+iNfygtGxG5n5BbKmip6/FzJJA+LkXK46EXjBAtdV0hVDk
	 NxcojRzSEa5aXjrRbGBJY+sz+72+9CY6SPDwlNHWxQvt4PGOG7QLt9MSyS6Urf1IKT
	 ZE/7kk6ZcPgA7gDZDySpO+j06NU5QfJy55QT+1+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 42/84] ibmveth: Use dcbf rather than dcbfl
Date: Mon, 28 Aug 2023 12:13:59 +0200
Message-ID: <20230828101150.693287373@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit bfedba3b2c7793ce127680bc8f70711e05ec7a17 upstream.

When building for power4, newer binutils don't recognise the "dcbfl"
extended mnemonic.

dcbfl RA, RB is equivalent to dcbf RA, RB, 1.

Switch to "dcbf" to avoid the build error.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -196,7 +196,7 @@ static inline void ibmveth_flush_buffer(
 	unsigned long offset;
 
 	for (offset = 0; offset < length; offset += SMP_CACHE_BYTES)
-		asm("dcbfl %0,%1" :: "b" (addr), "r" (offset));
+		asm("dcbf %0,%1,1" :: "b" (addr), "r" (offset));
 }
 
 /* replenish the buffers for a pool.  note that we don't need to


