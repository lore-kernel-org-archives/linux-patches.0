Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8677230214B;
	Thu, 15 Jan 2026 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499101; cv=none; b=Uk4vtrzUfOB81k4LCL5JVRv/PuwQwPy1X2iFmCh1IkJN+gmueEl8O9T5MIlz+U+ZmroBLxG9gQPvj0zpmZ5U+lFthhxhnliyEDWKrn2WgpsrDwtxcbdzCbiS61n06VCqe2TmVSh4y3E29vdnTdtEG3pnnT9jR2sov8mn9ocKh00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499101; c=relaxed/simple;
	bh=YMXCaZ4KKRfEfVjXWc3MtBN52jwFcdyIrIHIIRg4eC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKbZIoNUSS1cl7IFRpwBmS3VAgXe1nU1KgTJOpS8E8j+8a3FUytg6qyCJvu1BqAmRn2A4gRu1AwFtbEHONaXGHxRjLoHA6ARFPJ9ZAJjKxuKK8geuurdWsQ5t3T5KBr8vXt2hz2XUE+NMcn0BpBZIzL4t95Br7OoH83q4knkLdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2E+kva4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2E+kva4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16401C116D0;
	Thu, 15 Jan 2026 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499101;
	bh=YMXCaZ4KKRfEfVjXWc3MtBN52jwFcdyIrIHIIRg4eC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2E+kva4gAiQZkSGuHybkJsDhIgvGwNd6CQSZoADVlq9I2R7zfXx+h5Y6XgK1A1u7M
	 oBod7ceqcpxUEZc+G34Bgys9uMeMda6GZ/QAx+LBgG44MfRviwaEq6wSRlAZFg5kQb
	 qLJIMz/xowlw2iboto3iQiYZkIgAy7VFh7Hp5+Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/451] virtio: fix virtqueue_set_affinity() docs
Date: Thu, 15 Jan 2026 17:45:09 +0100
Message-ID: <20260115164234.825914704@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 43236d8bbafff94b423afecc4a692dd90602d426 ]

Rewrite the comment for better grammar and clarity.

Fixes: 75a0a52be3c2 ("virtio: introduce an API to set affinity for a virtqueue")
Message-Id: <e317e91bd43b070e5eaec0ebbe60c5749d02e2dd.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index b341dd62aa4da..f971986fa0e9a 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -247,7 +247,7 @@ const char *virtio_bus_name(struct virtio_device *vdev)
  * @vq: the virtqueue
  * @cpu: the cpu no.
  *
- * Pay attention the function are best-effort: the affinity hint may not be set
+ * Note that this function is best-effort: the affinity hint may not be set
  * due to config support, irq type and sharing.
  *
  */
-- 
2.51.0



