Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49EB30FA4
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A5DC433C8;
	Wed, 20 Sep 2023 12:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212399;
	bh=er29Bkh08PbHwMLyOulDBkG17vxl5ppV/3OV9EwrpzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=df+6ex766h48rpQ/R1MuRK3xcg/hl0/fRCWSsXLLYk0ARlvw4jm1m2rqZ9/VPVIKU
	 qNfnzu1HCMg9ukWnKF5A1f1loP+ifXjIETQOeE+s2K+6Pgd9Wq78j9ZLv390EztafC
	 9LLOVdCbXhz6dd8US7ZKQejRbtF+WZvHlAKNl9ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 261/273] media: pci: cx23885: replace BUG with error return
Date: Wed, 20 Sep 2023 13:31:41 +0200
Message-ID: <20230920112854.320917017@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 2e1796fd4904fdd6062a8e4589778ea899ea0c8d ]

It was completely unnecessary to use BUG in buffer_prepare().
Just replace it with an error return. This also fixes a smatch warning:

drivers/media/pci/cx23885/cx23885-video.c:422 buffer_prepare() error: uninitialized symbol 'ret'.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx23885/cx23885-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 2a20c7165e1e8..16564899f1141 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -420,7 +420,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 				dev->height >> 1);
 		break;
 	default:
-		BUG();
+		return -EINVAL; /* should not happen */
 	}
 	dprintk(2, "[%p/%d] buffer_init - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
 		buf, buf->vb.vb2_buf.index,
-- 
2.40.1



