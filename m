Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9793A8FA
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVCU30Wd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3281AC433C8;
	Wed, 15 Nov 2023 20:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078490;
	bh=uxNt+wBkDc0LCRvik+g8is3AmwaohYpTkDIx95tu8MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVCU30WdH+P3Lx459Jc58ArvDlSbs/q9vjRGWlZHf6MhBnty9i08ZI7kNQ7VRQGuA
	 spGQgVVt92GPxiqxwPngpEhPVXm65FO95wHL6Kf37Yh8EI2O0yRzn5PQSxMJqlpUw6
	 TJMp9k0vv52CmS+kZgAyRdIOF69CcF9xjYV3gJJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 329/379] media: cec: meson: always include meson sub-directory in Makefile
Date: Wed, 15 Nov 2023 14:26:44 -0500
Message-ID: <20231115192704.613090771@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 94e27fbeca27d8c772fc2bc807730aaee5886055 ]

'meson' directory contains two separate drivers, so it should be added
to Makefile compilation hierarchy unconditionally, because otherwise the
meson-ao-cec-g12a won't be compiled if meson-ao-cec is not selected.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: 4be5e8648b0c ("media: move CEC platform drivers to a separate directory")
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/cec/platform/Makefile b/drivers/media/cec/platform/Makefile
index 26d2bc7783944..a51e98ab4958d 100644
--- a/drivers/media/cec/platform/Makefile
+++ b/drivers/media/cec/platform/Makefile
@@ -6,7 +6,7 @@
 # Please keep it in alphabetic order
 obj-$(CONFIG_CEC_CROS_EC) += cros-ec/
 obj-$(CONFIG_CEC_GPIO) += cec-gpio/
-obj-$(CONFIG_CEC_MESON_AO) += meson/
+obj-y += meson/
 obj-$(CONFIG_CEC_SAMSUNG_S5P) += s5p/
 obj-$(CONFIG_CEC_SECO) += seco/
 obj-$(CONFIG_CEC_STI) += sti/
-- 
2.42.0



