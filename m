Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB01820322;
	Mon, 14 Oct 2024 14:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916361; cv=none; b=KGN7nhbvRcvLzBUWoeB63k8MrTu+lDRGh9SbDRXYIqI7GVIi05xvJ+qRYva4l5CNjA97e1R4OWKgzMsVXfhG158ChrD9Ilq3Rwx+1aUFFu3TbFQq/aF0I6Tz2CG1XrMXw87tvpKNt8h4lNqUN5QePOUS+DicR93djAYc/z+ecgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916361; c=relaxed/simple;
	bh=zpWxnC4RJTVY3O48sx5iD410tFFcA2G5NIAyTM4B//8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWFWohr9L4jZ6V8W1Sqv1r8QY526fPsyjoGs3Dpx6SNik2fZEgNdZJOqcqSxwv3KkJmXNem35LsUP2i3ACPF3cjHuWMfyTiBng73uOMiB4aTLZOzDFr4CWhBbQNSm3XJVY5ieDC44sHH8yPwBZB09e34Ji4qBXS0eTilpU7j7Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIrtanX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIrtanX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6489BC4CEC3;
	Mon, 14 Oct 2024 14:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916361;
	bh=zpWxnC4RJTVY3O48sx5iD410tFFcA2G5NIAyTM4B//8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIrtanX+K1lAglH/w/OXo9eHYBVBC8aRDFfX+tWrK5kzI66Lbu3TCKtqSvPAEYIMk
	 95UrXO4viNJeCn9rCixyNN2w4XGqS+B3HYs2ieRyIz/zIzhGC0a0Ey/AZZHflOGj07
	 39DQWnP0ZLyS8XizDi4af5TgP0ltN83b+r2aqzTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 130/214] net: ibm: emac: mal: fix wrong goto
Date: Mon, 14 Oct 2024 16:19:53 +0200
Message-ID: <20241014141050.065833064@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 08c8acc9d8f3f70d62dd928571368d5018206490 ]

dcr_map is called in the previous if and therefore needs to be unmapped.

Fixes: 1ff0fcfcb1a6 ("ibm_newemac: Fix new MAL feature handling")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20241007235711.5714-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/mal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index d92dd9c83031e..0c5e22d14372a 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -578,7 +578,7 @@ static int mal_probe(struct platform_device *ofdev)
 		printk(KERN_ERR "%pOF: Support for 405EZ not enabled!\n",
 				ofdev->dev.of_node);
 		err = -ENODEV;
-		goto fail;
+		goto fail_unmap;
 #endif
 	}
 
-- 
2.43.0



