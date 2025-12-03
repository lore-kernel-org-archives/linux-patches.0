Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD24D322557;
	Wed,  3 Dec 2025 15:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776915; cv=none; b=GFBsptfy+GmKdUnq/VgyZ/nJl2qoriyTTgUlwdtrmn9GvFW7DNHY6w1CIS8a/gyLZvixDSekRX8aPkwBXnHhhKQFvJ2mBEqJ/SMNxm7HxbkvYaPO3XF0qaOvfKMeL+wFOOOVLXcz5kgE9G2Wylam+vQhVGIkrHgYmMd6VSi7zpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776915; c=relaxed/simple;
	bh=RSp/CVlYaKANU7KahT3oKYqneBQSayPyzT/XgMhGJNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBhx4JjuVvteG4oEB0YIf4G1GTJxG5PVT67EEKi7co0wyJc7dtn0emSxSCfbbVNUzVLrwqyCOcILcC6o/WjncmEjYJOjypSqfUllb9WOhq4QgQqYmj/MJLuLicmQlRqblw9EGbMq34Ewkzkp9Lj/ZJ+60qODAff7exBY+2KS9/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFKQMaj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFKQMaj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054E5C116B1;
	Wed,  3 Dec 2025 15:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776914;
	bh=RSp/CVlYaKANU7KahT3oKYqneBQSayPyzT/XgMhGJNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFKQMaj2EnhE/jrjiKriL/0W2fY48kFojt4whra9/CpS9eAm+kwO+4a4YgEmIxLr/
	 Xpn8DpJyrnvfKncT543ritLh4TEQkxvhObIsDoVdH64gnw5vTgpKRWHgwLXvB+Ck4L
	 +NPI5JDZdq3Zzx0i1/uVUHePCin7KtF6Ym6M1EkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slark Xiao <slark_xiao@163.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 025/146] net: wwan: mhi: Keep modem name match with Foxconn T99W640
Date: Wed,  3 Dec 2025 16:26:43 +0100
Message-ID: <20251203152347.387924624@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slark Xiao <slark_xiao@163.com>

[ Upstream commit 4fcb8ab4a09b1855dbfd7062605dd13abd64c086 ]

Correct it since M.2 device T99W640 has updated from T99W515.
We need to align it with MHI side otherwise this modem can't
get the network.

Fixes: ae5a34264354 ("bus: mhi: host: pci_generic: Fix the modem name of Foxconn T99W640")
Signed-off-by: Slark Xiao <slark_xiao@163.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20251125070900.33324-1-slark_xiao@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/mhi_wwan_mbim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index c814fbd756a1e..f8bc9a39bfa30 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -98,7 +98,7 @@ static struct mhi_mbim_link *mhi_mbim_get_link_rcu(struct mhi_mbim_context *mbim
 static int mhi_mbim_get_link_mux_id(struct mhi_controller *cntrl)
 {
 	if (strcmp(cntrl->name, "foxconn-dw5934e") == 0 ||
-	    strcmp(cntrl->name, "foxconn-t99w515") == 0)
+	    strcmp(cntrl->name, "foxconn-t99w640") == 0)
 		return WDS_BIND_MUX_DATA_PORT_MUX_ID;
 
 	return 0;
-- 
2.51.0



