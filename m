Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EE0199EA3;
	Tue, 16 Jul 2024 16:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145924; cv=none; b=aNRQz9YLtU8hbxAnu3mZfqHqv9EcykTbMmFsKMCfoeVV3/DEI+hjKBgiT4nCbM8Ru+QlTBE6cWuprVc2mEBtn7DG84S+bHZCew+o8ZGjL+3AOYlsu+Nb6bvD6BD4BPAuTxpyhx4M0TiE+/q113MsuqUO1q/rCcNwzp33EKZ732U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145924; c=relaxed/simple;
	bh=rRHUeGvMkhkYXi17M3vch4lwm+ljGDkPZYuPIHnwAZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBYvw7lY1eeFYGZtNqOKRfLuNodz+WmqsGh4I715sTRtbbU0YAfx7v6+dlZQfdJDAnK4+teuSEa/HAiPL0NX9dvXw1oATkq2z5cXjeOOZa//CakyMt2EIyW4H1befgH16IV8OPfB42HWyHEfHKOuJrtHtsexCYbvHvzL9Q/O7xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kgo8QPR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kgo8QPR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A750FC116B1;
	Tue, 16 Jul 2024 16:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145924;
	bh=rRHUeGvMkhkYXi17M3vch4lwm+ljGDkPZYuPIHnwAZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kgo8QPR/npxwRPKGTGOH80SxsQ3BmpxECTd3Tl538US/yqIL5R+V824VYQEkdx3/0
	 7crXv/c3qlMykKGbBxdCc39EY77YrWc7ujebfmbKIxNRR1SsVsQjDNr3BRbbjnTW7q
	 RRJVKE27RoOlaQpp1a6FCzylMJUvT/hCetQYg8R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 093/121] wireguard: selftests: use acpi=off instead of -no-acpi for recent QEMU
Date: Tue, 16 Jul 2024 17:32:35 +0200
Message-ID: <20240716152754.907231627@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/wireguard/qemu/Makefile |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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


