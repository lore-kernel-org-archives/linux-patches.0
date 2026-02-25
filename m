Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988D01FE45D;
	Wed, 25 Feb 2026 01:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983995; cv=none; b=A8y+DnU9CY46weyDuL40xIxqR+puuJwY6Go+Zbr5gcwbs4Nf5deolr2wqxTPhi5V9vQLYayGUK8Bx0LGd2mJK2RQnfxDp7jrTdDnZSbgXuY4l3wlorhxjSye5Db0Yx2gFxldWRhgtbACMl6s44WohIPw64Gh0Chwta+A8oPT4kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983995; c=relaxed/simple;
	bh=fcuaRTs1OLtVSskA2/LDGrvV68Cst//mp8FeNu0E9Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c4A3Unfl6WY8IsG8ft7DKBOYkwSaFa5f6fxVbo90+dHqMZw4GlI7EQfWDNleuKxFh4RdY6PvHHprvXTnWdEgUg53KFeQcQSUbtfgc/bnzbiGnrvb+jyMdASAChf2cRWLpoC2WgqbVnz3HXETnmy+SL3Fx1ZEBLF6UKHPb5J69y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6iF3JB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6iF3JB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26763C116D0;
	Wed, 25 Feb 2026 01:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983995;
	bh=fcuaRTs1OLtVSskA2/LDGrvV68Cst//mp8FeNu0E9Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6iF3JB/mRkDbOeA8irQ5FItlbPABfpL3q7I+wniHUlVy3YYSz4vkrhP2l1psmzio
	 nWcZPpAFMxDGH1NEKiCEEwenodVtLJeb5nMrv3fuE5snOmUSecf9KefVx0PqttlJmQ
	 e8tTfhc74q7zkI6VStBqkLsfTB3PtuTfOL4j75ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 249/641] wifi: ath9k: add OF dependency to AHB
Date: Tue, 24 Feb 2026 17:19:35 -0800
Message-ID: <20260225012354.885923156@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



