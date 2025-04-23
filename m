Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474E92BF3C9;
	Wed, 23 Apr 2025 15:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422512; cv=none; b=DEsZm9PrGayIhJ+yTNOop3p7GfNZJn5Pqxfw6eZtpA89cNkDEFq371XUNG+kz08WQAPsd3Fq+JB3wV1axlVuzW3iJGM0L//bEfNh4ezvdYnTVWzH3aqqf7pejeP+rCiN7ha6T3xswxi+kqoWCQ/Nk42EYcGOlnr+EWVAC4jsZsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422512; c=relaxed/simple;
	bh=YeMR0XwkWsLUwMqv885RtcXmcFx15BdPPSR+Ltxii1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2BLAwjRCFiUY2J7kV4WIbRH6NU4fTQGM2FUj376ZFhFJvNmn4yj330Nea1rFlssb0YJury0KTf1Yzn/jtyXX9dqrRtUtoljxcS7f9osjZyIAFqZgMLFAHeCwTwaBxbRXEWIDFCnOHThtei25BrFtSFVY+r//n3xeqwGt92EKO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=biXvtI1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="biXvtI1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BF2C4CEE2;
	Wed, 23 Apr 2025 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422511;
	bh=YeMR0XwkWsLUwMqv885RtcXmcFx15BdPPSR+Ltxii1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=biXvtI1Yli5TPgtiBMYUwLTANiMeqVGyGpJJxHgCuyHEEQdSHug4BFhZ8fG/DsvH+
	 heQ8UcspdPpzfxnJc/6DQ17kSpwOeDYWaESc+bZOQwzVW/Sl72ubVIuwwifgW9OiYB
	 IfoLzdVObV2XySSJaf/AHTOkiQq3G1b4hSZHoKjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	GONG Ruiqi <gongruiqi1@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 378/393] usb: typec: fix pm usage counter imbalance in ucsi_ccg_sync_control()
Date: Wed, 23 Apr 2025 16:44:34 +0200
Message-ID: <20250423142658.944800819@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: GONG Ruiqi <gongruiqi1@huawei.com>

commit b0e525d7a22ea350e75e2aec22e47fcfafa4cacd upstream.

The error handling for the case `con_index == 0` should involve dropping
the pm usage counter, as ucsi_ccg_sync_control() gets it at the
beginning. Fix it.

Cc: stable <stable@kernel.org>
Fixes: e56aac6e5a25 ("usb: typec: fix potential array underflow in ucsi_ccg_sync_control()")
Signed-off-by: GONG Ruiqi <gongruiqi1@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250107015750.2778646-1-gongruiqi1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Minor context change fixed]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -587,7 +587,7 @@ static int ucsi_ccg_sync_write(struct uc
 				    UCSI_CMD_CONNECTOR_MASK;
 			if (con_index == 0) {
 				ret = -EINVAL;
-				goto unlock;
+				goto err_put;
 			}
 			con = &uc->ucsi->connector[con_index - 1];
 			ucsi_ccg_update_set_new_cam_cmd(uc, con, (u64 *)val);
@@ -603,8 +603,8 @@ static int ucsi_ccg_sync_write(struct uc
 
 err_clear_bit:
 	clear_bit(DEV_CMD_PENDING, &uc->flags);
+err_put:
 	pm_runtime_put_sync(uc->dev);
-unlock:
 	mutex_unlock(&uc->lock);
 
 	return ret;


