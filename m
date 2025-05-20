Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A132512E5;
	Tue, 20 May 2025 14:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750739; cv=none; b=pyrwqsb1gyFBS/z1o6Zkk8fIPqnFQsM2zmAD6Mts4tbNdipK7cNl/fhDEzgZ7CZe6iKaTvEpYgLt5jhoeytKtGxiKh9DoFGUnwqy7OEbNcfG9xpr5ZsPyvGuYAmP5BQCAhESP9uZsox8B4rWftxnkTKOjep80l53aPq/V/YLUSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750739; c=relaxed/simple;
	bh=kEtp4KiAVcH85sfCaTtSl/ZS4fhQCkjcKW4qKyrcQ18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cnzliu7dCEvN56DaoeB9EkG4d6AccHvGKfDdveDlDmCYLO0qR0sJW7hOh13IIk/lixY120e1i8RBo2PWSijZXyJej+L6CzpxptNWwU69r3zuA70Vzo4BWtvL0PEW3mvsimaa2T5VNMW8bPyMbP7IsHR37kI4XFvhcnPUyjuQpWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Et90fBTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Et90fBTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3504AC4CEE9;
	Tue, 20 May 2025 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750739;
	bh=kEtp4KiAVcH85sfCaTtSl/ZS4fhQCkjcKW4qKyrcQ18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Et90fBTMqFTHcF6DqeygNuNhMyqDy9dI19aGHAt3NIX4dskUV8tq3NDWKpgBJ/Oh/
	 7htI6DWkubguUZzkB3U7dOrZ52790D1eyzGvM3d6R8qtivf68l0aD/bcpchKAgQlaJ
	 Ed9IhV2EqCN5J/mr/qJh+h+KD2j6jXGMzszmMh1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@mailbox.org>,
	Melissa Wen <mwen@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 078/145] Revert "drm/amd/display: Hardware cursor changes color when switched to software cursor"
Date: Tue, 20 May 2025 15:50:48 +0200
Message-ID: <20250520125813.640658311@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

commit fe14c0f096f58d2569e587e9f4b05d772272bbb4 upstream.

This reverts commit 272e6aab14bbf98d7a06b2b1cd6308a02d4a10a1.

Applying degamma curve to the cursor by default breaks Linux userspace
expectation.

On Linux, AMD display manager enables cursor degamma ROM just for
implict sRGB on HW versions where degamma is split into two blocks:
degamma ROM for pre-defined TFs and `gamma correction` for user/custom
curves, and degamma ROM settings doesn't apply to cursor plane.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1513
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2803
Reported-by: Michel Dänzer <michel.daenzer@mailbox.org>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4144
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f6a305d4748801a6c799ae9375b2ecff3aed094b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp_cm.c
@@ -120,10 +120,11 @@ void dpp401_set_cursor_attributes(
 	enum dc_cursor_color_format color_format = cursor_attributes->color_format;
 	int cur_rom_en = 0;
 
-	// DCN4 should always do Cursor degamma for Cursor Color modes
 	if (color_format == CURSOR_MODE_COLOR_PRE_MULTIPLIED_ALPHA ||
 		color_format == CURSOR_MODE_COLOR_UN_PRE_MULTIPLIED_ALPHA) {
-		cur_rom_en = 1;
+		if (cursor_attributes->attribute_flags.bits.ENABLE_CURSOR_DEGAMMA) {
+			cur_rom_en = 1;
+		}
 	}
 
 	REG_UPDATE_3(CURSOR0_CONTROL,


