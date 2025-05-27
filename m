Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430CD42A9B;
	Tue, 27 May 2025 17:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367763; cv=none; b=KJHBFehBF7u4owougLCeFiiOx2m8eR89P69kO4umWqqdjooQoNvyYL0JEMVv99K3XWDzM680QTxqfNyN4g4fl1R/B4mnjIX2011MbjXodZKGQTdwp8T+NuQ5eGvRySYDhSjGmktd2y3Ox6nDcI68D6whnG23FVRbPJubIlXl6A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367763; c=relaxed/simple;
	bh=HFk9u/CRVP7aw8FLtvPdeNBwt9J4dwGpyv6qnioPfzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFpgbmKfnaAeq0M2vGxuQOZdyxViNkuQibgzTOp0e/ZR0tzfICm0fm3rmVWEoebGosQqJHkonP834M80wdvrHZ4f/cejQcT+wcpY2l53EwFfxaawFIV++cXpkSeeH2qAH8WszJonivnhTJXns1hqFoBnWbcWz6gt1+XE0IVtzqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLvo3ICD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLvo3ICD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBDEC4CEE9;
	Tue, 27 May 2025 17:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367763;
	bh=HFk9u/CRVP7aw8FLtvPdeNBwt9J4dwGpyv6qnioPfzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLvo3ICD2sgixVprpF6X3Y1r1A76OM7pbmQQGAJm0r2lvTIroAb10aHdAhOHpilnW
	 wvFZdWHasG+qLI+UUHH0P7TkpWC0WCpxfwQFpMdHTqAsD1RT/RgWmPMmg5QKWmapio
	 5Boxz45cLrO8jlKmdn0y3gMGJZP+vvTsb6zW+ryM=
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
Subject: [PATCH 6.14 492/783] drm/amd/display: Initial psr_version with correct setting
Date: Tue, 27 May 2025 18:24:49 +0200
Message-ID: <20250527162533.165445627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 167f9d99a5408..0ce0ad7f98396 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -276,6 +276,7 @@ static bool create_links(
 		link->link_id.type = OBJECT_TYPE_CONNECTOR;
 		link->link_id.id = CONNECTOR_ID_VIRTUAL;
 		link->link_id.enum_id = ENUM_ID_1;
+		link->psr_settings.psr_version = DC_PSR_VERSION_UNSUPPORTED;
 		link->link_enc = kzalloc(sizeof(*link->link_enc), GFP_KERNEL);
 
 		if (!link->link_enc) {
-- 
2.39.5



