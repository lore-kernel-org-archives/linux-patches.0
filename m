Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653421E0496;
	Wed,  6 Nov 2024 12:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896933; cv=none; b=rjJbReJLWP18MTALaeuyV9B9PUPy6Qr+Q7LwsMpt9kFAtP1Va5wqw1xE82l0kJXQJcclohWBzuRuNdol838Nd7CF9v10l8MHEAVsADgmF6VsM2NKGz0VVEgnCAj80VuOsIByb8YzccbUa8OQk3jn8i7iXrwg1MT8ULTUumMA5SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896933; c=relaxed/simple;
	bh=CUqSWyJZ9vr3n9UDkn0FULn2iWdIBbJXLY0ettqHZSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpBJq1XirazAWRlVzaztKI/OHrhzWfexx5Psh3tWgLyFKmXFaCTej9QZNSY2sKp9RxzkvhfcmwjVLegKI0nNz/md+rdvzxfK8J88mEJgKady5jPeadEXfFAH+ZHrx2vaS7t9Dp7tJirg3V2e8rEfu1P6UY7OCHxlqV9m2iSeAng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INu/F86k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INu/F86k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D78C4CED3;
	Wed,  6 Nov 2024 12:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896933;
	bh=CUqSWyJZ9vr3n9UDkn0FULn2iWdIBbJXLY0ettqHZSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INu/F86kAHb4XfxvwCBJsKEC2s2N1LjiFLEfLGsvPpRKiBYJgZg6ZUucuirjh4g5k
	 9Fgpng4ks0FQBolUV/+nXr4lgu3ZLlTw8MRI+Yl09mZ8dWI61ggJ9xs3NGo0Oie8hK
	 4ci6aDz6gNxIpg0i3LXy3e1GygYGDlRTIwFsNJE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/126] mac80211: MAC80211_MESSAGE_TRACING should depend on TRACING
Date: Wed,  6 Nov 2024 13:03:32 +0100
Message-ID: <20241106120306.379234624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



