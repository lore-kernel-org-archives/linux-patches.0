Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66192341062;
	Tue, 16 Dec 2025 11:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884730; cv=none; b=qaBzBX31kqZ9m9TK3kqn/kThJ0W8KVaoXkxLvicCufNhPGpKl+BUkzdZySUzAWoQHwS/O/gvbOlAlq5mSyJLMTArFiDzsROlgWt1ILl1wjIvWQ9IRczO3pSC2SSJbv06Ge08EeueuCmoIn8U67VnvDDfVTi2Radd7XIkZWsX6hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884730; c=relaxed/simple;
	bh=/gFRX1XMUN+q9oAp4u3Am1TTDLrzCJ6YKP2f/Ec0SVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QruWfRfm4jGJAlWaD0y48Q2U/xgmFAzqhR/C51BpLkptQPszlP61lWWoCLymLvc5RO+Y3hh/gE0MPC1WrC3Jt8UQkHdVweYKhFc5cMny2S0x7fY+khEfP/qVFv4D+h2m3W7PFdwtIs21nJt7qVE05rqs/KhSETraN0NMn1Rydxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f69NrTk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f69NrTk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1B7C4CEF1;
	Tue, 16 Dec 2025 11:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884726;
	bh=/gFRX1XMUN+q9oAp4u3Am1TTDLrzCJ6YKP2f/Ec0SVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f69NrTk5mTp8bxHG/8OtQpU1i8apbcSiIy+54D79nNRX3lp4kM5vAYR6epQAohAh8
	 C9mjdy4YmyjFCtpNrHjpEtIfO4X43PDEt8WfOD05NG8Heftra1pqsXVU3723bzYp9g
	 RCdl6P3JaAadebT2ERZlckAY7d6WC6Bbm6RsnLaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 247/354] virtio_vdpa: fix misleading return in void function
Date: Tue, 16 Dec 2025 12:13:34 +0100
Message-ID: <20251216111329.862519316@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit e40b6abe0b1247d43bc61942aa7534fca7209e44 ]

virtio_vdpa_set_status() is declared as returning void, but it used
"return vdpa_set_status()" Since vdpa_set_status() also returns
void, the return statement is unnecessary and misleading.
Remove it.

Fixes: c043b4a8cf3b ("virtio: introduce a vDPA based transport")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Message-Id: <20251001191653.1713923-1-alok.a.tiwari@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 7364bd53e38dd..bf62712bdbee8 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -93,7 +93,7 @@ static void virtio_vdpa_set_status(struct virtio_device *vdev, u8 status)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
 
-	return vdpa_set_status(vdpa, status);
+	vdpa_set_status(vdpa, status);
 }
 
 static void virtio_vdpa_reset(struct virtio_device *vdev)
-- 
2.51.0



