Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208810;
	b=EawwjfNcwhUPOBUFwjzAxUEpvEkGb3jB2iGrqYUUnLsSoDmy1czhk6KDwHOzA5aDH9nv
	 ii/h3praYJIh5DkLQHJXtM0PCPSnq7BCtqJYN3uwKqLGu/OWgTxXtHXJOn85V4Xg0Q9M0
	 mZu+1SqjxU5IwQRAMv23101XNTyJ3yuuSH+SqRUQ8EHNnEcS1esLWZLyaLDkPBVt7eVO5
	 iJp684Fr+hbMesvWf/NxbH6L5RHQ5jZJufgoRA42cIc7VNXcHRoTTlvk7UJUFZGA1j6cS
	 HN/1abIwrbKBT6XrVnz11b/cIwoqQ+I1BTCB314yaLSLCuYd1VLcT7O/BGfZmn2dm3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wm6FEJexsr6hP+dzjL9Dk1k5FVTCSx/LCOQT/Hdbymk=;
	b=wHPmM+dD2FQf4b6irr9R551XKLn7sxeuAUjTu1cKnHuiAZsigqWkck4CisGl1sbGxgtk
	 s4LQ0yAqtreBzCAkjW0P1DSqtAoL2/99jzaG92aV6Ii4cKN3gsOyLCggiw61S+hKIterU
	 57vf97btP2zYdD8pSJCsE1cHS41awATLevNGdPHKwlbS8KAjrBrmiIIUgFW3E3Dmk/WxT
	 NpjOgErRg6BXsAUaKkIXoAUGAM2pMDvnrTj3ob0ZLWhaxzIFGuxylZDJpc6hg3G1wp9Oo
	 FfFdtzgDurRLa7w6tv926GN0qA0T5T32NYi32KYDOGvMc9Pb7s34+Bu2LgRq97fLbOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zPMX+bBw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C5B606A31F;
	Wed, 28 Oct 2026 17:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zPMX+bBw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B341F031E0;
	Wed, 28 Oct 2026 17:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208810;
	bh=wm6FEJexsr6hP+dzjL9Dk1k5FVTCSx/LCOQT/Hdbymk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPMX+bBwv2cEDDqS1PPZboKL6KBRy2MJnbYWfW2ogOf7fWtGlmTt3vqZnuvAJP7or
	 jgu/c3N4OQa00iOWNG1xWuqbjRwvZ93Qjp9ZcTt/yBU2gDknDeCiSm58Cm95gsvpKt
	 wQMFHysJg/k8swFlJixvdNcacrk5nDIHCp+Y8WiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.10 251/516] page_pool: always add GFP_NOWARN for ATOMIC allocations
Date: Wed, 28 Oct 2026 17:56:43 +0100
Message-ID: <20261028170009.442638312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f3b52167a0cb23b27414452fbc1278da2ee884fc ]

Driver authors often forget to add GFP_NOWARN for page allocation
from the datapath. This is annoying to users as OOMs are a fact
of life, and we pretty much expect network Rx to hit page allocation
failures during OOM. Make page pool add GFP_NOWARN for ATOMIC allocations
by default.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250912161703.361272-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 09d98fcf669f2..1e3422c486c6d 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -185,6 +185,12 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	gfp_t gfp = _gfp;
 	dma_addr_t dma;
 
+	/* Unconditionally set NOWARN if allocating from NAPI.
+	 * Drivers forget to set it, and OOM reports on packet Rx are useless.
+	 */
+	if ((gfp & GFP_ATOMIC) == GFP_ATOMIC)
+		gfp |= __GFP_NOWARN;
+
 	/* We could always set __GFP_COMP, and avoid this branch, as
 	 * prep_new_page() can handle order-0 with __GFP_COMP.
 	 */
-- 
2.53.0



