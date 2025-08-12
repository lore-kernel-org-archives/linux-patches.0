Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4C82D3A94;
	Tue, 12 Aug 2025 19:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026628; cv=none; b=g6Y67QEBNDHW9r0LMnWB4K+rEctyZtdqpbjqsfoYlbDoqzJJkreDK0dL1mY7XxyM77PfYD9hIX5GOVbY1DalhWkMW+vEt63YsL35yEZ02ViObHooL32lrNeew4Pa8oaKhsasTQuR69L2uWzPgDg0fnxnbRQfcQPj+4Cy2cOTNXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026628; c=relaxed/simple;
	bh=rdRA/oXB27VBYC9LW5mcgBxpu3LrFsAw/gbs/VPYws8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btObjbTmGKKDvtf0kTYFUdFhOPd+U04etlRGsfiLje2jRbdLMBLd/tKsLPPEVk8WhEAI0yjXPPnTdjNBJcrk3DXCenXGdVP53hauZNnz7s/vI17aDONeCOJjyeEOHRoxcXJ5e5odXk12hAnYdS8DtGbTGb0w6S4ReFK2KnnLlxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlU7xmgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlU7xmgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDB9C4CEF7;
	Tue, 12 Aug 2025 19:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026628;
	bh=rdRA/oXB27VBYC9LW5mcgBxpu3LrFsAw/gbs/VPYws8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlU7xmgIjznqXH0A49YWD/ev/cD0dbMqgEf8xML2c0znvcm4xPZ0VVndzouqBOn4r
	 Bih2dNyJrekXsw5pZ1Xd4DIjff5OiCbrV1itLPzOJkE79wAy0Hkbnhfq2wz8j2zy9s
	 +wdo4S4oTUobnl5nMOKv/5mRaGPdXniEKzR/iDlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duo Yi <duo@meta.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 393/480] netlink: specs: ethtool: fix module EEPROM input/output arguments
Date: Tue, 12 Aug 2025 19:50:01 +0200
Message-ID: <20250812174413.638150949@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 01051012887329ea78eaca19b1d2eac4c9f601b5 ]

Module (SFP) eeprom GET has a lot of input params, they are all
mistakenly listed as output in the spec. Looks like kernel doesn't
output them at all. Correct what are the inputs and what the outputs.

Reported-by: Duo Yi <duo@meta.com>
Fixes: a353318ebf24 ("tools: ynl: populate most of the ethtool spec")
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250730172137.1322351-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/ethtool.yaml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index c650cd3dcb80..85e1d3b7512d 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -2077,9 +2077,6 @@ operations:
 
       do: &module-eeprom-get-op
         request:
-          attributes:
-            - header
-        reply:
           attributes:
             - header
             - offset
@@ -2087,6 +2084,9 @@ operations:
             - page
             - bank
             - i2c-address
+        reply:
+          attributes:
+            - header
             - data
       dump: *module-eeprom-get-op
     -
-- 
2.39.5



