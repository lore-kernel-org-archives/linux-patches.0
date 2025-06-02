Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B436221727;
	Mon,  2 Jun 2025 14:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873782; cv=none; b=Zm9YXwmWjduwOXUfeta8whNj4mOkL4oHsE8Axt6VCy0TLd4PFeaE4G1TD9BohRenbFNpXXRUo7HZ4wOip7dBlpf4YOT0oIg+2aHZx9RWU3iu///N9LvrO2c+et3TmD6anZT64B7cypX3fxFQ/715275+M6rqUByrTZ5q94xA0Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873782; c=relaxed/simple;
	bh=RREzUiSKj5l/bcP4gV13sicrTG3bl++dmdHnJkVYmtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgM9jLFDT7/ZYB3b7I/rVZQ1G04rBlr7jS2H35W7OezBpJ1kPqcCYA2H+ebtjIQyCxZT7YITJvnRGUdzPLZmB4H4Enc07aZiOTgSbO4BH1KNOcIoHM1nnpIHUqc3GV0dYzU5mqoHP1z0/Rknf2eyfT2W6kSLAgVttEbHiRT3g68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kX0dsqT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kX0dsqT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA6AC4CEF0;
	Mon,  2 Jun 2025 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873779;
	bh=RREzUiSKj5l/bcP4gV13sicrTG3bl++dmdHnJkVYmtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kX0dsqT6yvSA7gMCbN8O6nnWI2NyxnU3TmCxWUjWp+VFPobFz7V8VCy+d05W9qIeR
	 S45eBDuqwOlaHfUmlxZEGQj0WfXkfnOqD3/rzML3cX0/BnQfVMDX1cCptWIEPjFNib
	 2MBovWMY8ytlj0hEmyWrkPTQLiuhjfXYPdhVGaqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/444] drm/amd/display/dm: drop hw_support check in amdgpu_dm_i2c_xfer()
Date: Mon,  2 Jun 2025 15:45:14 +0200
Message-ID: <20250602134351.065465674@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bcf0dc05c7676..be17aebf9b342 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7474,7 +7474,7 @@ static int amdgpu_dm_i2c_xfer(struct i2c_adapter *i2c_adap,
 	int i;
 	int result = -EIO;
 
-	if (!ddc_service->ddc_pin || !ddc_service->ddc_pin->hw_info.hw_supported)
+	if (!ddc_service->ddc_pin)
 		return result;
 
 	cmd.payloads = kcalloc(num, sizeof(struct i2c_payload), GFP_KERNEL);
-- 
2.39.5



