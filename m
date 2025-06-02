Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD94919EEBD;
	Mon,  2 Jun 2025 14:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875356; cv=none; b=E8Wk+VwFMRr1WonRr3TlYJ8bJSh6NAKsKc1LqipOwo7Q8634uDVebmifQDSmExlvcNMAruYBRHz1KmM9cS7/xV1xZS0b8s3tc+h95CjXcY6loCU52e3Y0w8vw0E2DIdyvAmrTJ/UwnVC27i7fVvgvNxoB1mjDkGDPay+t3lBBCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875356; c=relaxed/simple;
	bh=yvOo1yRqr+9emsZI64UxORIPJBQaXkqpbBYe0jVW5fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Shhgiq9sN0hqtKPAW1/V+XR/XRYFkxfsXe6dfDrIDUhO4WHHn1Np+sCjVIhL/k8s0VXQZU7dyEZH6reABb/STKOxK17w7DgZHku9rUoAe0eOqLw0juQf1kvaXfX3+yUgj7xHnS8W+uyLA9S/CWqBfmzrNTzZGGyuf74PoxwpcsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvOIapie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvOIapie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C81C4CEEB;
	Mon,  2 Jun 2025 14:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875355;
	bh=yvOo1yRqr+9emsZI64UxORIPJBQaXkqpbBYe0jVW5fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvOIapie/ym84LqythNgz80kVTfOfQtZYnophZds40JTpfKOl9glIvkIVthTuNnbD
	 CJb/Aj799pHngaf+fN8xQOm6Ot5k/Ladl39dKJUsp1KsdM4EDkPPnOaZdTntLohvcL
	 nNdg4niTKAKqyCZ5bSXETEid1Bu0gWBKgZg2VH+4=
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
Subject: [PATCH 5.10 109/270] usb: typec: fix pm usage counter imbalance in ucsi_ccg_sync_control()
Date: Mon,  2 Jun 2025 15:46:34 +0200
Message-ID: <20250602134311.693079808@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[Minor context change fixed.]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -575,7 +575,7 @@ static int ucsi_ccg_sync_write(struct uc
 				    UCSI_CMD_CONNECTOR_MASK;
 			if (con_index == 0) {
 				ret = -EINVAL;
-				goto unlock;
+				goto err_put;
 			}
 			con = &uc->ucsi->connector[con_index - 1];
 			ucsi_ccg_update_set_new_cam_cmd(uc, con, (u64 *)val);
@@ -591,8 +591,8 @@ static int ucsi_ccg_sync_write(struct uc
 
 err_clear_bit:
 	clear_bit(DEV_CMD_PENDING, &uc->flags);
+err_put:
 	pm_runtime_put_sync(uc->dev);
-unlock:
 	mutex_unlock(&uc->lock);
 
 	return ret;


