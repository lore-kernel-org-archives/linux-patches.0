Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18697168DC;
	Sat,  3 Feb 2024 04:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933880; cv=none; b=LmsAy7T7HymZvewA8MXJbGsVjgzP2/Vu4ektIx7iFoVGTztPv0Zhj62TO5tM9T5pXYvv1mtY0M8yLk8rN0PHVKnt3O+voNb1j5Q1WqkFTnQnipi2flbyZFMBmBVrQWbdQR479/pASVAT6mQujgMAKPE4vLJzzCwnlIzPeedjCc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933880; c=relaxed/simple;
	bh=bDzC1l7iyTXaI9S1TRcD+dTZrzOLY9XkA5nfSUqiXCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSrbglfj8zdUA7/+iuJFQIqIDEMda//Lv99/DK5nifq5iLtEaZuBF272KRQ5/GGrEZZ53o6SlwnKyyBhcOur7xbCfk+d4jcvqnBe4j1ORe/mi5P8AmgmUzQSwZHBhhcfIBrUgx0o9AOuVrVd/lvj0NVULt2kP5sKfMaNDY85XXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IipPsiB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IipPsiB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C86C43399;
	Sat,  3 Feb 2024 04:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933879;
	bh=bDzC1l7iyTXaI9S1TRcD+dTZrzOLY9XkA5nfSUqiXCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IipPsiB9xT89lZ60YiB+wzROOSGBQQB0i3qoePupJAlhxlQunDNJhE2kwnplvMjXI
	 t8HknD3nQYsfF1G5gdAdxHRhyFTPkS4++6fqn7GpciEur7N7c4grQa/RHWqZhv3/JD
	 hD7fnQhKXJ5OP4xe9leM7Ag+vihf27pzpbH58XAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Josip Pavic <josip.pavic@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 220/353] drm/amd/display: make flip_timestamp_in_us a 64-bit variable
Date: Fri,  2 Feb 2024 20:05:38 -0800
Message-ID: <20240203035410.639418848@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josip Pavic <josip.pavic@amd.com>

[ Upstream commit 6fb12518ca58412dc51054e2a7400afb41328d85 ]

[Why]
This variable currently overflows after about 71 minutes. This doesn't
cause any known functional issues but it does make debugging more
difficult.

[How]
Make it a 64-bit variable.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Josip Pavic <josip.pavic@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_hw_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
index e2a3aa8812df..811474f4419b 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
@@ -244,7 +244,7 @@ enum pixel_format {
 #define DC_MAX_DIRTY_RECTS 3
 struct dc_flip_addrs {
 	struct dc_plane_address address;
-	unsigned int flip_timestamp_in_us;
+	unsigned long long flip_timestamp_in_us;
 	bool flip_immediate;
 	/* TODO: add flip duration for FreeSync */
 	bool triplebuffer_flips;
-- 
2.43.0



