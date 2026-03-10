Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E702D24B7;
	Tue, 10 Mar 2026 11:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141116; cv=none; b=sHZSNz8NOdlpZeNualc1i3DvFTyuwgGs95hH70QQUa//AgNxVYgRolsGfDAwCsNv3Gh23aE4CfJxuc4tLXIcy/4NvML+luw4OXqM5/9KSMxZYO5H9TT98TPQHHMNLO2k0nPUO8d/+cDkmVYOv/d4omOeaImvGbaYRLfE34RSkqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141116; c=relaxed/simple;
	bh=4UBRM1lSEZbrwQqGoY8O1MTTDKhrzqM8QsmFpF6JYsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGpFQpdgU9TU+5UAAg97NqDJc/7nRWJp+/B+ctLbM2uWqUXJ49JeCL8OVrtosLN+l5+48kCxfrL51TXkuDU1FVrsouszawDcVMxP2lcVtXoKDARGq0EJKsQH4PGZ9ek3pJbQEVdVFLa2R4hiwUDuQtUBbR4JADHc8yCahgmk1fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3i2TNR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3i2TNR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE33C2BC9E;
	Tue, 10 Mar 2026 11:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141116;
	bh=4UBRM1lSEZbrwQqGoY8O1MTTDKhrzqM8QsmFpF6JYsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3i2TNR0RzClEAboxMOf7mZDXjGSQ3l0lFDA3dyqgevyBjePS02OKOyNLp5lP2+9Z
	 pPFueYU5oBWva6yWQludzsM0xwLyVXifELl3PKmKvaxo+DMpQ85NWTS6cLZZLA/ZK+
	 3EL2MolyPnYdFrPZ3r3GJPkiAkrKN8TJzuf6nKc1L70IBLQWXP8XWzAnqLW4XFbAye
	 t/x7RJH5ws6ari35fI1eiVhE6X02Crxp3aF+xOxDRo/2caDF0Z5wQait3XYjy6qFap
	 iOcnX49iuCBRoScuOdLGJ5QrmsjGVM5fQK4wNK73Pvhufv9KVcatG2jFRD/kfOEHVG
	 uLbCOtiaGPwsw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jan Stancek <jstancek@redhat.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	stable@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 118/311] x86/boot: Handle relative CONFIG_EFI_SBAT_FILE file paths
Date: Tue, 10 Mar 2026 07:02:45 -0400
Message-ID: <3280ad3c2c7e3522e706751e903fc1feadc11181.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 68f9d7a1683b5..b8b2b7bea1d31 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -113,6 +113,7 @@ vmlinux-objs-$(CONFIG_EFI_SBAT) += $(obj)/sbat.o
 
 ifdef CONFIG_EFI_SBAT
 $(obj)/sbat.o: $(CONFIG_EFI_SBAT_FILE)
+AFLAGS_sbat.o += -I $(srctree)
 endif
 
 $(obj)/vmlinux: $(vmlinux-objs-y) $(vmlinux-libs-y) FORCE
-- 
2.51.0

