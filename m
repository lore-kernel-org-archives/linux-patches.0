Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8264A24;
	Mon, 14 Oct 2024 14:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916718; cv=none; b=ABZ2dWUMyffuIzhvY8uz6lqUyATepYHDLMT/Kl6OAvJt4vJ0fbGm9f1dKJ8qbD8xMCcXSr/pZXFCXofCohzkZFneZZA5p5XQcN1nWHAyk2OkTtcSeICMPV5MQvBOq398ah9oBFqbX3/FcP3am5wdlmyFQqjb6CfEb8rj/qD9xFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916718; c=relaxed/simple;
	bh=Wf1TEYqm3im/GhZOpbTViOgJjeUjmHeb0Lk7DU8U/gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoTZSOfChzbcvKwhfmI9Vy/DWebMw9CauXCYMFqHqnx6Bj2cO4p8veR7HF12da2OkQZ2k/0+BrASEkWie5mYjtHMNT+enldDFjM3jm34Alrw/86+KFVWqAo592T5yomoAxagbid+Ln0DxpcEE9HQrr65giwEgDPLELU7z7QceAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11ZblxCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11ZblxCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1867C4CEC3;
	Mon, 14 Oct 2024 14:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916718;
	bh=Wf1TEYqm3im/GhZOpbTViOgJjeUjmHeb0Lk7DU8U/gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11ZblxCv0UNCpc4d7T4576nQVKONWMDeSxWDl21qOpSAY3oim0HBNoDaKv6awlJ+B
	 YQJK6+JlQ5leE1Pt1cjU0CmeUbElkjFGp3jULCFcWN9QSzCXjJZcr1aFaC9w0TXEOr
	 KrMZypaZ/H0DoTO6eJx84SmPgnDpFbLCBwfhGXqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/213] drm/amd/display: Revert "Check HDCP returned status"
Date: Mon, 14 Oct 2024 16:19:13 +0200
Message-ID: <20241014141044.826470642@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit bc2fe69f16c7122b5dabc294aa2d6065d8da2169 ]

This reverts commit 5d93060d430b359e16e7c555c8f151ead1ac614b due to a
power consumption regression.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/modules/hdcp/hdcp1_execution.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
index b7da7037fe058..cee5e9e64ae71 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
@@ -432,18 +432,18 @@ static enum mod_hdcp_status authenticated_dp(struct mod_hdcp *hdcp,
 		goto out;
 	}
 
-	if (!mod_hdcp_execute_and_set(mod_hdcp_read_bstatus,
+	mod_hdcp_execute_and_set(mod_hdcp_read_bstatus,
 			&input->bstatus_read, &status,
-			hdcp, "bstatus_read"))
-		goto out;
-	if (!mod_hdcp_execute_and_set(check_link_integrity_dp,
+			hdcp, "bstatus_read");
+
+	mod_hdcp_execute_and_set(check_link_integrity_dp,
 			&input->link_integrity_check, &status,
-			hdcp, "link_integrity_check"))
-		goto out;
-	if (!mod_hdcp_execute_and_set(check_no_reauthentication_request_dp,
+			hdcp, "link_integrity_check");
+
+	mod_hdcp_execute_and_set(check_no_reauthentication_request_dp,
 			&input->reauth_request_check, &status,
-			hdcp, "reauth_request_check"))
-		goto out;
+			hdcp, "reauth_request_check");
+
 out:
 	return status;
 }
-- 
2.43.0



