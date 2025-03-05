Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A76519C542;
	Wed,  5 Mar 2025 18:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198360; cv=none; b=GFeT6kmUGyknxelUpMwZPRlZ9o85LaH9UTnDlUo75iNFneGbuSPWYqFl5ot+8cXBxx7AS5rvK0N+NQhwUM/c9y4XNsjmMzZaOA8cUWr7uLAfQ3mh1ipnF+/cIjrImV3GLgGj31EjC01OzvnOYC6dxRVflKE6t3OnhKMYZDGnZ0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198360; c=relaxed/simple;
	bh=URdcrTxlgASYIyHXVEh7EOS6tUVlG+MwojLNqSkKZ2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhxiHRpmd82ThC1+oEn2WllcGsr+KCwRDj8w1vodQdp26vaV8Yv+Da90h7kH2ccDUSx4gVGuKL9tDxcLFAqaGN8UETbawoCiiG0sDTDREdpqkDy+DleHdqfRcLyzEVlK4dBzWrUvDUlQDJixYqW9RbvCZ1v3HY4+5b/uITPhAOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyeq60Qi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyeq60Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D64C4CED1;
	Wed,  5 Mar 2025 18:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198360;
	bh=URdcrTxlgASYIyHXVEh7EOS6tUVlG+MwojLNqSkKZ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yyeq60Qi5OUVGdY9FHI36jbem5bEZ8oOd04SknAT8F6E4+8/7zpfVp6Q4QUgR8t0B
	 1UkR4q9i4uNvYTCfkDRtTIU7oba8yaNUtbaGKUYSnKb0JIylWPKWyqlPgLuJKqbor2
	 rN4t5PehyjmQQXxw0lAmmg6TSrG7uZiXAu+hjC4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 145/150] x86/microcode/AMD: Remove ugly linebreak in __verify_patch_section() signature
Date: Wed,  5 Mar 2025 18:49:34 +0100
Message-ID: <20250305174509.641678088@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

commit 7103f0589ac220eac3d2b1e8411494b31b883d06 upstream.

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20250211163648.30531-2-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -246,8 +246,7 @@ static bool verify_equivalence_table(con
  * On success, @sh_psize returns the patch size according to the section header,
  * to the caller.
  */
-static bool
-__verify_patch_section(const u8 *buf, size_t buf_size, u32 *sh_psize)
+static bool __verify_patch_section(const u8 *buf, size_t buf_size, u32 *sh_psize)
 {
 	u32 p_type, p_size;
 	const u32 *hdr;


