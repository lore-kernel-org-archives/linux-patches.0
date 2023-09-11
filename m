Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC7D111BE
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05F6C433C8;
	Mon, 11 Sep 2023 14:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444019;
	bh=iZkrdpgftTl08C/9zbvSMNSbFqyGo+asS9E+jf0kub0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b11r/IjIfayX6s+j0J9DUuX8vAj3Cqsjwvvw2i4Fs4Lnykulkk6f+IZqze4HJAkqr
	 2V0T/EizX0x3PgkDngd8NIQGFE7gBQfYWSuSD6NRC3GK9f1bhjHT2+oHJAjOMotRKg
	 foaebINdJnSNIvr5IjRtuyqsOZyqhiHJ9KjPmmSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 553/737] arm64: defconfig: Drop CONFIG_VIDEO_IMX_MEDIA
Date: Mon, 11 Sep 2023 15:46:52 +0200
Message-ID: <20230911134706.004516826@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 0ca2fbab99b12bb81fceaafe5495c00d76789a37 ]

CONFIG_VIDEO_IMX_MEDIA isn't needed on arm64 platforms since commit
9f257f502c2e ("media: imx: Unstage the imx7-media-csi driver") which
moved the last arm64 driver depending on that Kconfig symbol out of
staging. Drop it from the arm64 defconfig.

Fixes: 9f257f502c2e ("media: imx: Unstage the imx7-media-csi driver")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/configs/defconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index d3cea343a4c3d..fdfe54f35cf8e 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1107,7 +1107,6 @@ CONFIG_XEN_GNTDEV=y
 CONFIG_XEN_GRANT_DEV_ALLOC=y
 CONFIG_STAGING=y
 CONFIG_STAGING_MEDIA=y
-CONFIG_VIDEO_IMX_MEDIA=m
 CONFIG_VIDEO_MAX96712=m
 CONFIG_CHROME_PLATFORMS=y
 CONFIG_CROS_EC=y
-- 
2.40.1



