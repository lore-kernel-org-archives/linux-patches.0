Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831080;
	b=v2AWghzrpDa0PYeDWM27/n5pyQg83UovQSgodL+4R/M4mk4lAVBbnGu1vOM5av3CHZ4a
	 cU/y+l8vcRdKe2EV1WKAG1TigvcVbOV9zYB/x79XtMgsvhH9yAfP/5cNLnbYjz3fPPk+q
	 Q1iTxGpVmnyKnB2KY9Tv0Spw6bvlWOccKtFfNrn2iW9TCq5mqwB9MVXOEKfTarpNttubx
	 ryjxJYZ7rw1ivylXxT30753S6QuPQWe1EyH3ywuFFCbY5bb2p8KnF+M3d9EtTOD2FwxQq
	 /XJaDXNIxKtjqMDAl/DqqNiacDhJhtF55tJleZyATxc/yn8DRcBLAFmMNJjEAAMfSGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8hIQszmEdiUUOqqQHzThb0lWfoGrWavxZOvxz5ZiEW0=;
	b=RoQIIV5Sz9rlooFWNtYCDMx9Tlw4GUQcxI71otcLl271+uGJr2YmGCH5QgtopV6MngfL
	 YgXv1ap4Zs0Pn7jdEHR6s0/hbYP1Wo5EpErDL/f6IACN9l2268rMfwdglt+ygaARlABVo
	 7lCpj/xk9tKfP5JrUlPUJxE11y5yFY1yBVRitNOhe8l6Uo7HEl6rUIY2Fzt4gRaDyfaX0
	 SkprTlzTVd7uiiDDKVrZ3PObHmgvhposGmshr81NY4vmeHNhkI5SN/e/zPdngES2irfsZ
	 CmIVBRP3wsCuApuvzcrPu9+qT6B+lDnMPeYBH5nlsBCHOP/hWXnjZTNCRthQmFFjJBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNHh2kxM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0FF606AC29;
	Wed,  4 Nov 2026 22:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNHh2kxM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F02D1F00919;
	Wed,  4 Nov 2026 22:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831079;
	bh=8hIQszmEdiUUOqqQHzThb0lWfoGrWavxZOvxz5ZiEW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNHh2kxMoAueCr5Dav1WKRB8LYL6XpaZoDXmMmRjm6NYnOwtbolEtokq030jSMh56
	 cE9HaKK0lUleDesp2AvikyU47JHKfZz49S/bSfME2yfSL+xdUwIzR067Q+eERYiZZh
	 GTRwbY3d5pZMIE0xQSvndncVK8///iOMDmohyClI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0466/1005] tpm: atmel: depend on X86
Date: Wed,  4 Nov 2026 16:03:19 -0500
Message-ID: <20261104211057.071237479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 4bfacee94f309346bef0b598ea091088b9150af9 ]

tpm_atmel probes for the chip at fixed x86 Super-I/O ports (0x4e) with
inb()/outb(), so it only works on x86. TCG_ATMEL nevertheless depends
only on HAS_IOPORT_MAP/HAS_IOPORT, which arm and arm64 also satisfy.
There the probe is useless, and on platforms whose unbacked I/O access
faults it oopses in init_atmel() at boot (e.g. arm/versatile):

  Unable to handle kernel paging request at virtual address fee0004e
  PC is at init_atmel+0x34/0x244

TCG_NSC and TCG_TIS already "depends on X86" (commit 2f592f2a7d74 ("TPM:
NSC and TIS drivers X86 dependency fix")); TCG_ATMEL was missed. Add the
same dependency.

Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260712183234.23125-1-kmehltretter@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 8a8f692b60880..5f672f2c01b04 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -163,8 +163,7 @@ config TCG_NSC
 
 config TCG_ATMEL
 	tristate "Atmel TPM Interface"
-	depends on HAS_IOPORT_MAP
-	depends on HAS_IOPORT
+	depends on X86
 	help
 	  If you have a TPM security chip from Atmel say Yes and it 
 	  will be accessible from within Linux.  To compile this driver 
-- 
2.53.0



