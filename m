Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C820396550;
	Tue, 16 Dec 2025 12:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888305; cv=none; b=Xn+G1+svlPjn9OVxJL2Qdi/+smrSOPy9f6QBLgfFqFETGSq7mA5fHDb0JWCBXTptIabDmE2pS3dI4M/vlStQMmylRGietZ9rY1BcVzMiGcyaSAxeFR4lp8TXI57Mliys+b6VTpS63+nKY899+Wq8JVGY4Cd6djUb4Yks2qu5cF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888305; c=relaxed/simple;
	bh=yGLvqjQltyMy6SkwtI93cBYEbOYVhiYgu6y8uMnqi04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbJKz/gmoVsxjdldrhgLNqvHC6rM1HuMflMh4+jLYwahDFHjigxABvSXjbNGeXQKPEXC9ZIMi4fnZ0yvjWkEXyR4xR1SGcVQefy8tgAwyMl2aYtV9aDfrrbCxAIOnhsxh8lURLNwC4nGdl+sPl7XQeNtEQhxWeSuzQglStH3kII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdrbVheJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdrbVheJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82137C4CEF5;
	Tue, 16 Dec 2025 12:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888304;
	bh=yGLvqjQltyMy6SkwtI93cBYEbOYVhiYgu6y8uMnqi04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdrbVheJE/82xGztNFYIxmWEFb0wdXZGECVWkK9LdjNQzEJS9g2J6G5UvCj6S49oN
	 43RmNOTdNH2zaHcZCoRVNpE/hiDYz8pbq/261gMJnAFSP6wcYggYg6c0yHyo74mOy1
	 3vTO/gDb+JKIqc/kSW12KUpYYqQBVtCL/YoLQVPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 461/614] virtio: fix whitespace in virtio_config_ops
Date: Tue, 16 Dec 2025 12:13:48 +0100
Message-ID: <20251216111418.072150479@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 7831791e77a1cd29528d4dc336ce14466aef5ba6 ]

The finalize_features documentation uses a tab between words.
Use space instead.

Fixes: d16c0cd27331 ("docs: driver-api: virtio: virtio on Linux")
Message-Id: <39d7685c82848dc6a876d175e33a1407f6ab3fc1.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 1ea5baa62141f..dbc7eff1f101f 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -86,7 +86,7 @@ struct virtqueue_info {
  *	vdev: the virtio_device
  *	This sends the driver feature bits to the device: it can change
  *	the dev->feature bits if it wants.
- *	Note that despite the name this	can be called any number of
+ *	Note that despite the name this can be called any number of
  *	times.
  *	Returns 0 on success or error status
  * @bus_name: return the bus name associated with the device (optional)
-- 
2.51.0



