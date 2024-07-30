Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FD92101B8;
	Tue, 30 Jul 2024 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355297; cv=none; b=CUYRjaZ3OSq7ZV2aSgAGRrNEbwLiXjclWWiKMLVfZ5BQqbhspp7u/P1WRx9XCVW13M9Q3qihV6Pp5gJPlCylu9W4o7UYg0cE2AKqP1Qw2rzQxbtKQKBSpqq5k3QByHKiCtZaljTKwn74Qiss494pxv9hCoNhp1K5MC9f96gzzTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355297; c=relaxed/simple;
	bh=rnAqj1S5ic/JXaCqQSv6dcXWS9nxJxXWlifCHEt35x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFQyq+UAVMF54ax4NZFUUt9XPe2Fx/7kf8xB931KET5D70C3FVn1OMkGSNLTPp48Cfeuisn4bh/1DUnURCtief+VThD9QqEygBTPX6s8YOasSAZYrHfNbpKLoanWjpfaTVtL7RINIoUXwdKOW9jG5uei3Bp70JmcrMn2SZA1CZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNcHU7H0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNcHU7H0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D36C32782;
	Tue, 30 Jul 2024 16:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355296;
	bh=rnAqj1S5ic/JXaCqQSv6dcXWS9nxJxXWlifCHEt35x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNcHU7H0Uyh0OY4qc3xPxgkvIGky3F8+Fr4DWxsWOW37Mo4UNqlUfTJcbq/nnJXdc
	 xAa5ogkNHwf9pnWUkJ3ZbqrAjOpYJhJ6HOvlYYDG+fju3TNAV2qLy5cUEsRXOoeTXF
	 ocNquT7U3DKInuWVrq3GOSmBNGnYYwjXB3+5+KqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 038/809] drm/xe/display/xe_hdcp_gsc: Free arbiter on driver removal
Date: Tue, 30 Jul 2024 17:38:34 +0200
Message-ID: <20240730151726.155741208@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 609458abd5a10180f513ca364d6c0ae30128c821 ]

Free arbiter allocated in intel_hdcp_gsc_init().

Fixes: 152f2df954d8 ("drm/xe/hdcp: Enable HDCP for XE")
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Cc: Arun R Murthy <arun.r.murthy@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240708125918.23573-1-nirmoy.das@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
(cherry picked from commit 33891539f9d6f245e93a76e3fb5791338180374f)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_hdcp_gsc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c b/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
index d46f87a039f20..b3d3c065dd9d8 100644
--- a/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
+++ b/drivers/gpu/drm/xe/display/xe_hdcp_gsc.c
@@ -159,12 +159,16 @@ void intel_hdcp_gsc_fini(struct xe_device *xe)
 {
 	struct intel_hdcp_gsc_message *hdcp_message =
 					xe->display.hdcp.hdcp_message;
+	struct i915_hdcp_arbiter *arb = xe->display.hdcp.arbiter;
 
-	if (!hdcp_message)
-		return;
+	if (hdcp_message) {
+		xe_bo_unpin_map_no_vm(hdcp_message->hdcp_bo);
+		kfree(hdcp_message);
+		xe->display.hdcp.hdcp_message = NULL;
+	}
 
-	xe_bo_unpin_map_no_vm(hdcp_message->hdcp_bo);
-	kfree(hdcp_message);
+	kfree(arb);
+	xe->display.hdcp.arbiter = NULL;
 }
 
 static int xe_gsc_send_sync(struct xe_device *xe,
-- 
2.43.0



