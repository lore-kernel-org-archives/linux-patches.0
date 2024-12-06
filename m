Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F199710E0;
	Fri,  6 Dec 2024 14:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496438; cv=none; b=HUcarrcitDLBNjZSdMyQptnzQc08HxcJxv6Ot8UVM8C9ZL36x3N5JtMwp33At5GoU7Vpd7vm1C0MLd0p0HwF+6W8+fjOZ/XkJ+YJjlVKWT//AbH5XG5zNrD/gqB1P5eUoMPOLFWBCoXs+napigaJW2XdVpUyQmHC9MPEir0JwJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496438; c=relaxed/simple;
	bh=7m5eYa+Ob3wl0SgIiYfZ626dpyDQcUSXbQKnTa6Qiqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rh1IFXou5sr2RWcZ86sshH8aqskbN30Z5h38FM0pfij5qZ7Q6x7e6xG3PBOzsZkf+DcJpDJbSso9Nyk8pPxv2dIgxTTr10IKpF70nGHXK8ODeDaDKrg1Ps+etZ1ki3vMvx+vzzj1EMZ/SO/ewbKuvEK5xyJAhjLdxzP+ICNcBPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWX4g5ht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWX4g5ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61383C4CED1;
	Fri,  6 Dec 2024 14:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496437;
	bh=7m5eYa+Ob3wl0SgIiYfZ626dpyDQcUSXbQKnTa6Qiqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWX4g5htBgYIoL+MjiEDrAx7ln6ZBk0A62BiLyvOB+zD+9J4ZkJEx8gr+r1yAW8yg
	 VkwhT8MQnwLdUHyw6doCj6fuleQWMY6hG1VHzSSIlIWpHhC5IfSJs9m94i7tP1y5oK
	 TTBlt2LS9G/JcMi3endQL/s3Nojycc52J4zuRn30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>
Subject: [PATCH 6.12 122/146] drm: panel: jd9365da-h3: Remove unused num_init_cmds structure member
Date: Fri,  6 Dec 2024 15:37:33 +0100
Message-ID: <20241206143532.351548039@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 66ae275365be4f118abe2254a0ced1d913af93f2 upstream.

Now that the driver has been converted to use wrapped MIPI DCS functions,
the num_init_cmds structure member is no longer needed, so remove it.

Fixes: 35583e129995 ("drm/panel: panel-jadard-jd9365da-h3: use wrapped MIPI DCS functions")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://lore.kernel.org/r/20240930170503.1324560-1-hugo@hugovil.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930170503.1324560-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
+++ b/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
@@ -26,7 +26,6 @@ struct jadard_panel_desc {
 	unsigned int lanes;
 	enum mipi_dsi_pixel_format format;
 	int (*init)(struct jadard *jadard);
-	u32 num_init_cmds;
 	bool lp11_before_reset;
 	bool reset_before_power_off_vcioo;
 	unsigned int vcioo_to_lp11_delay_ms;


