Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E653093C6;
	Sat, 30 May 2026 16:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158979; cv=none; b=JPNZ5HRa6KT4sQa81vohQ4qm+0GY1iA0GQUdPBgrHT21yeWxv2TnCw80EajpJMsAv9mP46w8kQAKYDYwss9RXjFAe8q4+8hppz/xlUX+wz+PdZ5H6UT0KrOuIMvhMqYJb/rbch06BUqnnw/zkmTz4vukQIHPATqubvrS9IMTRQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158979; c=relaxed/simple;
	bh=RvzRehE13ZvzTmWb1R8kgpazjn/rkOquPi1+y9qDOAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uhoux/w6ihcxCyRAzEnMIMC2wpnLZ48EDQwSmF74SqVcOdaoicciBs0Or7vn55CKkH3mr4Y+ueyt3xjC80qGfPOIBzKW7X+rtI58xyy/KZgQKW94a41Ws2jrSs+UMyaR6k2dj6Fa8dxgmkaZKFBXbFFSpO0c6cbScHGemiUR1x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=juPDKPtD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juPDKPtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242931F00893;
	Sat, 30 May 2026 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158978;
	bh=lGujzGLk6Zwwd4srgZ+cVTZyqcF1Jtd4GMAC2OD0REo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juPDKPtDnBk6IqQlvRmr+SgVzgpS3r9FW3F+h1SMZd0h12BvOeVE12ssEIcDt1yL8
	 7xDEDXk3JgiIGPdSJueFI6GlzgmEY7D+0vs6e1yvrIrZW2Vo5jcPZlKiGgxEaFoGkk
	 ng+9XDN8+oAPmv2mqHQolszP7Iw74WAx/APHidNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rajani Kantha <681739313@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/969] bonding: return detailed error when loading native XDP fails
Date: Sat, 30 May 2026 17:53:36 +0200
Message-ID: <20260530160302.874162009@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 22ccb684c1cae37411450e6e86a379cd3c29cb8f ]

Bonding only supports native XDP for specific modes, which can lead to
confusion for users regarding why XDP loads successfully at times and
fails at others. This patch enhances error handling by returning detailed
error messages, providing users with clearer insights into the specific
reasons for the failure when loading native XDP.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20241021031211.814-2-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 7fe7485fbb160..c6b4f681c70d1 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5636,8 +5636,11 @@ static int bond_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 
 	ASSERT_RTNL();
 
-	if (!bond_xdp_check(bond))
+	if (!bond_xdp_check(bond)) {
+		BOND_NL_ERR(dev, extack,
+			    "No native XDP support for the current bonding mode");
 		return -EOPNOTSUPP;
+	}
 
 	old_prog = bond->xdp_prog;
 	bond->xdp_prog = prog;
-- 
2.53.0



