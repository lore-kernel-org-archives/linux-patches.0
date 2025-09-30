Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0D71D61B7;
	Tue, 30 Sep 2025 15:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244432; cv=none; b=moabIk7xqkLV4DqrGLbBApwdi/dfhlXNmUe5Oh6/t+ON+E/HB7Hj3nLo1QvlgLkudSjHR5ZNHUwFxJxMjRXMzmjRouXgyDO5nMG9BzaMo5g2kIvlwjOtoZk+ISwh7yrLu2vP+xC/GHwqzieJIs7XXnmPPEPnMfKW5YvVcR9kMi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244432; c=relaxed/simple;
	bh=T7AU73MIs/S3r/HkMKATErldhK3ofWWJK6IH2VIsxvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2jcz9v6P+lumHiTSxlseTRMNlMjDBb7BsC/Sn+xxrbd/J1HWgUk0ea/4E74LdN5o/0T6xG5y17OfHa/CmX1xHswzNgPBLHhGMsHuwkk8SqYPLpopkjoMAwqjBjusdUz05aJj2MtUVTogiivv5mXheY33KWsTdW76XRoJmKHMIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OneWuxn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OneWuxn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3E7C4CEF0;
	Tue, 30 Sep 2025 15:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244432;
	bh=T7AU73MIs/S3r/HkMKATErldhK3ofWWJK6IH2VIsxvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OneWuxn6WzZCFWDhLxz3Uc6KXSKTO+0U7Qf5b3gFNwUzgjmLB02E/EMOhMnMqhInw
	 WGv7fuqzZ0dCWwJ/QyarbNzGtDHD7sV38PndsR5nvrJFtXTYNv1d8keaMR4JuMyvy6
	 6l5kgKKuarSQZrSTBpIHnWySa+8+1awhTuPrzIo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Czapnik <lukasz.czapnik@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Kamakshi Nellore <nellorex.kamakshi@intel.com>
Subject: [PATCH 5.10 120/122] i40e: fix idx validation in config queues msg
Date: Tue, 30 Sep 2025 16:47:31 +0200
Message-ID: <20250930143827.874036325@linuxfoundation.org>
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

[ Upstream commit f1ad24c5abe1eaef69158bac1405a74b3c365115 ]

Ensure idx is within range of active/initialized TCs when iterating over
vf->ch[idx] in i40e_vc_config_queues_msg().

Fixes: c27eac48160d ("i40e: Enable ADq and create queue channel/s on VF")
Cc: stable@vger.kernel.org
Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Kamakshi Nellore <nellorex.kamakshi@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2340,7 +2340,7 @@ static int i40e_vc_config_queues_msg(str
 		}
 
 		if (vf->adq_enabled) {
-			if (idx >= ARRAY_SIZE(vf->ch)) {
+			if (idx >= vf->num_tc) {
 				aq_ret = I40E_ERR_NO_AVAILABLE_VSI;
 				goto error_param;
 			}
@@ -2361,7 +2361,7 @@ static int i40e_vc_config_queues_msg(str
 		 * to its appropriate VSIs based on TC mapping
 		 */
 		if (vf->adq_enabled) {
-			if (idx >= ARRAY_SIZE(vf->ch)) {
+			if (idx >= vf->num_tc) {
 				aq_ret = I40E_ERR_NO_AVAILABLE_VSI;
 				goto error_param;
 			}


