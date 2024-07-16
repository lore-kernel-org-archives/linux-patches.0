Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD053195B27;
	Tue, 16 Jul 2024 15:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145549; cv=none; b=majj1Q5i66hMxVeLONvUlY5xN6jvWtGjkpRNxAszA2sK8bEPbKO2DCC5/XMv+4nEDgTvud8HTW5+ZgymeYSKEXQZmudPp33OG8R2yHSeAC5veMdvew//X8aZmNZRrs2U3B++SFpXFaXn7m5nxueJ1vI33jsGkUYIFFq/CB9qTCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145549; c=relaxed/simple;
	bh=1auSytn9+oVK/SgWmqmKdsWxcsAH8uD4jMy8gC9MHCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7RgeIP8LLzquVIFuEflGWkSA27CvIwla6j9wAnbqXAs1DYUN6d1yIPaRGvHPjIM0XFOYJc4qwPddT/M2K6V/NuDTYgV3ebrB46rzmSOI7F5MHntnlj4BwsJAjdlp0Ez8BH3nRtChfQ3s5JDguV337KdpZ5qy2rLdAbLGe6LWLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uj6VoG/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uj6VoG/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522C6C116B1;
	Tue, 16 Jul 2024 15:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145549;
	bh=1auSytn9+oVK/SgWmqmKdsWxcsAH8uD4jMy8gC9MHCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uj6VoG/5VMnVKsfdEjfsOLnbr6rfKqqF4FSI69KO6WcXPKGJ9+7Dh9VmUQSzhvX42
	 owAI7dXT8HwW03IwcyQ8SayRaZk78FMj2XK+0N8rcagDsbe0SP4sc3ItPTMjDeew2I
	 UtsZMbFmgccamH5xywOKg5Co3gpe3HffGmiI8HrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 73/96] wireguard: selftests: use acpi=off instead of -no-acpi for recent QEMU
Date: Tue, 16 Jul 2024 17:32:24 +0200
Message-ID: <20240716152749.318831016@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 2cb489eb8dfc291060516df313ff31f4f9f3d794 upstream.

QEMU 9.0 removed -no-acpi, in favor of machine properties, so update the
Makefile to use the correct QEMU invocation.

Cc: stable@vger.kernel.org
Fixes: b83fdcd9fb8a ("wireguard: selftests: use microvm on x86")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20240704154517.1572127-2-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/wireguard/qemu/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/Makefile b/tools/testing/selftests/wireguard/qemu/Makefile
index e95bd56b332f..35856b11c143 100644
--- a/tools/testing/selftests/wireguard/qemu/Makefile
+++ b/tools/testing/selftests/wireguard/qemu/Makefile
@@ -109,9 +109,9 @@ KERNEL_ARCH := x86_64
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/x86/boot/bzImage
 QEMU_VPORT_RESULT := virtio-serial-device
 ifeq ($(HOST_ARCH),$(ARCH))
-QEMU_MACHINE := -cpu host -machine microvm,accel=kvm,pit=off,pic=off,rtc=off -no-acpi
+QEMU_MACHINE := -cpu host -machine microvm,accel=kvm,pit=off,pic=off,rtc=off,acpi=off
 else
-QEMU_MACHINE := -cpu max -machine microvm -no-acpi
+QEMU_MACHINE := -cpu max -machine microvm,acpi=off
 endif
 else ifeq ($(ARCH),i686)
 CHOST := i686-linux-musl
@@ -120,9 +120,9 @@ KERNEL_ARCH := x86
 KERNEL_BZIMAGE := $(KERNEL_BUILD_PATH)/arch/x86/boot/bzImage
 QEMU_VPORT_RESULT := virtio-serial-device
 ifeq ($(subst x86_64,i686,$(HOST_ARCH)),$(ARCH))
-QEMU_MACHINE := -cpu host -machine microvm,accel=kvm,pit=off,pic=off,rtc=off -no-acpi
+QEMU_MACHINE := -cpu host -machine microvm,accel=kvm,pit=off,pic=off,rtc=off,acpi=off
 else
-QEMU_MACHINE := -cpu coreduo -machine microvm -no-acpi
+QEMU_MACHINE := -cpu coreduo -machine microvm,acpi=off
 endif
 else ifeq ($(ARCH),mips64)
 CHOST := mips64-linux-musl
-- 
2.45.2



