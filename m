Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5626FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35765C433EF;
	Mon, 16 Jan 2023 16:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887441;
	bh=tFL3DRUV9X9ht4G4sZxsGA6kvgD1ueUyZ0Vr2kD4Mvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2e73/c+/KhJNx/LgX8tpDfE/ckdWm9Urp9kBxrdKFTkW2eAiTC45j/r0bai80gMJ1
	 YRRrJ12oUZYvQiM+bMA2li4+kvdJqfCmT8KGYPe1JmgAk3B5Mqo/HoiuqvMnCm3zAE
	 vrDfigfT/Tu3iJS+CJ7BfEKsk3wQKQSNOxXEdJQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/521] wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h
Date: Mon, 16 Jan 2023 16:46:53 +0100
Message-Id: <20230116154854.023290546@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index bd28deff9b8c..7eef3f7c36ad 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1186,7 +1186,7 @@ struct rtl8723bu_c2h {
 			u8 dummy3_0;
 		} __packed ra_report;
 	};
-};
+} __packed;
 
 struct rtl8xxxu_fileops;
 
-- 
2.35.1



