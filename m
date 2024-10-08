Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34C71DE4CC;
	Tue,  8 Oct 2024 12:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392018; cv=none; b=VWdkIo66YYSWmt+srxGbLZCq+MRM9+BCw4A0yoikuhgO5VEbp5cTf1c6JIQccAyknQHnm9vR1jCd/v3i8+DyZmJqDenHRWu+xqVzDrdm7K9+FZuuxNXSL+ryxN4DEhOqo7IEyqoQRyYFMfGuOZsQw/8Vv8SvDyKEXVrmn+fJRfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392018; c=relaxed/simple;
	bh=K5iRI8sBmPog/67WUZJpNUNIURUGjsr0iI8mcRk6PMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhM5E78NG15u9RaIyr1QYRHfeR0JheqnYqtGflYk5lyrE4SLdAstQ+jhGieFMis66pisRGiHTcG2/859VIa7TIAc0qWAlCDfxwpSHGakJHMmKBW6m1gXXTxbGrCa6Tu4j1v+8UOtm6IQ9FIhiM5q15IPzZOTmmBRsu+5MDbwMDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhV9jSug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhV9jSug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53049C4CEC7;
	Tue,  8 Oct 2024 12:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392018;
	bh=K5iRI8sBmPog/67WUZJpNUNIURUGjsr0iI8mcRk6PMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhV9jSugScOHMUVZQIyrN4rKEKXxEgmxDeTl0lqm9nYJ8NxW0bX+8w/DdIQWdMTDR
	 4EoVGYG6hCTgFJ+ulLyJ+yKpL0Mc0CWgLDc5KIiYZC1IsehZgOGbM55szyAWccf3q0
	 9Xb32nxEGNqLreCLv3bvFUCE6HP5TOGZhOZCe6Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	"Ahmed, Muhammad" <Ahmed.Ahmed@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 292/558] drm/amd/display: guard write a 0 post_divider value to HW
Date: Tue,  8 Oct 2024 14:05:22 +0200
Message-ID: <20241008115713.814380363@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed, Muhammad <Ahmed.Ahmed@amd.com>

[ Upstream commit 5d666496c24129edeb2bcb500498b87cc64e7f07 ]

[why]
post_divider_value should not be 0.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Ahmed, Muhammad <Ahmed.Ahmed@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c b/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
index 68cd3258f4a97..a64d8f3ec93a3 100644
--- a/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
@@ -47,7 +47,8 @@ static void dccg35_trigger_dio_fifo_resync(struct dccg *dccg)
 	uint32_t dispclk_rdivider_value = 0;
 
 	REG_GET(DENTIST_DISPCLK_CNTL, DENTIST_DISPCLK_RDIVIDER, &dispclk_rdivider_value);
-	REG_UPDATE(DENTIST_DISPCLK_CNTL, DENTIST_DISPCLK_WDIVIDER, dispclk_rdivider_value);
+	if (dispclk_rdivider_value != 0)
+		REG_UPDATE(DENTIST_DISPCLK_CNTL, DENTIST_DISPCLK_WDIVIDER, dispclk_rdivider_value);
 }
 
 static void dcn35_set_dppclk_enable(struct dccg *dccg,
-- 
2.43.0



