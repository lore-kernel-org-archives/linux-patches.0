Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A287A6FB1;
	Tue,  5 Dec 2023 03:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSaArJsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FEDC433C7;
	Tue,  5 Dec 2023 03:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746675;
	bh=9v6+D6gmnJgN0YWm+Q9LtqLz+RkRwnEEWTytvr2b17g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSaArJsZAaUgabg0JMkXjfyLQe7zyHbYwfWkFn+oYgXofgTZl34XhKfMfkCb3VokL
	 oHx9CHNNC3IEeK054zaHj41mW3ebJ+ZhIKZdTfvZatji3JncEE0YrsDzC8DnlHEDwc
	 LvS2sBb+m8G/O+mucGs91Cxm6+1xsceqSI8rHPhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Swapnil Patel <swapnil.patel@amd.com>,
	Roman Li <roman.li@amd.com>,
	Agustin Gutierrez <agustin.gutierrez@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/134] drm/amd/display: Remove power sequencing check
Date: Tue,  5 Dec 2023 12:16:27 +0900
Message-ID: <20231205031542.775971687@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Agustin Gutierrez <agustin.gutierrez@amd.com>

[ Upstream commit b0399e22ada096435de3e3e73899aa8bc026820d ]

[Why]
	Some ASICs keep backlight powered on after dpms off
	command has been issued.

[How]
	The check for no edp power sequencing was never going to pass.
	The value is never changed from what it is set by design.

Cc: stable@vger.kernel.org # 6.1+
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2765
Reviewed-by: Swapnil Patel <swapnil.patel@amd.com>
Acked-by: Roman Li <roman.li@amd.com>
Signed-off-by: Agustin Gutierrez <agustin.gutierrez@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index 28cb1f5a504d1..a17a06eb7762b 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -1930,8 +1930,7 @@ static void disable_link_dp(struct dc_link *link,
 	dp_disable_link_phy(link, link_res, signal);
 
 	if (link->connector_signal == SIGNAL_TYPE_EDP) {
-		if (!link->dc->config.edp_no_power_sequencing &&
-			!link->skip_implict_edp_power_control)
+		if (!link->skip_implict_edp_power_control)
 			link->dc->hwss.edp_power_control(link, false);
 	}
 
-- 
2.42.0



