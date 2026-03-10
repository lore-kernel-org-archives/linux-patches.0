Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C9E38E12D;
	Tue, 10 Mar 2026 11:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142022; cv=none; b=onoM4AJrSWCFPeL6yiLW2YhthWF/1AJNFDGW6wdLkExgebeifcolvREP24NxTW/tyeHoOfEnKI9dlxlUweMDFqOwCeWr2zmOLnN1RaZzobfS3HCUSdkxFU1cbIJfoBf4cfSlM3wU9tmpsk7PkKVclpEqbrRJJuwMNQN0Kn07Qx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142022; c=relaxed/simple;
	bh=ucy21ThxLtUDu7VLfV39Buw10dCj2kP4N/pW3NCHfLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reHBaCYuk9wZ8oal4pTMs1ZBuc+dqVvTz2ZUSfWeMT5GEvtNMREKlYx6NOEvmkvvO5t+n7YUuAaZ9d6DbGx9JdSoeMgNURpqXShXfjGx4OrqdnckGECQ9esiwu2B8W9zMZfU9iZFcV2L8l6qbGBF+j9JadUBghWCoPO5L2cFH8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P88QRUjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P88QRUjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE3BC2BC9E;
	Tue, 10 Mar 2026 11:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142021;
	bh=ucy21ThxLtUDu7VLfV39Buw10dCj2kP4N/pW3NCHfLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P88QRUjlkeWyCyE6klwiaStfPT+NotegxekVkRZMB+d7cMQjsAV7xhcpH6/K5Jx6c
	 dLe3jovhbEadxymrwFI2w46kh/mcmDT/5OSMxaHPSW/HIag91paGNzm7bEqPj/GK0c
	 c5j1jwv5IdLesW3dteV/RqGPpOcYbitpbYHz6GsCi0HOumDaJdb+P93ro3OO1z8I1c
	 nHPOWcJA7VJKnloEHUCJhxmPYjB3ckfN2vpJGskehDeApn7aY2CxSEIDbA4unZJ90X
	 x1kKR/8uW6y3Neqxp20396RiLdCYI8XzLP5zeKCgA4XWO3tNgx/Gk+qw73qGxvf/7w
	 CjEmMb+IwJuMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jan Stancek <jstancek@redhat.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	stable@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 148/314] x86/boot: Handle relative CONFIG_EFI_SBAT_FILE file paths
Date: Tue, 10 Mar 2026 07:16:47 -0400
Message-ID: <5cdc1ce0925cbddd10a0e455534beda697942480.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jan Stancek <jstancek@redhat.com>

commit 3d1973a0c76a78a4728cff13648a188ed486cf44 upstream.

CONFIG_EFI_SBAT_FILE can be a relative path. When compiling using a different
output directory (O=) the build currently fails because it can't find the
filename set in CONFIG_EFI_SBAT_FILE:

  arch/x86/boot/compressed/sbat.S: Assembler messages:
  arch/x86/boot/compressed/sbat.S:6: Error: file not found: kernel.sbat

Add $(srctree) as include dir for sbat.o.

  [ bp: Massage commit message. ]

Fixes: 61b57d35396a ("x86/efi: Implement support for embedding SBAT data for x86")
Signed-off-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/f4eda155b0cef91d4d316b4e92f5771cb0aa7187.1772047658.git.jstancek@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/compressed/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 74657589264df..2013840d6318f 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -110,6 +110,7 @@ vmlinux-objs-$(CONFIG_EFI_SBAT) += $(obj)/sbat.o
 
 ifdef CONFIG_EFI_SBAT
 $(obj)/sbat.o: $(CONFIG_EFI_SBAT_FILE)
+AFLAGS_sbat.o += -I $(srctree)
 endif
 
 $(obj)/vmlinux: $(vmlinux-objs-y) $(vmlinux-libs-y) FORCE
-- 
2.51.0

