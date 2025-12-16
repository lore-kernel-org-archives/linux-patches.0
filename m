Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072A4340DBF;
	Tue, 16 Dec 2025 11:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884735; cv=none; b=C/lAuw27XzjspJ3KSnYHefB6s74CWsBGF50/UUzg0JZ05B5lGO97iH/OqCmngvyuQME0xPVndrAcQirHoyEbH11SeCcE1oJVbCiXwGNMuSCEKu+T6dpIdbhfyR2ic8muaXINlAfPRohiqwf/ZgE+jLmwzHTTqmzcyE0zqEwnMr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884735; c=relaxed/simple;
	bh=ltanIlqv7j3i8Yj1gjFo8UJqKWEef5NT7e04TmvhexI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IA+HJuizeydVx0KnLCQIHFZpHp3g56ppUL8Q1bBMJdwrvcR9jRUey8j0bvRiIqYxsltbIrlq8ToGEth+DYNvyf+K6jrCbggFCj+HtI4ZwDNxAm1HcSMZm2LPQPdfOhieFllgTG2ckR6IY5nN9ok/FxFJm8XpSwVNaVswXiuF19Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDyj2u3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDyj2u3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180EAC4CEF1;
	Tue, 16 Dec 2025 11:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884733;
	bh=ltanIlqv7j3i8Yj1gjFo8UJqKWEef5NT7e04TmvhexI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDyj2u3O39sYEPg+fxfaaNgCxyWKalRxhrqbUSxpDwt4xgBcEHk0J8JLwX9IopMvs
	 w2x1uVISs015q5M6pjX2l0lYRUokNSp4niXU1jTOvDQB08B8pZK+H4PxOpLazle4bE
	 fduq2IQFwnt2q/E/tB1e9FGa+KWG3LJfqvKFHMUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/354] virtio: fix whitespace in virtio_config_ops
Date: Tue, 16 Dec 2025 12:13:36 +0100
Message-ID: <20251216111329.934890701@linuxfoundation.org>
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
index 165f71635cb99..8189f859231cc 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -82,7 +82,7 @@ struct virtqueue_info {
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



