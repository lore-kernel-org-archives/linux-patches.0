Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0A1341650;
	Tue, 11 Nov 2025 01:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824043; cv=none; b=FwhxlLjsL/TQ71zqr6A27vEfKMZ02qwWjbqoUgy7gVoL+V5kBpN1PUj/kQsgPgLEsCxznrxPkkevWZ/aoaTRLKehLC1pCfw2Hkcahsl6vFI3e4uA/sozgdmDXY3OG+7lpC1w3uHqjAC7RSRY68wnzByJuok1T2qqhWHETAYRYK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824043; c=relaxed/simple;
	bh=xYsb7htl5kWtAzYEukzqL/1GEckej4TRpn/MN4Oa7pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9roldlexXs5D3hBGqmO9j3Xin7CU0sT3FSma8SI46PLluzp1ezeFKXTStsH2f++4q6pK+C9cr01vXFBuktTKsqiRgE8g2T4M4GJiB73MpnMmof1DQYNvTqc3Ygq0dd5x5blyQezBByQlYhZq3P32ZLsFDAo22x6OjtrPPZ6/Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tog16TCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tog16TCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E4AC113D0;
	Tue, 11 Nov 2025 01:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824043;
	bh=xYsb7htl5kWtAzYEukzqL/1GEckej4TRpn/MN4Oa7pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tog16TCazeP05ozWF8XP0wbr+q0sraUBulMXehC8DOOUN4LsskqVgbd0ifWChvuzk
	 c/VYTuN+Ao8IjgiY9nXHUw+Q/uUYtiAGdSjv70Rm40n/C/Hjkyg/9Iv6ZCuxzuTLC0
	 5lA4qzGJH7gh+OVAZA4++nvKI2bgZ3ukKNqPNFFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Atwood <matthew.s.atwood@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 426/849] drm/xe: Extend Wa_22021007897 to Xe3 platforms
Date: Tue, 11 Nov 2025 09:39:56 +0900
Message-ID: <20251111004546.735663149@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>

[ Upstream commit 8d6f16f1f082881aa50ea7ae537b604dec647ed6 ]

WA 22021007897 should also be applied to Graphics Versions 30.00, 30.01
and 30.03. To make it simple, simply use the range [3000, 3003] that
should be ok as there isn't a 3002 and if it's added, the WA list would
need to be revisited anyway.

Cc: Matt Atwood <matthew.s.atwood@intel.com>
Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Signed-off-by: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
Reviewed-by: Matt Atwood <matthew.s.atwood@intel.com>
Link: https://lore.kernel.org/r/20250827-wa-22021007897-v1-1-96922eb52af4@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 535067e7fb0c9..f14bdaac674bb 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -879,6 +879,10 @@ static const struct xe_rtp_entry_sr lrc_was[] = {
 			     DIS_PARTIAL_AUTOSTRIP |
 			     DIS_AUTOSTRIP))
 	},
+	{ XE_RTP_NAME("22021007897"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3003), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(COMMON_SLICE_CHICKEN4, SBE_PUSH_CONSTANT_BEHIND_FIX_ENABLE))
+	},
 };
 
 static __maybe_unused const struct xe_rtp_entry oob_was[] = {
-- 
2.51.0



