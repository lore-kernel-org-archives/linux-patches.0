Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4575A2FE595;
	Tue, 12 Aug 2025 18:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025092; cv=none; b=T36XeLTywZjdFPApcpeEN1E6xMsKaKt6EpEhjG+ohXUmvuqbcg5qSInD/EZbHZuV5aHKF+QVd+zj6C+cIbAUwagUTiTZL2t1hwYxmxPzxH1oAO97td4GqzZ9KAqy27pbBoY8WpxjZ0dXXqGpio1Y989wvE1ogNZUhMjVxQNCi+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025092; c=relaxed/simple;
	bh=cKsQeSkm+Hlu5OqGDI3IuZHjSkvingSfceLq1nLS9IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/cbf7xqHme66ytUCPGd1Q4goRHAnt/T84TZ42BHGjBDjRasJYQ7KDxBnRDG2k3KBpOWL507BRjtXEUN1SfT9tqagMG8VXXQhBy+cVBt6J9JP/20MxA8NHJ0o3a45etNib8TuytiQN0DAVxGQsVNpBZysXdXgXADCmbbEtLTTzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhcVxyoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhcVxyoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9208C4CEF0;
	Tue, 12 Aug 2025 18:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025092;
	bh=cKsQeSkm+Hlu5OqGDI3IuZHjSkvingSfceLq1nLS9IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhcVxyocsn35CE2FeeXRMGaOZhDp/RONh9nHJUAJWs6hXiGq3jsvIoc9KLQcCVmb/
	 oel5RzgSrwqhX7gY8lgKmQSQcbl2B4kCyYORywCEqMKM4o0m8zg7ceHCnmxl03UW2d
	 tAzBat4bhjLteFEbHcZtbEG0q8V7LZwb4Vq/lPQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duo Yi <duo@meta.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 524/627] netlink: specs: ethtool: fix module EEPROM input/output arguments
Date: Tue, 12 Aug 2025 19:33:39 +0200
Message-ID: <20250812173451.778191331@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 348c6ad548f5..d1ee5307160f 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -2107,9 +2107,6 @@ operations:
 
       do: &module-eeprom-get-op
         request:
-          attributes:
-            - header
-        reply:
           attributes:
             - header
             - offset
@@ -2117,6 +2114,9 @@ operations:
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



