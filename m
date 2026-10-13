Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A7D47CA69;
	Tue, 13 Oct 2026 11:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892324; cv=none; b=awvrWuVXed6OcD0ylFvAl2C8HNMZbNZicyt1r2Uj2Td6l5O1tNsxdAcfs5/mECO1BhIdKU/SCOGr0qxbPbE2umCB4/f4Hpl6bezOYkn54GHG1PYpIQM5XU0w5OFws4bclIXiQccxIHSk4J4QeYpWzISTBZa9upN3jHftlj+ZHqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892324; c=relaxed/simple;
	bh=t0NXeYBRhRxjz8q2WGRDxykMLq5SaGVJqzn88Fqtp7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXtY8F3u0sSM6EIpYfrrnKsnnpzeEJIsoJj+iFZoxCcmaQCSNujbqtIbnEdDHdmzJF2OR2lVcwNgZ8q4B5y9Qq+DNgR4pLCdy0UfSIJK1CrDTIzyb6NA7EtGemdnmRS36+15V3gGuaWcuLgHYtxzPo/Z9crGrsOZxXXvnAbXSvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDmRaqUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDmRaqUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC8D1F00893;
	Tue, 13 Oct 2026 11:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892323;
	bh=IHk/Kbim6C2ghnh7icYtXDhzvFJZhHyXAtU7a4GXEzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mDmRaqUu9kxWsCwJ8EnGAkq7PlyKdtvttFtAkzghaHoxwl+P2EOdQoYcST6GMyfxq
	 TPeOmJSEebyAtjoUbqGUhgFtMEAW4YR2p1OQbcieGRv9hr7W/P+oplDl3fFkppFArA
	 mAW2099RrXV9r+6oYg+p6J0HqU+oCN35hsxbzpvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>
Subject: [PATCH 7.2 136/281] drm/bridge: th1520-dw-hdmi: Fix error check on dw_hdmi_probe() return value
Date: Tue, 13 Oct 2026 13:37:32 +0200
Message-ID: <20261013112858.453847969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit add916cfcec5b71cb242db85b91b2437be7390cf upstream.

The error check after calling dw_hdmi_probe() was incorrectly checking
the struct pointer hdmi instead of the probe result hdmi->dw_hdmi.

Fix this by checking the correct variable.

Fixes: 96f30ee0fb9d ("drm/bridge: add a driver for T-Head TH1520 HDMI controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Link: https://patch.msgid.link/20260321-th1520-v1-1-ec877197770d@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/th1520-dw-hdmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/th1520-dw-hdmi.c b/drivers/gpu/drm/bridge/th1520-dw-hdmi.c
index cbea8b14cd4b..3464720b4e13 100644
--- a/drivers/gpu/drm/bridge/th1520-dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/th1520-dw-hdmi.c
@@ -135,8 +135,8 @@ static int th1520_dw_hdmi_probe(struct platform_device *pdev)
 	plat_data->priv_data = hdmi;
 
 	hdmi->dw_hdmi = dw_hdmi_probe(pdev, plat_data);
-	if (IS_ERR(hdmi))
-		return PTR_ERR(hdmi);
+	if (IS_ERR(hdmi->dw_hdmi))
+		return PTR_ERR(hdmi->dw_hdmi);
 
 	platform_set_drvdata(pdev, hdmi);
 
-- 
2.56.0



