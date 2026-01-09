Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35E11DF72C;
	Fri,  9 Jan 2026 12:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962609; cv=none; b=n5G/QktsnvDcFIQI0v5rIylzHQQetzziRYN7QpZE+HRtklYyaZIZPdBl+zbUv6uoVI9q/zd4BGCJ70MVWd0J3yulfeVC55Sv5gl+4oOI0bVkya12sO0mfBvrYbZ02miFsADqoI3q9yWDfi5fyaV4qyHenkS8wOrEiR9v4TjvqY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962609; c=relaxed/simple;
	bh=R+xx7fq8pExZ0mxP1ppBUcSUwWr8fmHMc0s+T8jknkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+TmvMaUGwidtXUMI+8JWjMujQ97m8ov1VqVFLUpnIVmu5X24dU98PGijFS/2G+kjZ5G1x5lHZAzl/e8Oi1p6hXm8Eh7+q/jfGWkUH36kJ9pe/GxqzXrDE634ON043rL0oO8yqDljUgXRgrDfVAV+JJgF9lyVdd8vdkJmhT0RFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wu1fZ7Kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wu1fZ7Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83995C4CEF1;
	Fri,  9 Jan 2026 12:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962608;
	bh=R+xx7fq8pExZ0mxP1ppBUcSUwWr8fmHMc0s+T8jknkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wu1fZ7KpiPUTeDz18NfEy3/Gi26ripngyQeWNYAoE2gWy/21a+lwNRvqr557MiHf3
	 GxBuIleyv0nin2jSV1CvKv9pSKa4K/f0IlvjbwWQ7ppuRxgC/uWem6K4912i5bKcxH
	 G6NT75k5l4dl+O6eGp/vd7E+bS7FLDKG9Ho1g3S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 418/634] net: bridge: Describe @tunnel_hash member in net_bridge_vlan_group struct
Date: Fri,  9 Jan 2026 12:41:36 +0100
Message-ID: <20260109112133.266227201@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 901b9f609b0c..9f3f636587f3 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -224,6 +224,7 @@ struct net_bridge_vlan {
  * struct net_bridge_vlan_group
  *
  * @vlan_hash: VLAN entry rhashtable
+ * @tunnel_hash: Hash table to map from tunnel key ID (e.g. VXLAN VNI) to VLAN
  * @vlan_list: sorted VLAN entry list
  * @num_vlans: number of total VLAN entries
  * @pvid: PVID VLAN id
-- 
2.51.0



