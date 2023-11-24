Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350022E621;
	Fri, 24 Nov 2023 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIDW2rC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCCCC433C7;
	Fri, 24 Nov 2023 18:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850797;
	bh=ADL6/YMA8l/z+BPZXwRLQbILN7jFdLnsdc0lFKxhU60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIDW2rC61NDT8E1SVJAnPFdghVCU7evJ1tRzneKTbakX8ICK2AjChQlffjlzMAj1a
	 p8GR7VdNxEbGB74q1g9jcfueAx03U/No9mKfKRO/dIKd8MMCKsEKkTxQ6XA7TDHMYs
	 yotQWdtaN6sm1tD1pKn2wGoQnTqWQky3Qpy96NBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Wang <qinwang@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 168/491] vdpa_sim_blk: allocate the buffer zeroed
Date: Fri, 24 Nov 2023 17:46:44 +0000
Message-ID: <20231124172029.522995875@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 0d82410252ea324f0064e75b9865bb74cccc1dda ]

Deleting and recreating a device can lead to having the same
content as the old device, so let's always allocate buffers
completely zeroed out.

Fixes: abebb16254b3 ("vdpa_sim_blk: support shared backend")
Suggested-by: Qing Wang <qinwang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20231031144339.121453-1-sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index b3a3cb1657955..b137f36793439 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -437,7 +437,7 @@ static int vdpasim_blk_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	if (blk->shared_backend) {
 		blk->buffer = shared_buffer;
 	} else {
-		blk->buffer = kvmalloc(VDPASIM_BLK_CAPACITY << SECTOR_SHIFT,
+		blk->buffer = kvzalloc(VDPASIM_BLK_CAPACITY << SECTOR_SHIFT,
 				       GFP_KERNEL);
 		if (!blk->buffer) {
 			ret = -ENOMEM;
@@ -495,7 +495,7 @@ static int __init vdpasim_blk_init(void)
 		goto parent_err;
 
 	if (shared_backend) {
-		shared_buffer = kvmalloc(VDPASIM_BLK_CAPACITY << SECTOR_SHIFT,
+		shared_buffer = kvzalloc(VDPASIM_BLK_CAPACITY << SECTOR_SHIFT,
 					 GFP_KERNEL);
 		if (!shared_buffer) {
 			ret = -ENOMEM;
-- 
2.42.0



