Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993703D1CC3;
	Thu, 15 Jan 2026 17:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498135; cv=none; b=hOCGboUaC2ykTLaeHFCL9KG7AgvwQXBllBc0j57SgXUXO6cS5o/K/xUP1Ebqwl78wYVXhGD0WHz5sNpWLQ0Flqrs6rMEysSESusoDsSgO8IGrUlbYrCT1KlUWFb7f/CA/6fkTRRT23kT6balFxn/Ow/ZGfgKK02Ss+7tbYZL5/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498135; c=relaxed/simple;
	bh=DCTLY1YFJYCDomGEYqosVi9qnCznz5Bq7bOc5E1N/5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQXNeBvospoSARJH5ECu0fDlpJimxDQTfieaPU8L7vLJsWbyhq0rAhw+FmuP8Q2eJfmKTC+3UVRRLMIS85juSQPZmOPyn37O/ccSeDtY0G31f4uR8+h00WzmvylvAPSuHFXeGcjAmw0NSevb6IH9R9PEdgwhsjzvSVsxV0la0BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFXffyHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFXffyHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25721C16AAE;
	Thu, 15 Jan 2026 17:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498135;
	bh=DCTLY1YFJYCDomGEYqosVi9qnCznz5Bq7bOc5E1N/5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFXffyHPZxnaAwTdzhnquiVluwpipaKMvKBKGYqCzggd7UXMSkFEzfNOqHS6gRCwg
	 cJa1RYLNdCxqxvw1qZ8200yKRP+ce2oC8Fdts4rNlqX5SjeByrg4HrHronYJGcDbiV
	 jrSYM7muLZ6sBhhDveU5VhkUwbSQ4d2gr1w1ousM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 326/554] drm/amd/display: Use GFP_ATOMIC in dc_create_plane_state()
Date: Thu, 15 Jan 2026 17:46:32 +0100
Message-ID: <20260115164258.029381255@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3c41114dcdabb7b25f5bc33273c6db9c7af7f4a7 upstream.

This can get called from an atomic context.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4470
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8acdad9344cc7b4e7bc01f0dfea80093eb3768db)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_surface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_surface.c
@@ -104,7 +104,7 @@ void enable_surface_flip_reporting(struc
 struct dc_plane_state *dc_create_plane_state(struct dc *dc)
 {
 	struct dc_plane_state *plane_state = kvzalloc(sizeof(*plane_state),
-							GFP_KERNEL);
+							GFP_ATOMIC);
 
 	if (NULL == plane_state)
 		return NULL;


