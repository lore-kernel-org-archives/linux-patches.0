Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB441AA7A5;
	Mon, 14 Oct 2024 14:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916715; cv=none; b=rupoXaK7j9tU/apoyJ7/kA3vBzX7Yv+ttqzvoNH+YjMN0EjLtdk7+kEnuu9E6LR5uotkBMQS8Bo6mtnb9MXcU+tZPcxMUuuWDcdCGfYSZ3DpVbD1DvTR/8y7v6rJkrCVx4lX9LkZfTIttRhUVr65OI0uAA7XPyJbt1JbSoBJ0Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916715; c=relaxed/simple;
	bh=lzg+UfbzNNX+LeeXf7t405Cee2X22s2pYIPfjhoIIZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwGu5rTvuZVAJu/h5rmDwg2VXdTkDNWGsxeFIIrx8owYPRfll5/LfoPq7UChJxnjI4X5dUYlk2LtqLfMurs1GdJG5umsoYx99mSlzY/Htg/kwi/8ZfHtDfPTkYPo/FPSDqQle4imaQz8dgqN1izDkQbWEYP2LaPuedjq2TM9e0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+c1PpC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+c1PpC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0C6C4CEC3;
	Mon, 14 Oct 2024 14:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916714;
	bh=lzg+UfbzNNX+LeeXf7t405Cee2X22s2pYIPfjhoIIZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+c1PpC1BdfCSHMDG9LZ6aIVn8mi0bMFRskyA+mq7U2phG/9krOnwdcKBGFP+LZt9
	 hcfa+2u9qi8yFLwPjOccSm8I83GZ6y5BRCmiuCHfk2GbRvQEf3V9mEnLP3WhOhlS10
	 0SLWFBGtc2mYZTBwJhWB+1C+8Xm+rm97GkThCSq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/213] drm/amd/display: Remove a redundant check in authenticated_dp
Date: Mon, 14 Oct 2024 16:19:12 +0200
Message-ID: <20241014141044.787653804@linuxfoundation.org>
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

From: Wenjing Liu <wenjing.liu@amd.com>

[ Upstream commit 4b22869f76563ce1e10858d2ae3305affa8d4a6a ]

[WHY]
mod_hdcp_execute_and_set returns (*status == MOD_HDCP_STATUS_SUCCESS).
When it return 0, it is guaranteed that status == MOD_HDCP_STATUS_SUCCESS
will be evaluated as false. Since now we are using goto out already, all 3
if (status == MOD_HDCP_STATUS_SUCCESS) clauses are guaranteed to enter.
Therefore we are removing the if statements due to redundancy.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: bc2fe69f16c7 ("drm/amd/display: Revert "Check HDCP returned status"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/modules/hdcp/hdcp1_execution.c    | 27 +++++++++----------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
index 93c0455766ddb..b7da7037fe058 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp1_execution.c
@@ -432,21 +432,18 @@ static enum mod_hdcp_status authenticated_dp(struct mod_hdcp *hdcp,
 		goto out;
 	}
 
-	if (status == MOD_HDCP_STATUS_SUCCESS)
-		if (!mod_hdcp_execute_and_set(mod_hdcp_read_bstatus,
-				&input->bstatus_read, &status,
-				hdcp, "bstatus_read"))
-			goto out;
-	if (status == MOD_HDCP_STATUS_SUCCESS)
-		if (!mod_hdcp_execute_and_set(check_link_integrity_dp,
-				&input->link_integrity_check, &status,
-				hdcp, "link_integrity_check"))
-			goto out;
-	if (status == MOD_HDCP_STATUS_SUCCESS)
-		if (!mod_hdcp_execute_and_set(check_no_reauthentication_request_dp,
-				&input->reauth_request_check, &status,
-				hdcp, "reauth_request_check"))
-			goto out;
+	if (!mod_hdcp_execute_and_set(mod_hdcp_read_bstatus,
+			&input->bstatus_read, &status,
+			hdcp, "bstatus_read"))
+		goto out;
+	if (!mod_hdcp_execute_and_set(check_link_integrity_dp,
+			&input->link_integrity_check, &status,
+			hdcp, "link_integrity_check"))
+		goto out;
+	if (!mod_hdcp_execute_and_set(check_no_reauthentication_request_dp,
+			&input->reauth_request_check, &status,
+			hdcp, "reauth_request_check"))
+		goto out;
 out:
 	return status;
 }
-- 
2.43.0



