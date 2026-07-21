Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61C844AB9F;
	Tue, 21 Jul 2026 22:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674649; cv=none; b=Gqt146YUb2SA2BU/KTo/QYNXCI4aV2srKnki99pr+TjfdYMyibnliQFVuXx8IExxpbSuORid0s/ejqN7t7NE5TzFJz8s/Hk3IqgX4gNH+Q/qFIF/VVcYgPt/nu1Zg1WpQ+58r/B1kJPtybOhfxtGAu7ubMqfDRkBffpQt1A8zTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674649; c=relaxed/simple;
	bh=KxYKFKjuJtYSRwXKsUVLtd6drEt/hCAIr6PcXRr9vM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDJKXtX6IZGZ8/vU6wamVoyZnbxhaadAbBc31Fz/dqu4GxfjQiiMKg2GpANuSzWmrNPNwckwfaKlMrMXDvbEaplyxyAvz+3wImGsZ+o9iGYW2i+OqkgpXo2JvhAH0dTAObgPjj9VAoxiIyTt3B9Xeug4UXLMtxlpWZvbCktKHJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXruWFVX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXruWFVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576F61F000E9;
	Tue, 21 Jul 2026 22:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674647;
	bh=aTVCmH6/58Nvc6iSSxtNBzmJTlnHbBSCc7FNo3M6nwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXruWFVXQo8p7jneKbGRGIzlMs4Gde2sVPGtfB4SVQ+oxlT7/cO1MY3/BlBojBvQC
	 AsGefUJye3jRISig+grsNt0778lWr25DVx4jkZeS+0GD/iWCV8FcVrMCYrVsu/z4gR
	 FvPXMMqTJdjL2ji2AJCW48EJ7EZwv7XnI+nJf9kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Aiuto <fabioaiuto83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 619/699] staging: rtl8723bs: remove commented out condition
Date: Tue, 21 Jul 2026 17:26:18 +0200
Message-ID: <20260721152409.709306222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Fabio Aiuto <fabioaiuto83@gmail.com>

[ Upstream commit 2a62ff13132a22a754d042b2230117bbea0af477 ]

remove commented out condition checking channel > 14.

Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/83762719c0c13ac8b78612a32db26e691eef17d1.1626874164.git.fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a1fc19d61f66 ("staging: rtl8723bs: fix WEP length underflow and OOB read in OnAuth()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -165,7 +165,7 @@ static char *translate_scan(struct adapt
 		start = iwe_stream_add_event(info, start, stop, &iwe, IW_EV_UINT_LEN);
 	}
 
-	if (pnetwork->network.Configuration.DSConfig < 1 /*|| pnetwork->network.Configuration.DSConfig > 14*/)
+	if (pnetwork->network.Configuration.DSConfig < 1)
 		pnetwork->network.Configuration.DSConfig = 1;
 
 	 /* Add frequency/channel */


