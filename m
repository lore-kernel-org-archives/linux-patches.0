Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C58C1C07FF;
	Tue, 15 Oct 2024 13:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997957; cv=none; b=e1u+s4fCP5z9+c4srpei2LC1Fw0qV6E/plPD2deKG2wdp5PZ3kt4EwMKEgAxk39V4arzya0c1IpLovnDZjpCC0MJzeLvnN9ge/8QuSK5tpO3cqt7c1Ge4ErrY0EmztTdhSTHoL2HYQuBC9ouM2BmDw5k2QCulMnDRFPk7y2RYIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997957; c=relaxed/simple;
	bh=pnD6K8w0jl4FPDGexyOyWHi5JMSgO+Vkw/+gvTkI6Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGH1dd95Wp2i23GJF4cpwtRcGxQEmU5xKXwOnj9FXIDS5idn+Nb0BTEJTRQ5I7WmUENhT4bCZxBGumUgBWpOEfhzQ/8JsmAWkqbhRTmfA0OFMMFFChz2kj67S7vPjGU3tjbE/JjGUDHuHuVnN0dWjFE27wMEKPW9HziT6kflHQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xod1Monm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xod1Monm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97C6C4CEC6;
	Tue, 15 Oct 2024 13:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997957;
	bh=pnD6K8w0jl4FPDGexyOyWHi5JMSgO+Vkw/+gvTkI6Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xod1MonmcUhWGA+znQ2UsKCvb5GXe/vyEi52uo8N1q8Ky9TgkmSKfP8z2sRaRMvku
	 ihBCSSsAF+PBzVUbylGayiBw5ZlyXPdhmJO7zPJAVVP6SmfrO2I/X+rvcYmqqDmpBk
	 x9vggcXBv0ro6hpyzFWSVsj6k9FcxmDuHeEl47z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 306/518] wifi: rtw88: select WANT_DEV_COREDUMP
Date: Tue, 15 Oct 2024 14:43:30 +0200
Message-ID: <20241015123928.797096883@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



