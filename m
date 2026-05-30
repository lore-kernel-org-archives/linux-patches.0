Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB81217704;
	Sat, 30 May 2026 18:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165246; cv=none; b=dZY99mJ5sIaQSoqGkcxB1CwYEcR9nh92x7XR6IfjYSihtfbqY+i8BYD4mexKERAny6KU3h8Va2rS9S6G/X48oAI5+bJ5kzfYbhIjLcPc+tAcDu3SNpuxuatKrcvPSe+cgqHz9th2SK0mX+bmSUCabm4Bg7IyOA16O4nRwBdIjJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165246; c=relaxed/simple;
	bh=2zL0Pv8Wo/zQyzApB1FM9H1h5ONOl1K08wXgv5uQgV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmQp02fRapwX8hIljCTjuYEGYzrIBHVY4FqCtvDVLVetv5aXjoaTVYb+wBkvqJIoLBM+mrKWEL8R1pK6h3v/ebjNhMlZXDcnBNc0E/5OxKQpNFcO0Et+vH8WpJX8wZmV4zQ/KLcLBYGa82JAoEwX5BZovumb4aUYYNi2CgchgSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLGeGBOg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLGeGBOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4787F1F00893;
	Sat, 30 May 2026 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165244;
	bh=TBDwqGns5C5Ddh5HAm99fGWLTREMwjGx+lRa8kc1hKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLGeGBOgBS5JwV3irQqEoe5gpDQUshwqTHF2DKjRuqHNMxkLiCpnoJsjJaiGBojQz
	 pF8Hj5q64EdWaZRKWa0O1j7qTnb6AzX2IqehDDGlRqyaQ+tjlkUZQPMHc7qCEtRLpt
	 7JJxYA7f8MvqqU1nqI9MNldKAWY+azBZthDEJ00k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Li <lipeng321@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/589] net: lapbether: replace comparison to NULL with "lapbeth_get_x25_dev"
Date: Sat, 30 May 2026 17:58:23 +0200
Message-ID: <20260530160225.164043339@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Li <lipeng321@huawei.com>

[ Upstream commit d49859601d72baef143703c6944a4e41921f7e6e ]

According to the chackpatch.pl, comparison to NULL could
be written "lapbeth_get_x25_dev".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b120e4432f9f ("net: lapbether: handle NETDEV_PRE_TYPE_CHANGE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index f77cd8b69afe1..4f89693313175 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -412,7 +412,7 @@ static int lapbeth_device_event(struct notifier_block *this,
 	switch (event) {
 	case NETDEV_UP:
 		/* New ethernet device -> new LAPB interface	 */
-		if (lapbeth_get_x25_dev(dev) == NULL)
+		if (!lapbeth_get_x25_dev(dev))
 			lapbeth_new_device(dev);
 		break;
 	case NETDEV_GOING_DOWN:
-- 
2.53.0



