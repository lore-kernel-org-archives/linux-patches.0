Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB6B330B26;
	Wed,  3 Dec 2025 15:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777140; cv=none; b=tWhedfReUrLEEysm6A1M4Nmmpl5ANlMU3xH8gEY6OZ2huPp2+R3nnTikxqaY+gxnTqHVDvpnQ43w6tSni/Ycx8VrIDmufn1ZGZnA+LFKDdHtOgVtDagXMmhRAAsndrzrB8743cBO2E/xdyEcVjVbWfdrOfQspdr2uYBUGou1kGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777140; c=relaxed/simple;
	bh=qzRg4NXptuLcgq/hQt+QUdf0EW1gX9RX0XIuiDaWMiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIx2tEbAXNkK6rarrQiVbUnY0LTlkhgzek0JlfE7VlR8sD2Z0fcyY6FH7ix4k3tfNpc5yg0NZCBFlDi6j/wKuwOT/gmR4CVs81nOW5HIisR+l3taWxEBDC673GMGl+cVodSJaW2U86I1HEpWR6EGb4J61crZyJg9otSp8692X/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEhOHIbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEhOHIbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD2CC16AAE;
	Wed,  3 Dec 2025 15:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777140;
	bh=qzRg4NXptuLcgq/hQt+QUdf0EW1gX9RX0XIuiDaWMiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEhOHIbPWCPqAP1W/s4WTklgTUXe0tm3tfi/MzIJ+obszN5y3Wlq8bC3M/1th3lnk
	 QReLtu/wT76TVyp4zZeI7Lr+myeZjh1RcLhBwyQLxI4MzKt6m8tC9NXWWMHxe8EhAK
	 E2uU76EH6/jkwWczAegOGLOQtFMFVpVWwa2mOdC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyl5933@chinaunicom.cn>,
	Wentao Guan <guanwentao@uniontech.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.17 094/146] nvmem: layouts: fix nvmem_layout_bus_uevent
Date: Wed,  3 Dec 2025 16:27:52 +0100
Message-ID: <20251203152349.900175327@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

commit 03bc4831ef064e114328dea906101cff7c6fb8b3 upstream.

correctly check the ENODEV return value.

Fixes: 810b790033cc ("nvmem: layouts: fix automatic module loading")
CC: stable@vger.kernel.org
Co-developed-by: WangYuli <wangyl5933@chinaunicom.cn>
Signed-off-by: WangYuli <wangyl5933@chinaunicom.cn>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20251114110539.143154-1-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/layouts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvmem/layouts.c
+++ b/drivers/nvmem/layouts.c
@@ -51,7 +51,7 @@ static int nvmem_layout_bus_uevent(const
 	int ret;
 
 	ret = of_device_uevent_modalias(dev, env);
-	if (ret != ENODEV)
+	if (ret != -ENODEV)
 		return ret;
 
 	return 0;


