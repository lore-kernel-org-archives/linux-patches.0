Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D0022A4F1;
	Mon,  2 Jun 2025 14:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873772; cv=none; b=jicANyeM3BWOCUdc/Rg+DZ01/wmdpiReWrFbDOPRTwKFXaXzN+xFfDt60epZUJlAsxT1lPg4tfGbhI7MAWrFqOgpU0WU8qvpUUPhcrk80GjGmv/3rMOjRXEkH2Fn9N1+d/BXdvu/ZYqqCOvQqaBDDegsHeFCMydsJjR3pL8OH/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873772; c=relaxed/simple;
	bh=fP/GyWIAaeJC6VnpAZsG3yXFjqwHkG0gVw5JPaWMEeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbXXIzCpWujzB7iF1HKk9iE94w8YSNT9J1exFi0IrcmNpUS4uhLGk494Bxi/sSpF52CiGkUguMACKn+QjSLYmMfAlHdD6No/BU6FpHDEQG/zCwSTc6HL7n+2wAxqehv1vx7WL7k49BZND61G+RHH3ncCqLolOAbPowRkZjxPPaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOY9XMUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOY9XMUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FBFC4CEEB;
	Mon,  2 Jun 2025 14:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873772;
	bh=fP/GyWIAaeJC6VnpAZsG3yXFjqwHkG0gVw5JPaWMEeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOY9XMUdsUZy7Xb9Uemb7LHIsnK7nDs9Jz3KZFQpOTdtMoWOHLxelfya9ehzFQ/PV
	 g6lu6FL3qeaer/QrIaYSHEh5lfl0hwMc8tPNrYJ9Pghj8wnfVvQ64mkvqvuGYh+zCw
	 u8QzC6i7c53jibWQUvwpevrVpp/R9du8Y8CfxJ4c=
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
Subject: [PATCH 6.6 247/444] drm/amd/display: Initial psr_version with correct setting
Date: Mon,  2 Jun 2025 15:45:11 +0200
Message-ID: <20250602134350.941451739@linuxfoundation.org>
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
index c2efe18ceacd0..640d010b52bec 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -266,6 +266,7 @@ static bool create_links(
 		link->link_id.type = OBJECT_TYPE_CONNECTOR;
 		link->link_id.id = CONNECTOR_ID_VIRTUAL;
 		link->link_id.enum_id = ENUM_ID_1;
+		link->psr_settings.psr_version = DC_PSR_VERSION_UNSUPPORTED;
 		link->link_enc = kzalloc(sizeof(*link->link_enc), GFP_KERNEL);
 
 		if (!link->link_enc) {
-- 
2.39.5



