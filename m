Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212843;
	b=kHqeYnTKHxoaf2rvvrAAySe4EzeixDQkfkQbDumBcqEIzOi4lw74bp4P/XuHVgEnO+dE
	 45M2zeCjBFoh1x71wSX2E2C3k021aLuzDAU2tgpfzK9zcDDjv9HabikEFl1zRxwt2pleK
	 uL6/fRM0yci2nHxyhb+Eybiz8mdT0j9fxmlPc9Ub8ifrcvhTSwlX1cQUCpJ/x4ELziqxs
	 2JavtFiom4LEn+YvAvLxMoGzJ6gsZq+R3lyQekpj1t8O6O1UQR+SeCqVa6rPAbAylxWeJ
	 B2wfSTVX/C5qJ1sWQBG99Jb+N7Bmn38JFrqYh0S2ixNBiS3Ee6aBHmb43gWnpjOJedg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=00V1HFVMQ5Sdw6k5/AkzMK4m3Wtl9yGAnKhw1EnyKXg=;
	b=DtfqhdmzlEQROar1B74GUNPW3bcMMklj9j6Fao/aHupo+L1PgkVhraSrzYwwcylSF0V2
	 aohb2/7W91bttAkDVd3WC0F3dWCN2qpEfdkHkTM7U1liND05C4JjRgCw8/EhZsvgf6M0J
	 NVeHoW2UX2+hdSRlrQ8893U9GuhJfgaPsQqvY447pEUvjFv/qzI0DfdnkVVAfTKrENHna
	 Fc4YEPEWgy3r6pxh+FgXwWEDJsnxOOdepO9YcB7EOLMZwVewFlb5U641dFvq8vBsEfmZs
	 xityGkhnpTGVGL0uG/y4Kbez5PMnp1Z4kIuyOpgAkEbWgJ3CxWp4chly1WDf8nYzEAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I58CHfp2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF271606A31A;
	Wed, 28 Oct 2026 18:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I58CHfp2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB111F01825;
	Wed, 28 Oct 2026 18:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212842;
	bh=00V1HFVMQ5Sdw6k5/AkzMK4m3Wtl9yGAnKhw1EnyKXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I58CHfp2lGrdUb7vSG0IIgT43vABmQyUJ/DTv7fz2+3lffK3ItHDPTWS3vOdfpOuK
	 GAcSuW7jMW3yR7M5PxOGvuufUC+VOYwvdzu3IA6WzfzUlnR46ggCAmqwABGGL87n4F
	 /AH8dUIKRYitGogSuxFSZNa5TX0yGPXsFYvTE7fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willian Oliveira <williandossantosdeoliveira287@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 0253/1887] drm/amdgpu/gfx6: fix firmware leak on teardown
Date: Wed, 28 Oct 2026 17:39:09 +0100
Message-ID: <20261028170504.989348802@linuxfoundation.org>
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

From: Willian Oliveira <williandossantosdeoliveira287@gmail.com>

commit cc172e177795c5f87bc2d71768d077e1c10633e8 upstream.

The firmware requested in gfx_v6_0_init_microcode() is not released
when the GFX block is torn down, leaking the firmware resources.

Add gfx_v6_0_free_microcode() and call it from gfx_v6_0_sw_fini()
to release the PFP, ME, CE and RLC firmware.

Signed-off-by: Willian Oliveira <williandossantosdeoliveira287@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 386e81346f95ab0be5a82c5535de932e7a456924)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -308,6 +308,14 @@ static const u32 verde_rlc_save_restore_
 	0x00000000
 };
 
+static void gfx_v6_0_free_microcode(struct amdgpu_device *adev)
+{
+	amdgpu_ucode_release(&adev->gfx.pfp_fw);
+	amdgpu_ucode_release(&adev->gfx.me_fw);
+	amdgpu_ucode_release(&adev->gfx.ce_fw);
+	amdgpu_ucode_release(&adev->gfx.rlc_fw);
+}
+
 static int gfx_v6_0_init_microcode(struct amdgpu_device *adev)
 {
 	const char *chip_name;
@@ -3197,6 +3205,7 @@ static int gfx_v6_0_sw_fini(void *handle
 		amdgpu_ring_fini(&adev->gfx.compute_ring[i]);
 
 	amdgpu_gfx_rlc_fini(adev);
+	gfx_v6_0_free_microcode(adev);
 
 	return 0;
 }


