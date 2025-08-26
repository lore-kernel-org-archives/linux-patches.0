Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E72F227599;
	Tue, 26 Aug 2025 11:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207466; cv=none; b=QB0KQ/GRINLgRbVWufIKeMfefNeX8qIpbmb9+LqAeZKTPSQhtCrw7xpShJ+5GU2LShL4WYehV1IghApUNXarmGqVH8bLmpu564gskriXnHN4BFP3aYOhyE9ArlogDW0XL+Ho6sSQkqfR8A5EDyCLc7CUlMjXKOa+vOQAz2/KahQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207466; c=relaxed/simple;
	bh=3bAb6da2O8fYsOl1WiDvH828IayUaHIRNVmEHVtrIAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zyawnm3WZEC6T/oPoN3n+nAhnHwIfypk0kDE+1U2hCVdzwQKPxcg15gFRm8dqkBlGk37WfZXcTSmX8zDIN5xZap2dmlGkJZTbhhj7mt/ZhmHFSuX5H8jEeBwPCQ4VltWA8oJ60iTxF6mW+088tpHYyTFXlRelkuc8RlBIsb1mZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0ZmMrHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0ZmMrHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D4FC4CEF1;
	Tue, 26 Aug 2025 11:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207466;
	bh=3bAb6da2O8fYsOl1WiDvH828IayUaHIRNVmEHVtrIAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0ZmMrHq26C0jCYfZRmxMLuWjz1ixljoDVeon0yh7U+qIVoIRKpyMBblmgmvLo2yD
	 mhqDIZCPefMAVDaDiWGjXl0fJcyOZX2Yogk2EcxIg59uQ01NLuxZPl2381oGTDPkMk
	 UXBiX4q5iDxJ4r4+0JzQguMiBMmPXolgrADrbc8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>
Subject: [PATCH 6.16 193/457] drm/amd/display: Dont overwrite dce60_clk_mgr
Date: Tue, 26 Aug 2025 13:07:57 +0200
Message-ID: <20250826110942.138189667@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


