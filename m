Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DDC47CC79;
	Sat, 12 Sep 2026 12:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217978; cv=none; b=bBeZIk0jf+lauyEk9b3FFpHeHXwKrJ+xhI4qidnr9+YzHxb7SmF8b2FsOyoE8Nm0VvWGzCSxYWqJ1lG75aPFQ1fkGa+Bs6Gfq5iRkky+HOs/QJzMaEgp4G5V9tSfQyIKQa4YAawD5jX+9tMCyG3aJcPNhD5Rf7TCGhNMahw4MTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217978; c=relaxed/simple;
	bh=zOpzp8XvzDwQK46/ZoBVKFkCKIW6j7UOcTluP4mVdPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaPfUDwaoHb2ajE0ioAil/AUAMRU+o+2oqXZvzHDPvP9+V1ImXsomMF3HcpRvxi/p8Zd7BT0p7paLRliWZ3CSstuOHkZXdoTHw3D86TzugDAw2A3Lx6nh4A0l6WmNdVXzatmdEUBrteVzxBTqSgSF3L8EEsoqXMiZebVq4DsxUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qpo/7eOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qpo/7eOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6D21F00893;
	Sat, 12 Sep 2026 12:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217976;
	bh=RFibF3YR2G2128Nx7ncx155qrWiuW4+eU1qBsj0/zrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qpo/7eOxyE2zPezqQ0ADb4ZdVESJDu8pq/tmtU07SDpn4dv3QJJvsuKw0rafKfs2U
	 w/8okwhda245rWHneKTAV1NFRAsY7TnG9dwr1t1H/laHluzZDSJuAfSdcZV45mm5I9
	 UynNBKutLUTuCuVIR6Ij9TrJafpA/ggZd2QgRrmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1049/1376] powerpc: Use str_enabled_disabled() helper function
Date: Sat, 12 Sep 2026 08:57:55 +0200
Message-ID: <20260912065630.938263914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 19e0a70e6c3c1bf800b8ce9eb45864aa9e1e2781 ]

Remove hard-coded strings by using the str_enabled_disabled() helper
function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241027222219.1173-2-thorsten.blum@linux.dev
Stable-dep-of: 3f7c9f9c36b4 ("s390/irqflags: Add out-of-line definitions of arch_local_irq_*() for KMSAN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/secure_boot.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/secure_boot.c b/arch/powerpc/kernel/secure_boot.c
index 9e0efb657f393..3a28795b4ed82 100644
--- a/arch/powerpc/kernel/secure_boot.c
+++ b/arch/powerpc/kernel/secure_boot.c
@@ -5,6 +5,7 @@
  */
 #include <linux/types.h>
 #include <linux/of.h>
+#include <linux/string_choices.h>
 #include <asm/secure_boot.h>
 
 static struct device_node *get_ppc_fw_sb_node(void)
@@ -38,7 +39,7 @@ bool is_ppc_secureboot_enabled(void)
 	of_node_put(node);
 
 out:
-	pr_info("Secure boot mode %s\n", enabled ? "enabled" : "disabled");
+	pr_info("Secure boot mode %s\n", str_enabled_disabled(enabled));
 
 	return enabled;
 }
@@ -62,7 +63,7 @@ bool is_ppc_trustedboot_enabled(void)
 	of_node_put(node);
 
 out:
-	pr_info("Trusted boot mode %s\n", enabled ? "enabled" : "disabled");
+	pr_info("Trusted boot mode %s\n", str_enabled_disabled(enabled));
 
 	return enabled;
 }
-- 
2.53.0



