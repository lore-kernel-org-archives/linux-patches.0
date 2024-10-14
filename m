Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120684CDEC;
	Mon, 14 Oct 2024 15:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918832; cv=none; b=YQ60IrMME3AmxeIoF3lqqm9/AZvnlqG516MnfwVd8804EU/HdaYTbt0Qz4IVEQCkWJ+RKxnYBUdKSD5HSMi4Qpigd4tX/JcQGoku0fQH+tsYCSfUF6FOZ+fAYSxk1t5oyg3ap2ZplkwYqflARAsU+3IKwiB+wazv865ovyC1Tys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918832; c=relaxed/simple;
	bh=+C3IPsefhQi8+mJxnUqFn9+o8y95i+nhiDRvEzZcRkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUwMFpqtIY/N/o5RJCxnXkQIEOYlSUaxAd2lQy3hK7L8F9wo1B81pRJxeeRojI32K3PKYMmFvulnkXPfgDVcg3KFblwRZSjbqefYw9/TnJ8HJeNJ1rP8o7zyKAs1ofhfDnzpc2v0XV56tyq6aiPLvN86BbagiUK3NqMfs07b1yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sML865Dt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sML865Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D400C4CECF;
	Mon, 14 Oct 2024 15:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918831;
	bh=+C3IPsefhQi8+mJxnUqFn9+o8y95i+nhiDRvEzZcRkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sML865DtddwfBdiL4E6KTzQ4ip4Pp15WEMAzBDHZmuBP3gLUH88MLgjZRm61acFXU
	 IRT8NOd7GilQ8d2k2QUW5umVtAWoqhb5trV1m/p3fQmStrEZxylHMjXzJCHzEUzlLA
	 oALbkojpUaE16l2TzfQQn6T/reqLwh5QTv+99xlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 436/798] wifi: rtw88: select WANT_DEV_COREDUMP
Date: Mon, 14 Oct 2024 16:16:30 +0200
Message-ID: <20241014141235.092245325@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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



