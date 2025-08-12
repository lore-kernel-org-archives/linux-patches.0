Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1641C84C7;
	Tue, 12 Aug 2025 18:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022245; cv=none; b=h2Etknvo2wYIw1KD2ge72U18P3PGLt1UK0aYcWVAxqDLypDLyE2WIz+MfWL/EGHIPO8LeiSV+6wrXTFh4dOry7QK3OJXK9YCDcv/I54kRZWQylzBLN3AHLJ4LtTqwoUwLZOUO49J4ATpZvArc5+Z8NJGRWBc8Y7T0aWNBd2tGuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022245; c=relaxed/simple;
	bh=4DQcAn3I4blhEoRLV0ge5Tiv02FX+Yk2V0DfJ6Iokp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6wZKx2wd7OICaDPpq/CaFxt05urSE53BhdwvRRUqG5pC5kdm7j6M6EFAlz+rklJ6iO8ro3gfeaZA+draKz1u1FpwWgQXDeo2xlj5O2v2GyI5kgXi0lQg5tDIyS7oaql5VJOS48Y0AULubXddCakV5b2TAP8oG05U37RJSgVJ9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aswlj6St; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aswlj6St"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393EBC4CEF0;
	Tue, 12 Aug 2025 18:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022245;
	bh=4DQcAn3I4blhEoRLV0ge5Tiv02FX+Yk2V0DfJ6Iokp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aswlj6StgTdKCAjiMJO0/dXRwuXLAhudCLVGC1byNdu70V7Se3zoKwU1BdEvkTiYC
	 0NaGlJ+fhvh/oUN0n6EyfGVgm74/AMk03dbUe2HWVxIOX1qiObdmQfRue51wU4nu5c
	 Ghn+iRZGPh1F/YNu5OWGEBrTNvFuEOrv42WHsajw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/369] fbcon: Fix outdated registered_fb reference in comment
Date: Tue, 12 Aug 2025 19:26:34 +0200
Message-ID: <20250812173018.429563534@linuxfoundation.org>
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

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit 0f168e7be696a17487e83d1d47e5a408a181080f ]

The variable was renamed to fbcon_registered_fb, but this comment was
not updated along with the change. Correct it to avoid confusion.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Fixes: efc3acbc105a ("fbcon: Maintain a private array of fb_info")
[sima: Add Fixes: line.]
Signed-off-by: Simona Vetter <simona.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20250709103438.572309-1-oushixiong1025@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index c98786996c64..678d2802760c 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -953,13 +953,13 @@ static const char *fbcon_startup(void)
 	int rows, cols;
 
 	/*
-	 *  If num_registered_fb is zero, this is a call for the dummy part.
+	 *  If fbcon_num_registered_fb is zero, this is a call for the dummy part.
 	 *  The frame buffer devices weren't initialized yet.
 	 */
 	if (!fbcon_num_registered_fb || info_idx == -1)
 		return display_desc;
 	/*
-	 * Instead of blindly using registered_fb[0], we use info_idx, set by
+	 * Instead of blindly using fbcon_registered_fb[0], we use info_idx, set by
 	 * fbcon_fb_registered();
 	 */
 	info = fbcon_registered_fb[info_idx];
-- 
2.39.5



