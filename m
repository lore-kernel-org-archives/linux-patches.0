Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E92C8173C;
	Mon,  8 Apr 2024 13:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582965; cv=none; b=tBkAKBvC0VxWv2IWBQ7ysu4RJgHH7xfVKUgWorlY7N1u1xL9qr0P6w2CxgXuNdJPQu+G4QQx3EJ56/7TLpTOQHJ+rh8XJAlakr0vw7FZ7QareMoMvr4y8Np/fRajCcvN4RssEbJmyHnySM4sFLfWMGlpfrfpMDkNH7HQMO7zf6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582965; c=relaxed/simple;
	bh=o3XyHjdVN8pX6LAJjZJ8EXCHyqZiD0B8BpYAJ3MUDP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/yQxHExt96ti/RupWtXaXZjrIP7z2VVDTBhQ5YWzOT/nzA8zAN3hWtVOVifzf5khzDsQyRkENmu/zesuwDcqZ8SnBBKnV+3LUEDysitpINk7Ck7SrAwy4PzNYvu6lMOnpOcgHNfZd0QskrOVClnkJc5+JwaTtkrZZFQs3XDN3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bC8mnTWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bC8mnTWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E7DC433F1;
	Mon,  8 Apr 2024 13:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582964;
	bh=o3XyHjdVN8pX6LAJjZJ8EXCHyqZiD0B8BpYAJ3MUDP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bC8mnTWXQtiO9ryQiD9Pk1tn/J9w//F2YieffhcVshF1WFaYlPuUdTlHP2gMM66Rl
	 QsfZSX+GzISiXfEzveovWusbmSdOJL2T8R3qqufrV11D/KLnhS/7WwfdM1DxAKQs6r
	 tu0HOlOPkVuxMaPUHI7tgfkxNA6c62FVq4HqxNLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/252] virtchnl: Add header dependencies
Date: Mon,  8 Apr 2024 14:57:22 +0200
Message-ID: <20240408125311.090726796@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 7151d87a175c6618fe81705755eb3dc4199cad4e ]

The <linux/avf/virtchnl.h> uses BIT, struct_size and ETH_ALEN macros
but does not include appropriate header files that defines them.
Add these dependencies so this header file can be included anywhere.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 6dbdd4de0362 ("e1000e: Workaround for sporadic MDI error on Meteor Lake systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/avf/virtchnl.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index d0807ad43f933..6424aa06fb08d 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -4,6 +4,10 @@
 #ifndef _VIRTCHNL_H_
 #define _VIRTCHNL_H_
 
+#include <linux/bitops.h>
+#include <linux/overflow.h>
+#include <uapi/linux/if_ether.h>
+
 /* Description:
  * This header file describes the Virtual Function (VF) - Physical Function
  * (PF) communication protocol used by the drivers for all devices starting
-- 
2.43.0



