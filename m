Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018059;
	b=Sjw4ThkHNIdaJP7YpbZ8ebii3cIqrya2wsHNo9W41HLnoMt8OYNTKtjupbnkT90ws0In
	 bVGCKJtO9QasYw3qLXfqwGoshqrLbwZSmgsp/w+yLPjEMlyRCA9EJ9vhLlTL7Vy+BLIMi
	 bz8JXzXgbn8DoF9Q0/OnbRePkxj/oMBIz+EQDeeLMBgQ3FEJ0PgGbXvwCr1K6+wlO8ken
	 vPYNfJJpeg4eUVrNKhbne/4AKqCId0AXQkdYF5qeIPdnvKDW1Ca18Lou+OrIRw6O6ltc+
	 Es3+9Zh6392NfmNcSe0mMQxulUTk0iwY25pblD0KShKlwa9WPtz/OdK961G8Kt4iDxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mnk3lykODxMOda6g2qxoVGP8p2sddxKQHTCOFinK5ZI=;
	b=lpBdPh7cWiYThSGsBtZimj2nkjeDGnU+19Fa9/6k+fv/vCrprINZbnceJdBiPfBrh8d4
	 Kc8wg5AozbosLah2EPPlqqLFf6YtL2IbLHByDOl3+6uxTHFnF62KEB/hUFqoCaxOzzDe0
	 BkTitz5tNNMomx1LfNVTg6CLX/8puXcUtpKv7z4mNKb0ODHTBbIEhyz4fxGft9EIyaP2A
	 kO7U7iOWjEqUoBq1/jvi6LIWNXkI9hhzAoQ9X2F+JkmFEYe1emQ9O//a3mztkE7kRQuSo
	 s2FcfDMSb3MummpDYRoa6mWgOqT1XqmhndUgdtJLPCI9k0fvuRakzfeh/PrRCViwN8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wdfySimp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537BF606A337;
	Wed, 18 Nov 2026 16:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wdfySimp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F421F000C4;
	Wed, 18 Nov 2026 16:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018058;
	bh=mnk3lykODxMOda6g2qxoVGP8p2sddxKQHTCOFinK5ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdfySimpXAlkXLGrQDHDFbSdDbAnygck58nOSbiwpXrtTRk1F3t2LB/rgfSD2KLzQ
	 lyMxmW9PCDokolHnDfqpk6RU0si7hRnTvprnJOcHNgUJ/W4FqG1NbcbI8diGIwPpSj
	 Wb1mcnHnV380VF1lUy0HOf+1PtPEnCMvPHAoPV/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1105/2651] serial: 8250: Fix section mismatch with CONFIG_MODULES=n
Date: Wed, 18 Nov 2026 15:39:05 +0100
Message-ID: <20261118150327.774496369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit c44a4925cdac02af781ebfae96df68a7bf3580b0 ]

Without CONFIG_MODULES, __init_or_module means __init, so
serial8250_pnp_exit() and serial8250_hub6_exit() end up in .init.text.
They are also called from serial8250_exit(), which is __exit, and
modpost warns:

  WARNING: modpost: vmlinux: section mismatch in reference: serial8250_exit+0x2a (section: .exit.text) -> serial8250_pnp_exit (section: .init.text)

The exit code never runs in such a kernel, so nothing breaks at runtime.
But a function that is called from both __init and __exit code can't
carry either annotation, so drop it.

Fixes: a300273c458c ("serial: 8250: hub6: Add cleanup code")
Fixes: 4cf187f9dea9 ("serial: 8250: pnp: Annotate init and exit functions for conditional discarding")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260926163506.487201-1-danishkhateeb03@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_hub6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_hub6.c b/drivers/tty/serial/8250/8250_hub6.c
index 4d4c54c951cb9..848d9723ac56a 100644
--- a/drivers/tty/serial/8250/8250_hub6.c
+++ b/drivers/tty/serial/8250/8250_hub6.c
@@ -54,7 +54,7 @@ int __init serial8250_hub6_init(void)
 	return platform_device_register(&hub6_device);
 }
 
-void __init_or_module serial8250_hub6_exit(void)
+void serial8250_hub6_exit(void)
 {
 	platform_device_unregister(&hub6_device);
 }
-- 
2.53.0



