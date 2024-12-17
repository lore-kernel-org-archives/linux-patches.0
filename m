Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82941F9ECC;
	Tue, 17 Dec 2024 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456817; cv=none; b=e1GarOz13VVO621uTLN7aucE5kg7Vk6P19c+fMOLEjMXL6GYjdAutgn3ff/AooC84DYlCPLSRLZmU56PI4xNFx8bRY5ExO52Rz3V4wjtcSWQs5o1I/mlim461DN8tXRtBMpKI9+F2uSAcf4cln1e/xoxLqF6JTgrzPLt1D6hSr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456817; c=relaxed/simple;
	bh=8rreOfCQSGrEKCA2gnmlZfn8O7b8z7WbGF13qsmFT1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlYKdg+g3YTLm92mOUhNtQWWUHU+4O/AVIY5GksE442IuPs5uwtAUtCP4z8LssOj7OD0NKj5EyYCMQx/12wqsaoEkquEefDUj9y1aI5ZzsnLe1CwyZchAzrVLuzJiK3Xm+DkhhYfUdRcW+G5J/5cuXai0iGVbXhhO2sYU3ZMe+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emui6svX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emui6svX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5DAC4CED7;
	Tue, 17 Dec 2024 17:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456817;
	bh=8rreOfCQSGrEKCA2gnmlZfn8O7b8z7WbGF13qsmFT1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emui6svXEmkWDl9BPoURCSIdjmkv1Q++i4NjbUsJP9+PEY7E9wou5U3m6Te01f2kN
	 GEmuN8agQ+NIjtCa+jRSzu/vqMDUv6Dvww+My6WsxWSP6Af7oOsbNNTEYczUHgg0/T
	 qUQWovegqBG1PV2e+TlxSpb7PXnoQ5+c9Z4M81iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@idosch.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/172] team: Fix feature propagation of NETIF_F_GSO_ENCAP_ALL
Date: Tue, 17 Dec 2024 18:08:20 +0100
Message-ID: <20241217170552.304443740@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 98712844589e06d9aa305b5077169942139fd75c ]

Similar to bonding driver, add NETIF_F_GSO_ENCAP_ALL to TEAM_VLAN_FEATURES
in order to support slave devices which propagate NETIF_F_GSO_UDP_TUNNEL &
NETIF_F_GSO_UDP_TUNNEL_CSUM as vlan_features.

Fixes: 3625920b62c3 ("teaming: fix vlan_features computing")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Ido Schimmel <idosch@idosch.org>
Cc: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20241210141245.327886-5-daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index ddd9ae7085c7..6ace5a74cddb 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -983,7 +983,8 @@ static void team_port_disable(struct team *team,
 
 #define TEAM_VLAN_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG | \
 			    NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
-			    NETIF_F_HIGHDMA | NETIF_F_LRO)
+			    NETIF_F_HIGHDMA | NETIF_F_LRO | \
+			    NETIF_F_GSO_ENCAP_ALL)
 
 #define TEAM_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
 				 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
-- 
2.39.5



