Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9432A2288F4;
	Mon,  2 Jun 2025 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877225; cv=none; b=TIRoCDSj3ML5zg9FH+HrZUy+rorvuhrxE5udw9Jbi7xP/GiUvtCca2gy7PVSD5eBP9XuVi9tw66AqIQghWcJDRIRCO5qP3CNty1xR1TXooV0D4YqD7FmvD5dVekxyuAZxFrY6b9ct9e7jDjaP5N4bRvX4q/BNsb231a02s6kN/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877225; c=relaxed/simple;
	bh=HVb9JudTXiu9mZ0rU0sTg6+EYs9JOmQlsumEGVx2zAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRS3e6uWA1b2l/Nr8jSq3XWUbsFQM0ZBJ5sIYAZnYF8ogFHgvAGu0xHrO59sU+p1rDfjAy1v2Bf4BxJkvUmjHhDQL8h8CWUWU12n2OxBF/2JwSR/vSiQqWn6wp8zLvt62STyZVZsD+Okcq7sF7bt9VYgMltlmImy+GdC5sFC5AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpM9o3ER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpM9o3ER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEDAC4CEEB;
	Mon,  2 Jun 2025 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877225;
	bh=HVb9JudTXiu9mZ0rU0sTg6+EYs9JOmQlsumEGVx2zAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpM9o3ER8sgOMCxdGxgjjOY0jwN7SLLsN/+vLBar+H/AyBKOJU8YJ95TL+Zf84QwW
	 yE8tgZLPsEg8mkZCJZekBhkM7lwYlDJck/d7ua07ICigzevJAn9POyU2nRYJG3W4BM
	 /0AUGgKWDodPDKozm40+s10sx55+ZX1y0HiIH31Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/325] drm/amd/display: Initial psr_version with correct setting
Date: Mon,  2 Jun 2025 15:47:36 +0200
Message-ID: <20250602134327.128202373@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit d8c782cac5007e68e7484d420168f12d3490def6 ]

[Why & How]
The initial setting for psr_version is not correct while
create a virtual link.

The default psr_version should be DC_PSR_VERSION_UNSUPPORTED.

Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 2721842af8067..10672bb90a029 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -267,6 +267,7 @@ static bool create_links(
 		link->link_id.type = OBJECT_TYPE_CONNECTOR;
 		link->link_id.id = CONNECTOR_ID_VIRTUAL;
 		link->link_id.enum_id = ENUM_ID_1;
+		link->psr_settings.psr_version = DC_PSR_VERSION_UNSUPPORTED;
 		link->link_enc = kzalloc(sizeof(*link->link_enc), GFP_KERNEL);
 
 		if (!link->link_enc) {
-- 
2.39.5



