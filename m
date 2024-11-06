Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37A21DFD83;
	Wed,  6 Nov 2024 12:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895862; cv=none; b=bEO9k2qQrpv8oZDaF/sdym3UU5u0u9Kcz9LIy6FzzT3k/GjyrcwVUrX0OILvdXGN17OlIQi4aFzBr3Wy51r6gNsGE8tQwwAkr0tHP9RmWmmAomawat/rC3g60ihfRd3e/mM0JjUq5CGLy2iAQvJ9vMBOH7hzJZsiZevPy/L5NPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895862; c=relaxed/simple;
	bh=9tMQaqt5bPvLa8iDHhfiVXe8hkoh3/ZBq8ohcpVWxyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IO7fQ5Q1v6AaUXNe1/QqPdq0DHrWCqqy4/JJ6ZqOd/54AV702Yp5+xZ3tbtN+v4cdveWFVOyInm8hRa7NW6BI4ZPbO+xq09ckY7KpGcaxj/m0fTZuxERFg3WgJw5+4q64CgJeFKGLKfJI5G1VuH+BjG4bBGLZKLt+EsA9/gmHUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yv1YFt5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yv1YFt5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC8FC4CECD;
	Wed,  6 Nov 2024 12:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895862;
	bh=9tMQaqt5bPvLa8iDHhfiVXe8hkoh3/ZBq8ohcpVWxyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yv1YFt5ZgqYn3zvzDqdm0cn/DVq9Dqxy7vtXmPwIZ3DO7XeivSLKpNz2rhx00TLKc
	 voUL+bMY8ZTYp+2bPSb3GumGtxkQTlRpsJ73ODI9b6mVBrfxE8oRl5Zlu8VvYXokUn
	 7j09Dbyhb5CD5tv7g0atOPPNH1/IdwnZlsJ/1mRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 010/245] mac80211: MAC80211_MESSAGE_TRACING should depend on TRACING
Date: Wed,  6 Nov 2024 13:01:03 +0100
Message-ID: <20241106120319.497365962@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 13438cc0a6b13..cf0f7780fb109 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -96,7 +96,7 @@ config MAC80211_DEBUGFS
 
 config MAC80211_MESSAGE_TRACING
 	bool "Trace all mac80211 debug messages"
-	depends on MAC80211
+	depends on MAC80211 && TRACING
 	help
 	  Select this option to have mac80211 register the
 	  mac80211_msg trace subsystem with tracepoints to
-- 
2.43.0



