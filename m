Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064381;
	b=LBS8NRQFv30XLIsBMYWZ6FP8jnlSh6zUiTlFHTzBAoZzLyHt16NC4mn+Ve1DM5SLvc+d
	 Z6ecgw1D57AGOZJpZkxdtgdbuwL/PqdrGL+cXkNrLgbBMfA88dZj14tWYgEbSWgSeHh9p
	 x9Xi9apxDM5EeGOqXZ6xBN+rFMBW9/4nMmfj66e1j6MD6iRRqml+qVHaA4HLVlzd32oy6
	 BkugzxRXhs3ndTyTBOZpD4NLlneH0fWr/AJo8kVY5I4y0r3mJPKd+Z+dptiiur/JzH7Ve
	 hkKfaaHC6jXs2xBtY8zyvkIlmfQ7F51FHktKnqE76SjWaKwKJB6IE62kN0TKpz6/sgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WanRMcD8w8o1wl7mf+yo0gqk7dZw6YZF38rOCfjUx7M=;
	b=OMxozgx6aWUtS58Z6MwB6ChRvfoRs2fDlQxL4+vBQ1HG2vcZA6YhJT/tYKUwenq5WQSz
	 wMYQtV4i4X1kH6gUgqTwSx2kUz5Gi0Y6V06CjDbERawoimI07jqSLD7qRw44exwlwtkoE
	 eZOZbtzbD7J6KlX6SkxglqGt4l4xkaCgsLhP47O5DasD1s8wUuxQZYb5zmlMNI3Gma4Xz
	 SGHdjbGszUqfHukTuO3h5cVgYQko0ZttE1hk7yMShrFXgRXTdx5waQwfJfDvadvbE6zqI
	 99OE9AJbFbFxOOsMBGkklT7BYZ85XAnoQbjp+FYIk3GVlJ6T8ebbLYdDY9aqWiKrOng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1cKZH32o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA01606D811;
	Sat,  7 Nov 2026 15:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1cKZH32o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CDE1F008A3;
	Sat,  7 Nov 2026 15:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064380;
	bh=WanRMcD8w8o1wl7mf+yo0gqk7dZw6YZF38rOCfjUx7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1cKZH32oKasYYcFZ7j4yRoUzv91P3KSWacQQK44+N2mj47IdFf6Lo19XRmi1L2aTi
	 Lsy7PdkloX4UQbuh6MK9VCAWJJEqgzcWdXPSSqN+n1lzo3WqivpPaLUx4HxfjChscV
	 /frOX2DnK/R6qka/0IEAMenD5A8bqMagdtF8pO+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0422/1257] KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs
Date: Sat,  7 Nov 2026 08:45:18 -0500
Message-ID: <20261107134951.155738193@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit 6c29285e78b5e4811145ebda382ac0ba732ce56a ]

Protected VM ID register emulation leaves unlisted fields at 0. This
creates two issues for TGRAN:

  * TGRAN16: 0 means non-implemented. It prevents 16KB protected VMs
    from booting even when the hardware supports it.

  * TGRAN4|TGRAN64: 0 means implemented. This may falsely advertise the
    feature even when the hardware does not support it.

Advertise all the TGRAN fields in pvmid_aa64mmfr0 so that the hardware
support is properly propagated.

Cc: stable@vger.kernel.org
Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260928095454.3255918-2-vdonnefort@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 8758c68017765..ec469d96516a5 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -121,6 +121,9 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr0[] = {
 	MAX_FEAT(ID_AA64MMFR0_EL1, SNSMEM, IMP),
 	MAX_FEAT(ID_AA64MMFR0_EL1, BIGENDEL0, IMP),
 	MAX_FEAT(ID_AA64MMFR0_EL1, EXS, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN4, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN16, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, TGRAN64, IMP),
 	FEAT_END
 };
 
-- 
2.53.0



