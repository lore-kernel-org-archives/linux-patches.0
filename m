Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7473217B421;
	Wed,  2 Oct 2024 13:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876814; cv=none; b=Dnt9ZCEAFBEzDh2CxWL2NHg0wARqfctNFG6D77MxIZuOGFfaV4PR35rWmujR1b8EeiHzzO7fn80UyW0zd7P7IIzdo8pDAb/leNW8R64KPH+6AoZ6yHt7Ix0tlFUGiNy3a7P6C68N0BXuH9QeIXWN5a4BK6jymH8dsh/2IY/BoiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876814; c=relaxed/simple;
	bh=9tINYZcSj5JNYZxPpCvWAWxpYa6ee/aS8fimuELn2zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+4Bl8PEbTUbbjCwG7rZbdmM/4M0YZn6jAqoY0vcJbT3WtWoGF78Wu4tAIn19YykJFJlTGJMBRS7iwKGRvC6xs7LfOta8PbEr3XXPI8kJYr98EnfzHRnT1EiWcQyc1NGzDviVFkYW4f8S1RPnCvENRzBPZimuO8vT9rNYfrjMZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCoNHWND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCoNHWND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1536C4CEC5;
	Wed,  2 Oct 2024 13:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876814;
	bh=9tINYZcSj5JNYZxPpCvWAWxpYa6ee/aS8fimuELn2zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCoNHWNDiyVKPFr/CXyA1nPm8PKz7bYNQuT0FCX+UFQlg7eE/Fi/jxLSu6gSgDSey
	 hInUslw5thvUkJOvLzdfhKigqqrDj43mPHsH98KN/IO4K45EkhVwbBtjD3qbt01s85
	 leMvETC/6Z7h4B2JFI3MfkjCaL0k0QnFeziERO3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Pandey <quic_mapa@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.11 571/695] scsi: ufs: qcom: Update MODE_MAX cfg_bw value
Date: Wed,  2 Oct 2024 14:59:29 +0200
Message-ID: <20241002125845.301551692@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manish Pandey <quic_mapa@quicinc.com>

commit 0c40f079f1c808e7e480c795a79009f200366eb1 upstream.

Commit 8db8f6ce556a ("scsi: ufs: qcom: Add missing interconnect bandwidth
values for Gear 5") updated the ufs_qcom_bw_table for Gear 5. However, it
missed updating the cfg_bw value for the max mode.

Hence update the cfg_bw value for the max mode for UFS 4.x devices.

Fixes: 8db8f6ce556a ("scsi: ufs: qcom: Add missing interconnect bandwidth values for Gear 5")
Cc: stable@vger.kernel.org
Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
Link: https://lore.kernel.org/r/20240903063709.4335-1-quic_mapa@quicinc.com
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-qcom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -93,7 +93,7 @@ static const struct __ufs_qcom_bw_table
 	[MODE_HS_RB][UFS_HS_G3][UFS_LANE_2] = { 1492582,	204800 },
 	[MODE_HS_RB][UFS_HS_G4][UFS_LANE_2] = { 2915200,	409600 },
 	[MODE_HS_RB][UFS_HS_G5][UFS_LANE_2] = { 5836800,	819200 },
-	[MODE_MAX][0][0]		    = { 7643136,	307200 },
+	[MODE_MAX][0][0]		    = { 7643136,	819200 },
 };
 
 static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);


