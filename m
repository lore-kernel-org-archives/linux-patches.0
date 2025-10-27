Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7216730506B;
	Mon, 27 Oct 2025 19:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592221; cv=none; b=lf5rqm+apzsIj6Jr0oZ/kLlh/eX0SUGLzYucgl5Xm2cGRSEaCqo/ytR0q+SJcQcomohvMNbDrsAGxJHzeybhMg8QkghfUUREF2iWf/WutyYCCANm6+v0bSjejMQJDZb3O9zn2a0kgahMPSkoVIdXGchb4IN3tjTQ39mRn3tneec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592221; c=relaxed/simple;
	bh=X5uueY2jVEPuwDDBjBH5hkoT2NwPULEw12pWUsyvX6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqcD/3xexrEsH4hwd04QQjp5DIzJ/l3xmflsfmGmyd7ZVj6Z5IvlJ3SJkfNF2KGcw+BxR8Ba+lvReL7vHjRLjPGYuKVVdjUSMV46VoGLtwtpsKRtCV77LTjw1ONNCo5Zlqend4v1efVOkTPqsXWUPg24y4yblkDDpMhPQl97iJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3d7p7Om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3d7p7Om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077FFC4CEF1;
	Mon, 27 Oct 2025 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592221;
	bh=X5uueY2jVEPuwDDBjBH5hkoT2NwPULEw12pWUsyvX6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3d7p7OmPuJ1OqWzhlsgTjXAb9PZJODi5rTnCgUBdZ8nMBfz24iregbefb4lNsGIp
	 dqOQZSTyMqrWsBIdUyCFp+BoeOO9QZzrxBv8m1JyUzB49JvyurkHugrvzzX3DZcxJS
	 qejZ4inhEoPI8krUiNLw2ecK4U6cxVQAkocImFvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Guibert <philippe.guibert@6wind.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/157] doc: fix seg6_flowlabel path
Date: Mon, 27 Oct 2025 19:35:00 +0100
Message-ID: <20251027183502.346231773@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 0b4b77eff5f8cd9be062783a1c1e198d46d0a753 ]

This sysctl is not per interface; it's global per netns.

Fixes: 292ecd9f5a94 ("doc: move seg6_flowlabel to seg6-sysctl.rst")
Reported-by: Philippe Guibert <philippe.guibert@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/seg6-sysctl.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/networking/seg6-sysctl.rst b/Documentation/networking/seg6-sysctl.rst
index 07c20e470bafe..1b6af4779be11 100644
--- a/Documentation/networking/seg6-sysctl.rst
+++ b/Documentation/networking/seg6-sysctl.rst
@@ -25,6 +25,9 @@ seg6_require_hmac - INTEGER
 
 	Default is 0.
 
+/proc/sys/net/ipv6/seg6_* variables:
+====================================
+
 seg6_flowlabel - INTEGER
 	Controls the behaviour of computing the flowlabel of outer
 	IPv6 header in case of SR T.encaps
-- 
2.51.0



