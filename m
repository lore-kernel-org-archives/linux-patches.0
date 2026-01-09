Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B041946C8;
	Fri,  9 Jan 2026 12:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960780; cv=none; b=UQms4tyhOkgqEtmaTSZZkTfxVFjLzhdP+ikSpAWf1NMYgxbWIVX3pR2/B13l6ut2WKym9V3GqnXetsNgODk1o6565OQo9i9NMJPG7LkJVjegLqPaGeuDRH3OjE426PcSJ6IJU0HNpHKPmaKLab5SZfdIKF/ZNWYGPDWu01YjKto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960780; c=relaxed/simple;
	bh=4MnewyECCgJ5gZqsaKuZf+bfLX/yOxxDaW66QDT7deY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAdZ7DkbFro+JC86IccfbesB9DDLMnpkA/1LvpAyz0+Aykd+36quedProe5n0NpHtROFinWepQ+Bc+ADip1ON8DFlddfKYCth6vfmKBQSDHifuy4Cx7nEHOa1kVAkI8ytK/T5vucfxNri3Doeor5N2jQtlkqaFIJ/eViTvCq+ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YV8diOAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YV8diOAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1A3C4CEF1;
	Fri,  9 Jan 2026 12:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960779;
	bh=4MnewyECCgJ5gZqsaKuZf+bfLX/yOxxDaW66QDT7deY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YV8diOASnCjo9ElHv45ZHl+3nOLEpe4iw6i9MOFU/qfh1NXsYBJLiF95m45a3Vhuo
	 R3ruvmZctk6BxfnU8gh+S+mu6RU2oP3nPIkZsmEmcGU3FRqg/vIKwXZOhzSWRlUhem
	 Fgiowt/PeyQg7Kxws10sVGwrLmV6BgLyDxJ4N02E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 522/737] net: bridge: Describe @tunnel_hash member in net_bridge_vlan_group struct
Date: Fri,  9 Jan 2026 12:41:01 +0100
Message-ID: <20260109112153.636627114@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit f79f9b7ace1713e4b83888c385f5f55519dfb687 ]

Sphinx reports kernel-doc warning:

WARNING: ./net/bridge/br_private.h:267 struct member 'tunnel_hash' not described in 'net_bridge_vlan_group'

Fix it by describing @tunnel_hash member.

Fixes: efa5356b0d9753 ("bridge: per vlan dst_metadata netlink support")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251218042936.24175-2-bagasdotme@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_private.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index c8a4e3b39b0e..371a948d29cc 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -245,6 +245,7 @@ struct net_bridge_vlan {
  * struct net_bridge_vlan_group
  *
  * @vlan_hash: VLAN entry rhashtable
+ * @tunnel_hash: Hash table to map from tunnel key ID (e.g. VXLAN VNI) to VLAN
  * @vlan_list: sorted VLAN entry list
  * @num_vlans: number of total VLAN entries
  * @pvid: PVID VLAN id
-- 
2.51.0



