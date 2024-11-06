Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF521E0B7C;
	Wed,  6 Nov 2024 12:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896751; cv=none; b=Bb8bDl3KxkcmbC/EeBqhpKjazhxigVeJZ190v453sPgSHkg7WwMoT9tjr333B3jUXe70wsK5pI93A5yXIh8N1hruwU5ER98l3x3g8UNNAY/ZjM5CPQDV8698IaSr7+d+UtuYLdGKkqyct4G5OT9WQLigXRSkq+qWKWYG4C3kvA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896751; c=relaxed/simple;
	bh=rIwIDQ52LI8UeejoMlZKGh78AX1l+PdzHl9GFDd5I4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZTgRBC21wkj4Rm465ZPYIkQDHsm3ORgSYsU3IMPuPEUle3T1QcoM5rn0BvWkycbWPbHsm71N0ZxlPIt3fuxxg82w1yyThWdnnpTDNDzh5AvKtInQkskKo3nyWI0/oY1TSzumfly7DJ4LJaFiwExEGrOzx+IIPYnPjLMk5fRufU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12FJlE46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12FJlE46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11F7C4CED5;
	Wed,  6 Nov 2024 12:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896751;
	bh=rIwIDQ52LI8UeejoMlZKGh78AX1l+PdzHl9GFDd5I4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12FJlE468MhSbeAS2ITN3vKfy9YyH9P3THbw8XG3TuXZbxBHkZWQK/xJ2GPYvsmZS
	 3ueOFiHDVoDIrDVe62yQHOshFWDmaaXgZtaM5oJWoki04ezRfd+VusYQC8ROha1vVr
	 D6ofWMqBBfB3zgFuV7yPekLddeHDfSoOsitLy6/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/110] mac80211: MAC80211_MESSAGE_TRACING should depend on TRACING
Date: Wed,  6 Nov 2024 13:04:25 +0100
Message-ID: <20241106120304.827634126@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



