Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0965A1EF933;
	Wed,  6 Nov 2024 12:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897394; cv=none; b=bT4v/xP8HKccxgv5UR3c9ssqGLuw4HPEEPnxiegX06qf+etIKJnWfdmOkcncKCrtsUOTn5GGFNz99S1sdwWD4gXQYlc6/hSefQhJBcnmWTePuMI+r4URkQkPDvIh+PQpuXxG2DlT2EZE9OGRJymDBP4xYx9WmI0Kn4UfTsRTGME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897394; c=relaxed/simple;
	bh=aLyobywxSWeQ3oEpBpZgMwL5VyjOzoQCv3NgaV84740=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWVfN4Apj2pXWg/S9TAqPiXdYUdlHg+gK5nTGVaOehJx7AnEvd7Hc4bIApay1BLywaj8tUgyPCFxJ+HXs1ZcA1hfMydkQjs80i4SGntyQqhsz/2yMg7AZ9oR3CAg80cPRrXhdnaHMDfMQHNnbiRBqhsHvXPPhUKLP1NG6SVB5y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qC197E34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qC197E34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AF5C4CECD;
	Wed,  6 Nov 2024 12:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897393;
	bh=aLyobywxSWeQ3oEpBpZgMwL5VyjOzoQCv3NgaV84740=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qC197E345nogwYvTAw+5/rxT87chaZFWbCiLwFRAe4NIf6mMVnk9ACvj5FtMApZCT
	 GKHbxYtBug8lpGCgyblSXdkVJXeplBaUgfdRfKqKRYBLJWJ/4FUEBPinrXBNraqCAb
	 aqwbn+m4HihjdnAWM02DOzM3uB0+b4WHZaJomal4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/151] mac80211: MAC80211_MESSAGE_TRACING should depend on TRACING
Date: Wed,  6 Nov 2024 13:03:17 +0100
Message-ID: <20241106120309.097512358@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



