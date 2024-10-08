Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1B5192594;
	Tue,  8 Oct 2024 12:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391442; cv=none; b=QeohH5oG6cs1hruf3kEkn2n/O1nBcuDDHEhsD5zUjINqb1nCsBIGg/Y5BRmYm/lwggP0XfqvN5L1CFZlKNPTKQc+xjCleQUeHiOVvNBEYLPMkdpJZqIbaJrdPFICGSaH8wKSP4Sh38pqQDSxc0ZPo/jRquxXHHIdDx0JImd4BSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391442; c=relaxed/simple;
	bh=lAZ4M80G7zgKqhI1bEeli1uur/pGMkD5KB5COt/GiWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQOX4cJrqVCl6ZNbKu4+NeGR4Wxdr2jz7Tcg554rOA2IhMKVfwLxJtHwajR3VplmjcoaFTj5OOzP44U7LamQNo8Vg45vCLCfncIqOO8RWLNULq708F4rp6QtK8rtmjqiYTzO0y6TyfniRWDzo+ErYqXg3la7I3YAF+ds7gPD8KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8ukfdzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8ukfdzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B86BC4CEC7;
	Tue,  8 Oct 2024 12:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391441;
	bh=lAZ4M80G7zgKqhI1bEeli1uur/pGMkD5KB5COt/GiWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8ukfdzTcKnmTZsmG+ty4TSu6DF05pLuOEl05Qe7SlW8L0FPjkuNf53Cj9KPZvWC2
	 sYqn7wFZLsKDS3IqdTjHWkHbQH8To+sccPEi6xFMjUmuvu2Yoc9QutVvsommifLaa2
	 Tj5v2J1puwb2KrB9ZWtxau4M4zCKzPNVvH31H09Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 116/558] wifi: rtw88: select WANT_DEV_COREDUMP
Date: Tue,  8 Oct 2024 14:02:26 +0200
Message-ID: <20241008115706.931187942@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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
index 22838ede03cd8..02b0d698413be 100644
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



