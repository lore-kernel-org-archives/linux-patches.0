Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997ED393DD1;
	Tue, 26 Aug 2025 11:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208485; cv=none; b=ifJcaEcT3/cptpL3AMLacVjx65LpbVKocGLgRPhU+JXtJCujt/JjAsyfPNCXxbV92Y8hDSt5f4TJldgZyV5I7yTFOLCe/yv6VOVl87mPDlt0Ko4vpe7idFfqzXBCeK4Toqt1HNuV5c4soyBYxaWqMLFC905BFm1u878iHwrixMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208485; c=relaxed/simple;
	bh=megejMyKgfeMmmg8mF0npsCkeasAnQGd5bOJVCPPwLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BJ8aWh4XAseJcCmOdHvw9MEHJSWAf+XvytoCw+YOTLRXu9sPf1JK6K4HJXf55yzvV5s/uK409cPcESFmLvZKvouovTzm5oFkd66sqJ3kDDjzQBNSQElcrucCdbOP1+xa0BrXO0qWNDu7AEzeqiRvTzz0mNWHq/78NZRW6KnRi94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aP6pO0T3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aP6pO0T3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DE2C4CEF1;
	Tue, 26 Aug 2025 11:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208485;
	bh=megejMyKgfeMmmg8mF0npsCkeasAnQGd5bOJVCPPwLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aP6pO0T3h3m2g7NR9pCpyY4UXt+VYfSKIzu7ZkvgnbEypai0p7vPkFKpLk27zXoMo
	 PN6eC1na68tvTdXXz8qWPGJEJLtgUhGAkN2zcRVFJzrNexDruF3As25L5v74ROQ7Pd
	 QH18z/zqecoc6wJNejrd/sSzuKI/l3KLWbDHADZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>
Subject: [PATCH 6.12 129/322] drm/amd/display: Dont overwrite dce60_clk_mgr
Date: Tue, 26 Aug 2025 13:09:04 +0200
Message-ID: <20250826110918.987171563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 4db9cd554883e051df1840d4d58d636043101034 upstream.

dc_clk_mgr_create accidentally overwrites the dce60_clk_mgr
with the dce_clk_mgr, causing incorrect behaviour on DCE6.
Fix it by removing the extra dce_clk_mgr_construct.

Fixes: 62eab49faae7 ("drm/amd/display: hide VGH asic specific structs")
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bbddcbe36a686af03e91341b9bbfcca94bd45fb6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
@@ -158,7 +158,6 @@ struct clk_mgr *dc_clk_mgr_create(struct
 			return NULL;
 		}
 		dce60_clk_mgr_construct(ctx, clk_mgr);
-		dce_clk_mgr_construct(ctx, clk_mgr);
 		return &clk_mgr->base;
 	}
 #endif


