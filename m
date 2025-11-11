Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FEB248F6A;
	Tue, 11 Nov 2025 01:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823287; cv=none; b=dagxUEqWGeXlxfZdpOXxt2s48EJclmv8SiLfI2Nypud/WpncXctS0yyPIFHhLzXVn4pTLwlmVak5k2b7PGVfdff0TU5zd5dijayvnxi8CJFw/WkdFW7nHuEpDUT/8HvqZP3lKxHEBnlAlkvcw7OBoqgLGnGO6rhzs12VA8OPY5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823287; c=relaxed/simple;
	bh=D8la9ywqH612Bi+4vVEBMtdWXG2kCPnZmZmf/XYmxRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mm1wFx35/qVOnpT60bbEH9WCWozeF9j+T83tt3lwptr6gv0KpJXtBM2Otj40cN/TlyHn2MdahC8dav/XuBGEs5V/e11ISDLlcBkwKfXp7ecCNZnCHCQ6x6PzbWKmSPlfS3HVsYPAy3105wf6TIAkP0IMLbSoBKdcNhTNSTraF3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZuxa5ZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZuxa5ZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A38C19422;
	Tue, 11 Nov 2025 01:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823287;
	bh=D8la9ywqH612Bi+4vVEBMtdWXG2kCPnZmZmf/XYmxRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZuxa5ZL+6NJtrtvb8BtBHGpF/D6wWYF8s3xXl5mpfnj2bsuhocsUbiic3HPgg8EW
	 HvOJzFYzGt9b/wEXpJeK+BfZSihetbSy2ANniou17THSkyEkxag9PDcy7DJIp8dxmx
	 YPhfHWXlRKKyV9WBZqsyKVhXDVkN6qagTWajsCfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Danny Wang <Danny.Wang@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 190/565] drm/amd/display: Reset apply_eamless_boot_optimization when dpms_off
Date: Tue, 11 Nov 2025 09:40:46 +0900
Message-ID: <20251111004531.204116614@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Wang <Danny.Wang@amd.com>

[ Upstream commit ad335b5fc9ed1cdeb33fbe97d2969b3a2eedaf3e ]

[WHY&HOW]
The user closed the lid while the system was powering on and opened it
again before the “apply_seamless_boot_optimization” was set to false,
resulting in the eDP remaining blank.
Reset the “apply_seamless_boot_optimization” to false when dpms off.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Danny Wang <Danny.Wang@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index bdcbebd5722d4..426912d82179c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3132,7 +3132,7 @@ static void update_seamless_boot_flags(struct dc *dc,
 		int surface_count,
 		struct dc_stream_state *stream)
 {
-	if (get_seamless_boot_stream_count(context) > 0 && surface_count > 0) {
+	if (get_seamless_boot_stream_count(context) > 0 && (surface_count > 0 || stream->dpms_off)) {
 		/* Optimize seamless boot flag keeps clocks and watermarks high until
 		 * first flip. After first flip, optimization is required to lower
 		 * bandwidth. Important to note that it is expected UEFI will
-- 
2.51.0



