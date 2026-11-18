Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026855;
	b=SEt8r/q7xj7wJEro1gGtczfXESjZCR1aj03+kbluPlMG00yGmW7j6YQEKaAehpukQ1UL
	 tI/NEvwj6hhkkQ8pkGMpa9UtVoV07aQqjgx9QKkJeqirPB/Sx/juwame80Gp+xJxF8sJY
	 3ouOislh1UuSDB9UtSueOg/tkn1YfsznO/jIwpnpqqJY07XemYAlfp1f8+3vsCAqYcg+u
	 qUp0W/tl+Q+IjPmxImWOBQJy4WZyYH8/YCo6jRqUv1XVWPcs12sX097HvH8QvMy3XQA7y
	 TrVkUZjIIj7J8/pOkUMvYEAeMd085lV4IBgMMK/OcQeywfOULgSe2xqP5psye25NHEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rir00DvB1r3vGIJnTSmqVeEHvYIZV7m88qPAftI7Hkw=;
	b=W7yK9iz+xxXDaME2VRWD2zQO6IGGKpMBcLAKd53fRavY36P+JXr3zBVdsCDkegkJNghW
	 SYJIxaO4hZa7C4uHOrr93cXp2sLfBEWaqneOxqdRLHYwKF70CuQG7Jc09ei5jHKMBE0uD
	 yKSutWzs5WjEYfKUUIlTMbhtVGqXiMnwJ3pUEZiPG2xQZL1vqFq5lGsZx6pAmkSyw+Fmm
	 2XX8damc4MQJNukKABnY3isTIQkipMHa6bL3D/GIaa7wR6HC/+b8QXhmjbozO91NuZuTI
	 aobG/peOUckUOa07HHVYsqFHrTsrghADxxZke0oecpOU7pU637zxqiX8scuJ5MKyBpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p7NLZsOS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED783606A333;
	Wed, 18 Nov 2026 18:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p7NLZsOS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570851F000C4;
	Wed, 18 Nov 2026 18:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026854;
	bh=Rir00DvB1r3vGIJnTSmqVeEHvYIZV7m88qPAftI7Hkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7NLZsOShya44+wxXABFfL2YRETQF/SiNEPTECbprfPQmNlHRQ0tdxRr1nLC3AxGx
	 ppnYl5kABDboi1sy7LhMVYaHzKFqMk9me78GujJWjLQNDN8NJnqnxtRZCNYBnW5p8h
	 KNjsrkpGJkJgDK9k7qPAZqeMDVAUOnsFySeiYeJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1583/2151] irqchip/gic-v3-its: Clear vpt_page after freeing the pending table
Date: Wed, 18 Nov 2026 15:55:18 +0100
Message-ID: <20261118150219.546973628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 0d604b1e4617d18dbb5573290ba447d7369251d1 ]

its_vpe_teardown() frees vpt_page without clearing it, so its
vpt_page == NULL guard only holds the first time it runs on a vPE.
struct its_vpe outlives a failed KVM_DEV_ARM_VGIC_CTRL_INIT, so a retry
that fails again frees the pending table and the vPE ID a second time.

Fixes: 325ff3e78c64c ("irqchip/gic-v3-its: Prevent leak in its_vpe_irq_domain_alloc()")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: Radu Rendec <radu@rendec.net>
Link: https://patch.msgid.link/20260908142632.2795308-4-fuad.tabba@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 77662460b086a..4bd1623b9c49a 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4604,6 +4604,7 @@ static void its_vpe_teardown(struct its_vpe *vpe)
 	its_vpe_db_proxy_unmap(vpe);
 	its_vpe_id_free(vpe->vpe_id);
 	its_free_pending_table(vpe->vpt_page);
+	vpe->vpt_page = NULL;
 }
 
 static void its_vpe_irq_domain_free(struct irq_domain *domain,
-- 
2.53.0



