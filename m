Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD06E30506C;
	Tue, 30 Sep 2025 14:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244380; cv=none; b=O46GZTbMh3sToMdQFm/wHdueqq8P5YBStkgjAc6gHgkzjFwSthJM0hoq79dWWXati3Nb6xSYY0kN8EagYj1d4FPJAaSkIu69F370AL5p5H/qM3wHz6R+CcphadS68gWNbW+bqJ/lbWmJNi3D/4+3H4qwBIXxWcfQcvFYrRpF0iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244380; c=relaxed/simple;
	bh=eE7ynYRS3/7/NchgVsWnsEZb0NcCAw92PJSbxfwW70E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkyCrUTLkmX+m+q9WBPMFnfrf+kVRyYLCTk6tl4jkKZy27egSQKoGYt72IsB+dA6MB0+G4XpG/9FN+C2fjLvVkcFB6eleAYcmq+Kwi8UkmJMLLDqKvKt5oCq1VrLs0Y/ezg4647d2rCK2YT2uaO1t5KdTVWT0mPwBoPGpjV7HYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6PWHG/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6PWHG/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22A6C4CEF0;
	Tue, 30 Sep 2025 14:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244379;
	bh=eE7ynYRS3/7/NchgVsWnsEZb0NcCAw92PJSbxfwW70E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6PWHG/NfWoxGAXmAA7EQA2Fa3W872n8t/el1YisM3XPvz7Y9YfCBvwEzi30utlot
	 9Nk9DS1lJzKVl0+m2qxNStDzKiv4qYdxAogeTYdT5ksnYvC/zakfQH8vDY45iosL0u
	 jNvyzSDBEwoJ/wm6NhIyx0fgUZh6pkGLbeootxQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Czapnik <lukasz.czapnik@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 111/122] i40e: fix input validation logic for action_meta
Date: Tue, 30 Sep 2025 16:47:22 +0200
Message-ID: <20250930143827.513762170@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Czapnik <lukasz.czapnik@intel.com>

commit 9739d5830497812b0bdeaee356ddefbe60830b88 upstream.

Fix condition to check 'greater or equal' to prevent OOB dereference.

Fixes: e284fc280473 ("i40e: Add and delete cloud filter")
Cc: stable@vger.kernel.org
Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3412,7 +3412,7 @@ static int i40e_validate_cloud_filter(st
 
 	/* action_meta is TC number here to which the filter is applied */
 	if (!tc_filter->action_meta ||
-	    tc_filter->action_meta > vf->num_tc) {
+	    tc_filter->action_meta >= vf->num_tc) {
 		dev_info(&pf->pdev->dev, "VF %d: Invalid TC number %u\n",
 			 vf->vf_id, tc_filter->action_meta);
 		goto err;


