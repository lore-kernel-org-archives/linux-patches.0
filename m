Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738FD18DB2A;
	Wed, 25 Feb 2026 01:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983186; cv=none; b=c81znteDlqejXbVtpVp1ZdLV4vkFerK0xzM/SwQRsHGaz0ksqR+j4dXya79ljiHVkwSx7ZGZOPIMp7bohBBnsUD+fZ8t/15rJpyaMneCN8jt3afk2H4xpu6fM3+4Q6oDbWvyk4pfEe7M9CJWQov4ZfGtrZak5L/DuzgRfJLEhfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983186; c=relaxed/simple;
	bh=vfZCQXY1btQ16dHnfIHsPsMZkongTOLUYLCl4SPdULw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T/eeiZjHByuNncQQslOd6YMGwxaR26/EAODvW98vyTMtO4G6csBatRVJqaH5NrJozDBivoAsRyeUBNJnaH8N9biqf6S0FbkuXB4xxb6/VQNPSi60OpJJJovcESdXxyfqIEhAjnjFTpJ6hoF0f5amOSvj8t0PB8pjvyqg83Gr9Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWt9wieI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWt9wieI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33866C116D0;
	Wed, 25 Feb 2026 01:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983186;
	bh=vfZCQXY1btQ16dHnfIHsPsMZkongTOLUYLCl4SPdULw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWt9wieItLYPjVYs0mzMt/+CQZBP6xjMkF6yHwnCtAwBbFN1wgcnos3saEFFbc4vT
	 /5oZDCbC0jXBPzUks14DWGSB4KNh9PNPRA0+tBYO2iPo8ZhagNwkV2GN07DBC/zG84
	 h9WbKoaLoqk4u5OwTqz2zZL1tzvPbNdyJh1jW7ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 336/781] wifi: ath9k: add OF dependency to AHB
Date: Tue, 24 Feb 2026 17:17:25 -0800
Message-ID: <20260225012407.936884163@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 125e7b31f041cc0a4ede1e42bef69915f0a63a35 ]

The conversion to OF missed adding a Kconfig dependency.

Fixes: 2fa490c0d759 ("wifi: ath9k: ahb: replace id_table with of")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20250802000432.3079550-1-rosenp@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 0c47be06c153b..47d570a5ca6a1 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -47,7 +47,7 @@ config ATH9K_PCI
 
 config ATH9K_AHB
 	bool "Atheros ath9k AHB bus support"
-	depends on ATH9K
+	depends on ATH9K && OF
 	default n
 	help
 	  This option enables the AHB bus support in ath9k.
-- 
2.51.0



