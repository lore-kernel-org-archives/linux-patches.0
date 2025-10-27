Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AC432E120;
	Mon, 27 Oct 2025 19:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591839; cv=none; b=jRT629yrqwccheWPWcQc0CwH75jAR3YiDk425rsXnWUw1X4eDpCwkKDiYORNkfrcRwgz6IqpEMrNqrDaiwT6N+PFfK27i0XlbZTZT4XgJD2N4/NjDRYA8suzz+7KW5iegB+CcKXiXbxABn45RNfYKOjZAEM8eT4upo40QVRsxYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591839; c=relaxed/simple;
	bh=Kz9xL9BXhCC1hiVzQYIKU/xFOpbB0xRdBm5P55xZJdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AClkJRY+lXRhlycRgM4Fat6sUNUazhZBZXrPfKHshQM45+SwwwBdnxlBm39xAmfTYAGoIXPXj/PVcr4qBz2/TjbLRyKdey+3puAIkCo9KnK7eF/dh3oLoOwLGoV6Iy6wzKJP2sS0dcix+nWA79K9hDDk9TUeybJoTXyZe3I/9EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnp3WJqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnp3WJqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F3BC4CEF1;
	Mon, 27 Oct 2025 19:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591839;
	bh=Kz9xL9BXhCC1hiVzQYIKU/xFOpbB0xRdBm5P55xZJdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnp3WJqr9aTX3r7X+OIQMe5u6oj6zFiPi5WME836UnhvWY8TAAIylZ3tTbNsFwSgz
	 c2o4yI5W2oFEvVcNoSuAvEYKe/XdBU6ccmHcpgIkCiKdC1ReKZbIxEfGjwqOG4azhP
	 x9lf4trWh6aVYRoWaLuBsFgDL77Y1ZrTFzAyWKMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Guibert <philippe.guibert@6wind.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/123] doc: fix seg6_flowlabel path
Date: Mon, 27 Oct 2025 19:34:58 +0100
Message-ID: <20251027183446.886400857@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



