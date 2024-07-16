Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE5217A93F;
	Tue, 16 Jul 2024 15:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145168; cv=none; b=BuUVTfd11ttJK+j+vEQ8NekIT1hehn7Z/jlRM3qh7PZ9jcOE38Z13mvr4JSlslPdYyAru2QCZ/jxKntbBKFwUZFWke1TZw4t+ayKGCjjcwiHRPNv28g4GwBtlW+C6NnrxMyALnbK5lMCRcBjxX+uAdlx1st2tAyYqHdQgkLzc/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145168; c=relaxed/simple;
	bh=jSs8+24+wsWiog2gy3u9O/QYrRA2WEahyy48Ry3/bzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lba6913PwtaFy2CDtyZkBg3TJX0mn/amN9OuAN9uWl8gLiT941wSd4hl58qaaVLk/nOXylt1QEchVfjE7SM5XJlyBfg+VI+zFvcTYqcdP2eSelCB6z6Kh9A9bXcoyWQJNBoGg7l0fCEJVegUyCLkWBWHKSz+rM2xZ6wFBY7h8a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ror1fgM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ror1fgM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E07C116B1;
	Tue, 16 Jul 2024 15:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145168;
	bh=jSs8+24+wsWiog2gy3u9O/QYrRA2WEahyy48Ry3/bzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ror1fgM7YPSfThHvx6UsqfZUYY2t6JUwMMtlRD9Dfpi9SNmGtRNjgay7tMEVsotMR
	 J5l/GM1qe6i4ctxbPEyUqHzXdtGTjOsdhL6JDUd/PUASV1xNryfMyFLB6n8+951Dv+
	 gjP50/VijsgG5K7ddjBBvcsxmrlZbIvBZJcAtVF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 120/143] wireguard: selftests: use acpi=off instead of -no-acpi for recent QEMU
Date: Tue, 16 Jul 2024 17:31:56 +0200
Message-ID: <20240716152800.597048864@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


