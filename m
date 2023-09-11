Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A771C11711
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC8DC433CA;
	Mon, 11 Sep 2023 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441610;
	bh=hG54PWPrjvg9tHU0uP1vlYyQEC4A0MBT7shp7DuxfF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmsAb9W30RS6YxYQ3ntjHNqPDrFtpd8Kg2Ttm5F2TlOKf7SeFSGZHOScmpisn0PIC
	 AjW9Wic6N7jH/jr0TcHe5t1HPkKQwmuZTnPA6ojb/v8taMdc1tMbzkW7cLJZsH1axk
	 L8tscQR7WDCWouFnyhnjbxjMmE8jSbUxDiVVl7W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 474/739] media: amphion: fix UNUSED_VALUE issue reported by coverity
Date: Mon, 11 Sep 2023 15:44:33 +0200
Message-ID: <20230911134704.383869408@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit cf6a06354989c41b536be8e094561ee16223cf1f ]

assign value '-EINVAL' to ret, but the stored value is overwritten
before it can be used

Fixes: 9f599f351e86 ("media: amphion: add vpu core driver")
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_cmds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/amphion/vpu_cmds.c b/drivers/media/platform/amphion/vpu_cmds.c
index 7e137f276c3b1..235b71398d403 100644
--- a/drivers/media/platform/amphion/vpu_cmds.c
+++ b/drivers/media/platform/amphion/vpu_cmds.c
@@ -315,7 +315,7 @@ static int vpu_session_send_cmd(struct vpu_inst *inst, u32 id, void *data)
 {
 	unsigned long key;
 	int sync = false;
-	int ret = -EINVAL;
+	int ret;
 
 	if (inst->id < 0)
 		return -EINVAL;
-- 
2.40.1



