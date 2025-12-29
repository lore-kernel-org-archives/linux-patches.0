Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3448F347C6;
	Mon, 29 Dec 2025 16:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025019; cv=none; b=XXmyOE3qzkpqUjGmXB8elBFWstNETSkqWqed1sHnDirnoql2vmCyGVUSWNU8YCtaNRpBx4bsECUs9BtECiAUr7Dr5Jx6E+oDNjQFMk8Rd/Ctp9AODhDDmyxHNl5Gpqc1Vy4yZWO0NRSRgSu12wn7bQbNgiiB6W314FpaTd8Njn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025019; c=relaxed/simple;
	bh=t2WJcB8DKxlpFu3EVynIepaEYkbE1STkeM5QviiXpgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BP+hb/xfTCnSBE7T4+AlRhr1R531inb7+VqJZnHGWhn5+/AANgQcrnh1mDoYrjvVP8y+jVfZaXPuHdO9X6wnF7TPCUTQC/XY41OcnnUQ3AWiKBktlf45tlywMmuOQo3ZYL6bHyDCta3I2Dj6v4+RrYKgtfBVEoXNYgXaiwNIXxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwWqOxAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwWqOxAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AB0C4CEF7;
	Mon, 29 Dec 2025 16:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025019;
	bh=t2WJcB8DKxlpFu3EVynIepaEYkbE1STkeM5QviiXpgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwWqOxAUosbceIvHpJXPWKu+GrzilsaO7mCPllaGLkiohXI3aIcAxui9mkZk5ecqn
	 IP9OjPMDFtQbJY1yp9ATO9JARwfwwSg9GtZzt2k5/u89IPzkwvgyYmXcTBKJOvVBc7
	 KjKk7RduUXTOAGrrs+FkyJpEkFG9GJtdSqP65FfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Peng <pengyu@kylinos.cn>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/430] x86/microcode: Mark early_parse_cmdline() as __init
Date: Mon, 29 Dec 2025 17:07:04 +0100
Message-ID: <20251229160724.972481427@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Peng <pengyu@kylinos.cn>

[ Upstream commit ca8313fd83399ea1d18e695c2ae9b259985c9e1f ]

Fix section mismatch warning reported by modpost:

  .text:early_parse_cmdline() -> .init.data:boot_command_line

The function early_parse_cmdline() is only called during init and accesses
init data, so mark it __init to match its usage.

  [ bp: This happens only when the toolchain fails to inline the function and
    I haven't been able to reproduce it with any toolchain I'm using. Patch is
    obviously correct regardless. ]

Signed-off-by: Yu Peng <pengyu@kylinos.cn>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/all/20251030123757.1410904-1-pengyu@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index f75c140906d00..539edd6d6dc8c 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -136,7 +136,7 @@ bool __init microcode_loader_disabled(void)
 	return dis_ucode_ldr;
 }
 
-static void early_parse_cmdline(void)
+static void __init early_parse_cmdline(void)
 {
 	char cmd_buf[64] = {};
 	char *s, *p = cmd_buf;
-- 
2.51.0



