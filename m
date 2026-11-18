Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056447;
	b=WtYD/q+SvR/rBTELIJH0AonsL9zZOAhr3jflbi2pkiBpPy/EzloiIwLo2ubVBVr3vynU
	 3xaBkWWd+AUIrrnOsJY+x6EbSoeR7T6aFgtI06Z+xGIXVBgCWjFmIg9KTZZtOkNoyfvVQ
	 316SSMoD1Q9yJ6RaOCFyTGo8mFF3rRXWxC0bjofq/YG99+aE6KI6NtUIMUUIMuD2DBLsg
	 SpzH+9MWK6ZB1PTdRgrhcLZCQAWhydImTYL6CxEDf8L8oKYN6wb+K1aQzHa43GxqJ92MO
	 dV8VG5Md+1WkCgmVVfDKcj/Zu4DwneQT0BpKTYGpV8hlJXfRi8vhKDmufTfJCHFcfvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5PCPouGWxhL4t1W2m67Rrtm5Q8B/ZxQKnQlCaVp39/Y=;
	b=XZ6UzUjXXV1XbPot8TBPEFX1db1uTPxwSWqeOfaJb5Jzj5b6p56KBJANfDfxrLwdfqU5
	 xAShBC/IEvEO5phbt6zJO2SCBjXElW7sTr/ok+5qJf2KMKT7U92gGFRZ4DlqGDV5z2BXs
	 BVid0u/m59j3Sg0qZq2RQXCB0xfZKsMR8hKuA7R7mq7Sib0TAP3+yBYF2QpgCjDOO90h7
	 pwxe8I+7InyF9atQ2UUb4A+SYjCeCp0RfmESE+rmrDhdTOFy0FYgOJGrDr48E8jmtlq3p
	 EB4w2jiOhUQquqfVatTUpf8LDIiM02zuan482E1cwAk4HucuOYUVCBhlGiqd7yjuu/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s4Ll95rL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97B6606A330;
	Thu, 19 Nov 2026 02:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s4Ll95rL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128D61F000C4;
	Thu, 19 Nov 2026 02:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056446;
	bh=5PCPouGWxhL4t1W2m67Rrtm5Q8B/ZxQKnQlCaVp39/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4Ll95rLsMARGdy7+sz+SyTEA1eqZ5TpW9cs1FcL64fITnN9pxasssDshkEyfKfxZ
	 GluVr8ThoSOka2iuSiUGHwMofWPUP6Tid3Tv/4ibkTtFgnDYI7rEVGXoF0UueXAC/U
	 pmJvZ+ZkvK2NjuYMY0PASihKGBRe1BQG2mgS4D08=
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
Subject: [PATCH 5.15 1950/2214] irqchip/gic-v3-its: Clear vpt_page after freeing the pending table
Date: Wed, 18 Nov 2026 16:00:26 +0100
Message-ID: <20261118150129.000624272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5457498031431..450f9860c4557 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4475,6 +4475,7 @@ static void its_vpe_teardown(struct its_vpe *vpe)
 	its_vpe_db_proxy_unmap(vpe);
 	its_vpe_id_free(vpe->vpe_id);
 	its_free_pending_table(vpe->vpt_page);
+	vpe->vpt_page = NULL;
 }
 
 static void its_vpe_irq_domain_free(struct irq_domain *domain,
-- 
2.53.0



