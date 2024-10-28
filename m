Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D28B824A3;
	Mon, 28 Oct 2024 06:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098453; cv=none; b=kADsAUhve8bbqSlUo5ud6y+8v2DG3NGz6Q7UR9WAgMq5SOzc4IiYdI01zLHKNssWQqQgmrb72cpulZPcPyC5E31TUt8JIMsPKAMf3wzXdgfMWNCk+QRbv7PSvHspqTXD2Wf0FIDIxUDgLeKzE5BQFaVRo0/pm5/9B1zt+aUcIz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098453; c=relaxed/simple;
	bh=9LEDWVIA61+782YjdnP9LfAdZ/KQLlhoNjS/I2FDg+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgbdV83SDLFVuLnnCaD9lcRJqjshlbgvr/0XYJLRKBPSG4Bd8/g9mJcB+SOfgcndKZs2z+HBCPErORUM5oUZ/XtL//I+pa6ZdhUSVJr6e9SrvdL6rcUY7mKNPHloRfhau7UZHCXOg5TlvtrCWnLKguq2Cie2VafIhxuOotUmJ60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9L+7HEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9L+7HEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0726C4CEC3;
	Mon, 28 Oct 2024 06:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098453;
	bh=9LEDWVIA61+782YjdnP9LfAdZ/KQLlhoNjS/I2FDg+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9L+7HEY5Ksu8pcadGBB2Cr7vtZDfSbbA0RHiyq9RyM6cjIkG0Wdk/CkzaYq8CTKL
	 J7Thzw1Y34GGfjJOwWk9R3U0TgTu1egPcUEbvFo9aarEybyib1aG65Rg0TFrG9d3RS
	 /ViwTfuGuwWfZ7/yw3iMv6KucAruNYciOIk3fS38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.11 233/261] drm/bridge: Fix assignment of the of_node of the parent to aux bridge
Date: Mon, 28 Oct 2024 07:26:15 +0100
Message-ID: <20241028062317.954794404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@linaro.org>

commit 85e444a68126a631221ae32c63fce882bb18a262 upstream.

The assignment of the of_node to the aux bridge needs to mark the
of_node as reused as well, otherwise resource providers like pinctrl will
report a gpio as already requested by a different device when both pinconf
and gpios property are present.
Fix that by using the device_set_of_node_from_dev() helper instead.

Fixes: 6914968a0b52 ("drm/bridge: properly refcount DT nodes in aux bridge drivers")
Cc: stable@vger.kernel.org      # 6.8
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241018-drm-aux-bridge-mark-of-node-reused-v2-1-aeed1b445c7d@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241018-drm-aux-bridge-mark-of-node-reused-v2-1-aeed1b445c7d@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/aux-bridge.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/aux-bridge.c
+++ b/drivers/gpu/drm/bridge/aux-bridge.c
@@ -58,9 +58,10 @@ int drm_aux_bridge_register(struct devic
 	adev->id = ret;
 	adev->name = "aux_bridge";
 	adev->dev.parent = parent;
-	adev->dev.of_node = of_node_get(parent->of_node);
 	adev->dev.release = drm_aux_bridge_release;
 
+	device_set_of_node_from_dev(&adev->dev, parent);
+
 	ret = auxiliary_device_init(adev);
 	if (ret) {
 		ida_free(&drm_aux_bridge_ida, adev->id);


