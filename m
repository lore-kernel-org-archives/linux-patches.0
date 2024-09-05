Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D4C1922CC;
	Thu,  5 Sep 2024 09:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529558; cv=none; b=Mc/MBZ4L0Xp9arGG0HVVn0zYR4grTiQuyH35E9V0ohar+1grHK9JpD9kUjHNtrzrnBQPmTl5wIQqw3sxHBV2n0u06aIpBXJ5sYhUuKlL6ddQc6oNVB9djeZ5wkXxyiFSe4RL/hm6tDIaUomqTLlZYeLn0K20I6a+2nnNKeB6140=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529558; c=relaxed/simple;
	bh=2cUWDkLGb6B2j/r3tUxCIE5qsfpmiAkZeZ157yzQsHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETgnLpcn6oKawwTqrxfpJoxNcajnlnm9tiCH4PymMdce/HMqTXjzVSZU42pIDXypqhHISDdwnqZdktJhWqphnugJL3yk0Tn/g92SEvjiR7F986MH11oCTdZTfF7cxInnCO95tDfQtyvhmDQxSm7oxH9HRnso/Ptf9uKXwKwMSPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FejeEu5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FejeEu5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC63CC4CEC3;
	Thu,  5 Sep 2024 09:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529558;
	bh=2cUWDkLGb6B2j/r3tUxCIE5qsfpmiAkZeZ157yzQsHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FejeEu5iVvMGjgiGjj0PN94JDuSeVGE5M92Rlts+vbJDflNLvuxJzJCFTaF/Af9y
	 N1EviPxU/Ob4NvrD7TRBZUcjbOtb8z+mQO7OMIIWqXV4wZU0L+eicUmur0SVUgIMrL
	 D+0yfi8Q8rDUR/tDR7FZRJgKxtku0sZ5jGkLiKmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 072/184] drm/amd/display: Release clck_src memory if clk_src_construct fails
Date: Thu,  5 Sep 2024 11:39:45 +0200
Message-ID: <20240905093735.053654848@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit 674704a5dabe4a434645fdd11e35437f4e06dfc4 ]

[Why]
Coverity reports RESOURCE_LEAK for some implemenations
of clock_source_create. Do not release memory of clk_src
if contructor fails.

[How]
Free clk_src if contructor fails.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c    | 1 +
 .../gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c    | 1 +
 .../gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c  | 4 ++--
 .../gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c    | 1 +
 .../gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c  | 1 +
 5 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
index 56ee45e12b46..a73d3c6ef425 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
@@ -1538,6 +1538,7 @@ struct resource_pool *dce83_create_resource_pool(
 	if (dce83_construct(num_virtual_links, dc, pool))
 		return &pool->base;
 
+	kfree(pool);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
index d4c3e2754f51..5d1801dce273 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
@@ -1864,6 +1864,7 @@ static struct clock_source *dcn30_clock_source_create(
 		return &clk_src->base;
 	}
 
+	kfree(clk_src);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
index ff50f43e4c00..da73e842c55c 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn314/dcn314_resource.c
@@ -1660,8 +1660,8 @@ static struct clock_source *dcn31_clock_source_create(
 		return &clk_src->base;
 	}
 
-	BREAK_TO_DEBUGGER();
 	kfree(clk_src);
+	BREAK_TO_DEBUGGER();
 	return NULL;
 }
 
@@ -1821,8 +1821,8 @@ static struct clock_source *dcn30_clock_source_create(
 		return &clk_src->base;
 	}
 
-	BREAK_TO_DEBUGGER();
 	kfree(clk_src);
+	BREAK_TO_DEBUGGER();
 	return NULL;
 }
 
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
index 2df8a742516c..28c459907698 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -1716,6 +1716,7 @@ static struct clock_source *dcn35_clock_source_create(
 		return &clk_src->base;
 	}
 
+	kfree(clk_src);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
index ddf9560ab772..b7bd0f36125a 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -1696,6 +1696,7 @@ static struct clock_source *dcn35_clock_source_create(
 		return &clk_src->base;
 	}
 
+	kfree(clk_src);
 	BREAK_TO_DEBUGGER();
 	return NULL;
 }
-- 
2.43.0



