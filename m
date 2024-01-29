Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EE7157E6B;
	Mon, 29 Jan 2024 17:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548312; cv=none; b=TZhc7RDRtYM+PBfXDBASGgyr9t3gOW6uuaJo/JxIBpkvOG6IRlyFApnt1SuVEDCRnd3Q1dKxSMMDSxABzy7sYFuoxJoMlaA1YpZAT1RrZyYYoPmzWXZj5Q9d1mdeL57pJ/oKi+sSheVk2dWs2tsRGu3Wg1ezUrt4yutkrmr2V6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548312; c=relaxed/simple;
	bh=g8BzngOBHQ03EGrSipr+8TXX8RLrPVsVSBgsEuyr47w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CN65nNgjZMKhQ/BaDttSrhO0xzB+vDpAmAAL1A25rkk8CCmZ9sRXNb3IpkDC1uGsshOx8aiK/t7VgdonE3XeBwg0B3DwlDNoB/btgscDx13E9wVlygnjrA1Ass79KhHCONH6yy/KXwp8RTd96qK6e2JaKgPmd8irL78eQm8ik5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZwbH1cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZwbH1cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B703C43394;
	Mon, 29 Jan 2024 17:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548312;
	bh=g8BzngOBHQ03EGrSipr+8TXX8RLrPVsVSBgsEuyr47w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZwbH1cx+ENv7RcIwawhrbLMQn0Zd2zwFlk6JkeNejWVPUQz7hf8UCjo2bAMCg974
	 oWEsZW3hs55KDee8HYyC6Za3r9J89hxWjYG6J7Tc44FXQgrEVjSoVWguZl3fOx/q8R
	 YYL/nZCfKSkkHAEkeBTvef6zPPtPV8Oa3JcfRtqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 283/346] media: v4l: cci: Include linux/bits.h
Date: Mon, 29 Jan 2024 09:05:14 -0800
Message-ID: <20240129170024.712738827@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit eba5058633b4d11e2a4d65eae9f1fce0b96365d9 ]

linux/bits.h is needed for GENMASK(). Include it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: d92e7a013ff3 ("media: v4l2-cci: Add support for little-endian encoded registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/media/v4l2-cci.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/v4l2-cci.h b/include/media/v4l2-cci.h
index 0f6803e4b17e..f2c2962e936b 100644
--- a/include/media/v4l2-cci.h
+++ b/include/media/v4l2-cci.h
@@ -7,6 +7,7 @@
 #ifndef _V4L2_CCI_H
 #define _V4L2_CCI_H
 
+#include <linux/bits.h>
 #include <linux/types.h>
 
 struct i2c_client;
-- 
2.43.0



