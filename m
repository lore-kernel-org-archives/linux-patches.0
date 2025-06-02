Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0194821885A;
	Mon,  2 Jun 2025 14:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875668; cv=none; b=EiOBdo5m+WSeDQHf5Lh+VhA+2eKaU8MyuTDZWD4FyLPo7UWr4nhsZiJBLC32ppci7S6sv8FyVSLO5R7bjTHtxUlZ34Ak3L3x2vBpMPs0q+DoguFUCxB0AXNlDd5mVyrNQgBU8YLmn0FMPs1eh2T1IbwjGmiZ+X6xP2kPamoWi+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875668; c=relaxed/simple;
	bh=fLxxHNzWssvnSE96LODGmVLFYaeJHCGNieZ5jCaEuKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkWwJNEXmTxPmayfViZ2Je5y4IEQmPqDyN3cNyYbTyrUEIlv6UQgYb7YvwBdtJNmizhDZ6Jj7flUb6IsSjnLoeGflWh9wu66txSZfT7icydlt/LFklcVm1ZquL/o0EcbooLh0c7N9f2lLlnUVnjbQ8cSKNNaTRmgcnUIeqdXnzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxera9B4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxera9B4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B317C4CEEB;
	Mon,  2 Jun 2025 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875667;
	bh=fLxxHNzWssvnSE96LODGmVLFYaeJHCGNieZ5jCaEuKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxera9B4RoEGtwpaCFRH0F4jcx05QYcsZy2aF5cNiwuoEHOIF3TtUKPkzHzfqdd40
	 7RnlHt8yhggUH3aJL6ltCPK+1Ccc2+uFMp+CNotvusRXOmbHwVY3uRmTJKy7IElMRX
	 d6TDb/YAnh/2+LFK+rY2wcduOVXLw9NhZeLvwBzE=
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
Subject: [PATCH 5.10 207/270] drm/amd/display: Initial psr_version with correct setting
Date: Mon,  2 Jun 2025 15:48:12 +0200
Message-ID: <20250602134315.655416155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 84fb1377ec934..88a9473ccf531 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -228,6 +228,7 @@ static bool create_links(
 		link->link_id.type = OBJECT_TYPE_CONNECTOR;
 		link->link_id.id = CONNECTOR_ID_VIRTUAL;
 		link->link_id.enum_id = ENUM_ID_1;
+		link->psr_settings.psr_version = DC_PSR_VERSION_UNSUPPORTED;
 		link->link_enc = kzalloc(sizeof(*link->link_enc), GFP_KERNEL);
 
 		if (!link->link_enc) {
-- 
2.39.5



