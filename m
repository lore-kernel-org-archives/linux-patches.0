Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052672;
	b=czWG4hekWmbELlrDv9TS4KiCK7Uiujy8KA37P3KlWxfjgXe520sgImVp+ih3fU74Pi8S
	 rSW4H7YlLUL8JUyAg9MtKCiCHbaI8QPnyeBOP4H/b9Ic+nTWxQiCBCksXxmxwEYEdtuQA
	 rvNR3m9YqNDF/RcVnReY4Uni8EeRBwvBSfgGKr7jWpg5bwMGMNhIGQCifeZapdec+F8e3
	 G7850c4m4ha/nGHLhyJdcrqHmk+HGcGMEC4zB26lw716DOU5cdpGzSeZlKqcY8Sdr/kmf
	 JFWFtk4L3rs6mPC0j4G0xiZ4w1QzjRYgwPDj/5RkPt8b+WUlH5tOSfBbSvr1W5Fp4Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0SUAyEW+Zj6qLo7foHh99FB8OkyI6I2aRUy7dF9PjrU=;
	b=RnNhjVpuYFx7OlStsbALfJ4mDxkIJ9nJ2mmkWfcphVzz1cm5Zsuj8UmWeI6UqHin8Up9
	 J97k7HyNpSMzaJCEmKuioUaZLgbal4ZdZv3BYerBYXwEgJ8fs5NdJ0qfdx3mQH+eSlwZC
	 amem1kVB6IeykYBtImjtgQN8EpWUWIcXQxwlIMk4uVwBFUvLo3fxqcr/cOSpJzYBRF60z
	 9tTwFnn9IFlL3bCARWj3wDlQxSBulaPJ232cCd92aLxqtST4SahJxLCVW+NA9hykEWQKZ
	 oqU5CWM0NcRz/2Pe3EgrdORVFfo8VlxWIBVtkBhvtIVb7Ox+3wtD9T7ppKiDSGwkRrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbElcraI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E92606A332;
	Thu, 19 Nov 2026 01:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbElcraI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9901F000C4;
	Thu, 19 Nov 2026 01:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052671;
	bh=0SUAyEW+Zj6qLo7foHh99FB8OkyI6I2aRUy7dF9PjrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbElcraIZvX3KWGGU1hxXw+/eWaJwdt9LU8sHsX3AGVwsiRqzcvIHhmIVYNMILa7X
	 xCINKMY2C4vQchyHm4cfvauBs4CdEkoGA9Eu+BPQ/g82WsXOfoqe/ZVy4F252VF4v8
	 hbA4AyJ0oOMopSpvlyvfXtq6WUiURxNmeDZgDxQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0647/2214] efi/libstub: Dont replace an existing LINUX_EFI_MEMRESERVE table
Date: Wed, 18 Nov 2026 15:38:43 +0100
Message-ID: <20261118150037.245022401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 26e69788f27a4..31730075ef5d7 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -79,6 +79,14 @@ static void install_memreserve_table(void)
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



