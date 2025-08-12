Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217B72ED17F;
	Tue, 12 Aug 2025 18:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022910; cv=none; b=VEWFeJg4gscBjb4+7G+pnpuF4cZrZASbqqti6LEGYTeaQI6CZ8WXzHUeFELjnD/PcGKD+OH+lgsRqG1eVbkoOOAypFcq5ORbNki17B2vM4TGVqz0RHxGLePjVp4sukSlLkbtE7Kf58WFoyTODN8td8/tm3Vrqa80k73hCOFVVd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022910; c=relaxed/simple;
	bh=6ZQ+aKepDVMUuAuw6eI/hMVT6b0r4x/T7AnuRr+zLn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPkMIKD5lqn5Fx20wz/AxE8G559BoXhO9r9tx6v8l8R1MrsPKQFcJcBp1m6cPjlRlQsM4X86ksDQxE5mU5kH02AlcOiwWQsULgYg4XNkQCW5EtVNtIfVD0iLkxHr6gW2iV+BGu/jrmYhvP7zSGK0sbPNWs1HCuk8DrGct+T4JM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGW8M4T8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGW8M4T8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7F9C4CEF0;
	Tue, 12 Aug 2025 18:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022910;
	bh=6ZQ+aKepDVMUuAuw6eI/hMVT6b0r4x/T7AnuRr+zLn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGW8M4T8+FtKy4VFSLozrez7OvwWgI98mQmWTaBo6pDA0VMIXmgNtqtTMAxQV52gL
	 YjHNioJ6LFmiq9kcfxgXrWADPOcEsCC+ApF+dabEvAr8XdoymcDvd4yJk3tZotI1hK
	 r40CKCww/FxJddTSXuWw7jgzY3efQWD4ZZ1dIYUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baojun Xu <baojun.xu@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 296/369] ASoC: tas2781: Fix the wrong step for TLV on tas2781
Date: Tue, 12 Aug 2025 19:29:53 +0200
Message-ID: <20250812173027.862609321@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baojun Xu <baojun.xu@ti.com>

[ Upstream commit 9843cf7b6fd6f938c16fde51e86dd0e3ddbefb12 ]

The step for TLV on tas2781, should be 50 (-0.5dB).

Fixes: 678f38eba1f2 ("ASoC: tas2781: Add Header file for tas2781 driver")
Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Link: https://patch.msgid.link/20250801021618.64627-1-baojun.xu@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/tas2781-tlv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/sound/tas2781-tlv.h b/include/sound/tas2781-tlv.h
index d87263e43fdb..ef9b9f19d212 100644
--- a/include/sound/tas2781-tlv.h
+++ b/include/sound/tas2781-tlv.h
@@ -15,7 +15,7 @@
 #ifndef __TAS2781_TLV_H__
 #define __TAS2781_TLV_H__
 
-static const __maybe_unused DECLARE_TLV_DB_SCALE(dvc_tlv, -10000, 100, 0);
+static const __maybe_unused DECLARE_TLV_DB_SCALE(dvc_tlv, -10000, 50, 0);
 static const __maybe_unused DECLARE_TLV_DB_SCALE(amp_vol_tlv, 1100, 50, 0);
 
 #endif
-- 
2.39.5



