Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BE836404E;
	Wed, 20 May 2026 16:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294973; cv=none; b=WrROFnPWIoN3Yy/+pRMjZQmzVmLRCr4DiZcK2N+7BILrwDA1JWelXyq+Ad7fIJ8pMoC+TGBIOhOscCxfqAAXyI6F1VkWVTewQcL15Xt3wCZqWZmOlAcO55qdzoBKIz0uBZ6oddF3gO/EyT5FHkOyklm24PkqTiwRSoNW+0Ql1NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294973; c=relaxed/simple;
	bh=GuKQbN+KfQwsB4AbQrAhKE57RvtbewCJDEgVbTlAf9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHKahpBlcGmaD/sKhyr1UHblEPKbTkbiMsFVVCwZnnwazu6LGWeQBf0P4RJYJeUrGCBuFmsfBIuntQuur0QGw8OfN4k90ohgVtlSkDGBX4UuLfQ08j4z+7K2bFx1BB36CBzHbGuPD4Tf0OWzVkRAJrVFW8LXXLqtIIw+Wd6AGJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5H9GJPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5H9GJPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F731F000E9;
	Wed, 20 May 2026 16:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294971;
	bh=I58oMW24gBCTB9JB1Ld39YXw538saZpfVDOZjSysupM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5H9GJPTsWYhnAaHY0DADLxlH+0NN3MqKwvlW05wxHqidPZVYKDZ07IYhyxLPPNXH
	 RTY5s6iFEx8xEqf64SXQYqPrPeaUJTGQOF2BOlPBgW/6LgS1hl2ajkH3H/X3vcfK8e
	 PhVeI0Ul7Z70asUACX1UdtJclZqn0I2Tcn6dit90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliot Courtney <ecourtney@nvidia.com>,
	Gary Guo <gary@garyguo.net>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0241/1146] gpu: nova-core: gsp: use empty slices instead of [0..0] ranges
Date: Wed, 20 May 2026 18:08:11 +0200
Message-ID: <20260520162153.695110658@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliot Courtney <ecourtney@nvidia.com>

[ Upstream commit f6f072d8ef06ff5d29a6bb1bade3da29a1aafeec ]

The current code unnecessarily uses, for example, &before_rx[0..0] to
return an empty slice. Instead, just use an empty slice.

Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260129-nova-core-cmdq1-v3-3-2ede85493a27@nvidia.com
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Stable-dep-of: f64caf673cb5 ("gpu: nova-core: gsp: fix improper handling of empty slot in cmdq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/gsp/cmdq.rs | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/nova-core/gsp/cmdq.rs b/drivers/gpu/nova-core/gsp/cmdq.rs
index 03a4f35998498..fc4e7b1074307 100644
--- a/drivers/gpu/nova-core/gsp/cmdq.rs
+++ b/drivers/gpu/nova-core/gsp/cmdq.rs
@@ -242,7 +242,7 @@ impl DmaGspMem {
             // to `rx`, minus one unit, belongs to the driver.
             if rx == 0 {
                 let last = after_tx.len() - 1;
-                (&mut after_tx[..last], &mut before_tx[0..0])
+                (&mut after_tx[..last], &mut [])
             } else {
                 (after_tx, &mut before_tx[..rx])
             }
@@ -251,7 +251,7 @@ impl DmaGspMem {
             //
             // PANIC: per the invariants of `cpu_write_ptr` and `gsp_read_ptr`, `rx` and `tx` are
             // `<= MSGQ_NUM_PAGES`, and the test above ensured that `rx > tx`.
-            (after_tx.split_at_mut(rx - tx).0, &mut before_tx[0..0])
+            (after_tx.split_at_mut(rx - tx).0, &mut [])
         }
     }
 
@@ -273,8 +273,8 @@ impl DmaGspMem {
         let (before_rx, after_rx) = gsp_mem.gspq.msgq.data.split_at(rx);
 
         match tx.cmp(&rx) {
-            cmp::Ordering::Equal => (&after_rx[0..0], &after_rx[0..0]),
-            cmp::Ordering::Greater => (&after_rx[..tx], &before_rx[0..0]),
+            cmp::Ordering::Equal => (&[], &[]),
+            cmp::Ordering::Greater => (&after_rx[..tx], &[]),
             cmp::Ordering::Less => (after_rx, &before_rx[..tx]),
         }
     }
-- 
2.53.0



