Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6C027F755;
	Wed, 23 Apr 2025 15:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420944; cv=none; b=aWH4uQX95Ye6xXiDJQErsVEWBm5yokSfUnZF72R0PzlONzGn9LjCid2Fc+gi6o7g0O3Mig9MJp00Q+P1zmEsAJq26q0OsgxF64Tlr9wSyWw23lF1RYvw83v0YW6UbM3EnLSnq8E+srblwDD069zwCC8w9ASIbgJ9kBSWk/qiI/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420944; c=relaxed/simple;
	bh=PEJBQuGnaJoaxM05psf9xb0icsSJbSCuaOocjAeGbZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMLXyaedZ7OBvPQBPjSS8QNPr+OLaNooDG592E7HJ+4Eo64H7phoge/bRmwnFuzlIryoiAaPjAuQhAUkfgio6Hfx8HYUIL5BPPE5BC2FEnNtE3RFDgOXJlG64qp3MXE9PhhY0BcWpFKk9Tq/EvSqxo3dH2KMQFmMYa3NT+wOk9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4mIs7gP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4mIs7gP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F98DC4CEE2;
	Wed, 23 Apr 2025 15:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420944;
	bh=PEJBQuGnaJoaxM05psf9xb0icsSJbSCuaOocjAeGbZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4mIs7gP1pq5/zAW9X5khS8rZ8p0/hUraNTHAgY1XXLpGdg+5Fzdy5Tud3eau5z12
	 rMIzk6OXzbnPCH98YCzyM98EjLGhLrjU5NlnVF4UxrZHj2wrxsBJPLL933ejhSS2Fj
	 8aHw7UpPMM57cu6IXKMPiUCXrKhn2hzFt37vqjMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Nicolas Chauvet <kwizart@gmail.com>,
	Damian Tometzki <damian@riscv-rocks.de>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 176/223] drm/i915/gvt: fix unterminated-string-initialization warning
Date: Wed, 23 Apr 2025 16:44:08 +0200
Message-ID: <20250423142624.341337929@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

commit 2e43ae7dd71cd9bb0d1bce1d3306bf77523feb81 upstream.

Initializing const char opregion_signature[16] = OPREGION_SIGNATURE
(which is "IntelGraphicsMem") drops the NUL termination of the
string. This is intentional, but the compiler doesn't know this.

Switch to initializing header->signature directly from the string
litaral, with sizeof destination rather than source. We don't treat the
signature as a string other than for initialization; it's really just a
blob of binary data.

Add a static assert for good measure to cross-check the sizes.

Reported-by: Kees Cook <kees@kernel.org>
Closes: https://lore.kernel.org/r/20250310222355.work.417-kees@kernel.org
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13934
Tested-by: Nicolas Chauvet <kwizart@gmail.com>
Tested-by: Damian Tometzki <damian@riscv-rocks.de>
Cc: stable@vger.kernel.org
Reviewed-by: Zhenyu Wang <zhenyuw.linux@gmail.com>
Link: https://lore.kernel.org/r/20250327124739.2609656-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 4f8207469094bd04aad952258ceb9ff4c77b6bfa)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/opregion.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/opregion.c
+++ b/drivers/gpu/drm/i915/gvt/opregion.c
@@ -222,7 +222,6 @@ int intel_vgpu_init_opregion(struct inte
 	u8 *buf;
 	struct opregion_header *header;
 	struct vbt v;
-	const char opregion_signature[16] = OPREGION_SIGNATURE;
 
 	gvt_dbg_core("init vgpu%d opregion\n", vgpu->id);
 	vgpu_opregion(vgpu)->va = (void *)__get_free_pages(GFP_KERNEL |
@@ -236,8 +235,10 @@ int intel_vgpu_init_opregion(struct inte
 	/* emulated opregion with VBT mailbox only */
 	buf = (u8 *)vgpu_opregion(vgpu)->va;
 	header = (struct opregion_header *)buf;
-	memcpy(header->signature, opregion_signature,
-	       sizeof(opregion_signature));
+
+	static_assert(sizeof(header->signature) == sizeof(OPREGION_SIGNATURE) - 1);
+	memcpy(header->signature, OPREGION_SIGNATURE, sizeof(header->signature));
+
 	header->size = 0x8;
 	header->opregion_ver = 0x02000000;
 	header->mboxes = MBOX_VBT;


