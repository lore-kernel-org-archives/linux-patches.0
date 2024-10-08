Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BEB1DEFED;
	Tue,  8 Oct 2024 13:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393207; cv=none; b=SLtOxItodfrYcH5HB+F4E77RQjCiq3GnGbZH5PtJbeQ8cqyW2wsKkb++vtxeIdN/NsaR5UAULoBwKLu0XN7OjhIWe+VO8i/8lYBAp+ooq5VTXc5/1GnEifiorPbRuJztWTibMWjQV+vaBcLwmtDh4jTFOj0xE3Y8wR8gfyD8+6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393207; c=relaxed/simple;
	bh=twa4kOF9p1GkjolZfHajeOhhfEIstVp+g8f7LVuenfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhyRBYwtNSUrK1nItSOriYu0VW4NKDLBm3aKKR2+U4lUSeK+U55rvZeYclOEXgClFga8QItJoTwzC//6pryjZUlcFQzoFPDAQEPdmBu+b/dbINvcRZhgOGfIMwr/VRvTc2YlyHU1uFt2OhuBcpmcCtvnKci7U+tltBEUEUPDVsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WokVjNGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WokVjNGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968C7C4CEC7;
	Tue,  8 Oct 2024 13:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393207;
	bh=twa4kOF9p1GkjolZfHajeOhhfEIstVp+g8f7LVuenfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WokVjNGm6iEp+m+kSMFnGaz1Y5dhp8vXXHZgPtiYztAZHI0SVk1Y6q0N7+73n4FQ/
	 PUrCKTXz3kPQyyP1OnQ3vUMbb49C8ynoS5UYlMYi3d1DPGspq2okxjIEhBzYhj2OJw
	 1O5n4f8/Dx3Mg36fMIp91f7XcUyyhMm1A0MBDh34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/386] wifi: rtw88: select WANT_DEV_COREDUMP
Date: Tue,  8 Oct 2024 14:05:28 +0200
Message-ID: <20241008115632.724261268@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cffad1c012499..2af2bc613458d 100644
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



