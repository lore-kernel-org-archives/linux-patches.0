Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031196;
	b=b6SiHInrQTlXW3JPm1bF89RlJcqBPoeGwU3g00BLh/pLr/baii4oHHT+elBhfuGveReL
	 jfBtKElPrP0TA2/4Spf9fHjFn8rmuuVl141cheseNf4MkvDBQSv4pjLVzpz17gKD/hdbN
	 /wiCEBkmo86XBoxR4dBWwRsG4x8l6ITHMrJ7vGLvuLeA3fKEZ1MUaRaEcpBqmgvA08oVL
	 wiGgRAwfBk5b/o/sYMp4qCLKXAIH/VItmqa9GgF11QL0egNeuZSmNxb88UwKzgkLCvbUL
	 U/HBQYWiJCiV5zqqL6CWY6qXkuG0cmJOdfPdBTr9O83iYbdLQGadcJQeGMpRBbR0N9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7SHTnr8kf+2fo9BJf3X0IB7unL7QbyAqz8bnMN2+l3Q=;
	b=1xJiJ5S1EAmFWHp0wC2reeCMEDlR/kCvlm2ejWLsAuB8vjge9TaLQaEa/bFMTKMWYdrF
	 tDtSXRCqgxJyVJoGiUI+1bB/jXNIFOiAj7skvbSiDLivoKAsdRRf1pN9fP6axYhORzvw0
	 453S0DvMgVjpqUJ1eE5FM8mGUlqaKnAZ4I1AHBiEuh7g88Kj3r7rKIqNWIi48SB3vd0Fn
	 EZGrNkWFPGVTUNMft8DvyFHuB4znQBZ9dRoD0+CYVhHLVuz9BaHzGXxkZPUvr4OEeJwt+
	 Ck/2p+iFJ6qQpaqScY75kQgixT1Xl00Z91f1ID1+By3Qkw+0B1GLPNsjhCmLwOlJggA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ojvVMq/g";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BCE606A320;
	Wed, 18 Nov 2026 19:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojvVMq/g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52461F000C4;
	Wed, 18 Nov 2026 19:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031196;
	bh=7SHTnr8kf+2fo9BJf3X0IB7unL7QbyAqz8bnMN2+l3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojvVMq/gBUXwH/C3oQ19JmjNdaCX4+GsYnhiIMJAwWC1FxxZOUOBBZc7Ze/mQYPQT
	 aOuK3MLXORoV4XFQBd7uh5HBry/GRiMcJGK0J1yBUoq6PykpBW6kZguDOUjIHO9Iro
	 gQHBlZcMaLFRjJSyIG9rMGwnR9/g5/BLcTLJUlCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0921/1756] efi/libstub: Free cmdline_ptr in efi_pe_entry
Date: Wed, 18 Nov 2026 15:50:48 +0100
Message-ID: <20261118150046.644870698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 8ea857a2bb547e388e86ca42c58a97e162e09f83 ]

Sashiko points out that efi_handle_cmdline() allocates this memory and
hands it over to the caller. If efi_pe_entry() ever returns it should be
freed. Add a __free annotation.

Fixes: 42c8ea3dca09 ("efi: libstub: Factor out EFI stub entrypoint into separate file")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub-entry.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-entry.c b/drivers/firmware/efi/libstub/efi-stub-entry.c
index 2ebb81fd9f42a..06934278677d6 100644
--- a/drivers/firmware/efi/libstub/efi-stub-entry.c
+++ b/drivers/firmware/efi/libstub/efi-stub-entry.c
@@ -36,7 +36,6 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 	unsigned long image_addr;
 	unsigned long image_size = 0;
 	/* addr/point and size pairs for memory management*/
-	char *cmdline_ptr = NULL;
 	unsigned long reserve_addr = 0;
 	unsigned long reserve_size = 0;
 
@@ -58,6 +57,7 @@ efi_status_t __efiapi efi_pe_entry(efi_handle_t handle,
 		return status;
 	}
 
+	char *cmdline_ptr __free(efi_pool) = NULL;
 	status = efi_handle_cmdline(image, &cmdline_ptr);
 	if (status != EFI_SUCCESS)
 		return status;
-- 
2.53.0



