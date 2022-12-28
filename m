Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD6C1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37C4C43398;
	Wed, 28 Dec 2022 16:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243235;
	bh=8dHz68H1Uj+xaR1T8ByyvWjIaz529nGW+h/QHX9DYLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOoPb6rAc8gPPF+CesbW/Vg381l/PEE5qvXxww3L0dWHdtuL0DqLZ0CwYfJ+scJSy
	 WjmBH2zVF+5ehkOqeNTqqA6NBtU+QlisvjoF3GSHdj/sIxDXp8F3PCLqgxuNYBK63E
	 XKzkV6iwRGVp4n2k2pqKFa8t6nuHM+gRXE+aajdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0504/1073] wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h
Date: Wed, 28 Dec 2022 15:34:52 +0100
Message-Id: <20221228144341.731349109@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit dd469a754afdb782ba3033cee102147493dc39f4 ]

This struct is used to access a sequence of bytes received from the
wifi chip. It must not have any padding bytes between the members.

This doesn't change anything on my system, possibly because currently
none of the members need more than byte alignment.

Fixes: b2b43b7837ba ("rtl8xxxu: Initial functionality to handle C2H events for 8723bu")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1a270918-da22-ff5f-29fc-7855f740c5ba@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 782b089a2e1b..1ba66b8f70c9 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1190,7 +1190,7 @@ struct rtl8723bu_c2h {
 			u8 bw;
 		} __packed ra_report;
 	};
-};
+} __packed;
 
 struct rtl8xxxu_fileops;
 
-- 
2.35.1



