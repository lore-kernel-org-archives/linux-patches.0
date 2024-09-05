Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EC91494DB;
	Thu,  5 Sep 2024 10:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530712; cv=none; b=pcknFWAOA3z1t8kNgXE771TFWNuL2/d942STxJV0aLrlO3MFe4uJPVU0YCMLkg3zInrthVqIunZl7LHgCt7fdtoPq1DljuBMshTOqQuEyJa/+Hfbtum+uMZqrQLFNQi4Su6q2JoKQj84xk6cz0HrYpT+wZ4vRu5Aj0V1FBRj0rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530712; c=relaxed/simple;
	bh=TIJWgG4TSa9XC+S02/lqXg1DWJfIwOxfdtTLKav0mZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMumUuAKIA9UhbcR3BYeT8omkU63HHTjXvjifCdi3OE8felkT+JabjYWvJOFNbh0GoosR79hFVtb5TN3bvV1DushegCtcyZlvZFC+i+M53yMUuYvngW15hxKSBWG1/uq87qz65uBFAmGKql/ErGgy5oT7KbjVMa1v5Sypo3jJow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8y5whjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8y5whjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5714C4CEC3;
	Thu,  5 Sep 2024 10:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530712;
	bh=TIJWgG4TSa9XC+S02/lqXg1DWJfIwOxfdtTLKav0mZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8y5whjyTrpdGBqQElYoDbcA8wetj8R3gJ04B4AdTi6ygSVImiCMFr5WTvG38VFim
	 2l4tfdPVWVDSHrmho/ITtWM+UdaJp6z62z//SoI/obHmZpqiTzoT/eSsCZdGjnjP0n
	 nfBYSZq0+F0xsUzaCGJpixupbD8qpH9qG7KMn63E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	winstang <winstang@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/101] drm/amd/display: added NULL check at start of dc_validate_stream
Date: Thu,  5 Sep 2024 11:42:02 +0200
Message-ID: <20240905093719.647567780@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: winstang <winstang@amd.com>

[ Upstream commit 26c56049cc4f1705b498df013949427692a4b0d5 ]

[Why]
prevent invalid memory access

[How]
check if dc and stream are NULL

Co-authored-by: winstang <winstang@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: winstang <winstang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 83898e46bcad..29400db42bb2 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -3629,6 +3629,9 @@ void resource_build_bit_depth_reduction_params(struct dc_stream_state *stream,
 
 enum dc_status dc_validate_stream(struct dc *dc, struct dc_stream_state *stream)
 {
+	if (dc == NULL || stream == NULL)
+		return DC_ERROR_UNEXPECTED;
+
 	struct dc_link *link = stream->link;
 	struct timing_generator *tg = dc->res_pool->timing_generators[0];
 	enum dc_status res = DC_OK;
-- 
2.43.0



