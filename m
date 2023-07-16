Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB008F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB8FC433C8;
	Sun, 16 Jul 2023 20:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538847;
	bh=G3ylqh69nfF3OpmlpvALLxUEzrfgD5fwzWFe6tDaFDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgSHA3mdVaaSO876HcHsLmrhBBL+ar2dIvCbyLYJxidt+o1XJGukI709hVITm8KT1
	 ntij/3Rhw6OQopUZgYIVmAZOHTCV6nlil7iqUffPXXADpoB2g/4U0qVtcUb5GxsEym
	 L4eTTaD/HrYmbFRojiJ98Ew3klnp8Ir5WRBKGGbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Lundberg Pedersen <dlp@qtec.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 569/800] media: videodev2.h: Fix p_s32 and p_s64 pointer types
Date: Sun, 16 Jul 2023 21:47:02 +0200
Message-ID: <20230716195002.303729430@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Lundberg Pedersen <dlp@qtec.com>

[ Upstream commit 3f6375a2d1956739c6c8ffa3a862c9278d346940 ]

Use the intended pointer types for p_s32 and p_64 in the union of the
struct v4l2_ext_control.

Fixes: e77eb66342c7 ("videodev2.h: add p_s32 and p_s64 pointers")
Signed-off-by: Daniel Lundberg Pedersen <dlp@qtec.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/videodev2.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index aee75eb9e6863..9e7cf1d369456 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1807,8 +1807,8 @@ struct v4l2_ext_control {
 		__u8 __user *p_u8;
 		__u16 __user *p_u16;
 		__u32 __user *p_u32;
-		__u32 __user *p_s32;
-		__u32 __user *p_s64;
+		__s32 __user *p_s32;
+		__s64 __user *p_s64;
 		struct v4l2_area __user *p_area;
 		struct v4l2_ctrl_h264_sps __user *p_h264_sps;
 		struct v4l2_ctrl_h264_pps *p_h264_pps;
-- 
2.39.2



