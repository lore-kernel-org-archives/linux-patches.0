Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9187915218A;
	Tue,  2 Jul 2024 17:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941048; cv=none; b=TcRXgLH+sqp7JJTbs9vQlfA8pyxBRZ/u7rG37iylGkwqqANAWvkoQUgAVj6FtMhxbwQ/+jgcB71wiuXuYMU4EYjF3UkuMVeDwftO4w88xJK0Dl+/xka0gVI4/K5NJZas4lw5+hvwia/9bezy14YY58MkpzDEfq/OtyG7BWGOCaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941048; c=relaxed/simple;
	bh=BZQQr9Q40YZOxRF2ZnRHdYAFadHHwl78/THZfdbgV7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2zgabeBCtsD/rTNYdm8FXyT0EW7UqRAdgXTVYNuknoEFHU7M8t+PqX5Ywr04sMTjDsVzSvqTTaOO+bxOi9SzbWMUSLm48cic2sh+zYoaRGpbQc0mtVWl0k66aoluWJcGbzG96zHRsCXvjSTUIAw0GSscYGJfGsp0QK8IloJm5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvyX6ZMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvyX6ZMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3079C116B1;
	Tue,  2 Jul 2024 17:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941048;
	bh=BZQQr9Q40YZOxRF2ZnRHdYAFadHHwl78/THZfdbgV7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvyX6ZMH3U9JbqAG2OSA3lwO+UNU7Fd1iBg7tgjokadrMaCwikfM+WZ9gEIHRTROV
	 VRSGKCbT55CB0TINiNbOTFU26iLfJ7poWhGVnZgJbnw0kmegOZ8lWumzTpPLrSyF2/
	 ykYWHeSotTOmfqIjOhsEGNtWpUspCFt4p2uBAKbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wesley Cheng <quic_wcheng@quicinc.com>
Subject: [PATCH 6.6 113/163] usb: dwc3: core: Add DWC31 version 2.00a controller
Date: Tue,  2 Jul 2024 19:03:47 +0200
Message-ID: <20240702170237.334077201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wesley Cheng <quic_wcheng@quicinc.com>

commit 1e43c86d84fb0503e82a143e017f35421498fc1a upstream.

Add revision value for identifying DWC31 version 2.00a based controllers.

Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20240301213554.7850-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1247,6 +1247,7 @@ struct dwc3 {
 #define DWC31_REVISION_170A	0x3137302a
 #define DWC31_REVISION_180A	0x3138302a
 #define DWC31_REVISION_190A	0x3139302a
+#define DWC31_REVISION_200A	0x3230302a
 
 #define DWC32_REVISION_ANY	0x0
 #define DWC32_REVISION_100A	0x3130302a


