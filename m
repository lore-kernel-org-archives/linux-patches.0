Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039754;
	b=DNXHMg4Dsm2FeHBBAwaeuIO8no8hwb8T3LOYZFXA1s3FltM0Mv0mSWqJmOqkCsAGD0d5
	 aLqca7ibVFFyxHceVI3Wkawjw7S95KRp3RmJVikblUeOfcJxLwhhtOVr29co5/RCgSDym
	 7IAQlZzO5Qp11ABufmAlfwm57nSaVucXeK8zkeS/f0CbiOCDea5pyC775iISLkeMfQ2Aw
	 xGaUTazPPQyLaeJTDSCVVsGhdI23oZfZ/SX98JV9uGlr+LyVD7gdhfU8vBq0B4enYzbOj
	 9quuFKnssMlyrrjcneVcp/Xmivl2lQeMandDZUtQvueAxZ8rehy5Y9nzLNOoC3gRwxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AdiKm+L/YoeUyRDgBsJbg37evudS0NUEiq/HHmygtJg=;
	b=em3rpzhg61ig+FZwzhDr/hY/9aZdIzezrhfAaKEgNpEXoVPRQmXGpDKxlF5/1Rf216Zl
	 Uwk97qY/XOykVlUfIPlNZW65dNo67EApE53dN4B3o2VAzJDRNFmV/vM0NzmwPejIIFOXx
	 VQkC9+Mea0IRmsQwQ7N89e+8wrpoSHQ9idISRwdZ1baJxmLb4FjZ+ySO0uDQV3RU9WOxI
	 meNPq9RpBq11FiABSwuPiRMu4jXGd+LlyIbg3fdfehN9hktgvlvyIpetFuOBwwMaJfzCs
	 FSXq0+BLRFHE6NdSrfT/BTSd0PICUmCocMN+BLYHYo3gIkwp0vEEO6flVXeIUvyzTeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJ9PLzQt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F72606A325;
	Wed, 18 Nov 2026 22:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJ9PLzQt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238E01F000C4;
	Wed, 18 Nov 2026 22:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039753;
	bh=AdiKm+L/YoeUyRDgBsJbg37evudS0NUEiq/HHmygtJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJ9PLzQtIEWMKzejRIa/tlrtH0rOh9cw8ba8yqP1elh6TJ/6pwf+6awDzKr9iNPGD
	 qa4FgRX3FXzfRy2OxaOKjKIHZbgDNPk8YaeSd5j6HoH5fF0pBMtdRUuRqkbu+7giwy
	 XUWUFbXuwQtZPCuAyHFeAGNMviTtCxG4ZBUVsiyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2212/3318] microblaze: Pass -m{big,little}-endian through KBUILD_CPPFLAGS
Date: Wed, 18 Nov 2026 15:47:14 +0100
Message-ID: <20261118150428.269985129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit b9eababe8c0b9f71ce7f35f903879a7fcb6daebe ]

These parameters are also necessary for preprocessed files which do not
contain code. One example is arch/microblaze/kernel/vmlinux.lds.S which
inspects __MICROBLAZEEL__ for the definition of 'jiffies_64'.
As currently the endianness is not passed from the build system for this
file, the preprocessor will instead use the default endianness of the
toolchain. When a default big-endian toolchain is used to build a
little-endian kernel, that kernel will hang during delay calibration
as 'jiffies' never changes.

Make sure all preprocessor invocations know about the correct endianness
by passing it through KBUILD_CPPFLAGS. This will also be inherited by
CFLAGS and AFLAGS.

Fixes: 02b08045a030 ("microblaze: Add support for little-endian Microblaze")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20260914-kunit-microblaze-v2-2-7d5756e858f8@weissschuh.net
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index 02e6be9c5b0dc..9087a366ce789 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -34,12 +34,10 @@ CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_BARREL) += -mxl-barrel-shift
 CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_PCMP_INSTR) += -mxl-pattern-compare
 
 ifdef CONFIG_CPU_BIG_ENDIAN
-KBUILD_CFLAGS += -mbig-endian
-KBUILD_AFLAGS += -mbig-endian
+KBUILD_CPPFLAGS += -mbig-endian
 KBUILD_LDFLAGS += -EB
 else
-KBUILD_CFLAGS += -mlittle-endian
-KBUILD_AFLAGS += -mlittle-endian
+KBUILD_CPPFLAGS += -mlittle-endian
 KBUILD_LDFLAGS += -EL
 endif
 
-- 
2.53.0



