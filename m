Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E481E1C33;
	Wed,  6 Nov 2024 13:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899161; cv=none; b=XgkSffVjiW9ss8nb6t0sxdGZOzPOAH2M+ABnSP7gkMQeygqTKZED6TfveUwb2rWT3eJUcuwkQV1flGuXmVX+vEd5orqEP5Uo5FyXgxLjwselxDhyeY+EkmpYZMEEEGe/rZvB0QOO9YUkMYn7ddGrjPr7B8SAkcBJJMXtQozMPeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899161; c=relaxed/simple;
	bh=sMyRLOGtdBGZLb50oiqKvR3Or2AxwfeoEim092TmaNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGnWnM0it4T/jmtd+0aKoGg6Y+1lLL47nYQXNB5gIpOoF3Xj8G4Az7X0+c8ynNj4oV191m7TfWouZtX6nWHlEuEl2Dg77BPArhTmjG6vUGguh7tJ/RnLkZQD0c9qBheeiECDb2C7Is7wGOpjLVIH+WXmzGHit1tj6MrvjeMZvTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Me8My0CA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Me8My0CA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6666EC4CECD;
	Wed,  6 Nov 2024 13:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899158;
	bh=sMyRLOGtdBGZLb50oiqKvR3Or2AxwfeoEim092TmaNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Me8My0CAkE1/wavcjTaYSdFxwyBGdkGz1aZdmyGvB/8SS2FmfoTmPvqrJ7dCtZYxA
	 WAxuTgEKPRH7eoyAY8u6SoiAYt0wF6FDAbgq5ijDRh/O2QlB6yovdNiqGKQOMfQuml
	 SOP+utg+K8jy8gXnv4PWAjN2tvj9EbMEhoFEaBhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/73] mac80211: MAC80211_MESSAGE_TRACING should depend on TRACING
Date: Wed,  6 Nov 2024 13:05:11 +0100
Message-ID: <20241106120300.184063320@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit b3e046c31441d182b954fc2f57b2dc38c71ad4bc ]

When tracing is disabled, there is no point in asking the user about
enabling tracing of all mac80211 debug messages.

Fixes: 3fae0273168026ed ("mac80211: trace debug messages")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://patch.msgid.link/85bbe38ce0df13350f45714e2dc288cc70947a19.1727179690.git.geert@linux-m68k.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 51ec8256b7fa9..8278221a36a1d 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -86,7 +86,7 @@ config MAC80211_DEBUGFS
 
 config MAC80211_MESSAGE_TRACING
 	bool "Trace all mac80211 debug messages"
-	depends on MAC80211
+	depends on MAC80211 && TRACING
 	help
 	  Select this option to have mac80211 register the
 	  mac80211_msg trace subsystem with tracepoints to
-- 
2.43.0



