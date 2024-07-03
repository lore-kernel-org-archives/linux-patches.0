Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EF07CF1F;
	Wed,  3 Jul 2024 10:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003523; cv=none; b=TuT1yno1Fy3GedrCJ9+GkM2TnLbFgj3OIdErpuL/0493RCuVFXZxMcKVMRe8FUFnkGcNq5YK+NHDQDyu6Orc6lYGG7Jbr6xnMzGGuFy9dL1oLt9n4pXMQVH+tutt0W41btSE86+2Aftma8j0X20TPWUAhHYy8WHa7P2FkvqWqyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003523; c=relaxed/simple;
	bh=u2u7dfnug24IIKK5MpmOTH+mq0ivvqQpKHMx7U1NuQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyuWKB17amQ0n0wSMrOSNt1ODM+5rAR2v3i0qXV/Hd1gXdYE0HrnCqaqSogZ9t8zoieuFOSAVTPoZY7Z1bKWKC3XsKvpnqnBQ+Pupv0Eh4wplji5qBi1AhVq3UsB1sWQUnBXpQ8hSHEht+7ibZmBQfuYqL1fwT6HyTyvUUT4eAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjloaYP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjloaYP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A6FC32781;
	Wed,  3 Jul 2024 10:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003523;
	bh=u2u7dfnug24IIKK5MpmOTH+mq0ivvqQpKHMx7U1NuQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjloaYP2ZOZV+780SGOGWA4z3sN73mHfonH5I+XZYTigE2KKSj/8quDgKNhwy0STm
	 pViaN1Ji93W0q2OVrrWHT7rDXqPm2P8IqlJFOAmZfO3Jgw/7zpIVr2ke8ubE89F78U
	 e38zPnRjkQ/lU/Eh25Tsn0OTo3JxbXhCCqbInMaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5186630949e3c55f0799@syzkaller.appspotmail.com,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/139] net: usb: rtl8150 fix unintiatilzed variables in rtl8150_get_link_ksettings
Date: Wed,  3 Jul 2024 12:39:33 +0200
Message-ID: <20240703102833.310932379@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit fba383985354e83474f95f36d7c65feb75dba19d ]

This functions retrieves values by passing a pointer. As the function
that retrieves them can fail before touching the pointers, the variables
must be initialized.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+5186630949e3c55f0799@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20240619132816.11526-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 933d1a74bcdb3..9534c2f6dcef6 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -804,7 +804,8 @@ static int rtl8150_get_link_ksettings(struct net_device *netdev,
 				      struct ethtool_link_ksettings *ecmd)
 {
 	rtl8150_t *dev = netdev_priv(netdev);
-	short lpa, bmcr;
+	short lpa = 0;
+	short bmcr = 0;
 	u32 supported;
 
 	supported = (SUPPORTED_10baseT_Half |
-- 
2.43.0



