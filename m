Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064949;
	b=l+14l77hAVgYUWVP1XY/KXW8HyM1gYh/UQecyL1VsRsnN5DotR2W7DoLelChXm5NTIQU
	 c5JubIlEe1ETUM4Lyn+fkzCkHfJSdarp8JDBlqrNLrytqS632gVATZuyYIWbPcGWB4X1n
	 ofIJ+mPNaHn3oC8r2/4x65+a9ZKOTcd54uDeMeyUicmN2lzeqK4ATgiEZpsZJgajLuMyi
	 LuA/l8/n/o2kvEqmskaxsgh9E7/KJUJo1gqvR3O+nbquY31fuazVToaqQ7yvblUHw/TMS
	 mmQNlOxN0e+5JZL4cRag0fNddoS+d95Qh5CSBtDJn2ATzj2a9XmGMqjUDrISfbAp8Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MKGDx/eMqbQPO3DlSA4Ap5yNeTOAMhiAkFGZlMUfB4U=;
	b=SXDgT9T12MhmLrRqNScs8ck6M72ZQ9XhlFKYmdx+xjym+4A+TAeSmkMo74hGOdutU48h
	 mPlqIzd3kPhuV3Bwbal+rBSf3J/xDQwgYgPbZeYLgqXj3nF8f3xAKpHeQiqC3GtHFZEhW
	 jiyvs81YiVu/mLkbO6yTCqqXvUBzkR/4Re+6Eo8PmZrN9SoQP312LmeFvpZfF1wXQSwak
	 QPqAL5Ex5/yxV3iEMVDtVIUbNrHYtehjqC4bm/IxQxZ05ra0NPYBkxmAkxUnbyUJHIr5e
	 oxkG1V4B1xRvQMWIhzTOos+kWDK7rQ3wAbPBuML7rNEWRPE2HWnQZEaR71XcNvpLu1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JgH+9SG0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC19F606A9C0;
	Sat,  7 Nov 2026 15:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JgH+9SG0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892671F0089F;
	Sat,  7 Nov 2026 15:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064948;
	bh=MKGDx/eMqbQPO3DlSA4Ap5yNeTOAMhiAkFGZlMUfB4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgH+9SG0n3CTRqSDtZ67wb00Y+GKvN6vu9Z5CbY/d+ShUlddXO//pFaDcqmHXqq5c
	 +8ZZF7nAVOYcpj5YGx+tU+wSmdkO7y1q5x7O1hPu/LkgIoa+yn0qBuC1SRCXnYdsWV
	 8lgnza1jcPZPc6/7U9mxvTnu0C57w8Kw1I7w2HoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0797/1257] efi/libstub: Dont replace an existing LINUX_EFI_MEMRESERVE table
Date: Sat,  7 Nov 2026 08:51:33 -0500
Message-ID: <20261107135001.340714198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 42d6073bcd062..a4cb39656b031 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -83,6 +83,14 @@ static void install_memreserve_table(void)
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



