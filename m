Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC5339E162;
	Sat, 30 May 2026 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160907; cv=none; b=VCyaqSfG0eyvQsnf/73aLujWk/DJdjxPlO4kr6T1r8NFrJ82z4I/05/njK5mNsy43UYlm8aZP8pJxDBhAttbtUlJaVHzJHw/kc4/IVtf+GxlhCs66Vgo88G19+KP1j3RaxVL+pREnYsm94Q614UsxOo+cGvpvcwmLdw4fJGmA8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160907; c=relaxed/simple;
	bh=C8C7bJJP3PRMgHSM9v2cZeRoOLpJmMPMg2WHeG32bJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rtx5wCc0e8YRv9ZjVNXBXYFG/1EurmAVVR7lOnQCrm6QyRSlRQjgM9fnX6By8Q0cVgZ3QdZLdUfyy2Fq96INNvzkVh0g+aHnHa0rLijoskGchbHiKwwG538+B44yggmzJXwzB3jlGZc8revd+Am74fNXHFoRjZDwiUThMuLAwaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svGW7dR6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svGW7dR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA0B1F00893;
	Sat, 30 May 2026 17:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160906;
	bh=E4Dh6WxIyHIBQN4K5q1V7uN/D3IrYmYvibsH0jyz3Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=svGW7dR6k+P7/UpC+5Dir4J2SJIythIxvNlit7ivOariChiae/USbISnL2sKFiduY
	 zCclWCIXuLkybd0eipzCPQuseQz3ch5f3A+DHRBhn6arfRDhyiVFkJsL6fAQ0XLFK0
	 pjANWVm8SnmJrYcutr8SzMrtz8bMkNaKj0OvTTuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 440/969] irqchip/irq-pic32-evic: Address warning related to wrong printf() formatter
Date: Sat, 30 May 2026 17:59:24 +0200
Message-ID: <20260530160312.421854638@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 86be659415b0ddefebc3120e309091aa215a9064 ]

This driver is currently only build on 32 bit MIPS systems. When building
it on x86_64, the following warning occurs:

    drivers/irqchip/irq-pic32-evic.c: In function ‘pic32_ext_irq_of_init’:
    ./include/linux/kern_levels.h:5:25: error: format ‘%d’ expects argument of type
     ‘int’, but argument 2 has type ‘long unsigned int’ [-Werror=format=]

Update the printf() formatter in preparation for allowing this driver to
be compiled on all architectures.

Fixes: aaa8666ada780 ("IRQCHIP: irq-pic32-evic: Add support for PIC32 interrupt controller")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260222-irqchip-pic32-v1-1-37f50d1f14af@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-pic32-evic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-pic32-evic.c b/drivers/irqchip/irq-pic32-evic.c
index 1d9bb28d13e5d..1a72047f3aa2e 100644
--- a/drivers/irqchip/irq-pic32-evic.c
+++ b/drivers/irqchip/irq-pic32-evic.c
@@ -198,7 +198,7 @@ static void __init pic32_ext_irq_of_init(struct irq_domain *domain)
 
 	of_property_for_each_u32(node, pname, prop, p, hwirq) {
 		if (i >= ARRAY_SIZE(priv->ext_irqs)) {
-			pr_warn("More than %d external irq, skip rest\n",
+			pr_warn("More than %zu external irq, skip rest\n",
 				ARRAY_SIZE(priv->ext_irqs));
 			break;
 		}
-- 
2.53.0



