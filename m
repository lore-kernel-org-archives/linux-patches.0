Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2502238174;
	Mon,  2 Jun 2025 14:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876367; cv=none; b=Q5ExKB6H3BPygnHoJHUhOcgRIHeaxST5p1w/Q5ZiEfdk9EQDXrrZqdt6YeX8vUZRNUDknwKktFsT7c5d/8VbMwJut8UtL2kFwojEEUZjZSdzhK8HHVmD6uECmwt1gmbqtGqR75B/utGIOOPFBnac9NurJqlWD6tUvetZJzDlC3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876367; c=relaxed/simple;
	bh=1f0eYIISdGeO1ecTRoDxFeFo/P5n8WspQTA85yCVq4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8iXFe5Aj2rnr0o7EbU19UOMS2m3nENA7nFkAIiBIJ2yCMCqzW8FMqXDwspqQpmkj+Go/1fozKXqvTlLdfXZqC03iF9EMnq7/3A3wWLV2H0oVHAR/c7/dBIZZ57xDyy5HVFWFMW6xFWnLRZ6iOqNuBTzVD+CjHTUdCXh1MVnT5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JCDPdse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JCDPdse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A19C4CEEB;
	Mon,  2 Jun 2025 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876367;
	bh=1f0eYIISdGeO1ecTRoDxFeFo/P5n8WspQTA85yCVq4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JCDPdsejwfEL2dtwLF4iG5lGAofT9iljjlO3Nl9GetvpkFcGNc2SS/B4HMwM0UwJ
	 dNSTl/G461RVOFcd+S+AZhFnQadCDKPxr/M8s/9ByLGJLUDqsUwjuRkdx3mq3N3cwt
	 o/GrE94DQxHkg5ry/VwR6+0j34dnN6H2jqUaKO5w=
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
Subject: [PATCH 5.15 124/207] drm/amd/display: Initial psr_version with correct setting
Date: Mon,  2 Jun 2025 15:48:16 +0200
Message-ID: <20250602134303.571968959@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d3d638252e2b9..e1085c316b78e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -248,6 +248,7 @@ static bool create_links(
 		link->link_id.type = OBJECT_TYPE_CONNECTOR;
 		link->link_id.id = CONNECTOR_ID_VIRTUAL;
 		link->link_id.enum_id = ENUM_ID_1;
+		link->psr_settings.psr_version = DC_PSR_VERSION_UNSUPPORTED;
 		link->link_enc = kzalloc(sizeof(*link->link_enc), GFP_KERNEL);
 
 		if (!link->link_enc) {
-- 
2.39.5



