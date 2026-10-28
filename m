Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216251;
	b=Yqo0BkI3WuLf/s5nr5TzP2yDPu55YpK8fWnEupDtpHSso19h3m+kNqRVPc2nNX+MvoW0
	 ispcx9rChvrh+fPLME31rEnOUC67ZR4s21SBKXGnYAhykCouKGSn8HsC7w0wC44W363wT
	 E4sLaIcSzHkNvr8Ujx/YeOdVnENF73TIsxUSYWNPB4uARjjLvsfgqePcYrVMzc+g7iN64
	 tlk5kM7hr7HXcCBEuDy7BjPYubcjgQmo5RuJaOLMcrDAgmpjKfpVoJI+t8c7vcy6aPu6l
	 zFtjMKta3B8tbyqNY4VadEv24W/aClRWToVup5qy6OeAuVmtH03CU/oRhjwKQAmb8Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0M+sakMjymEhHYEDHvwAI+VmT5mBk0oPX0vokWqpXKY=;
	b=d9uZdFgTNzrmDgaKtDv8pVDoG1hr+F+iaNSwIg+lLzmpiWtoP+7Xr3B33qomBhYe/fnR
	 n+6HwO3Bu+IEwdmj9xugr2LwJg7JCH+gpzzM5Wj5vnQNMeA5a1Z5FaHD2zMJO1lTpr3iy
	 kGC+LM7SarypnMr2bCLYb8ud3+L73YRxx1hP83SASrTDPK93VcyqHdY8xxdfrpwufInlr
	 O3nITF975/kbA4uwbVKPSScUVMWUM390fN0mVoHa28H52B/ihC6dl737/Qa5+7t3DBVgC
	 ozXQ+o3fBQ8RkeZKKy0+y0Dxm6+53FB/Mur1hWi2nCnlQ7GekOY1moPl+Zq3Pwl6H7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LaHYmOvB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2B3606A31A;
	Wed, 28 Oct 2026 19:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LaHYmOvB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696981F01825;
	Wed, 28 Oct 2026 19:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216251;
	bh=0M+sakMjymEhHYEDHvwAI+VmT5mBk0oPX0vokWqpXKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LaHYmOvBBbxwaqNb7byvVd9AwLzo/OxjA7FcGI/rsIIuAyGp44B5EtCCxrJxPlnPN
	 6MLxOPe/znDnOX7i8b/4Tv0/p5I3bMGXCko01zH7TBPAstU/QpsITFdO88HXbP3XME
	 pyOuSL3eYD7XZHg4w6lDomslGyKMs5SBU/iQ7QeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1492/1887] KVM: arm64: vgic-its: Dont dereference a NULL collection on ITT save
Date: Wed, 28 Oct 2026 17:59:48 +0100
Message-ID: <20261028170533.408752874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit c6c156d931c33b92362383cf76f6d6e1291dcbfe ]

MAPC with V=0 drops ite->collection but leaves the ITE on the device's
ITT list, and vgic_its_save_ite() dereferences it unconditionally. A
guest that issues MAPD, MAPTI and then MAPC(V=0) therefore oopses the
host when the VMM issues KVM_DEV_ARM_ITS_SAVE_TABLES to migrate it.
That sequence is UNPREDICTABLE per the architecture, but KVM already
handles the resulting state in the translate, MOVI and DISCARD paths.

Save a zeroed entry, which vgic_its_restore_ite() reads back as
invalid. Skipping the ITE instead would leave the ITT slot holding
whatever is in guest memory, and restore rejects an entry naming a
collection the restored collection table does not have.

Fixes: eff484e0298da ("KVM: arm64: vgic-its: ITT save and restore")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260807104102.2410744-2-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 15c047d7539d1..88a01ceb8ce2f 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2218,6 +2218,14 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 	u32 next_offset;
 	u64 val;
 
+	/*
+	 * MAPC with V=0 keeps the ITEs mapped but drops their collection,
+	 * and with it the ICID. Save a zeroed entry, which the restore path
+	 * reads back as invalid.
+	 */
+	if (!ite->collection)
+		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite_esz);
+
 	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
 	val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
-- 
2.53.0



