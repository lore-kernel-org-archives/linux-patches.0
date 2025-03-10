Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6A41C5D6F;
	Mon, 10 Mar 2025 18:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630994; cv=none; b=fFxrlKASiq/wAy6yZaEQ7a7kV1xig7sWMBi1xE5OdAEZDZR+HRUDFAsg/X8+GGvisLjuFqZ76SjoNZldN1W09NX6w2f4tnXIdrRSTQZ5qUtQqbYzYY46sFmggmeLB0v+jEfdVlhv9ZzM3aJWa0SMXqW8hAIy5MilQEyvf7zJphY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630994; c=relaxed/simple;
	bh=tNKtYXtSdMtJdmMDtUbxuax6R7dyCCW1SSYgt3jwPrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maNlYqodOzdFhpPWxdT2nZZo3tcMcRTBwc56+4iqFzPraYD/j/IbXvg20XtUEwp3j6QkVymdnxSYmdzwsjVDW3entYnxXChQyXGrvlTXVAvDWetbwjXGXwfiPCd16/RfTFO5bOZv480saUjt7907H+lFUAgsMxKnZOanm9WaOkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+WVNf83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+WVNf83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65155C4CEE5;
	Mon, 10 Mar 2025 18:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630993;
	bh=tNKtYXtSdMtJdmMDtUbxuax6R7dyCCW1SSYgt3jwPrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+WVNf83/5G0OYCooz5OvAl1Q7BwOfN2GKlVhntcUVzIArg4xcDTWSnr6x95N9Wvy
	 /tJNU3naBvVTcEPP29HoOYO7ATBZwjRuK2IWQTYMpCFDlnXNTniot62aEW/3f5t5vQ
	 bJWzVbApzIapvCCJyASWSOfDTVsDNuaFh06eQvG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 606/620] media: uvcvideo: Avoid returning invalid controls
Date: Mon, 10 Mar 2025 18:07:32 +0100
Message-ID: <20250310170609.452527554@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 414d3b49d9fd4a0bb16a13d929027847fd094f3f upstream.

If the memory where ctrl_found is placed has the value of uvc_ctrl and
__uvc_find_control does not find the control we will return an invalid
index.

Fixes: 6350d6a4ed487 ("media: uvcvideo: Set error_idx during ctrl_commit errors")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1709,7 +1709,7 @@ static int uvc_ctrl_find_ctrl_idx(struct
 				  struct uvc_control *uvc_control)
 {
 	struct uvc_control_mapping *mapping = NULL;
-	struct uvc_control *ctrl_found;
+	struct uvc_control *ctrl_found = NULL;
 	unsigned int i;
 
 	if (!entity)


