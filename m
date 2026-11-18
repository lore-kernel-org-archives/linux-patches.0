Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026005;
	b=sZETa+xg5qCpKwf4VcfAkT7l2gAZEPjObShmvbDe8FWdacBTDn+LU3geWUpb4pC0v3Vy
	 f/KFyV1H2N8Ds+IrHBjtSZfdfnxubcRfFSE0FGWuQJvHEoBKfQJ5NqGyukLPCcnMEjman
	 MxBAsUQeYzSOPTPE0F/E/+fkTd45R6mu0e3lDHQs50wLPz5hYbTHGIfju1wn34hpokTLK
	 dOPjrVrMVKCRJ1LcLGFw4Fct+dBmDhwVvv3p+6aTLyiv2aZBt4mpnIDVKHE526sgOYyqH
	 EoDxznupfOygJFGgsi2pE5SnhjmMsAXFDzmMABnBT28eXmauOmRhVRJLbKz8NPhw3uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mzpqijy0DvIX8um6gd3EzBO3Gm2y6SLYAPpAq3y4Y54=;
	b=W8J1lobpDTE04k2Ns3uND2EL6pbvyOi1rv74G5irpdVF9Any3sKOiejutAnVucuifHzZ
	 8PbgEfQ5jqTWBkY+aKctgNaLU4IqJWnP6ESA86rV54J4tnf2U29OSgV4xjbMmHnsAxQk/
	 yTM36zPxeNII9isbBhOw43dXn9nwIBE0aw6OCbxwhWH95paAq9xnpYDkeg36kilg38+cX
	 GUKFXPtaUrPQFxv0Etn7B09qmANWMJx02LYaphOOpHopqUZslo+EGbziw7mQUN3/uUa2q
	 t/268tqeQkUBzwuz6wsB20ncihD0dWoeqMNCczsDrSx4j3ACvysEnjzIQ5r6d+lU64w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QI6vUkFV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E9D606A320;
	Wed, 18 Nov 2026 18:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QI6vUkFV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF5D1F000C4;
	Wed, 18 Nov 2026 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026005;
	bh=Mzpqijy0DvIX8um6gd3EzBO3Gm2y6SLYAPpAq3y4Y54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QI6vUkFVXv1O9e3UA0uGwM4QtOI8sWg+x1cDuTMAwBV20YUMxeiP1lzfPtU4K6c+d
	 OETU094OVJej8aauwZuXEv2doRBMwuRVOfXMmZaiKavKPc534utW8wmx1GimPakEB9
	 O30dPkdJilUWmGHFO2fK4Z/KaVA1fXnwpUPfRTkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1280/2151] gpu: buddy: Drop the stale @p line from the gpu_buddy_print() kernel-doc
Date: Wed, 18 Nov 2026 15:50:15 +0100
Message-ID: <20261118150208.752032286@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit b7027ff72c2fd4f7697a00b854c882445e9150b5 ]

gpu_buddy_print() takes only the allocator since commit ba110db8e1bc
("gpu: Move DRM buddy allocator one level up (part two)"), but the
kernel-doc still describes a printer argument and kernel-doc warns about
the excess parameter on every docs build.

Drop the line.

Fixes: ba110db8e1bc ("gpu: Move DRM buddy allocator one level up (part two)")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Link: https://patch.msgid.link/20260907012125.21209-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/buddy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/buddy.c b/drivers/gpu/buddy.c
index bf5920bd22580..158f54e82547b 100644
--- a/drivers/gpu/buddy.c
+++ b/drivers/gpu/buddy.c
@@ -1291,7 +1291,6 @@ EXPORT_SYMBOL(gpu_buddy_block_print);
  * gpu_buddy_print - print allocator state
  *
  * @mm: GPU buddy manager
- * @p: GPU printer to use
  */
 void gpu_buddy_print(struct gpu_buddy *mm)
 {
-- 
2.53.0



