Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9A523645D;
	Fri, 24 Apr 2026 13:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037834; cv=none; b=DkWRG7v2+QPVODdmrs34RLGZlC7VXVCV30QouDQGSoRsDGzsqdhz8LK7YP4lZksKQq9mZcJFjHVXv6baIPGTUxBD2C0AMSYJKvYa/1YabFpsvDGZvywlaJmksJYNjHNa9EE2uOdbPmdFL+uYQqASixs/eoH2SNDtnovjwLz27gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037834; c=relaxed/simple;
	bh=0zI5gsNyUcSV0TZ0aueWgUgQBh9cdb7qtzh75c344Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5JAIBammXUE3f5C1o4pKYZglk+ml7BmSxCOtD5u/Ie74ojFLjHaTZwax/lEFZQTE407NAymyyfOWoURTsbWm/b6fqwegzxv5uosn+li1+6MUQkS489ea86M2nd7ifbfcitPWWYYuuxAEb1R4YwJ8phD2eTEyMCvDuQmI8qLgiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHPedUHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHPedUHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5E2C2BCB2;
	Fri, 24 Apr 2026 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037834;
	bh=0zI5gsNyUcSV0TZ0aueWgUgQBh9cdb7qtzh75c344Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHPedUHJYc42/K+sq9wC8YhEqlk1yEI+b5zvw2nqQheH7yHgWopOa74QpAWAxbSuz
	 GPjbc+XA6b8hFRgIPfBR85vF0MkWAal2FALqLDhcMS8YqTC/LzSR3aMbzjzMG4U8SC
	 X5G7vHfSZGc4hHhqN3kxWaZAHgXUM3PTMMyC/grQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Baltieri <fabio.baltieri@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/166] net: txgbe: leave space for null terminators on property_entry
Date: Fri, 24 Apr 2026 15:29:29 +0200
Message-ID: <20260424132544.352665470@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Baltieri <fabio.baltieri@gmail.com>

[ Upstream commit 5a37d228799b0ec2c277459c83c814a59d310bc3 ]

Lists of struct property_entry are supposed to be terminated with an
empty property, this driver currently seems to be allocating exactly the
amount of entry used.

Change the struct definition to leave an extra element for all
property_entry.

Fixes: c3e382ad6d15 ("net: txgbe: Add software nodes to support phylink")
Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Tested-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20260405222013.5347-1-fabio.baltieri@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 51199c355f95c..b0554c8f25213 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -161,10 +161,10 @@ struct txgbe_nodes {
 	char i2c_name[32];
 	char sfp_name[32];
 	char phylink_name[32];
-	struct property_entry gpio_props[1];
-	struct property_entry i2c_props[3];
-	struct property_entry sfp_props[8];
-	struct property_entry phylink_props[2];
+	struct property_entry gpio_props[2];
+	struct property_entry i2c_props[4];
+	struct property_entry sfp_props[9];
+	struct property_entry phylink_props[3];
 	struct software_node_ref_args i2c_ref[1];
 	struct software_node_ref_args gpio0_ref[1];
 	struct software_node_ref_args gpio1_ref[1];
-- 
2.53.0



