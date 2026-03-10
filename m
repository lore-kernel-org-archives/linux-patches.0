Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F68938A711;
	Tue, 10 Mar 2026 11:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142115; cv=none; b=UeB4eiestsJk6ImnydQTGCKibEWGY8FnZQkPAZYQrqrzFYChIqUszlhus7qW81FAJiLXvHYnxezk9P0WwOGoZE2c8HSxLRkyZ1YGitHp+GsNDd3CxX1mreayqjRLIKz+tH8xhZB3OPVy4IbcZYIXQomk0u9dLDbyrvsYlkbzquk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142115; c=relaxed/simple;
	bh=WYArNvPx2WMJLM95iVc3EBtZMhibHNC8WwXO86cpRXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSyJwNj7U5qK9TEq7kaxIwAmoEaLn9YQv/Cssg0LnBYoy7zCeBzYa0QGVLaQEbB8zxe/Gxw0QtpvBYoyWQmWC7AFp8LpiePUK7/yC92xl6kSupslres6DmZBCj+d4KLK7NGZfUC8uKesc1sad6vmC8auIlTboqzFrEvaGUeUOlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5Q/NB2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5Q/NB2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0154C19423;
	Tue, 10 Mar 2026 11:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142115;
	bh=WYArNvPx2WMJLM95iVc3EBtZMhibHNC8WwXO86cpRXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5Q/NB2GjxQAFMQTBvk6Z8nQ4jNwyz908ADar/pTpEbMrCYh2ZcMt5Bo08/kIKLAa
	 19Dv9CIfv+yIh0wd2/AnunnEVk7Zh55gcoXeEVM1tIYVyleGObcoDoZF7iUBFKLZpm
	 h495Jzrh3K9JhzO/YT/14gjhKWT3Ownckbni9f8hCAQd1rR+TntFkwInXve5IF+MO0
	 6cXWIynRU6HzvPZE9AhKAwv5tJHGzl+RpSgr1oo205Fv4kHpzkWC/ilAJEnRv/2He2
	 Mj75GO4+TPsJHP//3r32y6fsNZSk3CQwySIuosdWhEINM/IXUcrMq+6/eLrQTTVIGK
	 lnxYnf1if02yw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mariusz Skamra <mariusz.skamra@codecoup.pl>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 203/314] Bluetooth: Fix CIS host feature condition
Date: Tue, 10 Mar 2026 07:17:42 -0400
Message-ID: <077cb75db9b2d47d15bdbf06428ecc6e30039999.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mariusz Skamra <mariusz.skamra@codecoup.pl>

commit 7cff9a40c6b0f72ccefdaf0ffe03cfac30348f51 upstream.

This fixes the condition for sending the LE Set Host Feature command.
The command is sent to indicate host support for Connected Isochronous
Streams in this case. It has been observed that the system could not
initialize BIS-only capable controllers because the controllers do not
support the command.

As per Core v6.2 | Vol 4, Part E, Table 3.1 the command shall be
supported if CIS Central or CIS Peripheral is supported; otherwise,
the command is optional.

Fixes: 709788b154ca ("Bluetooth: hci_core: Fix using {cis,bis}_capable for current settings")
Cc: stable@vger.kernel.org
Signed-off-by: Mariusz Skamra <mariusz.skamra@codecoup.pl>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ iso_capable() => cis_capable() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index cc1d340a32c62..9f01837250a5e 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4546,7 +4546,7 @@ static int hci_le_set_host_feature_sync(struct hci_dev *hdev)
 {
 	struct hci_cp_le_set_host_feature cp;
 
-	if (!iso_capable(hdev))
+	if (!cis_capable(hdev))
 		return 0;
 
 	memset(&cp, 0, sizeof(cp));
-- 
2.51.0

