Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EEEE573
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12A4C433D2;
	Mon, 15 May 2023 16:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168937;
	bh=uCSUtyvj8ZSa6PDseg7z1s5325cFPAq9sbVZ7nFabB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvS8s5AefH7DYWzyzGrIIupVranApQJkKL0UIVub2ChNBjQD1h3CtYwfiPP1+PBZW
	 mvr/Nl473UkWms44AZedwQ3U08ZIP3jVhzsEneD/RFjKBZXZPymha1FeP44XtXOGF+
	 hctJg1wIyrLMXr61DvldxPDgi7NxsgYb/2yMNSyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/191] rtlwifi: Start changing RT_TRACE into rtl_dbg
Date: Mon, 15 May 2023 18:24:57 +0200
Message-Id: <20230515161709.391512103@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Larry Finger <Larry.Finger@lwfinger.net>

[ Upstream commit 78a7245d84300cd616dbce26e6fc42a039a62279 ]

The macro name RT_TRACE makes it seem that it is used for tracing, when
is actually used for debugging. Change the name to RT_DEBUG.

This step creates the new macro while keeping the old RT_TRACE to allow
building. It will be removed at the end of the patch series.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200723204244.24457-2-Larry.Finger@lwfinger.net
Stable-dep-of: 905a9241e4e8 ("wifi: rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_rfreg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/debug.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index ad6834af618b4..14f822afc89ac 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -181,6 +181,10 @@ void _rtl_dbg_print_data(struct rtl_priv *rtlpriv, u64 comp, int level,
 			 const char *titlestring,
 			 const void *hexdata, int hexdatalen);
 
+#define rtl_dbg(rtlpriv, comp, level, fmt, ...)			\
+	_rtl_dbg_trace(rtlpriv, comp, level,				\
+		       fmt, ##__VA_ARGS__)
+
 #define RT_TRACE(rtlpriv, comp, level, fmt, ...)			\
 	_rtl_dbg_trace(rtlpriv, comp, level,				\
 		       fmt, ##__VA_ARGS__)
@@ -197,6 +201,13 @@ void _rtl_dbg_print_data(struct rtl_priv *rtlpriv, u64 comp, int level,
 
 struct rtl_priv;
 
+__printf(4, 5)
+static inline void rtl_dbg(struct rtl_priv *rtlpriv,
+			   u64 comp, int level,
+			   const char *fmt, ...)
+{
+}
+
 __printf(4, 5)
 static inline void RT_TRACE(struct rtl_priv *rtlpriv,
 			    u64 comp, int level,
-- 
2.39.2



