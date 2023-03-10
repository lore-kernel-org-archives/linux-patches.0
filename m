Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2096A8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B641C433EF;
	Fri, 10 Mar 2023 14:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457002;
	bh=rplNL3ybWykRjj0qvso+TAtH8avN7CLNd9FgBOZyaDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zLcJ+kI3SXPL6fHpU0MMTR6Z9ViziaVlsWLP5dQYT505giNq5+4WsfNfjizEtu4RX
	 Z5zz0SPXRdyughCZoN1ICVx10jHs7FveJ02kARr1RI9vsbUfSSHIq0dH5k7pEp+7X2
	 1c8XYIaJBgQEAkG4o873b/h4uwo3eIHkCW8YXKqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.2 198/211] vDPA/ifcvf: ifcvf_request_irq works on ifcvf_hw
Date: Fri, 10 Mar 2023 14:39:38 +0100
Message-Id: <20230310133724.909113674@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhu Lingshan <lingshan.zhu@intel.com>

commit 7cfd36b7e8be6bdaeb5af0f9729871b732a7a3c8 upstream.

All ifcvf_request_irq's callees are refactored
to work on ifcvf_hw, so it should be decoupled
from the adapter as well

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
Message-Id: <20221125145724.1129962-9-lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -314,9 +314,8 @@ err:
 	return -EFAULT;
 }
 
-static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_irq(struct ifcvf_hw *vf)
 {
-	struct ifcvf_hw *vf = &adapter->vf;
 	int nvectors, ret, max_intr;
 
 	nvectors = ifcvf_alloc_vectors(vf);
@@ -468,7 +467,7 @@ static void ifcvf_vdpa_set_status(struct
 
 	if ((status & VIRTIO_CONFIG_S_DRIVER_OK) &&
 	    !(status_old & VIRTIO_CONFIG_S_DRIVER_OK)) {
-		ret = ifcvf_request_irq(adapter);
+		ret = ifcvf_request_irq(vf);
 		if (ret) {
 			status = ifcvf_get_status(vf);
 			status |= VIRTIO_CONFIG_S_FAILED;


