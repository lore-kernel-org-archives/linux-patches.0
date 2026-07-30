Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E923194A6C;
	Thu, 30 Jul 2026 15:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425736; cv=none; b=DtnC+D6O7z98wkeLMffr347jtrKQLFpDVp/bRWa5Mc/gRPFzcS5YCXe1rxcdlIVa6R4GiXeMHdnPfsh368YIIsozpjA1GnvfF9AKCizNcherKbcCyMRdYj4YhjMJA015Oj2kwLgtuucYMggQ/jyo+t/kzj4abLyg3vP30XrMwq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425736; c=relaxed/simple;
	bh=CYN8Q+52nMXb4anRBHWnlUTZGEaz4zhVTn08JLO/4uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ds5wiEWSSx9mw2KlhRtxGsGeTD/p026KWjwzHBsWS2cPeiqkMwc6U9qkviczGz95DUDJBra+dSELdPsPW9uAFqcPDFtduhmOVyiN3YWWFPu+CO7Ib89ypD1g4APVhclXruFGPV2RV4wrlh0/Wc8T4fU3wjQNCkKVZOSW+FAgWyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhdfA95F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhdfA95F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7048B1F000E9;
	Thu, 30 Jul 2026 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425735;
	bh=4Uc/OxoiK1QZrwDCqkjTOnjLfQd7+wm3gdf4EN3+SSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhdfA95FuzWnIL/uj5DXwWmE2YsokMSnEJ+9j5Dadb1Z1o3t9xEJwFsYQZGmcvSzw
	 bR/Ak33cbxk2ZSQZ+eLVu1fHt1k0Usuml78vNL+7twmL1VyvBIrOVhHqn0kxg29W6C
	 IH/uAq6740ftd6Tu4GWg3jOQF29lHv30jBUnFBk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 172/602] netlink: specs: rt-link: convert bridge port flag attributes to u8
Date: Thu, 30 Jul 2026 16:09:24 +0200
Message-ID: <20260730141439.584774620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit f6e3b21608e974c4aaa4cfd73a239dacf1d8a9a3 ]

A number of IFLA_BRPORT_* attributes are documented in the rt-link spec
as having the "flag" type, i.e. a payload-less NLA_FLAG attribute whose
meaning is presence-only. This does not match the kernel, which emits
these attributes with nla_put_u8() and validates them as NLA_U8 in
br_port_policy[]. The values are not mere presence flags but carry a u8
payload (0/1).

Convert these bridge port attributes from "flag" to "u8" so the spec
reflects the actual wire format.

Fixes: 077b6022d24b ("doc/netlink/specs: Add sub-message type to rt_link family")
Reviewed-by: Petr Machata <petrm@nvidia.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Link: https://patch.msgid.link/a57cdfcfc4a6dcb92106c25b4dde5059fde2bd44.1783236731.git.danieller@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/rt_link.yaml | 40 ++++++++++++------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/Documentation/netlink/specs/rt_link.yaml b/Documentation/netlink/specs/rt_link.yaml
index a048fc30389d68..5fb757dcb53c2e 100644
--- a/Documentation/netlink/specs/rt_link.yaml
+++ b/Documentation/netlink/specs/rt_link.yaml
@@ -1619,31 +1619,31 @@ attribute-sets:
         type: u32
       -
         name: mode
-        type: flag
+        type: u8
       -
         name: guard
-        type: flag
+        type: u8
       -
         name: protect
-        type: flag
+        type: u8
       -
         name: fast-leave
-        type: flag
+        type: u8
       -
         name: learning
-        type: flag
+        type: u8
       -
         name: unicast-flood
-        type: flag
+        type: u8
       -
         name: proxyarp
-        type: flag
+        type: u8
       -
         name: learning-sync
-        type: flag
+        type: u8
       -
         name: proxyarp-wifi
-        type: flag
+        type: u8
       -
         name: root-id
         type: binary
@@ -1690,34 +1690,34 @@ attribute-sets:
         type: pad
       -
         name: mcast-flood
-        type: flag
+        type: u8
       -
         name: mcast-to-ucast
-        type: flag
+        type: u8
       -
         name: vlan-tunnel
-        type: flag
+        type: u8
       -
         name: bcast-flood
-        type: flag
+        type: u8
       -
         name: group-fwd-mask
         type: u16
       -
         name: neigh-suppress
-        type: flag
+        type: u8
       -
         name: isolated
-        type: flag
+        type: u8
       -
         name: backup-port
         type: u32
       -
         name: mrp-ring-open
-        type: flag
+        type: u8
       -
         name: mrp-in-open
-        type: flag
+        type: u8
       -
         name: mcast-eht-hosts-limit
         type: u32
@@ -1726,10 +1726,10 @@ attribute-sets:
         type: u32
       -
         name: locked
-        type: flag
+        type: u8
       -
         name: mab
-        type: flag
+        type: u8
       -
         name: mcast-n-groups
         type: u32
@@ -1738,7 +1738,7 @@ attribute-sets:
         type: u32
       -
         name: neigh-vlan-suppress
-        type: flag
+        type: u8
       -
         name: backup-nhid
         type: u32
-- 
2.53.0



