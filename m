Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F991DE8A6;
	Wed, 19 Feb 2025 09:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955913; cv=none; b=Njcguny8+vOuXOd00EflMwKpOunntVc1B8TfHiVZMe/LoTDUAJ6gBcfHoiy9ktxOsWSZOkbH8w6PoWEJggCvJFNwTbbeBmn+C6L5iyiihFIWrMhRddhYVzPd8S20wtjCNehi4e2mJkYJrI71s+aHmxweQ0LX1+hI5eBteM8UT9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955913; c=relaxed/simple;
	bh=QtbILcJcFVDEyclW0/wcSBPgzT+exelXpZREZF+kB4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhdGj35c7UwZ4inHGSQyj+SjXN4b6VGldM7iEqGYLjaFHh1SfUyZ7xTXGvsiSO1vRT9M8AdfGzhCSbuvRrf/wYapL7OEwO88jXyxAHEzPC83Rr6VO2jzdYCPeJ0OLGEEkesdUmUC58T9J/h2QKCUoG4WR9C53utdPfP8qFl8whA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16Wn0LiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16Wn0LiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067D1C4CED1;
	Wed, 19 Feb 2025 09:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955913;
	bh=QtbILcJcFVDEyclW0/wcSBPgzT+exelXpZREZF+kB4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16Wn0LiAK24VUu7Q+gxONdDrwEMbH9Hp84MKXGCQTJiLLwoXujJnq3WCh/2KA4tMJ
	 byAGNigewDmRDEPWRTLLhcova0jlqoI9OBTboaVhkEA8Q1GruS01F1yoIxWZTZWEk7
	 NkonAMkHGbUbIQp1d+lXgAIgSLCfcX+ww0YsnHVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 134/152] drm/amd/display: Add null check for head_pipe in dcn201_acquire_free_pipe_for_layer
Date: Wed, 19 Feb 2025 09:29:07 +0100
Message-ID: <20250219082555.346825702@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit f22f4754aaa47d8c59f166ba3042182859e5dff7 upstream.

This commit addresses a potential null pointer dereference issue in the
`dcn201_acquire_free_pipe_for_layer` function. The issue could occur
when `head_pipe` is null.

The fix adds a check to ensure `head_pipe` is not null before asserting
it. If `head_pipe` is null, the function returns NULL to prevent a
potential null pointer dereference.

Reported by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/resource/dcn201/dcn201_resource.c:1016 dcn201_acquire_free_pipe_for_layer() error: we previously assumed 'head_pipe' could be null (see line 1010)

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ dcn201 was moved from drivers/gpu/drm/amd/display/dc to
  drivers/gpu/drm/amd/display/dc/resource since commit
  8b8eed05a1c6 ("drm/amd/display: Refactor resource into component directory").
  The path is changed accordingly to apply the patch on 6.6.y. ]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn201/dcn201_resource.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_resource.c
@@ -1002,8 +1002,10 @@ static struct pipe_ctx *dcn201_acquire_f
 	struct pipe_ctx *head_pipe = resource_get_otg_master_for_stream(res_ctx, opp_head_pipe->stream);
 	struct pipe_ctx *idle_pipe = resource_find_free_secondary_pipe_legacy(res_ctx, pool, head_pipe);
 
-	if (!head_pipe)
+	if (!head_pipe) {
 		ASSERT(0);
+		return NULL;
+	}
 
 	if (!idle_pipe)
 		return NULL;


