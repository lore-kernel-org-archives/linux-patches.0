Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4522F2E7BD4;
	Tue, 12 Aug 2025 18:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022900; cv=none; b=MTj2WsQfBWFokRcsjtqhe93thWV5YEq/HfQoq80yMOWbKU/bPjhkNj08D0fZJQXookKpKUp3M9X6fkttFkozUIB9rnaSZwSmZcbXkWRFtlt21Tfy+lfwQKJTZquZsp5xzz2o1jzTpFLflOQPA5Djwxm5O+qKI0orSlyyAAwyvQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022900; c=relaxed/simple;
	bh=ta6IC6JktSiLiQrQVWlT0roQK+CQyrNqHmFs/cdVRkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3e3Lt/OmUUsbNsmNRFuZXWJrHQxVAPbfXrDBzYdvyQgMsj3mGY5TDYtnBsz6qcV44NrRUO+jv6ZpMmxtqKyKkS7r/oIdRPM0NtD3FD2t5AReN8Cf99wyhnLRi+nbiFeztKJGiGGk1RrYvMQqWusBlLw5ZCF27msoJW6DNbeHE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awc6wigG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awc6wigG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FCFC4CEF0;
	Tue, 12 Aug 2025 18:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022900;
	bh=ta6IC6JktSiLiQrQVWlT0roQK+CQyrNqHmFs/cdVRkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awc6wigGWE8+lPwGrPMbx0wG/AOAgtjKjf0uDMYRme6ZiHjKh6hEc75yttM5XhPV7
	 qdv62EgiIyciBzGxUggLIJ0xYpYXFpJNiGnZdmSHkeqTdptQIfIGTXWRWJK+ErP6/q
	 AYPWl3aP5GY+MSQywp3xNeyK2fim4Ju6aZeg3/mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duo Yi <duo@meta.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/369] netlink: specs: ethtool: fix module EEPROM input/output arguments
Date: Tue, 12 Aug 2025 19:29:50 +0200
Message-ID: <20250812173027.753162420@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f6c5d8214c7e..4936aa5855b1 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -1682,9 +1682,6 @@ operations:
 
       do: &module-eeprom-get-op
         request:
-          attributes:
-            - header
-        reply:
           attributes:
             - header
             - offset
@@ -1692,6 +1689,9 @@ operations:
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



