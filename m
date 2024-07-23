Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EE1158848;
	Tue, 23 Jul 2024 18:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759374; cv=none; b=E48XgGYQm1KQCb8HxxT5GpJqFwNhfT64Y7NUkfMnrbio+4Y0NIKcm/FKnpk7P0QZNhkpFD3Qo3XYPIaSQYvjxhwCKq9wRy25LxylnIvDkro4TvITHoTa6uBUP39DZ5sdPODzjqO57V9vmNkfpwL7i7EOAJcwvNphXASa1OIB51M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759374; c=relaxed/simple;
	bh=bgvDswSRab90psYCiVqM0B4j45QLNUJYE0xWRMfyYmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V00lANjUsJijm1qT+GguKDDhiH7JKkiz6YhhNJVGz15NMRTWMKUTQdSx5qUJQY2AXUMf4CJK13WmoiJsvRkSMNu4Yva7BtBruZUhGgkW/e359zIBqwlKYEEivvykQ199uElqRlrGCQzVI7xALnVZ+gIFuMoS6CIHKtwdRG6O1/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XITmYKNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XITmYKNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88771C4AF0A;
	Tue, 23 Jul 2024 18:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759373;
	bh=bgvDswSRab90psYCiVqM0B4j45QLNUJYE0xWRMfyYmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XITmYKNF0pXymGSfexwc3Q6d+4vztg1AfayP9+3b7Ms+hCzhiAxzcR8zH1euE7+GJ
	 ImEgMO9765FkrRrMVZyfiaqdlN1w78/G6ezzN2JKXf6QOEBzON3szQFBehtudy2W4z
	 FiQpMEW2AroHYo0PnKvId+FOnuCEwbYmI+WohFvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/105] can: kvaser_usb: fix return value for hif_usb_send_regout
Date: Tue, 23 Jul 2024 20:23:40 +0200
Message-ID: <20240723180405.676255170@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 0d34d8163fd87978a6abd792e2d8ad849f4c3d57 ]

As the potential failure of usb_submit_urb(), it should be better to
return the err variable to catch the error.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://lore.kernel.org/all/20240521041020.1519416-1-nichen@iscas.ac.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 5136d1e161181..65dd57247c62e 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -292,7 +292,7 @@ int kvaser_usb_send_cmd_async(struct kvaser_usb_net_priv *priv, void *cmd,
 	}
 	usb_free_urb(urb);
 
-	return 0;
+	return err;
 }
 
 int kvaser_usb_can_rx_over_error(struct net_device *netdev)
-- 
2.43.0



