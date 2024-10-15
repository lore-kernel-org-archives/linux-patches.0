Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDE91E9078;
	Tue, 15 Oct 2024 11:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992407; cv=none; b=hn00F65a1Ck5ETjEvhiaYxZJi+LPd65/5dkakGvp7HbB8Y/o3XKqXIDQbgPVY7Cir3wJCFmv5jehfUl0/N9v7Nt4od/OyI7LkRYyEY+sOXbAffheT2HL0r5Ec9SnY3HwFjwrAniutuYQ+vMEIsvyOhr54sfr/MBsOjyQXp1okVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992407; c=relaxed/simple;
	bh=f0LKASA5zb5cpMfmzXF4BRnz1vM+JPNV7UoYiNvTZzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1jbXXn+KKsa9Yli1Tz5gl1B9eVzMRsUsbLy1uzI3SE0C2IzmQvtTbFv+x+6YOSIcAd0o7CR9l1UR/aTFxTRtxhX3PKQGfE+1R4qTZ+Dk9ybNJ5t6hw406KgvBcSrNHqlWERxwZAPs2Ypba0CB3Nujxc/TX1JjAKYs4iNx6c/2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFiA607Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFiA607Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75DDEC4CEC6;
	Tue, 15 Oct 2024 11:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992406;
	bh=f0LKASA5zb5cpMfmzXF4BRnz1vM+JPNV7UoYiNvTZzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFiA607Z79dxPccj3Qtz21KMgtZ2BgrCjFQGbog9Vp38MfqjJ6LG1werxkxG1CVA8
	 I+B1+Nw36SzAA1kvYmcYVkGUsOSJxn4NWwS6XyQuTvS/gzh3W6lcORzL/g0Y2IVHDp
	 cmTwkDDVc6YzyGiO0IVffRB8F9KN4JK8uUwuOcJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/691] wifi: iwlwifi: mvm: increase the time between ranging measurements
Date: Tue, 15 Oct 2024 13:20:54 +0200
Message-ID: <20241015112444.567279695@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 3a7ee94559dfd640604d0265739e86dec73b64e8 ]

The algo running in fw may take a little longer than 5 milliseconds,
(e.g. measurement on 80MHz while associated). Increase the minimum
time between measurements to 7 milliseconds.

Fixes: 830aa3e7d1ca ("iwlwifi: mvm: add support for range request command version 13")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240729201718.d3f3c26e00d9.I09e951290e8a3d73f147b88166fd9a678d1d69ed@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index 9d0d01f27d929..36042c334a13d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -103,7 +103,7 @@
 #define IWL_MVM_FTM_INITIATOR_SECURE_LTF	false
 #define IWL_MVM_FTM_RESP_NDP_SUPPORT		true
 #define IWL_MVM_FTM_RESP_LMR_FEEDBACK_SUPPORT	true
-#define IWL_MVM_FTM_NON_TB_MIN_TIME_BETWEEN_MSR	5
+#define IWL_MVM_FTM_NON_TB_MIN_TIME_BETWEEN_MSR	7
 #define IWL_MVM_FTM_NON_TB_MAX_TIME_BETWEEN_MSR	1000
 #define IWL_MVM_D3_DEBUG			false
 #define IWL_MVM_USE_TWT				true
-- 
2.43.0



