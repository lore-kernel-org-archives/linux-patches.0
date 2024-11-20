Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70031AB6C0;
	Wed, 20 Nov 2024 12:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107567; cv=none; b=INJ4/noPCR7sVWPu5xFUpPrJeI32hrmYkVSjQtEI8iJ99PgE7hwiRLgBFHwNsxsHfwUq7oeQl2w2i9NV0vKpP/0vD+4H8MHF81rXzpmyuNW3Ky9BMwxX4mbgQg00Cv7amU4xsdHaeSlONNTRRii3V9cu8OY8xsyKb1AZgAW3YC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107567; c=relaxed/simple;
	bh=86Hucs/Lg0Y5ySq1ZjdaROGdZWxX+1T6C15qbiMWDGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYF92fOH5yXWOVbkE47KFBYH1Pu+CkBGmUUDp1+PJC1J6nsYNCyJXYn+hNGjL6PeVro7G6c4ZIOHor+kMLaD1DOhO7gfjIu/ybqVEjZl1e/3LS1JdSbEUl64x75SPibtO4HQbzZd8IUElqopz2U68bk65osP02NmUzzIzAzVPYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbOGgAbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbOGgAbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9A2C4CED6;
	Wed, 20 Nov 2024 12:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107566;
	bh=86Hucs/Lg0Y5ySq1ZjdaROGdZWxX+1T6C15qbiMWDGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbOGgAbC06ido3ILR9QMPwvB3kT2elPV90bnb5eVBoyBTgcBHDtXC8wOJngmhzlAX
	 THJDZ6Tx3lsY5FsNK/sZx5ZYvze/7SKsdkA6vYj7Rn66UjDOjR7gqjzd2iZIAWuvYZ
	 Sn5K628W3UQiVEoBCmi/iYIsH0Zeu9cRi61WBJKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.11 081/107] firmware: arm_scmi: Report duplicate opps as firmware bugs
Date: Wed, 20 Nov 2024 13:56:56 +0100
Message-ID: <20241120125631.511959563@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

From: Sibi Sankar <quic_sibis@quicinc.com>

commit e2261bb81e0db86c3c866734cf93232a58464ecd upstream.

Duplicate opps reported by buggy SCP firmware currently show up
as warnings even though the only functional impact is that the
level/index remain inaccessible. Make it less scary for the end
user by using dev_info instead, along with FW_BUG tag.

Suggested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: stable@vger.kernel.org
Message-ID: <20241030125512.2884761-4-quic_sibis@quicinc.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/perf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firmware/arm_scmi/perf.c
+++ b/drivers/firmware/arm_scmi/perf.c
@@ -387,7 +387,7 @@ process_response_opp(struct device *dev,
 
 	ret = xa_insert(&dom->opps_by_lvl, opp->perf, opp, GFP_KERNEL);
 	if (ret) {
-		dev_warn(dev, "Failed to add opps_by_lvl at %d for %s - ret:%d\n",
+		dev_info(dev, FW_BUG "Failed to add opps_by_lvl at %d for %s - ret:%d\n",
 			 opp->perf, dom->info.name, ret);
 		return ret;
 	}
@@ -409,7 +409,7 @@ process_response_opp_v4(struct device *d
 
 	ret = xa_insert(&dom->opps_by_lvl, opp->perf, opp, GFP_KERNEL);
 	if (ret) {
-		dev_warn(dev, "Failed to add opps_by_lvl at %d for %s - ret:%d\n",
+		dev_info(dev, FW_BUG "Failed to add opps_by_lvl at %d for %s - ret:%d\n",
 			 opp->perf, dom->info.name, ret);
 		return ret;
 	}


