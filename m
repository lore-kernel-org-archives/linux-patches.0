Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F51519B3FF;
	Tue, 15 Oct 2024 11:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993574; cv=none; b=Mq1gZJ6NzC0hHoYt4ZN7aKcoD0lA5oqPS/IEf08XZbyQyJoduIsD3S2JpirmugF5r2Q4n9KYAHq7ctjVfep4iQXJaC8cWMyY5q5ELAbju8ThRMR20nHeoEchDv+3dt+QJuUq5PFMLWaGHWmLP+pU9wjLF+7QE7OcyLLWIC8bV1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993574; c=relaxed/simple;
	bh=vD9s+ZNpl5vyuz3NQS8G4McorOs9TMSSUFb00TwuqpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfiDJZIyaw961+3R+Hu0PZM3yh3G5xbUmlpJQyzisbz7iUFHGvQe3PBwr4Foh4gldU7Dd7MNdl3+V7NymoJ/kGjJYy/p6JXD8CtgV0WuThLFUe27Yqiu63QAuo4iF3QF6ObZ0etRFlcXtK9suNigoV143A5b5rwjeTkalniOEj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZSniNJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZSniNJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EA5C4CEC6;
	Tue, 15 Oct 2024 11:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993574;
	bh=vD9s+ZNpl5vyuz3NQS8G4McorOs9TMSSUFb00TwuqpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZSniNJ+prTkzG+n0CWFbrcglTWUx3sYGEAY4co/m3jeIsfJE2bLzzQUzoNRrOZte
	 m4vEaHMmJ6d//TiQIXB85wqepID13QaDhsCm19iVRjzOCdygE3BUBDJKLkpKLnfLn5
	 b6e0U6xnADQ9rWxA914kN9tZ+ZIBPWNIfbkUl6m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 421/691] wifi: rtw88: select WANT_DEV_COREDUMP
Date: Tue, 15 Oct 2024 13:26:09 +0200
Message-ID: <20241015112457.054549108@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 7e989b0c1e33210c07340bf5228aa83ea52515b5 ]

We have invoked device coredump when fw crash.
Should select WANT_DEV_COREDUMP by ourselves.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240718070616.42217-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
index e3d7cb6c12902..5c18da555681a 100644
--- a/drivers/net/wireless/realtek/rtw88/Kconfig
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -12,6 +12,7 @@ if RTW88
 
 config RTW88_CORE
 	tristate
+	select WANT_DEV_COREDUMP
 
 config RTW88_PCI
 	tristate
-- 
2.43.0



