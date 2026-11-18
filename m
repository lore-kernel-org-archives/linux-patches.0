Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045544;
	b=I/DMjcHATt4HsJ1nis5N747nYuQ8J0uKNS4oTGBwJwnksthuZbiTx7ItP4Ac3NkGIJMM
	 cuc8fOAEz5DQGpCVuIgJvGsZZo+jRWGnwai5dJu0wJjl537YZKE6JzoHZQMT1VeFWiErb
	 SLEO9sPQz7bYUAZzOAcC4zR3FrQ8z4hrPlyVawRsaLOwxTKBh0FZotCc77GgVre3TrruI
	 Med27Q1FdnHbz10OWLggPnzNnaxnyQSKl8j0jTs9sXC8tyk8PWhmBo89f+TTaL8gBOf0a
	 GKjt4dbiO6qvkKsFff+JqScG3+VhkltOVYfEBgPu4Yd9YRZLS8B33f0vIXmwhMlX1vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J5MRxa80KgEYXaJLHz0N4VlITWasYBtJAFFoQDJVYro=;
	b=lhL4QEsPk6LTkzVL1dztqjGiEDJfp7+UFoEwz6TayDFdmUZxHt3X3Pqe6GrIoQyqoES7
	 zAAGqVSdB+VPg1Wg//X5UgU4s006lo1MB9N1PR+lVvPJFfsnQTCsC+/I7CLpo1RcsfkA/
	 Mgp1jQH0tkrdif3f364NigrhSNAyjFIHka7TfZSPhZudBbk5DWYYx1qETUzzgJjtNc3+v
	 W28Kz1v7yR/YJlrsieHOkzBL25IpqIl8B9P+iakPwtmIvhS4bSNg/C1g08+/bosbqTrKK
	 sMpDbdnt4ADbpxYgM0bMep5sbuhRdG2V3/Y9E4yFGD6WLgSlS3y1otsNf6cIT+arEwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5JhMG3U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95D8606A320;
	Wed, 18 Nov 2026 23:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5JhMG3U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361381F000C5;
	Wed, 18 Nov 2026 23:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045544;
	bh=J5MRxa80KgEYXaJLHz0N4VlITWasYBtJAFFoQDJVYro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5JhMG3UKgft8AEZUlceAh7XPovNKee2MUvj8w79TeD/mr+jqZsq1v+fVn3cJRaTn
	 cC8NYYmNnvguUwGlJAHEZA/I6m2vAPJKgrh4Sao7LB/2Ja0V/0x3HnyU9bBlUT823f
	 g94B8deI7uMFXPv+j8nyj7IaLy0f2VfnzigPdaEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0961/2857] efi/libstub: Dont replace an existing LINUX_EFI_MEMRESERVE table
Date: Wed, 18 Nov 2026 15:33:15 +0100
Message-ID: <20261118150236.203278608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit aaf3ed0f46298e18ec8bc477cf0a37478e41f2ea ]

The LINUX_EFI_MEMRESERVE table is the root of a linked list of memory
reservations that need to persist across kexec, such as the GICv3 LPI
pending and property tables, which cannot be moved once the
redistributors have been enabled. Each kernel adds its own reservations
to the list that it finds via the EFI configuration table, and honours
the ones made by its predecessors.

The EFI stub installs a new, empty table unconditionally, replacing any
existing one. This is fine on a cold boot, but not if the stub is being
executed by a loader that passes on the configuration tables of an
earlier kernel, e.g., a kexec loader that runs the incoming kernel's EFI
stub, as the reservations made by earlier kernels would be lost.

So leave an existing table in place, and only install a new one if none
exists yet.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index cf474f0dd261a..b3f4d1e233dd0 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -86,6 +86,14 @@ static void install_memreserve_table(void)
 	efi_guid_t memreserve_table_guid = LINUX_EFI_MEMRESERVE_TABLE_GUID;
 	efi_status_t status;
 
+	/*
+	 * If an earlier boot stage installed a memreserve table already, e.g.,
+	 * a kexec loader passing on the persistent reservations made by the
+	 * previous kernel, use it as is: installing a new one would replace it.
+	 */
+	if (get_efi_config_table(memreserve_table_guid))
+		return;
+
 	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, sizeof(*rsv),
 			     (void **)&rsv);
 	if (status != EFI_SUCCESS) {
-- 
2.53.0



