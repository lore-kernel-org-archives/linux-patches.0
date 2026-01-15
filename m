Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFE23BF2E6;
	Thu, 15 Jan 2026 17:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498315; cv=none; b=V0JzLAqpVEYdUhuzzEgDJU7h06CpHNzmcLgQWl+vYNfasRd1db4wEM0UjA2IwiQq7T8H+WmZE064r24eWyJN56LqAGaPz0XWiKA49eTOtam7okWpZaArvUImQqwWO/bmaUrGNkmic7LFYHBNljGwi9OqJpTtyPoAa5oWYgFd0KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498315; c=relaxed/simple;
	bh=nKOluNQc3N5sYFgCUTHWHOB5BY19hYmaIjd9nXPdZHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gaavgrgt9BbGudqsgslbFUg+dx0fTJZtcXJfYMY5tDnKLT0bpNHjapE/2rBVIqV5orEbH1YH0Cv9ZmtZqK77/usdF+7peXNs16T9Kn2yAr8VzeolPGQ4Ru7MKBOdrVshZd7zS3bwu28a2ezndjNn7tE2WiXsMUuaOHYmnPb6ZCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAQTz8sQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAQTz8sQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76262C116D0;
	Thu, 15 Jan 2026 17:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498314;
	bh=nKOluNQc3N5sYFgCUTHWHOB5BY19hYmaIjd9nXPdZHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAQTz8sQeqKpBlSZ6xel89YYgkYyzNQ+5nulFrfe7f9SJy+aKSKglH+5SMp8+iC7j
	 ExJHsy4Sr06w201VXE3u7eYjHipVPHLjt6rwawn9KK/RI4SvA9c/jvGf/VBTs26Tgi
	 pq4JPWOafOm/afvARkiICMjkoKM5i026JsLH58Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 355/554] net: bridge: Describe @tunnel_hash member in net_bridge_vlan_group struct
Date: Thu, 15 Jan 2026 17:47:01 +0100
Message-ID: <20260115164259.078364745@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8acb427ae6de..0fd8dad7eca4 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -221,6 +221,7 @@ struct net_bridge_vlan {
  * struct net_bridge_vlan_group
  *
  * @vlan_hash: VLAN entry rhashtable
+ * @tunnel_hash: Hash table to map from tunnel key ID (e.g. VXLAN VNI) to VLAN
  * @vlan_list: sorted VLAN entry list
  * @num_vlans: number of total VLAN entries
  * @pvid: PVID VLAN id
-- 
2.51.0



