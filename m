Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B5C81751;
	Wed,  7 Aug 2024 15:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043671; cv=none; b=i1ycwDC8wHN158dJ9SGPDsQ46SeCP1sBhysZe+EKZjgMIBubtP1OGd3RFOh/alY3Oox2oVjwkcAntFd1L43qanGcndtJWVpWU05l0J1eEWH+jp65qBkpm2XOfbu/6QTVvzYFZmAAODMO4HQM2GWBh/pfpoblDwu2dSmE8Z6/b9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043671; c=relaxed/simple;
	bh=cKRSKkrA5Fh7TXQIiE0iFyUens1Vot/P+RNcTXgqMVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPr9z14Xi+r6bH+aHECVvtR1l9wUurm3+2wDLb+NcScUUeomAmcRsD0UIoGGFfogaqgiwNdnp4n2Wb1F4DT1bEZrI1xtCDRcc85zH2xroT+uB8vDcmmS0oLGVDqo8DgQy9G0vQqb3aXmWUet8i0kLNFVRIwTfv4Jknrs4FlY7u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ax8nyIDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ax8nyIDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B3EC4AF0B;
	Wed,  7 Aug 2024 15:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043671;
	bh=cKRSKkrA5Fh7TXQIiE0iFyUens1Vot/P+RNcTXgqMVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ax8nyIDRscmpaq1fJIUB8KDq6QW9iiplYg6qYL6EAEh12U9/IRFfK5BgoFSsvi6j6
	 pgRIkpo4d5/s95e9gvbg3kxxUKZCbjTJWIsnbdwsoGziHiFhHB2WeyeTD7A7pDSQHs
	 tVefTxTtOmz41wcLuF/75GKH9e6FT3Zuw0cUr5CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/86] drm/udl: Use USB timeout constant when reading EDID
Date: Wed,  7 Aug 2024 17:00:08 +0200
Message-ID: <20240807150040.197208419@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 2c1eafc40e53312864bf2fdccb55052dcbd9e8b2 ]

Set the USB control-message timeout to the USB default of 5 seconds.
Done for consistency with other uses of usb_control_msg() in udl and
other drivers.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221006095355.23579-4-tzimmermann@suse.de
Stable-dep-of: 5aed213c7c6c ("drm/udl: Remove DRM_CONNECTOR_POLL_HPD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/udl/udl_connector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/udl/udl_connector.c b/drivers/gpu/drm/udl/udl_connector.c
index e9539829032c5..cb3d6820eaf93 100644
--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -31,7 +31,7 @@ static int udl_get_edid_block(void *data, u8 *buf, unsigned int block,
 		int bval = (i + block * EDID_LENGTH) << 8;
 		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				      0x02, (0x80 | (0x02 << 5)), bval,
-				      0xA1, read_buff, 2, 1000);
+				      0xA1, read_buff, 2, USB_CTRL_GET_TIMEOUT);
 		if (ret < 1) {
 			DRM_ERROR("Read EDID byte %d failed err %x\n", i, ret);
 			kfree(read_buff);
-- 
2.43.0



