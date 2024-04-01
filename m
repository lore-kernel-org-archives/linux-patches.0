Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFDF1CA8F;
	Mon,  1 Apr 2024 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987610; cv=none; b=dQi3xM5/jnaTQALa98c340/qRQnRh9qLfluc8WKbs8cwhr2ytkM4qwwlnjeYebep/XwKztyP9T4duE/5wmZJ1poW7Raf1k0D5yayAllTGl7ps9z6OoTIZAwZNwL0gGGU04/mvaUCOlVeK1iJhMhIvThJRn++6r2usQNlv0SQiwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987610; c=relaxed/simple;
	bh=PMXGzjb806ynvh1IP1ObXdohw69i6bUOzonWbfgnmCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etrT/gnMmptfXvem/hnx+t7GmQenhve7MckGmJMlgqiJtOiJg6ryG7iKP3O26CmZXOUghVyVDsl2LRZ8Hm0QIS6DS5sN8cfXyBPfK1vt5EomO6sL/wNr0h7SLbWSjHdDbUT6fT7Ug4DX9IKueF3jZPu0wkaS5PazT837Nr0LxzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t26Uvur2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t26Uvur2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E62C433C7;
	Mon,  1 Apr 2024 16:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987609;
	bh=PMXGzjb806ynvh1IP1ObXdohw69i6bUOzonWbfgnmCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t26Uvur2p1CT0WmsPrIv5JXvC0m+TmSN2TDfhEgepHiGvsSXgDS4Kw9rncVUi0olq
	 6FzHPMmpszHmtYxLEAO51cVJv6gDqBAI17sRLUElIdHyUp+NiG9sXBU4dwssxgbPD+
	 vlZXrgm4/LFCuY7eI7249aQKVVUiDHQxJQ12DZf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sun peng Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.8 339/399] drm/amd/display: Fix bounds check for dcn35 DcfClocks
Date: Mon,  1 Apr 2024 17:45:05 +0200
Message-ID: <20240401152559.294491104@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <roman.li@amd.com>

commit 2f10d4a51bbcd938f1f02f16c304ad1d54717b96 upstream.

[Why]
NumFclkLevelsEnabled is used for DcfClocks bounds check
instead of designated NumDcfClkLevelsEnabled.
That can cause array index out-of-bounds access.

[How]
Use designated variable for dcn35 DcfClocks bounds check.

Fixes: a8edc9cc0b14 ("drm/amd/display: Fix array-index-out-of-bounds in dcn35_clkmgr")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -706,7 +706,7 @@ static void dcn35_clk_mgr_helper_populat
 		clock_table->NumFclkLevelsEnabled;
 	max_fclk = find_max_clk_value(clock_table->FclkClocks_Freq, num_fclk);
 
-	num_dcfclk = (clock_table->NumFclkLevelsEnabled > NUM_DCFCLK_DPM_LEVELS) ? NUM_DCFCLK_DPM_LEVELS :
+	num_dcfclk = (clock_table->NumDcfClkLevelsEnabled > NUM_DCFCLK_DPM_LEVELS) ? NUM_DCFCLK_DPM_LEVELS :
 		clock_table->NumDcfClkLevelsEnabled;
 	for (i = 0; i < num_dcfclk; i++) {
 		int j;


