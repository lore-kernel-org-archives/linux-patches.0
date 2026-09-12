Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9351B415B8E;
	Sat, 12 Sep 2026 09:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205464; cv=none; b=eT908lvss0igNf26s7JiKHt607B/S5PD9woQq8/bMwYv0NJ8M9jWNJk7Eh2Gpr10iHl0GZk8Hwr+Lgu4C4arTSb4KxJ951Emr/yNTEb1Kb6TJFdFgTbwuHFUhTnRDB8s/dQoYx05a7ox/TwU7CHZsIHDqecvjKWbHoW/8mhxLIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205464; c=relaxed/simple;
	bh=yjhspxsIi4OadzLyIvGyR6t2BPgAcWP5A984aIMtvs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJ5kgZFNpv7OWMVYUUahn9pOLA712x/9r+9h4eJYYiMCoAnkzBNt88TFYJjQbywKw2yiTWUxkwc0uTvS99OE+U64xX0VocaZgQPgcC7IjRAH5e1qAJFdRc7R1H+TdN5BrSh+2gH8907SudqSbnBi1g8+4CsKZNuvjUZyoYsz6ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9JqI38l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9JqI38l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8483A1F00893;
	Sat, 12 Sep 2026 09:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205463;
	bh=LMlZtG4tYA5Ip86lTGdRoF4BOx8X2NO8ai05fbnjzOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9JqI38lZLPyrNCTpybKbOV6GaHw6Nq6oz/uB2GurdU93Eic5F9R2YUiL5rWonMQN
	 lcM1ESqrWZPZOyIxOGeWzhsHh7L89woIGbQ/WN/Qi+vJgzz39mrLB/70luTDU9a376
	 bWqafI1Ru+A3rKeuLfNZwHozrHou71j0f7rUf4D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Sk Anirban <sk.anirban@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1782/1815] drm/xe: Do not apply WA 14025883347 to media 3503
Date: Sat, 12 Sep 2026 08:58:52 +0200
Message-ID: <20260912065730.863218864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit f0feab6e9e008faa406d189fb40cb7ab1bed420a ]

The database was updated and the WA is no longer listed as applicable
to media 3503, so don't enable it there.

Fixes: c57db41b8d2c ("drm/xe/guc: Add Wa_14025883347 for GuC DMA failure on reset")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Sk Anirban <sk.anirban@intel.com>
Cc: Badal Nilawar <badal.nilawar@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20260818213520.283063-1-daniele.ceraolospurio@intel.com
(cherry picked from commit fae59d5de5de39bc51ac2839f74970312e0c8905)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa_oob.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index f8a185103b805..132a41859ab79 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -63,5 +63,5 @@
 16026007364    MEDIA_VERSION(3000)
 14020316580    MEDIA_VERSION(1301)
 
-14025883347	MEDIA_VERSION_RANGE(1301, 3503)
+14025883347	MEDIA_VERSION_RANGE(1301, 3500)
 		GRAPHICS_VERSION_RANGE(2004, 3005)
-- 
2.53.0



