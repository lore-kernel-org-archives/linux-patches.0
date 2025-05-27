Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2BE2110E;
	Tue, 27 May 2025 17:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365523; cv=none; b=aHX+GD6y6qsidY7NWDtq/fafO4jSdiIUXlLgpmmiHoxzScQenzME4icO3DRjeUJXh+TRun2nWaUZk7/pqBnO9Olu/saNKoB6p2u4ZnLFAG2ua9ClDFaFcuvM0f5S/DgFwH+rECPVttF7ns91DIICTQvy6+zin0mW1QHIvbYQFVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365523; c=relaxed/simple;
	bh=goBn1PJOMLuUQGE7nffSjHQ9Onrd5OIiuo2efF95M8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRWLf4o5y8H8Ui0HNiOU3JKJtkTei+UYpj9rbvdBSNcQrJUM0cymLKr9zdnCoNlXEij35W4l7Mgcbi2dFDlFfhvKyVug6FMKXvnpx8x6RGOlVYZD9CchbFq6l+SkCWRUjfwXrVmbs70PqG5jk3at2e1n+/okk6DOcQvCPAZDkz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9rJ9uRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9rJ9uRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA0CC4CEE9;
	Tue, 27 May 2025 17:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365523;
	bh=goBn1PJOMLuUQGE7nffSjHQ9Onrd5OIiuo2efF95M8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9rJ9uRWWbcY6ZrST47fGUZ3zh7rCVbWE+WhrMVBlWy1SU8jwmok6yb+mUMGFgCQl
	 2HDGSG3zUa3zqU29e+X4vSBurPDAvqsXbkKQf+BtOfFnQNCsZ2FBw4UMNxdt7ftKov
	 7TVkGbeytdgumqL/U6y8tMcvEOkN0pB85urZWM6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 403/626] drm/amd/display/dm: drop hw_support check in amdgpu_dm_i2c_xfer()
Date: Tue, 27 May 2025 18:24:56 +0200
Message-ID: <20250527162501.393499590@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 33da70bd1e115d7d73f45fb1c09f5ecc448f3f13 ]

DC supports SW i2c as well.  Drop the check.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 1e5984e71bfd7..09ef87c69230e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8288,7 +8288,7 @@ static int amdgpu_dm_i2c_xfer(struct i2c_adapter *i2c_adap,
 	int i;
 	int result = -EIO;
 
-	if (!ddc_service->ddc_pin || !ddc_service->ddc_pin->hw_info.hw_supported)
+	if (!ddc_service->ddc_pin)
 		return result;
 
 	cmd.payloads = kcalloc(num, sizeof(struct i2c_payload), GFP_KERNEL);
-- 
2.39.5



