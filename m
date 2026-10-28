Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212533;
	b=GWI50j036i87iHGpHMq+7B1kF87Fa9a/NfvvmoLXH/7HE6dcA+y9iZYIX3J8BR8J+Pgg
	 G5rVPZLrHA6cqHPMZelzCTOCdB0LG9mZ4+QDJmZFo5zSqft6yvGedVCLw9l2NCV/h6vWP
	 wIN1tFFt4dBxDrCc3PBy81qmzinntIHKIOuLiz4fgBrQQaYf4NRymYQ+AT02JNoiLAvik
	 90tNRqo2v8EVbJQbqvSYrHSVL33zAfXUWoC9/S0CvA3b5NXuPIGW0nzokFiObFi0kmxqK
	 gfG7S6Ur8BR+sObE2RSIn6+1ertPQDZZb9DGrAd6dUiFoNlUAX6klamjbmai2VCguqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jP8LvkG3gW1Nuogkrfz/zYbYDOUb2bY4HOSxrA6h7PY=;
	b=ATgfvE71Wr3ugiYK3WAhGd08hPwRxIx6L1Q/umGCSBpZI3P/NjA9fdCHW7+cGwvuZltT
	 6+MLY2K6it7S/FF8jmhVhlAgvJL1f3VEh4e+J4bt2rj8nhqGwrwrZZ3Gxrwjmps6Hzg0l
	 wyGAnwWeaIJpSJ6qbdkFIyMLBQf6UitQyS9MGvj7OquZl2MF2GvvyU9dKYDObwo5Ogvzq
	 WpaN1KhOX9QQ6Nj0zF8Y3V1CqIYww48t+cg6u3PUbsLIcRA3Pyc3GlDudY0B/3ZsDMjy+
	 FCNzUnbU9dW/8sQSmLMv19jiEypwb+2Rh+99zylcMSgZ8NG1VlZ7+Yle3GkI/HdozfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZzfcOYtD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7D8606A31A;
	Wed, 28 Oct 2026 18:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZzfcOYtD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F349D1F01825;
	Wed, 28 Oct 2026 18:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212532;
	bh=jP8LvkG3gW1Nuogkrfz/zYbYDOUb2bY4HOSxrA6h7PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzfcOYtDxbxK3LZF0Ri45ZLo1IezPrdZNCN17H8hONQ7RDPSzxJTTldRnKDDNfOYY
	 c+aNe00DYhvskXhvhMs718HHzfoEuDemdrVvBiOA5vT9k6tBI1lBlqfs9BLMf/8B1m
	 ZR4p2D5iPU4pUtXkdj0MjzdJPqKQhQ0p15cvF6GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0186/1887] x86/CPU/AMD: Clear virtualized VMLOAD/VMSAVE on Zen4 client
Date: Wed, 28 Oct 2026 17:38:02 +0100
Message-ID: <20261028170503.468434197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit a5ca1dc46a6b610dd4627d8b633d6c84f9724ef0 ]

A number of Zen4 client SoCs advertise the ability to use virtualized
VMLOAD/VMSAVE, but using these instructions is reported to be a cause
of a random host reboot.

These instructions aren't intended to be advertised on Zen4 client
so clear the capability.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219009
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index a61606a614bd7..8d9c067992e5f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1161,6 +1161,17 @@ static void init_amd_zen3(struct cpuinfo_x86 *c)
 static void init_amd_zen4(struct cpuinfo_x86 *c)
 {
 	init_amd_zen_common();
+
+	/*
+	 * These Zen4 SoCs advertise support for virtualized VMLOAD/VMSAVE
+	 * in some BIOS versions but they can lead to random host reboots.
+	 */
+	switch (c->x86_model) {
+	case 0x18 ... 0x1f:
+	case 0x60 ... 0x7f:
+		clear_cpu_cap(c, X86_FEATURE_V_VMSAVE_VMLOAD);
+		break;
+	}
 }
 
 static void init_amd(struct cpuinfo_x86 *c)
-- 
2.53.0



