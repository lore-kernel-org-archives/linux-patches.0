Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8267D18FC91;
	Tue, 12 Aug 2025 18:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021724; cv=none; b=pttDNLsxPcqAho+ys5MWQI/vrhMfq2HIY+k+ROGtLd6rGogCRVgIFLqdKbEVUNN7A5wq0vtCFHCryX5ROaLmBg/SBoYkMEVeeCVR+r5zXQ8K0Jh6rRUN7yFwh4hC5hrOUaZ/uoOGM4B4fe0tjjx9r5MjT8BfSQuznx5fTNdvpmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021724; c=relaxed/simple;
	bh=xD3+EzYFBzpCzkekFNgSUt2otreJlfiQcxxZEw/ekc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5XLfOZMr+HZ6Seh0GaIo8JiBPbrmGzQAzPYKy9i8YNviL4Y8Svrvw9n41OGiQU79bMZUyNeFwf4PO+2wEK3HJL6wT1HaC6Etg2jL2jDxfXv9deqBoCZb6ukbhYatIo4nz2/4PDYFikkLT7zw7sclJ9AYa+HTmLteyWMSrnNxdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmbIR56K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmbIR56K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0F7C4CEF0;
	Tue, 12 Aug 2025 18:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021724;
	bh=xD3+EzYFBzpCzkekFNgSUt2otreJlfiQcxxZEw/ekc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmbIR56KY82I0YUdB1DAGYrJI88MLP+K/SXXhLydQaKaX2N29Lu/YaWfAFletIX+b
	 B2EBWQA+I84uaiKhUVc6k0gxBL76SQMIBt+ZFFtqmfJsVheKh5pVsRDE4UAOA24amA
	 rBvNIK+9Lc7MnRhs8iX/n4sKIbXo1iC6wWfCf/Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duo Yi <duo@meta.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 207/262] netlink: specs: ethtool: fix module EEPROM input/output arguments
Date: Tue, 12 Aug 2025 19:29:55 +0200
Message-ID: <20250812173001.963928876@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3e38f6956793..b463949736c5 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -1489,9 +1489,6 @@ operations:
 
       do: &module-eeprom-get-op
         request:
-          attributes:
-            - header
-        reply:
           attributes:
             - header
             - offset
@@ -1499,6 +1496,9 @@ operations:
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



