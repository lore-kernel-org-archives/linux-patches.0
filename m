Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD47473161;
	Wed, 21 Feb 2024 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525473; cv=none; b=BuSlfgrDn5AxYriczMtNZIuQfqUdqpFU0fhO8RXyrg4s/4TIUT+L/zo6LeByxY3M7Jp2TlZ/qqE2PTYVz3NomFIFr79I6ycn0nUXx4A2qYkWfp97xCpUhXD+W2bpiRdOFiCzTWQ5AHzvfqPY1v25sOzD1EHQDzR8MWm+l1IWTUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525473; c=relaxed/simple;
	bh=TNqvS6uyobU64wZJt4ubUzB+wrfqliEsEHcAz/p6QFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnAgM5UC11Y/9XuxufLfLsuoRAoKHx3YRAi+PYasNDx095M6et1JJNgMpA34I/+y6rfjqhalWp90nW2sSVVjCLTPGHOQGqDMx7GwHa++H/p8ZGKr6JJNG4SYH/u6WoCTfmU0BGEiW9hbVtjR8/Yqaekf7EkjuZwHD1RPgGt34m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9Pu39oh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9Pu39oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A70EC43394;
	Wed, 21 Feb 2024 14:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525473;
	bh=TNqvS6uyobU64wZJt4ubUzB+wrfqliEsEHcAz/p6QFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9Pu39ohvGmKbmLp0guSTcxv1hx7Qchq/gYdPYBjs1wTueArKLSad3rRkMk40P5oF
	 QnuwMMzZkGoL50+y8bjeVC+JVebNsorbr6VSG6sTx9kGoPe/Poi7ZSuXJo/AxIhR0h
	 oxzrlkJ94vIYHpftKoUg2hs3Peg/NVw3eBIbIx8E=
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
Subject: [PATCH 5.4 137/267] drm/amd/display: make flip_timestamp_in_us a 64-bit variable
Date: Wed, 21 Feb 2024 14:07:58 +0100
Message-ID: <20240221125944.351522154@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0b8700a8a94a..c6281d4a18ce 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
@@ -423,7 +423,7 @@ struct dc_cursor_position {
 };
 
 struct dc_cursor_mi_param {
-	unsigned int pixel_clk_khz;
+	unsigned long long pixel_clk_khz;
 	unsigned int ref_clk_khz;
 	struct rect viewport;
 	struct fixed31_32 h_scale_ratio;
-- 
2.43.0



